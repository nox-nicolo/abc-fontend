List<dynamic> listFromPaginatedBody(dynamic decoded, {String key = 'items'}) {
  if (decoded is List) return decoded;
  if (decoded is Map<String, dynamic>) {
    final value = decoded[key] ?? decoded['items'] ?? decoded['results'];
    if (value is List) return value;
  }
  return const [];
}
