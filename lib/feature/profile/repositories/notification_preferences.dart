import 'dart:async';
import 'dart:convert';

import 'package:africa_beuty/core/constants/server_constants.dart';
import 'package:africa_beuty/core/failure/failure.dart';
import 'package:africa_beuty/core/http/api_client.dart';
import 'package:africa_beuty/feature/profile/model/notification_preferences.dart';
import 'package:fpdart/fpdart.dart';

class NotificationPreferencesRepository {
  Future<Either<AppFailure, NotificationPreferences>> getPreferences() async {
    try {
      final uri = Uri.parse(
          '${ServerConstants.serverUrl}/users/me/notification-preferences');
      final res = await ApiClient.instance.get(uri);
      if (res.statusCode >= 200 && res.statusCode < 300) {
        final decoded = jsonDecode(res.body) as Map<String, dynamic>;
        return Right(NotificationPreferences.fromMap(decoded));
      }
      return Left(_detail(res.body, 'Failed to load reminder settings'));
    } on TimeoutException {
      return Left(AppFailure('Request timed out'));
    } on SessionExpiredException catch (e) {
      return Left(AppFailure(e.toString()));
    } catch (e) {
      return Left(AppFailure(e.toString()));
    }
  }

  Future<Either<AppFailure, NotificationPreferences>> updatePreferences({
    bool? allowReminders,
    int? reminderLeadMinutes,
  }) async {
    try {
      final uri = Uri.parse(
          '${ServerConstants.serverUrl}/users/me/notification-preferences');
      final body = <String, dynamic>{};
      if (allowReminders != null) body['allow_reminders'] = allowReminders;
      if (reminderLeadMinutes != null) {
        body['reminder_lead_minutes'] = reminderLeadMinutes;
      }

      final res =
          await ApiClient.instance.patch(uri, body: jsonEncode(body));
      if (res.statusCode >= 200 && res.statusCode < 300) {
        final decoded = jsonDecode(res.body) as Map<String, dynamic>;
        return Right(NotificationPreferences.fromMap(decoded));
      }
      return Left(_detail(res.body, 'Failed to update reminder settings'));
    } on TimeoutException {
      return Left(AppFailure('Request timed out'));
    } on SessionExpiredException catch (e) {
      return Left(AppFailure(e.toString()));
    } catch (e) {
      return Left(AppFailure(e.toString()));
    }
  }

  AppFailure _detail(String body, String fallback) {
    try {
      final decoded = jsonDecode(body);
      return AppFailure(decoded['detail']?.toString() ?? fallback);
    } catch (_) {
      return AppFailure(fallback);
    }
  }
}
