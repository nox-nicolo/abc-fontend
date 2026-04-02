import 'package:africa_beuty/core/page/bottom_nav.dart';
import 'package:africa_beuty/feature/auth/view/page/login.dart';
import 'package:africa_beuty/feature/welcome/view/page/welcome.dart';
import 'package:africa_beuty/main.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

void main() {
  testWidgets('shows welcome page for first-time user', (tester) async {
    await tester.pumpWidget(
      const ProviderScope(
        child: MyApp(
          isFirstTime: true,
          isLoggedIn: false,
        ),
      ),
    );

    await tester.pumpAndSettle();
    expect(find.byType(WelcomePage), findsOneWidget);
  });

  testWidgets('shows sign in page for returning logged out user', (tester) async {
    await tester.pumpWidget(
      const ProviderScope(
        child: MyApp(
          isFirstTime: false,
          isLoggedIn: false,
        ),
      ),
    );

    await tester.pumpAndSettle();
    expect(find.byType(SignInPage), findsOneWidget);
  });

  testWidgets('shows app shell for logged in user', (tester) async {
    await tester.pumpWidget(
      const ProviderScope(
        child: MyApp(
          isFirstTime: false,
          isLoggedIn: true,
        ),
      ),
    );

    await tester.pumpAndSettle();
    expect(find.byType(BottomNavigationPage), findsOneWidget);
  });
}