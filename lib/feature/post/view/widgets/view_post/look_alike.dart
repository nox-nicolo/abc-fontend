
/* ---------------------------------------------------
   LOOK ALIKE
--------------------------------------------------- */

import 'package:flutter/material.dart';

class SimilarResultsSection extends StatelessWidget {
  final List<SimilarResultItem> items;
  final VoidCallback? onViewAll;

  const SimilarResultsSection({
    super.key,
    required this.items,
    this.onViewAll,
  });

  @override
  Widget build(BuildContext context) {
    if (items.isEmpty) return const SizedBox.shrink();

    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// HEADER
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Similar Results',
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Women who booked this service achieved looks like these',
                      style: theme.textTheme.labelMedium,
                    ),
                  ],
                ),
                const Spacer(),
                if (onViewAll != null)
                  TextButton(
                    onPressed: onViewAll,
                    child: const Text('View all'),
                  ),
              ],
            ),
          ),

          const SizedBox(height: 14),

          /// HORIZONTAL LIST
          SizedBox(
            height: 240,
            child: ListView.separated(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              scrollDirection: Axis.horizontal,
              itemCount: items.length,
              separatorBuilder: (_, __) => const SizedBox(width: 14),
              itemBuilder: (_, index) {
                final item = items[index];
                return _ResultCard(item: item);
              },
            ),
          ),
        ],
      ),
    );
  }
}

/* ---------------------------------------------------
   RESULT CARD
--------------------------------------------------- */

class _ResultCard extends StatelessWidget {
  final SimilarResultItem item;

  const _ResultCard({required this.item});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return GestureDetector(
      onTap: item.onTap,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(22),
        child: Stack(
          children: [
            /// IMAGE
            AspectRatio(
              aspectRatio: 3 / 4,
              child: Image.network(
                item.imageUrl,
                fit: BoxFit.cover,
              ),
            ),

            /// SOFT GRADIENT OVERLAY (bottom)
            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              child: Container(
                height: 80,
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.bottomCenter,
                    end: Alignment.topCenter,
                    colors: [
                      Colors.black54,
                      Colors.transparent,
                    ],
                  ),
                ),
              ),
            ),

            /// MICRO LABEL (optional)
            if (item.label != null)
              Positioned(
                left: 10,
                bottom: 10,
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.55),
                    borderRadius: BorderRadius.circular(999),
                  ),
                  child: Text(
                    item.label!,
                    style: theme.textTheme.labelSmall?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
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

/* ---------------------------------------------------
   MODEL
--------------------------------------------------- */

class SimilarResultItem {
  final String id;
  final String imageUrl;
  final String? label; // e.g. "Same artist", "Similar style"
  final VoidCallback onTap;

  const SimilarResultItem({
    required this.id,
    required this.imageUrl,
    required this.onTap,
    this.label,
  });
}
