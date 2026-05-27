import 'package:africa_beuty/core/utils/image_url.dart';
import 'package:africa_beuty/core/widgets/skeleton.dart';
import 'package:flutter/material.dart';

class SalonResultTile extends StatelessWidget {
  final Map<String, dynamic> data;

  const SalonResultTile({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: _buildImage(context),
      title: Text(data['name'] ?? 'Salon'),
      subtitle: Text(data['location'] ?? ''),
      onTap: () {
        // Navigate to salon profile
      },
    );
  }

  Widget _buildImage(BuildContext context) {
    final imageUrl = resolveImageUrl(
      data['image_url'] ?? data['profile_picture'] ?? data['cover_image'],
    );

    if (imageUrl != null && imageUrl.toString().isNotEmpty) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: Image.network(
          imageUrl,
          width: 44,
          height: 44,
          fit: BoxFit.cover,
          errorBuilder: (_, _, _) => _fallback(context),
          loadingBuilder: (context, child, progress) {
            if (progress == null) return child;
            return _loading();
          },
        ),
      );
    }

    return _fallback(context);
  }

  Widget _fallback(BuildContext context) {
    return Container(
      width: 44,
      height: 44,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: Theme.of(context).colorScheme.surfaceContainerHighest,
      ),
      child: const Icon(Icons.store),
    );
  }

  Widget _loading() {
    return const SizedBox(
      width: 44,
      height: 44,
      child: SkeletonCard(width: 44, height: 44, radius: 8),
    );
  }
}
