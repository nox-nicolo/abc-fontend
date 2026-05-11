import 'dart:async';
import 'dart:convert';

import 'package:africa_beuty/core/constants/server_constants.dart';
import 'package:africa_beuty/core/http/api_client.dart';
import 'package:africa_beuty/core/monitoring/app_logger.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';

@pragma('vm:entry-point')
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  try {
    await Firebase.initializeApp();
  } catch (_) {}
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

  Future<void> init() async {
    if (_initialized) return;

    try {
      await Firebase.initializeApp();
      FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);
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
  }

  Future<void> syncTokenIfPossible() async {
    await init();
    if (!_initialized) return;

    try {
      await FirebaseMessaging.instance.requestPermission(
        alert: true,
        badge: true,
        sound: true,
      );

      final token = await FirebaseMessaging.instance.getToken();
      if (token == null || token.isEmpty) return;
      await _registerToken(token);
    } catch (error, stackTrace) {
      AppLogger.warning(
        'Could not sync FCM token',
        error: error,
        stackTrace: stackTrace,
      );
    }
  }

  Future<void> _registerToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    var deviceId = prefs.getString(_deviceIdKey);
    if (deviceId == null || deviceId.isEmpty) {
      deviceId = const Uuid().v4();
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
    }
  }

  String _platformLabel() {
    if (kIsWeb) return 'web';
    return defaultTargetPlatform.name;
  }
}
