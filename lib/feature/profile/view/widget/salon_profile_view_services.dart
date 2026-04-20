import 'package:africa_beuty/feature/profile/model/salon_view_profile.dart';
import 'package:africa_beuty/feature/service/view/page/salon_service_detail.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class SalonServicesSheet extends StatelessWidget {
  final SalonViewProfileModel salon;

  /// Called when the user taps "Book" on a service — passes the chosen service.
  final ValueChanged<SalonServiceItemModel>? onBook;

  const SalonServicesSheet({super.key, required this.salon, this.onBook});

  bool get _isEmpty =>
      salon.services.categories.isEmpty ||
      salon.services.categories.every((c) => c.services.isEmpty);

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
              child: _isEmpty
                  ? _EmptyServices(controller: controller)
                  : ListView.builder(
                      controller: controller,
                      itemCount: categories.length,
                      itemBuilder: (ctx, index) {
                        return _CategorySection(
                          category: categories[index],
                          salon: salon,
                          onBook: onBook,
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
  final SalonViewProfileModel salon;
  final ValueChanged<SalonServiceItemModel>? onBook;

  const _CategorySection({
    required this.category,
    required this.salon,
    this.onBook,
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
          height: 350,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: category.services.length,
            itemBuilder: (ctx, i) {
              return _ServiceCard(
                service: category.services[i],
                salon: salon,
                onBook: onBook,
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
  final SalonViewProfileModel salon;
  final ValueChanged<SalonServiceItemModel>? onBook;

  const _ServiceCard({
    required this.service,
    required this.salon,
    this.onBook,
  });

  void _openDetail(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => SalonServiceDetailPage(
          salon: salon,
          service: service,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    final price = service.priceMin != null
        ? "${service.priceMin}${service.priceMax != null ? " – ${service.priceMax}" : ""} ${service.currency}"
        : "—";

    final duration = service.durationMinutes != null
        ? "${service.durationMinutes} min"
        : "—";

    return Container(
      width: 240,
      margin: const EdgeInsets.only(right: 14),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(22),
        color: scheme.surface,
        boxShadow: const [
          BoxShadow(
            blurRadius: 14,
            offset: Offset(0, 8),
            color: Colors.black12,
          ),
        ],
      ),
      child: InkWell(
        onTap: () => _openDetail(context),
        borderRadius: BorderRadius.circular(22),
        child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Service image ───────────────────────────────────
          ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(22)),
            child: CachedNetworkImage(
              imageUrl: service.stylists.isNotEmpty &&
                      service.stylists.first.avatar != null
                  ? service.stylists.first.avatar!
                  : "",
              height: 140,
              width: double.infinity,
              fit: BoxFit.cover,
              placeholder: (ctx, url) =>
                  Container(color: Colors.grey.shade200),
              errorWidget: (ctx, url, err) =>
                  Container(color: Colors.grey.shade200,
                    child: Icon(Icons.spa_outlined,
                        size: 40, color: Colors.grey.shade400)),
            ),
          ),

          // ── Info ────────────────────────────────────────────
          Padding(
            padding: const EdgeInsets.fromLTRB(12, 12, 12, 0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  service.name,
                  style: Theme.of(context)
                      .textTheme
                      .titleSmall
                      ?.copyWith(fontWeight: FontWeight.w700),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Text(
                  "$price  •  $duration",
                  style: Theme.of(context)
                      .textTheme
                      .labelSmall
                      ?.copyWith(color: scheme.onSurfaceVariant),
                ),

                if (service.stylists.isNotEmpty) ...[
                  const SizedBox(height: 10),
                  _StylistsRow(stylists: service.stylists),
                ],
              ],
            ),
          ),

          const Spacer(),

          // ── Book button ─────────────────────────────────────
          Padding(
            padding: const EdgeInsets.fromLTRB(12, 0, 12, 12),
            child: SizedBox(
              width: double.infinity,
              height: 40,
              child: FilledButton(
                style: FilledButton.styleFrom(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                ),
                onPressed: onBook != null ? () => onBook!(service) : null,
                child: const Text(
                  'Book',
                  style: TextStyle(fontWeight: FontWeight.w700),
                ),
              ),
            ),
          ),
        ],
      ),
      ),
    );
  }
}


class _EmptyServices extends StatelessWidget {
  final ScrollController controller;
  const _EmptyServices({required this.controller});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return ListView(
      controller: controller,
      padding: const EdgeInsets.fromLTRB(24, 48, 24, 48),
      children: [
        Icon(Icons.spa_outlined,
            size: 56, color: scheme.onSurfaceVariant),
        const SizedBox(height: 16),
        Text(
          'No services yet',
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w800,
              ),
        ),
        const SizedBox(height: 8),
        Text(
          "This salon hasn't configured any services yet. Check back later.",
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: scheme.onSurfaceVariant,
              ),
        ),
      ],
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
        separatorBuilder: (ctx, i) => const SizedBox(width: 8),
        itemBuilder: (ctx, i) {
          final s = stylists[i];
          return Row(
            children: [
              CircleAvatar(
                radius: 14,
                backgroundImage: s.avatar != null
                    ? CachedNetworkImageProvider(s.avatar!)
                    : null,
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
