import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:africa_beuty/core/constants/server_constants.dart';
import 'package:africa_beuty/core/failure/failure.dart';
import 'package:africa_beuty/core/http/api_client.dart';
import 'package:africa_beuty/feature/notifications/model/notification.dart';
import 'package:fpdart/fpdart.dart';

abstract class NotificationRepository {
  Future<Either<AppFailure, NotificationListPage>> list({
    String? cursor,
    int limit = 20,
  });

  Future<Either<AppFailure, int>> unreadCount();

  Future<Either<AppFailure, bool>> markAllRead();

  Future<Either<AppFailure, bool>> markRead(String notificationId);
}

class NotificationRepositoryImpl implements NotificationRepository {
  @override
  Future<Either<AppFailure, NotificationListPage>> list({
    String? cursor,
    int limit = 20,
  }) async {
    try {
      final params = <String, String>{
        'limit': limit.toString(),
        if (cursor != null) 'cursor': cursor,
      };

      final uri = Uri.parse(
        '${ServerConstants.serverUrl}/notifications',
      ).replace(queryParameters: params);

      final response = await ApiClient.instance
          .get(uri)
          .timeout(const Duration(seconds: 15));

      if (response.statusCode == 200) {
        final body = jsonDecode(response.body) as Map<String, dynamic>;
        return Right(NotificationListPage.fromMap(body));
      }

      final body = _safeDecode(response.body);
      return Left(AppFailure(body?['detail'] ?? 'Failed to load notifications'));
    } on SocketException {
      return Left(AppFailure('No internet connection'));
    } on TimeoutException {
      return Left(AppFailure('Request timed out'));
    } on SessionExpiredException catch (e) {
      return Left(AppFailure(e.toString()));
    } catch (e) {
      return Left(AppFailure('Load notifications error: $e'));
    }
  }

  @override
  Future<Either<AppFailure, int>> unreadCount() async {
    try {
      final uri = Uri.parse(
        '${ServerConstants.serverUrl}/notifications/unread-count',
      );

      final response = await ApiClient.instance
          .get(uri)
          .timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        final body = jsonDecode(response.body) as Map<String, dynamic>;
        return Right((body['unread'] ?? 0) as int);
      }

      final body = _safeDecode(response.body);
      return Left(AppFailure(body?['detail'] ?? 'Failed to load unread count'));
    } on SocketException {
      return Left(AppFailure('No internet connection'));
    } on TimeoutException {
      return Left(AppFailure('Request timed out'));
    } on SessionExpiredException catch (e) {
      return Left(AppFailure(e.toString()));
    } catch (e) {
      return Left(AppFailure('Unread count error: $e'));
    }
  }

  @override
  Future<Either<AppFailure, bool>> markAllRead() async {
    try {
      final uri = Uri.parse(
        '${ServerConstants.serverUrl}/notifications/read',
      );

      final response = await ApiClient.instance
          .post(uri)
          .timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) return const Right(true);

      final body = _safeDecode(response.body);
      return Left(AppFailure(body?['detail'] ?? 'Failed to mark as read'));
    } on SocketException {
      return Left(AppFailure('No internet connection'));
    } on TimeoutException {
      return Left(AppFailure('Request timed out'));
    } on SessionExpiredException catch (e) {
      return Left(AppFailure(e.toString()));
    } catch (e) {
      return Left(AppFailure('Mark read error: $e'));
    }
  }

  @override
  Future<Either<AppFailure, bool>> markRead(String notificationId) async {
    try {
      final uri = Uri.parse(
        '${ServerConstants.serverUrl}/notifications/$notificationId/read',
      );

      final response = await ApiClient.instance
          .post(uri)
          .timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) return const Right(true);

      final body = _safeDecode(response.body);
      return Left(AppFailure(body?['detail'] ?? 'Failed to mark as read'));
    } on SocketException {
      return Left(AppFailure('No internet connection'));
    } on TimeoutException {
      return Left(AppFailure('Request timed out'));
    } on SessionExpiredException catch (e) {
      return Left(AppFailure(e.toString()));
    } catch (e) {
      return Left(AppFailure('Mark read error: $e'));
    }
  }
}

Map<String, dynamic>? _safeDecode(String body) {
  try {
    return jsonDecode(body) as Map<String, dynamic>;
  } catch (_) {
    return null;
  }
}
