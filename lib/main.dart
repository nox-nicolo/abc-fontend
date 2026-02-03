
import 'package:africa_beuty/core/page/bottom_nav.dart';
import 'package:africa_beuty/feature/auth/view/page/login.dart';
import 'package:africa_beuty/feature/auth/view/page/set_profile.dart';
import 'package:africa_beuty/feature/auth/view/page/sign_up.dart';
import 'package:africa_beuty/feature/auth/view/page/verify.dart';
import 'package:africa_beuty/feature/home/views/page/home_screen.dart';
import 'package:africa_beuty/core/theme/dark_theme.dart';
import 'package:africa_beuty/core/theme/light_theme.dart';
import 'package:africa_beuty/feature/profile/view/widget/create_service.dart';
import 'package:africa_beuty/feature/welcome/view/page/select_account.dart';
import 'package:africa_beuty/feature/welcome/view/page/welcome.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';

void main() async {
  // Initialize Hive
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter(); 
  
  // Open the settings box
  var box = await Hive.openBox('settings');
  
  // Check if first_time exists, if not, it defaults to true
  bool isFirstTime = box.get('isFirstTime', defaultValue: true);

  runApp(
    ProviderScope(
      child: MyApp(isFirstTime: isFirstTime), 
    )
  );
}

class MyApp extends StatelessWidget {
  final bool isFirstTime;
  const MyApp({super.key, required this.isFirstTime});

  @override
  Widget build(BuildContext context) {
    
    return MaterialApp(
      title: 'African Beauty',
      theme: LightTheme.theme,
      darkTheme: DarkTheme.theme,
      themeMode: ThemeMode.system,
      debugShowCheckedModeBanner: false,
      // initialRoute: isFirstTime ? '/' : '/signin',

      routes: {
        // '/': (context) =>  WelcomePage(),
        '/': (context) => SelectServicePage(),
        '/select_account': (context) => const SelectAccount(), 
        '/signup': (context) => const SignUpPage(), 
        '/signin': (context) => const SignInPage(), 
        '/verify': (context) => const Verify(),
        '/home': (context) => const HomeScreen(),
        '/page0': (context) => const BottomNavigationPage(), // page0
        '/set_profile': (context) => const SetProfile(),  // set_profile
      }
    );
  }
}

