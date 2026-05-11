List<dynamic> listFromPaginatedBody(dynamic decoded, {String key = 'items'}) {
  if (decoded is List) return decoded;
  if (decoded is Map) {
    final value = decoded[key] ?? decoded['items'] ?? decoded['results'];
    if (value is List) return value;
    final data = decoded['data'];
    if (data is List) return data;
    if (data is Map) {
      final nested = data[key] ?? data['items'] ?? data['results'];
      if (nested is List) return nested;
    }
  }
  return const [];
}
