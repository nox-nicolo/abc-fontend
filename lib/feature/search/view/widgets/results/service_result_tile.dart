import 'package:flutter/material.dart';

class ServiceResultTile extends StatelessWidget {
  final Map<String, dynamic> data;

  const ServiceResultTile({
    super.key,
    required this.data,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: _buildImage(),
      title: Text(data['name'] ?? 'Service'),
      subtitle: data['salon_name'] != null
          ? Text('by ${data['salon_name']}')
          : null,
      trailing: data['price'] != null
          ? Text('\$${data['price']}')
          : null,
      onTap: () {
        // Navigate to service detail
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
      child: const Icon(Icons.design_services),
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
