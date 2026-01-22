import 'package:flutter/material.dart';

class UserResultTile extends StatelessWidget {
  final Map<String, dynamic> data;

  const UserResultTile({
    super.key,
    required this.data,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: _buildAvatar(),
      title: Text(data['username'] ?? 'Unknown user'),
      subtitle: Text(data['full_name'] ?? ''),
      trailing: data['verified'] == true
          ? const Icon(Icons.verified, color: Colors.blue, size: 18)
          : null,
      onTap: () {
        // Navigate to user profile
      },
    );
  }

  Widget _buildAvatar() {
    final imageUrl = data['profile_image'];

    if (imageUrl != null && imageUrl.toString().isNotEmpty) {
      return CircleAvatar(
        radius: 22,
        backgroundColor: Colors.grey.shade200,
        backgroundImage: NetworkImage(imageUrl),
        onBackgroundImageError: (_, __) {},
      );
    }

    return const CircleAvatar(
      radius: 22,
      child: Icon(Icons.person),
    );
  }
}
