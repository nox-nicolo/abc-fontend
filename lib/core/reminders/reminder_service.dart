import 'dart:async';
import 'dart:convert';

import 'package:africa_beuty/core/constants/server_constants.dart';
import 'package:africa_beuty/core/http/api_client.dart';
import 'package:africa_beuty/core/http/paginated_response.dart';
import 'package:africa_beuty/feature/profile/model/notification_preferences.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest_all.dart' as tzdata;
import 'package:timezone/timezone.dart' as tz;

class ReminderService {
  ReminderService._();
  static final ReminderService instance = ReminderService._();

  static const _channelId = 'booking_reminders';
  static const _channelName = 'Booking Reminders';
  static const _channelDesc = 'Reminders for upcoming bookings';

  final FlutterLocalNotificationsPlugin _plugin =
      FlutterLocalNotificationsPlugin();

  bool _initialized = false;

  Future<void> init() async {
    if (_initialized) return;
    tzdata.initializeTimeZones();

    const androidInit = AndroidInitializationSettings('@mipmap/ic_launcher');
    const iosInit = DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );
    const settings = InitializationSettings(android: androidInit, iOS: iosInit);

    await _plugin.initialize(settings);

    // Android 13+ runtime permission for POST_NOTIFICATIONS.
    final android = _plugin
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >();
    await android?.requestNotificationsPermission();

    _initialized = true;
  }

  /// Wipe all scheduled reminders and rebuild from server state.
  /// Safe to call at app start, after preferences change, or after a booking
  /// is created / cancelled / rescheduled.
  Future<void> syncFromServer() async {
    if (!_initialized) await init();

    try {
      final prefs = await _fetchPreferences();
      if (prefs == null) return;

      await _plugin.cancelAll();

      if (!prefs.allowReminders) return;

      final lead = Duration(minutes: prefs.reminderLeadMinutes);
      final now = DateTime.now();

      final customerBookings = await _fetchCustomerBookings();
      for (final (id, startAt, label) in customerBookings) {
        _scheduleFor(
          notificationId: (id.hashCode & 0x7FFFFFFF),
          title: 'Upcoming appointment',
          body: label != null
              ? 'Your $label starts in ${prefs.reminderLeadMinutes} min'
              : 'Your appointment starts in ${prefs.reminderLeadMinutes} min',
          fireAt: startAt.subtract(lead),
          now: now,
        );
      }

      final salonBookings = await _fetchSalonBookings();
      for (final (id, startAt, label) in salonBookings) {
        _scheduleFor(
          notificationId: (~id.hashCode) & 0x7FFFFFFF,
          title: 'Upcoming booking at your salon',
          body: label != null
              ? '$label in ${prefs.reminderLeadMinutes} min'
              : 'A booking starts in ${prefs.reminderLeadMinutes} min',
          fireAt: startAt.subtract(lead),
          now: now,
        );
      }
    } catch (e) {
      if (kDebugMode) {
        debugPrint('ReminderService.syncFromServer failed: $e');
      }
    }
  }

  Future<void> cancelAll() async {
    if (!_initialized) await init();
    await _plugin.cancelAll();
  }

  void _scheduleFor({
    required int notificationId,
    required String title,
    required String body,
    required DateTime fireAt,
    required DateTime now,
  }) {
    if (!fireAt.isAfter(now)) return; // already past — skip
    final tzTime = tz.TZDateTime.from(fireAt, tz.local);

    _plugin.zonedSchedule(
      notificationId,
      title,
      body,
      tzTime,
      const NotificationDetails(
        android: AndroidNotificationDetails(
          _channelId,
          _channelName,
          channelDescription: _channelDesc,
          importance: Importance.high,
          priority: Priority.high,
        ),
        iOS: DarwinNotificationDetails(),
      ),
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
    );
  }

  Future<NotificationPreferences?> _fetchPreferences() async {
    try {
      final uri = Uri.parse(
        '${ServerConstants.serverUrl}/users/me/notification-preferences',
      );
      final res = await ApiClient.instance.get(uri);
      if (res.statusCode >= 200 && res.statusCode < 300) {
        final decoded = jsonDecode(res.body) as Map<String, dynamic>;
        return NotificationPreferences.fromMap(decoded);
      }
    } catch (_) {}
    return null;
  }

  Future<List<(String, DateTime, String?)>> _fetchCustomerBookings() async {
    try {
      final uri = Uri.parse(
        '${ServerConstants.serverUrl}/booking/my?upcoming=true',
      );
      final res = await ApiClient.instance.get(uri);
      if (res.statusCode >= 200 && res.statusCode < 300) {
        final decoded = listFromPaginatedBody(jsonDecode(res.body));
        return decoded
            .whereType<Map<String, dynamic>>()
            .map(
              (m) => (
                m['id'] as String,
                DateTime.parse(m['start_at'] as String).toLocal(),
                m['service_name_snapshot'] as String?,
              ),
            )
            .toList();
      }
    } catch (_) {}
    return const [];
  }

  Future<List<(String, DateTime, String?)>> _fetchSalonBookings() async {
    try {
      final uri = Uri.parse(
        '${ServerConstants.serverUrl}/booking/salon?upcoming=true',
      );
      final res = await ApiClient.instance.get(uri);
      if (res.statusCode >= 200 && res.statusCode < 300) {
        final decoded = listFromPaginatedBody(jsonDecode(res.body));
        return decoded
            .whereType<Map<String, dynamic>>()
            .map(
              (m) => (
                m['id'] as String,
                DateTime.parse(m['start_at'] as String).toLocal(),
                _salonLabel(m),
              ),
            )
            .toList();
      }
    } catch (_) {}
    return const [];
  }

  String? _salonLabel(Map<String, dynamic> m) {
    final name = m['customer_name'] as String?;
    final service = m['service_name_snapshot'] as String?;
    if (name != null && service != null) return '$name — $service';
    return name ?? service;
  }
}
