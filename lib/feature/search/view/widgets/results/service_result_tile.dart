import 'package:africa_beuty/core/widgets/skeleton.dart';
import 'package:flutter/material.dart';

class ServiceResultTile extends StatelessWidget {
  final Map<String, dynamic> data;

  const ServiceResultTile({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: _buildImage(context),
      title: Text(data['name'] ?? 'Service'),
      subtitle: data['salon_name'] != null
          ? Text('by ${data['salon_name']}')
          : null,
      trailing: data['price'] != null ? Text('\$${data['price']}') : null,
      onTap: () {
        // Navigate to service detail
      },
    );
  }

  Widget _buildImage(BuildContext context) {
    final imageUrl = data['image_url'];

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
      child: const Icon(Icons.design_services),
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
