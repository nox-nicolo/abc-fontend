import 'package:flutter/material.dart';

class HashtagResultTile extends StatelessWidget {
  final Map<String, dynamic> data;

  const HashtagResultTile({
    super.key,
    required this.data,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: const Icon(Icons.tag),
      title: Text('#${data['name'] ?? ''}'),
      subtitle: Text('${data['count'] ?? 0} posts'),
      onTap: () {
        // Navigate to hashtag feed
      },
    );
  }
}
