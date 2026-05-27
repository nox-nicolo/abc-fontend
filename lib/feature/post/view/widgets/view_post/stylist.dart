/* ---------------------------------------------------
   STYLIST
--------------------------------------------------- */
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class PostStylistSection extends StatelessWidget {
  final List<StylistPreview> stylists;
  final VoidCallback? onView;

  const PostStylistSection({super.key, required this.stylists, this.onView});

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
            onPressed: onView ?? () => _showStylistDetails(context),
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

  void _showStylistDetails(BuildContext context) {
    showModalBottomSheet<void>(
      context: context,
      showDragHandle: true,
      isScrollControlled: true,
      builder: (_) => _StylistDetailsSheet(stylists: stylists),
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
        _StylistAvatarImg(
          url: stylist.avatarUrl,
          name: stylist.name,
          radius: 22,
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
            Text(stylist.role ?? 'Stylist', style: theme.textTheme.labelSmall),
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
    final shown = stylists.take(10).toList();
    final extra = stylists.length - shown.length;

    return Row(
      children: [
        _AvatarStack(stylists: shown, extraCount: extra > 0 ? extra : null),
        const SizedBox(width: 12),
        Flexible(
          child: Text(
            'Styled by ${stylists.length} professional${stylists.length == 1 ? '' : 's'}',
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: theme.textTheme.bodyMedium,
          ),
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

  const _AvatarStack({required this.stylists, this.extraCount});

  @override
  Widget build(BuildContext context) {
    const double size = 36;
    const double overlap = 14;
    final visibleCount = stylists.length;

    return SizedBox(
      height: size,
      width: size + (visibleCount - 1) * overlap,
      child: Stack(
        clipBehavior: Clip.none,
        children: List.generate(visibleCount, (index) {
          final isLast = index == stylists.length - 1 && extraCount != null;

          return Positioned(
            left: index * overlap,
            child: CircleAvatar(
              radius: size / 2,
              backgroundColor: Theme.of(context).colorScheme.surface,
              child: CircleAvatar(
                radius: (size / 2) - 1.5,
                child: isLast
                    ? Text(
                        '+$extraCount',
                        style: Theme.of(context).textTheme.labelMedium
                            ?.copyWith(fontWeight: FontWeight.w700),
                      )
                    : _StylistAvatarImg(
                        url: stylists[index].avatarUrl,
                        name: stylists[index].name,
                        radius: (size / 2) - 1.5,
                      ),
              ),
            ),
          );
        }),
      ),
    );
  }
}

/* ---------------------------------------------------
   AVATAR IMAGE (with fallback initials)
--------------------------------------------------- */

class _StylistAvatarImg extends StatelessWidget {
  final String url;
  final String name;
  final double radius;

  const _StylistAvatarImg({
    required this.url,
    required this.name,
    required this.radius,
  });

  @override
  Widget build(BuildContext context) {
    final initial = name.isNotEmpty ? name[0].toUpperCase() : '?';
    final size = radius * 2;

    if (url.trim().isEmpty) {
      return CircleAvatar(radius: radius, child: Text(initial));
    }

    return ClipOval(
      child: CachedNetworkImage(
        imageUrl: url,
        width: size,
        height: size,
        fit: BoxFit.cover,
        errorWidget: (_, _, _) =>
            CircleAvatar(radius: radius, child: Text(initial)),
      ),
    );
  }
}

class _StylistDetailsSheet extends StatelessWidget {
  final List<StylistPreview> stylists;

  const _StylistDetailsSheet({required this.stylists});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;

    return SafeArea(
      child: DraggableScrollableSheet(
        expand: false,
        initialChildSize: stylists.length > 4 ? 0.62 : 0.38,
        minChildSize: 0.28,
        maxChildSize: 0.88,
        builder: (context, scrollController) {
          return ListView.separated(
            controller: scrollController,
            padding: const EdgeInsets.fromLTRB(18, 4, 18, 22),
            itemCount: stylists.length + 1,
            separatorBuilder: (_, index) =>
                index == 0 ? const SizedBox(height: 10) : const Divider(),
            itemBuilder: (context, index) {
              if (index == 0) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Assigned stylists',
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${stylists.length} professional${stylists.length == 1 ? '' : 's'} assigned to this service',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: scheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                );
              }

              final stylist = stylists[index - 1];
              return ListTile(
                contentPadding: EdgeInsets.zero,
                leading: _StylistAvatarImg(
                  url: stylist.avatarUrl,
                  name: stylist.name,
                  radius: 24,
                ),
                title: Text(
                  stylist.name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: theme.textTheme.bodyLarge?.copyWith(
                    fontWeight: FontWeight.w800,
                  ),
                ),
                subtitle: Text(stylist.role ?? 'Stylist'),
              );
            },
          );
        },
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
