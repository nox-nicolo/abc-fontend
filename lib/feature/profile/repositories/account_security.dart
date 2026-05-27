import 'dart:async';
import 'dart:convert';

import 'package:africa_beuty/core/constants/server_constants.dart';
import 'package:africa_beuty/core/failure/failure.dart';
import 'package:africa_beuty/core/http/api_client.dart';
import 'package:africa_beuty/core/http/response_body.dart';
import 'package:africa_beuty/feature/profile/model/account_security.dart';
import 'package:fpdart/fpdart.dart';

class AccountSecurityRepository {
  Future<Either<AppFailure, List<AccountDevice>>> getDevices() async {
    try {
      final response = await ApiClient.instance.get(
        Uri.parse('${ServerConstants.serverUrl}/users/me/device-tokens'),
      );

      if (response.statusCode >= 200 && response.statusCode < 300) {
        final decoded = decodeMapOrThrow(response);
        final items = (decoded['items'] as List<dynamic>? ?? [])
            .map((item) => AccountDevice.fromMap(item as Map<String, dynamic>))
            .toList();
        return Right(items);
      }
      return Left(
        AppFailure(responseErrorMessage(response, 'Failed to load devices')),
      );
    } on TimeoutException {
      return Left(AppFailure('Request timed out'));
    } on SessionExpiredException catch (e) {
      return Left(AppFailure(e.toString()));
    } catch (e) {
      return Left(AppFailure(e.toString()));
    }
  }

  Future<Either<AppFailure, void>> removeDevice(String deviceId) async {
    try {
      final response = await ApiClient.instance.delete(
        Uri.parse(
          '${ServerConstants.serverUrl}/users/me/device-tokens/$deviceId',
        ),
      );

      if (response.statusCode >= 200 && response.statusCode < 300) {
        return const Right(null);
      }
      return Left(
        AppFailure(responseErrorMessage(response, 'Failed to remove device')),
      );
    } on SessionExpiredException catch (e) {
      return Left(AppFailure(e.toString()));
    } catch (e) {
      return Left(AppFailure(e.toString()));
    }
  }

  Future<Either<AppFailure, List<MutedAccount>>> getMutedAccounts({
    String? query,
    String sort = 'newest',
  }) async {
    try {
      final uri = Uri.parse('${ServerConstants.serverUrl}/users/me/mutes')
          .replace(
            queryParameters: {
              if (query != null && query.trim().isNotEmpty) 'q': query.trim(),
              'sort': sort,
            },
          );
      final response = await ApiClient.instance.get(uri);

      if (response.statusCode >= 200 && response.statusCode < 300) {
        final decoded = decodeMapOrThrow(response);
        final items = (decoded['items'] as List<dynamic>? ?? [])
            .map((item) => MutedAccount.fromMap(item as Map<String, dynamic>))
            .toList();
        return Right(items);
      }
      return Left(
        AppFailure(
          responseErrorMessage(response, 'Failed to load muted accounts'),
        ),
      );
    } on TimeoutException {
      return Left(AppFailure('Request timed out'));
    } on SessionExpiredException catch (e) {
      return Left(AppFailure(e.toString()));
    } catch (e) {
      return Left(AppFailure(e.toString()));
    }
  }

  Future<Either<AppFailure, void>> unmute(MutedAccount item) async {
    try {
      final response = await ApiClient.instance.delete(
        Uri.parse(
          '${ServerConstants.serverUrl}/users/me/mutes/${item.targetType}/${item.targetId}',
        ),
      );

      if (response.statusCode >= 200 && response.statusCode < 300) {
        return const Right(null);
      }
      return Left(
        AppFailure(responseErrorMessage(response, 'Failed to unmute')),
      );
    } on SessionExpiredException catch (e) {
      return Left(AppFailure(e.toString()));
    } catch (e) {
      return Left(AppFailure(e.toString()));
    }
  }

  Future<Either<AppFailure, void>> changePassword({
    required String currentPassword,
    required String newPassword,
  }) async {
    try {
      final response = await ApiClient.instance.post(
        Uri.parse('${ServerConstants.serverUrl}/auth/change-password'),
        body: jsonEncode({
          'current_password': currentPassword,
          'new_password': newPassword,
        }),
      );

      if (response.statusCode >= 200 && response.statusCode < 300) {
        return const Right(null);
      }
      return Left(
        AppFailure(
          responseErrorMessage(
            response,
            'Password change is not available yet',
          ),
        ),
      );
    } on SessionExpiredException catch (e) {
      return Left(AppFailure(e.toString()));
    } catch (e) {
      return Left(AppFailure(e.toString()));
    }
  }

  Future<Either<AppFailure, List<LoginActivity>>> getLoginHistory() async {
    try {
      final response = await ApiClient.instance.get(
        Uri.parse('${ServerConstants.serverUrl}/auth/login-history'),
      );

      if (response.statusCode >= 200 && response.statusCode < 300) {
        final decoded = decodeMapOrThrow(response);
        final items = (decoded['items'] as List<dynamic>? ?? []).map((item) {
          final map = item as Map<String, dynamic>;
          final createdAt =
              DateTime.tryParse(map['created_at']?.toString() ?? '') ??
              DateTime.now();
          final revoked = map['revoked'] as bool? ?? false;
          return LoginActivity(
            title: revoked ? 'Signed-out session' : 'Active sign-in',
            subtitle: revoked
                ? 'This session was revoked or signed out'
                : 'This session can refresh access tokens',
            createdAt: createdAt,
            isCurrent: !revoked,
          );
        }).toList();
        return Right(items);
      }
      return Left(
        AppFailure(
          responseErrorMessage(response, 'Failed to load login history'),
        ),
      );
    } on SessionExpiredException catch (e) {
      return Left(AppFailure(e.toString()));
    } catch (e) {
      return Left(AppFailure(e.toString()));
    }
  }

  Future<Either<AppFailure, void>> deactivateAccount({
    required String password,
  }) async {
    return _accountStatusRequest(
      path: '/auth/account/deactivate',
      password: password,
      fallback: 'Failed to deactivate account',
      delete: false,
    );
  }

  Future<Either<AppFailure, void>> deleteAccount({
    required String password,
  }) async {
    return _accountStatusRequest(
      path: '/auth/account',
      password: password,
      fallback: 'Failed to delete account',
      delete: true,
    );
  }

  Future<Either<AppFailure, void>> _accountStatusRequest({
    required String path,
    required String password,
    required String fallback,
    required bool delete,
  }) async {
    try {
      final uri = Uri.parse('${ServerConstants.serverUrl}$path');
      final body = jsonEncode({'password': password});
      final response = delete
          ? await ApiClient.instance.delete(uri, body: body)
          : await ApiClient.instance.post(uri, body: body);

      if (response.statusCode >= 200 && response.statusCode < 300) {
        return const Right(null);
      }
      return Left(AppFailure(responseErrorMessage(response, fallback)));
    } on SessionExpiredException catch (e) {
      return Left(AppFailure(e.toString()));
    } catch (e) {
      return Left(AppFailure(e.toString()));
    }
  }
}
