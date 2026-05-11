import 'package:africa_beuty/core/network/network_status_controller.dart';
import 'package:africa_beuty/core/widgets/network_status_banner.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('shows retry banner while offline', (tester) async {
    final controller = NetworkStatusController()..reportOffline();

    await tester.pumpWidget(
      MaterialApp(
        home: NetworkStatusBanner(
          controller: controller,
          child: const Scaffold(body: Text('Home')),
        ),
      ),
    );

    expect(find.text('You are offline'), findsOneWidget);
    expect(find.text('Retry'), findsOneWidget);

    controller.dispose();
  });

  testWidgets('shows recovered banner after reconnecting', (tester) async {
    final controller = NetworkStatusController()
      ..reportOffline()
      ..reportOnline();

    await tester.pumpWidget(
      MaterialApp(
        home: NetworkStatusBanner(
          controller: controller,
          child: const Scaffold(body: Text('Home')),
        ),
      ),
    );

    expect(find.text('Back online'), findsOneWidget);

    await tester.pump(const Duration(seconds: 3));
    await tester.pumpAndSettle();

    expect(find.text('Back online'), findsNothing);

    controller.dispose();
  });
}
