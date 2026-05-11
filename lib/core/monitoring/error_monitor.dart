import 'dart:async';
import 'dart:convert';

import 'package:africa_beuty/core/constants/server_constants.dart';
import 'package:africa_beuty/core/monitoring/app_logger.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bugfender/flutter_bugfender.dart';
import 'package:http/http.dart' as http;

class ErrorMonitor {
  ErrorMonitor._();

  static const String _bugfenderKey = String.fromEnvironment(
    'BUGFENDER_APP_KEY',
  );
  static const String _appVersion = String.fromEnvironment(
    'APP_VERSION',
    defaultValue: '1.0.0',
  );
  static const String _buildNumber = String.fromEnvironment(
    'BUILD_NUMBER',
    defaultValue: '1',
  );
  static const bool _backendReportingEnabled = bool.fromEnvironment(
    'BACKEND_CRASH_REPORTING_ENABLED',
    defaultValue: true,
  );
  static bool _bugfenderEnabled = false;

  static Future<void> init() async {
    if (_bugfenderKey.isEmpty) {
      AppLogger.info('Remote Flutter error monitoring disabled');
      return;
    }

    try {
      await FlutterBugfender.init(
        _bugfenderKey,
        printToConsole: kDebugMode,
        enableUIEventLogging: false,
        enableCrashReporting: true,
      );
      _bugfenderEnabled = true;
      AppLogger.info('Bugfender error monitoring enabled');
    } catch (error, stackTrace) {
      AppLogger.warning(
        'Bugfender initialization failed',
        error: error,
        stackTrace: stackTrace,
      );
    }
  }

  static void installFlutterHandlers() {
    FlutterError.onError = (FlutterErrorDetails details) {
      FlutterError.presentError(details);
      capture(
        details.exception,
        details.stack,
        context: details.context?.toDescription(),
      );
    };

    PlatformDispatcher.instance.onError = (Object error, StackTrace stack) {
      capture(error, stack, context: 'platform_dispatcher');
      return true;
    };
  }

  static void runGuarded(FutureOr<void> Function() body) {
    runZonedGuarded(body, (Object error, StackTrace stackTrace) {
      capture(error, stackTrace, context: 'zone');
    });
  }

  static void capture(Object error, StackTrace? stackTrace, {String? context}) {
    final message = context ?? 'Unhandled Flutter error';
    AppLogger.error(message, error: error, stackTrace: stackTrace);

    if (_bugfenderEnabled) {
      unawaited(
        FlutterBugfender.sendCrash(
          error.toString(),
          stackTrace?.toString() ?? '',
        ),
      );
    }
    unawaited(_sendBackendReport(error, stackTrace, context: context));
  }

  static Future<void> _sendBackendReport(
    Object error,
    StackTrace? stackTrace, {
    String? context,
  }) async {
    if (!_backendReportingEnabled) return;

    try {
      final uri = Uri.parse('${ServerConstants.serverUrl}/crash-reports');
      final response = await http
          .post(
            uri,
            headers: const {'Content-Type': 'application/json'},
            body: jsonEncode({
              'message': context ?? 'Unhandled Flutter error',
              'error': error.toString(),
              'stack_trace': stackTrace?.toString(),
              'context': context,
              'platform': _platformLabel(),
              'app_version': _appVersion,
              'build_number': _buildNumber,
              'fatal': true,
            }),
          )
          .timeout(const Duration(seconds: 5));

      if (response.statusCode >= 400) {
        AppLogger.warning(
          'Backend crash report rejected',
          error: response.statusCode,
        );
      }
    } catch (reportError, reportStack) {
      AppLogger.warning(
        'Backend crash report failed',
        error: reportError,
        stackTrace: reportStack,
      );
    }
  }

  static String _platformLabel() {
    if (kIsWeb) return 'web';
    return defaultTargetPlatform.name;
  }
}
