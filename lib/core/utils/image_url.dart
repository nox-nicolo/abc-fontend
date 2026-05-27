import 'package:africa_beuty/core/constants/server_constants.dart';

String imageUrlOrEmpty(Object? value) => resolveImageUrl(value) ?? '';

String? resolveImageUrl(Object? value) {
  final raw = value?.toString().trim();
  if (raw == null || raw.isEmpty) return null;

  final lower = raw.toLowerCase();
  if (lower == 'not set' || lower == 'null' || lower == 'none') return null;
  if (raw.startsWith('http://') ||
      raw.startsWith('https://') ||
      raw.startsWith('data:')) {
    return raw;
  }

  final base = ServerConstants.apiBaseUrl.replaceFirst(RegExp(r'/+$'), '');
  final path = raw.startsWith('/') ? raw : '/$raw';
  return '$base$path';
}
