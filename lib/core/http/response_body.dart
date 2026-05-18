import 'dart:convert';

import 'package:http/http.dart' as http;

Map<String, dynamic>? tryDecodeMap(String body) {
  if (body.trim().isEmpty) return null;

  try {
    final decoded = jsonDecode(body);
    return decoded is Map<String, dynamic> ? decoded : null;
  } catch (_) {
    return null;
  }
}

List<dynamic>? tryDecodeList(String body) {
  if (body.trim().isEmpty) return null;

  try {
    final decoded = jsonDecode(body);
    return decoded is List<dynamic> ? decoded : null;
  } catch (_) {
    return null;
  }
}

Map<String, dynamic> decodeMapOrThrow(http.Response response) {
  final decoded = tryDecodeMap(response.body);
  if (decoded != null) return decoded;

  throw FormatException(_invalidResponseMessage(response));
}

String responseErrorMessage(http.Response response, String fallback) {
  final decoded = tryDecodeMap(response.body);
  final detail = decoded?['detail'] ?? decoded?['message'] ?? decoded?['error'];

  if (response.statusCode >= 500) {
    return _serverErrorMessage(fallback, detail);
  }

  if (detail != null && detail.toString().trim().isNotEmpty) {
    return detail.toString();
  }

  if (response.body.trim().isEmpty) {
    return '$fallback. No data was returned. Please try again.';
  }

  return fallback;
}

String _serverErrorMessage(String fallback, Object? detail) {
  final message = detail?.toString().trim();
  if (message != null &&
      message.isNotEmpty &&
      !_isGenericServerError(message)) {
    return message;
  }

  return '$fallback. The server is having trouble right now. Please try again.';
}

bool _isGenericServerError(String message) {
  final normalized = message.toLowerCase();
  return normalized == 'server error' ||
      normalized == 'internal server error' ||
      normalized == 'server error. please try again later' ||
      normalized == 'something went wrong' ||
      normalized == 'try again later';
}

String _invalidResponseMessage(http.Response response) {
  if (response.body.trim().isEmpty) {
    return 'Server returned an empty response (${response.statusCode}).';
  }
  return 'Server returned an invalid response (${response.statusCode}).';
}
