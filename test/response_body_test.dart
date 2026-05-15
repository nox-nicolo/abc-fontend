import 'package:africa_beuty/core/http/response_body.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;

void main() {
  test('tryDecodeMap returns null for empty bodies', () {
    expect(tryDecodeMap(''), isNull);
    expect(tryDecodeMap('   '), isNull);
  });

  test('responseErrorMessage uses fallback for empty error bodies', () {
    final response = http.Response('', 502);

    expect(
      responseErrorMessage(response, 'Login failed'),
      'Login failed. Server returned an empty response.',
    );
  });

  test('responseErrorMessage reads detail from JSON errors', () {
    final response = http.Response('{"detail":"Invalid credentials"}', 401);

    expect(
      responseErrorMessage(response, 'Login failed'),
      'Invalid credentials',
    );
  });

  test('decodeMapOrThrow gives a readable error for empty success bodies', () {
    final response = http.Response('', 200);

    expect(
      () => decodeMapOrThrow(response),
      throwsA(
        isA<FormatException>().having(
          (error) => error.message,
          'message',
          'Server returned an empty response (200).',
        ),
      ),
    );
  });
}
