
import 'package:africa_beuty/feature/profile/model/salon_view_profile.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class SalonServicesSheet extends StatelessWidget {
  final SalonViewProfileModel salon;

  const SalonServicesSheet({super.key, required this.salon});

  @override
  Widget build(BuildContext context) {
    final categories = salon.services.categories;

    return DraggableScrollableSheet(
      expand: false,
      initialChildSize: 0.9,
      minChildSize: 0.5,
      maxChildSize: 0.95,
      builder: (context, controller) {
        return Column(
          children: [
            // drag handle
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 12),
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey[400],
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
            ),

            Text(
              "Services",
              style: Theme.of(context)
                  .textTheme
                  .titleLarge
                  ?.copyWith(fontWeight: FontWeight.w800),
            ),

            const SizedBox(height: 12),

            Expanded(
              child: ListView.builder(
                controller: controller,
                itemCount: categories.length,
                itemBuilder: (_, index) {
                  return _CategorySection(
                    category: categories[index],
                  );
                },
              ),
            ),
          ],
        );
      },
    );
  }
}


class _CategorySection extends StatelessWidget {
  final SalonServiceCategoryModel category;

  const _CategorySection({
    required this.category,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 24, 16, 12),
          child: Text(
            category.categoryName,
            style: Theme.of(context)
                .textTheme
                .titleMedium
                ?.copyWith(fontWeight: FontWeight.w800),
          ),
        ),

        SizedBox(
          height: 330,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: category.services.length,
            itemBuilder: (_, i) {
              return _ServiceCard(
                service: category.services[i],
              );
            },
          ),
        ),
      ],
    );
  }
}


class _ServiceCard extends StatelessWidget {
  final SalonServiceItemModel service;

  const _ServiceCard({required this.service});

  @override
  Widget build(BuildContext context) {
    final price = service.priceMin != null
        ? "${service.priceMin}${service.priceMax != null ? " - ${service.priceMax}" : ""} ${service.currency}"
        : "—";

    final duration = service.durationMinutes != null
        ? "${service.durationMinutes} min"
        : "—";

    return Container(
      width: 240,
      margin: const EdgeInsets.only(right: 14),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(22),
        color: Theme.of(context).colorScheme.surface,
        boxShadow: const [
          BoxShadow(
            blurRadius: 14,
            offset: Offset(0, 8),
            color: Colors.black12,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // image (fallback if no stylist avatar)
          CachedNetworkImage(
            imageUrl: service.stylists.isNotEmpty &&
                    service.stylists.first.avatar != null
                ? service.stylists.first.avatar!
                : "",
            height: 140,
            width: double.infinity,
            fit: BoxFit.cover,
            placeholder: (_, __) =>
                Container(color: Colors.grey.shade300),
            errorWidget: (_, __, ___) =>
                Container(color: Colors.grey.shade300),
          ),

          Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  service.name,
                  style: Theme.of(context)
                      .textTheme
                      .titleSmall
                      ?.copyWith(fontWeight: FontWeight.w700),
                ),
                const SizedBox(height: 4),
                Text(
                  "$price • $duration",
                  style: Theme.of(context)
                      .textTheme
                      .labelSmall
                      ?.copyWith(color: Colors.grey[600]),
                ),

                if (service.stylists.isNotEmpty) ...[
                  const SizedBox(height: 10),
                  _StylistsRow(stylists: service.stylists),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}




class _StylistsRow extends StatelessWidget {
  final List<SalonServiceStylistModel> stylists;

  const _StylistsRow({required this.stylists});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 34,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: stylists.length,
        separatorBuilder: (_, __) => const SizedBox(width: 8),
        itemBuilder: (_, i) {
          final s = stylists[i];
          return Row(
            children: [
              CircleAvatar(
                radius: 14,
                backgroundImage:
                    s.avatar != null ? CachedNetworkImageProvider(s.avatar!) : null,
                backgroundColor: Colors.grey.shade300,
              ),
              const SizedBox(width: 6),
              Text(
                s.name,
                style: Theme.of(context)
                    .textTheme
                    .labelSmall
                    ?.copyWith(fontWeight: FontWeight.w600),
              ),
            ],
          );
        },
      ),
    );
  }
}
