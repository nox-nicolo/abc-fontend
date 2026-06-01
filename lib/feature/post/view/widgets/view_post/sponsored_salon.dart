/* ---------------------------------------------------
   SPONSORED SALONS
--------------------------------------------------- */

import 'package:flutter/material.dart';

/* ---------------------------------------------------
   SPONSORED SALONS
--------------------------------------------------- */

class SponsoredSalonsSection extends StatelessWidget {
  final List<SponsoredSalon> salons;

  const SponsoredSalonsSection({super.key, required this.salons});

  @override
  Widget build(BuildContext context) {
    if (salons.isEmpty) return const SizedBox.shrink();

    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// HEADER
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Text(
              'Sponsored salons offering this service',
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w800,
              ),
            ),
          ),

          const SizedBox(height: 14),

          /// LIST
          ListView.separated(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: salons.length,
            separatorBuilder: (_, _) => const SizedBox(height: 12),
            itemBuilder: (_, index) {
              return _SalonCard(salon: salons[index]);
            },
          ),
        ],
      ),
    );
  }
}

/* ---------------------------------------------------
   SALON CARD
--------------------------------------------------- */

class _SalonCard extends StatelessWidget {
  final SponsoredSalon salon;

  const _SalonCard({required this.salon});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final hasImage = salon.imageUrl.trim().isNotEmpty;
    final initial = salon.name.trim().isNotEmpty
        ? salon.name.trim()[0].toUpperCase()
        : 'S';

    return InkWell(
      borderRadius: BorderRadius.circular(8),
      onTap: salon.onTap,
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          color: scheme.surfaceContainerLowest,
          boxShadow: [
            BoxShadow(
              color: scheme.primary.withValues(alpha: 0.08),
              blurRadius: 18,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            /// SALON LOGO / IMAGE
            CircleAvatar(
              radius: 26,
              backgroundColor: scheme.primaryContainer,
              backgroundImage: hasImage ? NetworkImage(salon.imageUrl) : null,
              child: hasImage
                  ? null
                  : Text(
                      initial,
                      style: theme.textTheme.titleMedium?.copyWith(
                        color: scheme.onPrimaryContainer,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
            ),

            const SizedBox(width: 14),

            /// INFO
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    salon.name,
                    style: theme.textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  if (salon.location.isNotEmpty) ...[
                    const SizedBox(height: 4),
                    Text(salon.location, style: theme.textTheme.labelSmall),
                  ],
                  const SizedBox(height: 8),

                  Row(
                    children: [
                      if (salon.price != null) _PricePill(price: salon.price!),
                      if (salon.rating != null) ...[
                        const SizedBox(width: 8),
                        _RatingChip(rating: salon.rating!),
                      ],
                    ],
                  ),
                ],
              ),
            ),

            /// CTA
            TextButton(onPressed: salon.onTap, child: const Text('View')),
          ],
        ),
      ),
    );
  }
}

/* ---------------------------------------------------
   SMALL COMPONENTS
--------------------------------------------------- */

class _PricePill extends StatelessWidget {
  final String price;

  const _PricePill({required this.price});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: scheme.primary.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        price,
        style: Theme.of(context).textTheme.labelLarge?.copyWith(
          fontWeight: FontWeight.w700,
          color: scheme.primary,
        ),
      ),
    );
  }
}

class _RatingChip extends StatelessWidget {
  final double rating;

  const _RatingChip({required this.rating});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Icon(Icons.star_rounded, size: 18, color: Colors.amber),
        const SizedBox(width: 4),
        Text(
          rating.toStringAsFixed(1),
          style: Theme.of(context).textTheme.labelMedium,
        ),
      ],
    );
  }
}

/* ---------------------------------------------------
   MODEL
--------------------------------------------------- */

class SponsoredSalon {
  final String id;
  final String name;
  final String imageUrl;
  final String location;
  final String? price; // e.g. "TZS 120,000"
  final double? rating;
  final VoidCallback onTap;

  const SponsoredSalon({
    required this.id,
    required this.name,
    required this.imageUrl,
    required this.location,
    required this.onTap,
    this.price,
    this.rating,
  });
}
