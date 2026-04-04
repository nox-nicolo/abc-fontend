import 'package:africa_beuty/core/http/api_client.dart';
import 'package:africa_beuty/core/page/bottom_nav.dart';
import 'package:africa_beuty/core/theme/dark_theme.dart';
import 'package:africa_beuty/core/theme/light_theme.dart';
import 'package:africa_beuty/feature/auth/repositories/local_storage_service.dart';
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
  await Hive.initFlutter();

  // When both tokens are expired the ApiClient calls this to force logout.
  ApiClient.onSessionExpired = () {
    navigatorKey.currentState?.pushNamedAndRemoveUntil(
      '/signin',
      (_) => false,
    );
  };

  final bool isFirstTime = await LocalStorageService.getIsFirstTime();
  final bool isLoggedIn = await LocalStorageService.isLoggedIn();

  runApp(
    ProviderScope(
      child: MyApp(
        isFirstTime: isFirstTime,
        isLoggedIn: isLoggedIn,
      ),
    ),
  );
}

class MyApp extends StatelessWidget {
  final bool isFirstTime;
  final bool isLoggedIn;

  const MyApp({
    super.key,
    required this.isFirstTime,
    required this.isLoggedIn,
  });

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
      home: _getStartPage(),
      routes: {
        '/select_account': (context) => const SelectAccount(),
        '/signup': (context) => const SignUpPage(),
        '/signin': (context) => const SignInPage(),
        '/verify': (context) => const Verify(),
        '/logout': (context) => const LogoutPage(),
        '/page0': (context) => const BottomNavigationPage(),
        '/set_profile': (context) => const SetProfile(),
      },
    );
  }
}