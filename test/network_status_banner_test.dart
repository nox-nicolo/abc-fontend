import 'package:africa_beuty/core/network/network_status_controller.dart';
import 'package:africa_beuty/core/widgets/network_status_banner.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';

void main() {
  testWidgets('shows retry banner while offline', (tester) async {
    final controller = NetworkStatusController(
      client: MockClient((request) async {
        throw http.ClientException('no route');
      }),
      serverProbeUri: Uri.parse('https://api.example.test'),
      internetProbeUri: Uri.parse('https://example.test'),
    );

    await controller.retry();

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

  testWidgets('shows connection problem before offline is confirmed', (
    tester,
  ) async {
    final controller = NetworkStatusController()
      ..reportOffline()
      ..reportOffline();

    await tester.pumpWidget(
      MaterialApp(
        home: NetworkStatusBanner(
          controller: controller,
          child: const Scaffold(body: Text('Home')),
        ),
      ),
    );

    expect(find.text('Connection problem'), findsOneWidget);
    expect(find.text('You are offline'), findsNothing);

    controller.dispose();
  });

  testWidgets('shows recovered banner after reconnecting', (tester) async {
    final controller = NetworkStatusController()
      ..reportOffline()
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

  testWidgets('retry shows offline only when server and internet probes fail', (
    tester,
  ) async {
    final controller = NetworkStatusController(
      client: MockClient((request) async {
        throw http.ClientException('no route');
      }),
      serverProbeUri: Uri.parse('https://api.example.test'),
      internetProbeUri: Uri.parse('https://example.test'),
    );

    final result = await controller.retry();

    expect(result, isFalse);
    expect(controller.isOffline, isTrue);

    controller.dispose();
  });

  testWidgets('retry keeps connection problem when internet still works', (
    tester,
  ) async {
    final controller = NetworkStatusController(
      client: MockClient((request) async {
        if (request.url.host == 'example.test') {
          return http.Response('', 204);
        }
        return http.Response('', 503);
      }),
      serverProbeUri: Uri.parse('https://api.example.test'),
      internetProbeUri: Uri.parse('https://example.test'),
    );

    final result = await controller.retry();

    expect(result, isFalse);
    expect(controller.isServerUnreachable, isTrue);
    expect(controller.isOffline, isFalse);

    controller.dispose();
  });
}
