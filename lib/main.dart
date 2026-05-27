import 'dart:async';

import 'package:africa_beuty/core/http/api_client.dart';
import 'package:africa_beuty/core/monitoring/error_monitor.dart';
import 'package:africa_beuty/core/page/bottom_nav.dart';
import 'package:africa_beuty/core/push/push_notification_service.dart';
import 'package:africa_beuty/core/reminders/reminder_service.dart';
import 'package:africa_beuty/core/theme/dark_theme.dart';
import 'package:africa_beuty/core/theme/light_theme.dart';
import 'package:africa_beuty/core/widgets/network_status_banner.dart';
import 'package:africa_beuty/feature/auth/repositories/local_storage_service.dart';
import 'package:africa_beuty/feature/auth/view/page/forgot_password.dart';
import 'package:africa_beuty/feature/auth/view/page/login.dart';
import 'package:africa_beuty/feature/auth/view/page/logout_page.dart';
import 'package:africa_beuty/feature/auth/view/page/set_profile.dart';
import 'package:africa_beuty/feature/auth/view/page/sign_up.dart';
import 'package:africa_beuty/feature/auth/view/page/verify.dart';
import 'package:africa_beuty/feature/welcome/view/page/select_account.dart';
import 'package:africa_beuty/feature/welcome/view/page/welcome.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';

final navigatorKey = GlobalKey<NavigatorState>();

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await ErrorMonitor.init();
  ErrorMonitor.installFlutterHandlers();

  ErrorMonitor.runGuarded(() async {
    await _bootstrap();
  });
}

Future<void> _bootstrap() async {
  await Hive.initFlutter();

  // When both tokens are expired the ApiClient calls this to force logout.
  ApiClient.onSessionExpired = () {
    navigatorKey.currentState?.pushNamedAndRemoveUntil('/signin', (_) => false);
  };

  final bool isFirstTime = await LocalStorageService.getIsFirstTime();
  final bool isLoggedIn = await LocalStorageService.isLoggedIn();

  runApp(
    ProviderScope(
      child: MyApp(isFirstTime: isFirstTime, isLoggedIn: isLoggedIn),
    ),
  );

  unawaited(_startPostLaunchServices(isLoggedIn: isLoggedIn));
}

Future<void> _startPostLaunchServices({required bool isLoggedIn}) async {
  await ReminderService.instance.init();
  await PushNotificationService.instance.init();
  if (isLoggedIn) {
    await PushNotificationService.instance.syncTokenIfPossible();
    await ReminderService.instance.syncFromServer();
  }
}

class MyApp extends StatelessWidget {
  final bool isFirstTime;
  final bool isLoggedIn;

  const MyApp({super.key, required this.isFirstTime, required this.isLoggedIn});

  Widget _getStartPage() {
    if (isFirstTime) {
      return const WelcomePage();
    }

    if (isLoggedIn) {
      return const BottomNavigationPage();
    }

    return const SignInPage();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'African Beauty',
      theme: LightTheme.theme,
      darkTheme: DarkTheme.theme,
      themeMode: ThemeMode.system,
      debugShowCheckedModeBanner: false,
      navigatorKey: navigatorKey,
      builder: (context, child) {
        return NetworkStatusBanner(child: child ?? const SizedBox.shrink());
      },
      home: _getStartPage(),
      routes: {
        '/select_account': (context) => const SelectAccount(),
        '/signup': (context) => const SignUpPage(),
        '/signin': (context) => const SignInPage(),
        '/forgot_password': (context) => const ForgotPasswordPage(),
        '/verify': (context) => const Verify(),
        '/logout': (context) => const LogoutPage(),
        '/page0': (context) => const BottomNavigationPage(),
        '/set_profile': (context) => const SetProfile(),
      },
    );
  }
}
