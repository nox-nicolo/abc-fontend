
/* ---------------------------------------------------
   STYLIST
--------------------------------------------------- */
import 'package:flutter/material.dart';

class PostStylistSection extends StatelessWidget {
  final List<StylistPreview> stylists;
  final VoidCallback onView;

  const PostStylistSection({
    super.key,
    required this.stylists,
    required this.onView,
  });

  @override
  Widget build(BuildContext context) {
    if (stylists.isEmpty) return const SizedBox.shrink();

    final theme = Theme.of(context);
    final scheme = theme.colorScheme;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      child: Row(
        children: [
          // LEFT CONTENT
          if (stylists.length == 1)
            _SingleStylist(stylist: stylists.first)
          else
            _MultipleStylists(stylists: stylists),

          const Spacer(),

          // VIEW BUTTON
          TextButton(
            onPressed: onView,
            style: TextButton.styleFrom(
              foregroundColor: scheme.primary,
              textStyle: theme.textTheme.labelLarge?.copyWith(
                fontWeight: FontWeight.w700,
              ),
            ),
            child: const Text('View'),
          ),
        ],
      ),
    );
  }
}

/* ---------------------------------------------------
   SINGLE STYLIST
--------------------------------------------------- */

class _SingleStylist extends StatelessWidget {
  final StylistPreview stylist;

  const _SingleStylist({required this.stylist});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Row(
      children: [
        CircleAvatar(
          radius: 22,
          backgroundImage: NetworkImage(stylist.avatarUrl),
        ),
        const SizedBox(width: 12),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              stylist.name,
              style: theme.textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.w700,
              ),
            ),
            Text(
              stylist.role ?? 'Stylist',
              style: theme.textTheme.labelSmall,
            ),
          ],
        ),
      ],
    );
  }
}

/* ---------------------------------------------------
   MULTIPLE STYLISTS
--------------------------------------------------- */

class _MultipleStylists extends StatelessWidget {
  final List<StylistPreview> stylists;

  const _MultipleStylists({required this.stylists});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final shown = stylists.take(5).toList();
    final extra = stylists.length - shown.length;

    return Row(
      children: [
        _AvatarStack(
          stylists: shown,
          extraCount: extra > 0 ? extra : null,
        ),
        const SizedBox(width: 12),
        Text(
          'Styled by ${stylists.length} professionals',
          style: theme.textTheme.bodyMedium,
        ),
      ],
    );
  }
}

/* ---------------------------------------------------
   AVATAR STACK
--------------------------------------------------- */

class _AvatarStack extends StatelessWidget {
  final List<StylistPreview> stylists;
  final int? extraCount;

  const _AvatarStack({
    required this.stylists,
    this.extraCount,
  });

  @override
  Widget build(BuildContext context) {
    const double size = 36;
    const double overlap = 12;

    return SizedBox(
      height: size,
      width: size + (stylists.length - 1) * overlap,
      child: Stack(
        children: List.generate(stylists.length, (index) {
          final isLast = index == stylists.length - 1 && extraCount != null;

          return Positioned(
            left: index * overlap,
            child: CircleAvatar(
              radius: size / 2,
              backgroundColor: Theme.of(context).colorScheme.surface,
              child: CircleAvatar(
                radius: (size / 2) - 1.5,
                backgroundImage:
                    isLast ? null : NetworkImage(stylists[index].avatarUrl),
                child: isLast
                    ? Text(
                        '+$extraCount',
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
   MODEL
--------------------------------------------------- */

class StylistPreview {
  final String id;
  final String name;
  final String avatarUrl;
  final String? role;

  const StylistPreview({
    required this.id,
    required this.name,
    required this.avatarUrl,
    this.role,
  });
}

