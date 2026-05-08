import 'dart:async';

import 'package:africa_beuty/core/monitoring/app_logger.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bugfender/flutter_bugfender.dart';

class ErrorMonitor {
  ErrorMonitor._();

  static const String _bugfenderKey = String.fromEnvironment(
    'BUGFENDER_APP_KEY',
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

    if (!_bugfenderEnabled) return;

    unawaited(
      FlutterBugfender.sendCrash(
        error.toString(),
        stackTrace?.toString() ?? '',
      ),
    );
  }
}
