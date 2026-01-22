import 'package:flutter/material.dart';

class SalonResultTile extends StatelessWidget {
  final Map<String, dynamic> data;

  const SalonResultTile({
    super.key,
    required this.data,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: _buildImage(),
      title: Text(data['name'] ?? 'Salon'),
      subtitle: Text(data['location'] ?? ''),
      onTap: () {
        // Navigate to salon profile
      },
    );
  }

  Widget _buildImage() {
    final imageUrl = data['image_url'];

    if (imageUrl != null && imageUrl.toString().isNotEmpty) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: Image.network(
          imageUrl,
          width: 44,
          height: 44,
          fit: BoxFit.cover,
          errorBuilder: (_, __, ___) => _fallback(),
          loadingBuilder: (context, child, progress) {
            if (progress == null) return child;
            return _loading();
          },
        ),
      );
    }

    return _fallback();
  }

  Widget _fallback() {
    return Container(
      width: 44,
      height: 44,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: Colors.grey.shade300,
      ),
      child: const Icon(Icons.store),
    );
  }

  Widget _loading() {
    return Container(
      width: 44,
      height: 44,
      alignment: Alignment.center,
      child: const SizedBox(
        width: 16,
        height: 16,
        child: CircularProgressIndicator(strokeWidth: 2),
      ),
    );
  }
}
