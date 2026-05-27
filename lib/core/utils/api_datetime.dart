DateTime parseApiDateTime(Object? value) {
  final raw = value?.toString().trim();
  if (raw == null || raw.isEmpty) return DateTime.now().toUtc();

  final hasTimezone = RegExp(
    r'(z|[+-]\d{2}:?\d{2})$',
    caseSensitive: false,
  ).hasMatch(raw);
  final normalized = hasTimezone ? raw : '${raw}Z';

  return DateTime.parse(normalized).toUtc();
}

DateTime? tryParseApiDateTime(Object? value) {
  final raw = value?.toString().trim();
  if (raw == null || raw.isEmpty) return null;

  try {
    return parseApiDateTime(raw);
  } catch (_) {
    return null;
  }
}
