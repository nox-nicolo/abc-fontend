class ProfileCompletionModel {
  const ProfileCompletionModel({
    required this.role,
    required this.score,
    required this.completed,
    required this.total,
    required this.title,
    required this.subtitle,
    required this.items,
  });

  final String role;
  final int score;
  final int completed;
  final int total;
  final String title;
  final String subtitle;
  final List<ProfileCompletionItem> items;

  factory ProfileCompletionModel.fromMap(Map<String, dynamic> map) {
    return ProfileCompletionModel(
      role: map['role']?.toString() ?? '',
      score: (map['score'] as num?)?.toInt() ?? 0,
      completed: (map['completed'] as num?)?.toInt() ?? 0,
      total: (map['total'] as num?)?.toInt() ?? 0,
      title: map['title']?.toString() ?? 'Profile strength',
      subtitle: map['subtitle']?.toString() ?? '',
      items: (map['items'] as List<dynamic>? ?? [])
          .whereType<Map<String, dynamic>>()
          .map(ProfileCompletionItem.fromMap)
          .toList(),
    );
  }
}

class ProfileCompletionItem {
  const ProfileCompletionItem({
    required this.key,
    required this.title,
    required this.subtitle,
    required this.completed,
    required this.weight,
  });

  final String key;
  final String title;
  final String subtitle;
  final bool completed;
  final int weight;

  factory ProfileCompletionItem.fromMap(Map<String, dynamic> map) {
    return ProfileCompletionItem(
      key: map['key']?.toString() ?? '',
      title: map['title']?.toString() ?? '',
      subtitle: map['subtitle']?.toString() ?? '',
      completed: map['completed'] == true,
      weight: (map['weight'] as num?)?.toInt() ?? 1,
    );
  }
}
