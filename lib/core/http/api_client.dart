import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:africa_beuty/core/constants/server_constants.dart';
import 'package:africa_beuty/feature/auth/repositories/local_storage_service.dart';
import 'package:http/http.dart' as http;

const _kTimeout = Duration(seconds: 15);

class _TimeoutAppException implements Exception {
  const _TimeoutAppException();
  @override
  String toString() => 'Request timed out. Please check your connection and try again.';
}

class _NetworkAppException implements Exception {
  const _NetworkAppException();
  @override
  String toString() => 'No internet connection.';
}

/// Thrown when both the access-token AND the refresh-token are expired /
/// invalid.  Repositories should convert this to a Left(AppFailure(...)).
class SessionExpiredException implements Exception {
  const SessionExpiredException();
  @override
  String toString() => 'Your session has expired. Please log in again.';
}

/// Central HTTP client.
///
/// - Automatically attaches `Authorization: Bearer <token>` to every request.
/// - On a 401 response, silently calls `/auth/refresh`, saves the new tokens,
///   and retries the original request exactly once.
/// - If the refresh also fails (refresh token expired / server error), it:
///     1. Clears all stored auth data.
///     2. Calls [onSessionExpired] (set once at app startup in main.dart).
///     3. Throws [SessionExpiredException].
/// - Concurrent 401s share a single refresh attempt (no duplicate calls).
class ApiClient {
  ApiClient._();
  static final ApiClient instance = ApiClient._();

  /// Set once in `main()` — invoked when the session cannot be recovered.
  /// Typically navigates to `/signin` and clears the back-stack.
  static void Function()? onSessionExpired;

  // Shared completer so concurrent 401s don't all fire separate refreshes.
  Completer<bool>? _refreshCompleter;

  // ── Public HTTP methods ─────────────────────────────────────────

  Future<http.Response> get(Uri uri, {Map<String, String>? extra}) =>
      _request(() async =>
          http.get(uri, headers: await _headers(extra)).timeout(_kTimeout));

  Future<http.Response> post(
    Uri uri, {
    Map<String, String>? extra,
    Object? body,
    Encoding? encoding,
  }) =>
      _request(
        () async => http
            .post(uri,
                headers: await _headers(extra), body: body, encoding: encoding)
            .timeout(_kTimeout),
      );

  Future<http.Response> patch(
    Uri uri, {
    Map<String, String>? extra,
    Object? body,
  }) =>
      _request(
        () async => http
            .patch(uri, headers: await _headers(extra), body: body)
            .timeout(_kTimeout),
      );

  Future<http.Response> put(
    Uri uri, {
    Map<String, String>? extra,
    Object? body,
  }) =>
      _request(
        () async => http
            .put(uri, headers: await _headers(extra), body: body)
            .timeout(_kTimeout),
      );

  Future<http.Response> delete(Uri uri, {Map<String, String>? extra}) =>
      _request(() async =>
          http.delete(uri, headers: await _headers(extra)).timeout(_kTimeout));

  // ── Internal ────────────────────────────────────────────────────

  Future<http.Response> _request(
    Future<http.Response> Function() call,
  ) async {
    try {
      final response = await call();
      if (response.statusCode != 401) return response;

      final refreshed = await _refresh();
      if (!refreshed) {
        onSessionExpired?.call();
        throw const SessionExpiredException();
      }

      // Retry with the freshly stored token.
      return call();
    } on TimeoutException {
      throw const _TimeoutAppException();
    } on SocketException {
      throw const _NetworkAppException();
    }
  }

  /// Ensures only one refresh call happens even if multiple requests get 401
  /// at the same time.
  Future<bool> _refresh() async {
    if (_refreshCompleter != null) return _refreshCompleter!.future;

    _refreshCompleter = Completer<bool>();
    try {
      final ok = await _doRefresh();
      _refreshCompleter!.complete(ok);
      return ok;
    } catch (_) {
      _refreshCompleter!.complete(false);
      return false;
    } finally {
      _refreshCompleter = null;
    }
  }

  Future<bool> _doRefresh() async {
    final refreshToken = await LocalStorageService.getRefreshToken();
    if (refreshToken == null) {
      await LocalStorageService.clearAuthData();
      return false;
    }

    try {
      // Backend endpoint has a typo: /auth/refersh (not /auth/refresh).
      // Token is passed in the Authorization header, not the request body.
      final response = await http
          .post(
            Uri.parse('${ServerConstants.serverUrl}/auth/refersh'),
            headers: {'Authorization': 'Bearer $refreshToken'},
          )
          .timeout(_kTimeout);

      if (response.statusCode != 200) {
        await LocalStorageService.clearAuthData();
        return false;
      }

      final data = jsonDecode(response.body) as Map<String, dynamic>;
      final userId = await LocalStorageService.getUserId() ?? '';

      await LocalStorageService.saveAuthData(
        accessToken: data['access_token'] as String,
        // Some servers don't rotate the refresh token — keep the old one then.
        refreshToken: (data['refresh_token'] as String?) ?? refreshToken,
        tokenType: (data['token_type'] as String?) ?? 'Bearer',
        userId: userId,
      );
      return true;
    } catch (_) {
      await LocalStorageService.clearAuthData();
      return false;
    }
  }

  Future<Map<String, String>> _headers([Map<String, String>? extra]) async {
    final token = await LocalStorageService.getAccessToken();
    return {
      'Content-Type': 'application/json',
      if (token != null) 'Authorization': 'Bearer $token',
      ...?extra,
    };
  }
}
