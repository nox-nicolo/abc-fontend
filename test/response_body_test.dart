import 'package:africa_beuty/core/http/response_body.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;

void main() {
  test('tryDecodeMap returns null for empty bodies', () {
    expect(tryDecodeMap(''), isNull);
    expect(tryDecodeMap('   '), isNull);
  });

  test('responseErrorMessage adds context for empty server error bodies', () {
    final response = http.Response('', 502);

    expect(
      responseErrorMessage(response, 'Login failed'),
      'Login failed. The server is having trouble right now. Please try again.',
    );
  });

  test('responseErrorMessage reads detail from JSON errors', () {
    final response = http.Response('{"detail":"Invalid credentials"}', 401);

    expect(
      responseErrorMessage(response, 'Login failed'),
      'Invalid credentials',
    );
  });

  test('responseErrorMessage adds context for generic server errors', () {
    final response = http.Response(
      '{"detail":"Server error. Please try again later"}',
      500,
    );

    expect(
      responseErrorMessage(response, 'Failed to load posts'),
      'Failed to load posts. The server is having trouble right now. Please try again.',
    );
  });

  test('responseErrorMessage keeps specific server errors', () {
    final response = http.Response('{"detail":"Image upload failed"}', 500);

    expect(
      responseErrorMessage(response, 'Account upload failed'),
      'Image upload failed',
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
