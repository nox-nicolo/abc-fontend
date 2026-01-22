
/* ---------------------------------------------------
   REVIEWS
--------------------------------------------------- */

import 'package:flutter/material.dart';

class ServiceReviewsSection extends StatefulWidget {
  final List<ServiceReview> reviews;

  const ServiceReviewsSection({
    super.key,
    required this.reviews,
  });

  @override
  State<ServiceReviewsSection> createState() => _ServiceReviewsSectionState();
}

class _ServiceReviewsSectionState extends State<ServiceReviewsSection> {
  bool _expanded = false;

  @override
  Widget build(BuildContext context) {
    if (widget.reviews.isEmpty) {
      return const SizedBox.shrink();
    }

    final theme = Theme.of(context);
    final reviews = widget.reviews;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// HEADER ROW
          InkWell(
            borderRadius: BorderRadius.circular(12),
            onTap: () => setState(() => _expanded = !_expanded),
            child: Row(
              children: [
                const Icon(Icons.star_rate_rounded),
                const SizedBox(width: 6),
                Text(
                  '${reviews.length} Reviews',
                  style: theme.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const Spacer(),
                Icon(
                  _expanded
                      ? Icons.keyboard_arrow_up
                      : Icons.keyboard_arrow_down,
                ),
              ],
            ),
          ),

          const SizedBox(height: 12),

          /// AVATAR STACK
          _AvatarStack(
            reviews: reviews,
          ),

          /// EXPANDED REVIEWS
          if (_expanded) ...[
            const SizedBox(height: 16),
            ...reviews.map(
              (r) => _ReviewItem(review: r),
            ),
          ],
        ],
      ),
    );
  }
}

/* ---------------------------------------------------
   AVATAR STACK
--------------------------------------------------- */

class _AvatarStack extends StatelessWidget {
  final List<ServiceReview> reviews;

  const _AvatarStack({required this.reviews});

  @override
  Widget build(BuildContext context) {
    const double size = 36;
    const double overlap = 14;

    final shown = reviews.take(10).toList();
    final extra = reviews.length - shown.length;

    return SizedBox(
      height: size,
      width: size + (shown.length - 1) * overlap,
      child: Stack(
        children: List.generate(shown.length, (index) {
          final isLast = index == shown.length - 1 && extra > 0;

          return Positioned(
            left: index * overlap,
            child: CircleAvatar(
              radius: size / 2,
              backgroundColor: Theme.of(context).colorScheme.surface,
              child: CircleAvatar(
                radius: (size / 2) - 1.5,
                backgroundImage:
                    isLast ? null : NetworkImage(shown[index].avatarUrl),
                child: isLast
                    ? Text(
                        '+$extra',
                        style: Theme.of(context)
                            .textTheme
                            .labelMedium
                            ?.copyWith(fontWeight: FontWeight.w700),
                      )
                    : null,
              ),
            ),
          );
        }),
      ),
    );
  }
}

/* ---------------------------------------------------
   SINGLE REVIEW ITEM
--------------------------------------------------- */

class _ReviewItem extends StatelessWidget {
  final ServiceReview review;

  const _ReviewItem({required this.review});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// USER AVATAR
          CircleAvatar(
            radius: 20,
            backgroundImage: NetworkImage(review.avatarUrl),
          ),
          const SizedBox(width: 12),

          /// REVIEW CONTENT
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _RatingStars(rating: review.rating),
                const SizedBox(height: 6),
                Text(
                  review.text,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/* ---------------------------------------------------
   RATING STARS
--------------------------------------------------- */

class _RatingStars extends StatelessWidget {
  final double rating;

  const _RatingStars({required this.rating});

  @override
  Widget build(BuildContext context) {
    final filled = rating.floor();

    return Row(
      children: List.generate(5, (i) {
        return Icon(
          i < filled ? Icons.star_rounded : Icons.star_border_rounded,
          size: 18,
          color: Colors.amber,
        );
      }),
    );
  }
}

/* ---------------------------------------------------
   MODEL
--------------------------------------------------- */

class ServiceReview {
  final String id;
  final String avatarUrl;
  final double rating;
  final String text;

  const ServiceReview({
    required this.id,
    required this.avatarUrl,
    required this.rating,
    required this.text,
  });
}
