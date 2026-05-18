import 'dart:async';
import 'dart:convert';
import 'dart:math';

import 'package:africa_beuty/core/constants/server_constants.dart';
import 'package:africa_beuty/core/http/api_client.dart';
import 'package:africa_beuty/core/monitoring/app_logger.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:permission_handler/permission_handler.dart' as permissions;
import 'package:shared_preferences/shared_preferences.dart';

const _pushChannelId = 'abc_high_importance';
const _pushChannelName = 'Important Notifications';
const _pushChannelDesc =
    'Messages, bookings, comments, likes, and salon updates';

final FlutterLocalNotificationsPlugin _localNotifications =
    FlutterLocalNotificationsPlugin();
bool _localNotificationsInitialized = false;

@pragma('vm:entry-point')
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  try {
    await Firebase.initializeApp();
  } catch (_) {}

  if (message.notification == null) {
    await _showLocalNotification(message);
  }
}

class PushNotificationService {
  PushNotificationService._();

  static final PushNotificationService instance = PushNotificationService._();

  static const String _deviceIdKey = 'abc_device_id';
  static const String _appVersion = String.fromEnvironment(
    'APP_VERSION',
    defaultValue: '1.0.0',
  );
  static const String _buildNumber = String.fromEnvironment(
    'BUILD_NUMBER',
    defaultValue: '1',
  );

  bool _initialized = false;
  StreamSubscription<String>? _tokenRefreshSub;
  StreamSubscription<RemoteMessage>? _foregroundSub;

  Future<void> init() async {
    if (_initialized) return;

    try {
      await Firebase.initializeApp();
      FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);
      await _ensureLocalNotificationsInitialized();
      await FirebaseMessaging.instance
          .setForegroundNotificationPresentationOptions(
            alert: true,
            badge: true,
            sound: true,
          );
      _initialized = true;
    } catch (error, stackTrace) {
      AppLogger.warning(
        'Firebase push notifications disabled. Add Firebase app config files.',
        error: error,
        stackTrace: stackTrace,
      );
      return;
    }

    _tokenRefreshSub?.cancel();
    _tokenRefreshSub = FirebaseMessaging.instance.onTokenRefresh.listen(
      (token) => unawaited(_registerToken(token)),
      onError: (error, stackTrace) {
        AppLogger.warning(
          'FCM token refresh failed',
          error: error,
          stackTrace: stackTrace is StackTrace ? stackTrace : null,
        );
      },
    );

    _foregroundSub?.cancel();
    _foregroundSub = FirebaseMessaging.onMessage.listen(
      (message) => unawaited(_showLocalNotification(message)),
      onError: (error, stackTrace) {
        AppLogger.warning(
          'Foreground FCM handling failed',
          error: error,
          stackTrace: stackTrace is StackTrace ? stackTrace : null,
        );
      },
    );
  }

  Future<void> syncTokenIfPossible() async {
    await init();
    if (!_initialized) return;

    try {
      final token = await FirebaseMessaging.instance.getToken();
      if (token == null || token.isEmpty) {
        AppLogger.warning('FCM token is empty; phone cannot receive push yet');
        return;
      }
      await _registerToken(token);
    } catch (error, stackTrace) {
      AppLogger.warning(
        'Could not sync FCM token',
        error: error,
        stackTrace: stackTrace,
      );
    }
  }

  Future<PushPermissionResult> requestNotificationPermission() async {
    await init();
    if (!_initialized) return PushPermissionResult.unavailable;

    try {
      await _ensureLocalNotificationsInitialized();

      final android = _localNotifications
          .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin
          >();
      final androidGranted = await android?.requestNotificationsPermission();

      final settings = await FirebaseMessaging.instance.requestPermission(
        alert: true,
        badge: true,
        sound: true,
      );

      final firebaseGranted =
          settings.authorizationStatus == AuthorizationStatus.authorized ||
          settings.authorizationStatus == AuthorizationStatus.provisional;
      final granted = androidGranted ?? firebaseGranted;

      if (granted) {
        await syncTokenIfPossible();
        return PushPermissionResult.granted;
      }

      final status = await permissions.Permission.notification.status;
      if (status.isPermanentlyDenied) {
        return PushPermissionResult.permanentlyDenied;
      }
      return PushPermissionResult.denied;
    } catch (error, stackTrace) {
      AppLogger.warning(
        'Notification permission request failed',
        error: error,
        stackTrace: stackTrace,
      );
      return PushPermissionResult.unavailable;
    }
  }

  Future<PushPermissionResult> notificationPermissionStatus() async {
    try {
      final status = await permissions.Permission.notification.status;
      if (status.isGranted) return PushPermissionResult.granted;
      if (status.isPermanentlyDenied) {
        return PushPermissionResult.permanentlyDenied;
      }
      if (status.isDenied) return PushPermissionResult.denied;
      return PushPermissionResult.unavailable;
    } catch (error, stackTrace) {
      AppLogger.warning(
        'Notification permission status check failed',
        error: error,
        stackTrace: stackTrace,
      );
      return PushPermissionResult.unavailable;
    }
  }

  Future<void> openNotificationSettings() async {
    await permissions.openAppSettings();
  }

  Future<void> _registerToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    var deviceId = prefs.getString(_deviceIdKey);
    if (deviceId == null || deviceId.isEmpty) {
      deviceId = _newDeviceId();
      await prefs.setString(_deviceIdKey, deviceId);
    }

    final response = await ApiClient.instance.put(
      Uri.parse('${ServerConstants.serverUrl}/users/me/device-tokens'),
      body: jsonEncode({
        'device_id': deviceId,
        'platform': _platformLabel(),
        'push_provider': 'fcm',
        'push_token': token,
        'app_version': _appVersion,
        'build_number': _buildNumber,
      }),
    );

    if (response.statusCode < 200 || response.statusCode >= 300) {
      AppLogger.warning(
        'Backend rejected FCM device token',
        error: response.statusCode,
      );
    } else {
      AppLogger.info('FCM device token registered with backend');
    }
  }

  String _platformLabel() {
    if (kIsWeb) return 'web';
    return defaultTargetPlatform.name;
  }

  String _newDeviceId() {
    final randomPart = Random.secure().nextInt(0x7fffffff);
    return '${_platformLabel()}-${DateTime.now().microsecondsSinceEpoch}-$randomPart';
  }
}

enum PushPermissionResult { granted, denied, permanentlyDenied, unavailable }

Future<void> _showLocalNotification(RemoteMessage message) async {
  await _ensureLocalNotificationsInitialized();

  final notification = message.notification;
  final title =
      notification?.title ??
      message.data['title']?.toString() ??
      'African Beauty';
  final body =
      notification?.body ??
      message.data['body']?.toString() ??
      'New notification';

  await _localNotifications.show(
    message.messageId?.hashCode ?? DateTime.now().millisecondsSinceEpoch,
    title,
    body,
    NotificationDetails(
      android: const AndroidNotificationDetails(
        _pushChannelId,
        _pushChannelName,
        channelDescription: _pushChannelDesc,
        importance: Importance.high,
        priority: Priority.high,
        playSound: true,
        enableVibration: true,
        icon: '@mipmap/ic_launcher',
      ),
      iOS: const DarwinNotificationDetails(
        presentAlert: true,
        presentBadge: true,
        presentSound: true,
      ),
    ),
    payload: jsonEncode(message.data),
  );
}

Future<void> _ensureLocalNotificationsInitialized({
  bool requestPermission = false,
}) async {
  if (_localNotificationsInitialized) return;

  const androidInit = AndroidInitializationSettings('@mipmap/ic_launcher');
  const iosInit = DarwinInitializationSettings(
    requestAlertPermission: false,
    requestBadgePermission: false,
    requestSoundPermission: false,
  );

  await _localNotifications.initialize(
    const InitializationSettings(android: androidInit, iOS: iosInit),
  );

  final android = _localNotifications
      .resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin
      >();
  if (requestPermission) await android?.requestNotificationsPermission();
  await android?.createNotificationChannel(
    const AndroidNotificationChannel(
      _pushChannelId,
      _pushChannelName,
      description: _pushChannelDesc,
      importance: Importance.high,
      playSound: true,
    ),
  );

  _localNotificationsInitialized = true;
}
