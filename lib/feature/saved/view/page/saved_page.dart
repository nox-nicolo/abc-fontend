import 'package:africa_beuty/feature/post/view/page/view_post.dart';
import 'package:africa_beuty/feature/profile/view/page/view_profile.dart';
import 'package:africa_beuty/feature/saved/model/saved_item.dart';
import 'package:africa_beuty/feature/saved/provider/saved_provider.dart';
import 'package:africa_beuty/feature/service/view/page/service_view_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SavedPage extends ConsumerWidget {
  const SavedPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final saved = ref.watch(savedCollectionProvider);

    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Saved'),
          centerTitle: true,
          actions: [
            IconButton(
              tooltip: 'Refresh saved',
              onPressed: () => ref.invalidate(savedCollectionProvider),
              icon: const Icon(Icons.refresh_rounded),
            ),
          ],
          bottom: const TabBar(
            tabs: [
              Tab(text: 'Salons'),
              Tab(text: 'Services'),
              Tab(text: 'Styles'),
            ],
          ),
        ),
        body: saved.when(
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (error, _) => _SavedError(
            message: error.toString(),
            onRetry: () => ref.invalidate(savedCollectionProvider),
          ),
          data: (collection) => RefreshIndicator(
            onRefresh: () => ref.refresh(savedCollectionProvider.future),
            child: TabBarView(
              children: [
                _SavedSalonsList(collection: collection),
                _SavedServicesList(collection: collection),
                _SavedStylesList(collection: collection),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _SavedSalonsList extends ConsumerWidget {
  const _SavedSalonsList({required this.collection});

  final SavedCollection collection;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final items = collection.salons;
    if (items.isEmpty) {
      return const _EmptySavedList(
        icon: Icons.storefront_outlined,
        title: 'No saved salons yet',
        message:
            'Save salons you trust so booking, comparing, and finding them again is easier.',
      );
    }

    return ListView.separated(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 28),
      itemCount: items.length + 1,
      separatorBuilder: (_, index) => SizedBox(height: index == 0 ? 12 : 8),
      itemBuilder: (context, index) {
        if (index == 0) {
          return _SavedOverview(
            collection: collection,
            title: 'Your salon shortlist',
            message:
                'These salons help tune future recommendations around location, trust, and services you come back to.',
          );
        }

        final salon = items[index - 1];
        return _SavedTile(
          imageUrl: salon.imageUrl,
          icon: Icons.storefront_rounded,
          title: salon.name,
          subtitle: [
            if (salon.username != null) '@${salon.username}',
            salon.subtitle,
            _relativeTime(salon.savedAt),
          ].whereType<String>().join(' • '),
          onTap: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (_) =>
                    ViewProfilePage(isServiceProfile: true, userId: salon.id),
              ),
            );
          },
          onRemove: () => _toggleSaved(
            context,
            ref,
            () => ref.read(savedRepositoryProvider).toggleSalon(salon.id),
          ),
        );
      },
    );
  }
}

class _SavedServicesList extends ConsumerWidget {
  const _SavedServicesList({required this.collection});

  final SavedCollection collection;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final items = collection.services;
    if (items.isEmpty) {
      return const _EmptySavedList(
        icon: Icons.design_services_outlined,
        title: 'No saved services yet',
        message:
            'Save services you are considering to compare prices and jump back into booking.',
      );
    }

    return ListView.separated(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 28),
      itemCount: items.length + 1,
      separatorBuilder: (_, index) => SizedBox(height: index == 0 ? 12 : 8),
      itemBuilder: (context, index) {
        if (index == 0) {
          return _SavedOverview(
            collection: collection,
            title: 'Services you are considering',
            message:
                'Saved services become a strong taste signal for recommendations and faster repeat bookings.',
          );
        }

        final service = items[index - 1];
        final price = service.price == null
            ? null
            : '${service.currency ?? ''} ${service.price!.toStringAsFixed(0)}'
                  .trim();

        return _SavedTile(
          imageUrl: service.imageUrl,
          icon: Icons.design_services_rounded,
          title: service.name,
          subtitle: [
            service.salonName,
            price,
            _relativeTime(service.savedAt),
          ].whereType<String>().join(' • '),
          onTap: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (_) => ServiceDetailsPage(serviceId: service.id),
              ),
            );
          },
          onRemove: () => _toggleSaved(
            context,
            ref,
            () => ref.read(savedRepositoryProvider).toggleService(service.id),
          ),
        );
      },
    );
  }
}

class _SavedStylesList extends ConsumerWidget {
  const _SavedStylesList({required this.collection});

  final SavedCollection collection;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final items = collection.styles;
    if (items.isEmpty) {
      return const _EmptySavedList(
        icon: Icons.auto_awesome_outlined,
        title: 'No saved styles yet',
        message:
            'Bookmark looks you like so your profile can learn your style direction over time.',
      );
    }

    return CustomScrollView(
      slivers: [
        SliverPadding(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 12),
          sliver: SliverToBoxAdapter(
            child: _SavedOverview(
              collection: collection,
              title: 'Your style inspiration',
              message:
                  'These saved looks are useful for future recommendations and for showing salons what you want.',
            ),
          ),
        ),
        SliverPadding(
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 28),
          sliver: SliverGrid.builder(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              mainAxisSpacing: 12,
              crossAxisSpacing: 12,
              childAspectRatio: 0.76,
            ),
            itemCount: items.length,
            itemBuilder: (context, index) {
              final style = items[index];
              return _SavedStyleCard(
                style: style,
                onOpen: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => PostViewPage(postId: style.id),
                    ),
                  );
                },
                onRemove: () => _toggleSaved(
                  context,
                  ref,
                  () => ref.read(savedRepositoryProvider).toggleStyle(style.id),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}

class _SavedOverview extends StatelessWidget {
  const _SavedOverview({
    required this.collection,
    required this.title,
    required this.message,
  });

  final SavedCollection collection;
  final String title;
  final String message;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;

    return DecoratedBox(
      decoration: BoxDecoration(
        color: scheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    title,
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
                Text(
                  '${collection.totalCount} saved',
                  style: theme.textTheme.labelLarge?.copyWith(
                    color: scheme.primary,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              message,
              style: theme.textTheme.bodySmall?.copyWith(
                color: scheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                _SavedCountChip(
                  icon: Icons.storefront_rounded,
                  label: '${collection.salons.length} salons',
                ),
                const SizedBox(width: 8),
                _SavedCountChip(
                  icon: Icons.design_services_rounded,
                  label: '${collection.services.length} services',
                ),
                const SizedBox(width: 8),
                _SavedCountChip(
                  icon: Icons.auto_awesome_rounded,
                  label: '${collection.styles.length} styles',
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _SavedCountChip extends StatelessWidget {
  const _SavedCountChip({required this.icon, required this.label});

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
        decoration: BoxDecoration(
          color: scheme.surface,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 16, color: scheme.primary),
            const SizedBox(width: 5),
            Flexible(
              child: Text(
                label,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: Theme.of(
                  context,
                ).textTheme.labelSmall?.copyWith(fontWeight: FontWeight.w700),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SavedTile extends StatelessWidget {
  const _SavedTile({
    required this.imageUrl,
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
    required this.onRemove,
  });

  final String? imageUrl;
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;
  final VoidCallback onRemove;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.zero,
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      child: ListTile(
        contentPadding: const EdgeInsets.fromLTRB(12, 8, 4, 8),
        leading: _SavedThumb(imageUrl: imageUrl, icon: icon),
        title: Text(title, maxLines: 1, overflow: TextOverflow.ellipsis),
        subtitle: subtitle.isEmpty
            ? null
            : Text(subtitle, maxLines: 2, overflow: TextOverflow.ellipsis),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              tooltip: 'Remove from saved',
              onPressed: onRemove,
              icon: const Icon(Icons.bookmark_remove_outlined),
            ),
            const Icon(Icons.chevron_right),
          ],
        ),
        onTap: onTap,
      ),
    );
  }
}

class _SavedStyleCard extends StatelessWidget {
  const _SavedStyleCard({
    required this.style,
    required this.onOpen,
    required this.onRemove,
  });

  final SavedStyle style;
  final VoidCallback onOpen;
  final VoidCallback onRemove;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final savedAt = _relativeTime(style.savedAt);

    return InkWell(
      borderRadius: BorderRadius.circular(8),
      onTap: onOpen,
      child: Ink(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          color: scheme.surfaceContainerHighest,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Stack(
                children: [
                  Positioned.fill(
                    child: ClipRRect(
                      borderRadius: const BorderRadius.vertical(
                        top: Radius.circular(8),
                      ),
                      child: _SavedImageFill(
                        imageUrl: style.imageUrl,
                        icon: Icons.auto_awesome,
                      ),
                    ),
                  ),
                  Positioned(
                    top: 6,
                    right: 6,
                    child: Material(
                      color: scheme.surface.withValues(alpha: 0.92),
                      shape: const CircleBorder(),
                      child: IconButton(
                        tooltip: 'Remove from saved',
                        visualDensity: VisualDensity.compact,
                        onPressed: onRemove,
                        icon: const Icon(Icons.bookmark_remove_outlined),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    style.title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(fontWeight: FontWeight.w700),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    [
                      style.salonName,
                      if (style.likesCount != null) '${style.likesCount} likes',
                      savedAt,
                    ].whereType<String>().join(' • '),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: scheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SavedThumb extends StatelessWidget {
  const _SavedThumb({this.imageUrl, required this.icon});

  final String? imageUrl;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(8),
      child: SizedBox(
        width: 56,
        height: 56,
        child: _SavedImageFill(imageUrl: imageUrl, icon: icon),
      ),
    );
  }
}

class _SavedImageFill extends StatelessWidget {
  const _SavedImageFill({this.imageUrl, required this.icon});

  final String? imageUrl;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    if (imageUrl != null && imageUrl!.isNotEmpty) {
      return Image.network(
        imageUrl!,
        fit: BoxFit.cover,
        width: double.infinity,
        height: double.infinity,
        errorBuilder: (_, _, _) => _fallback(context),
      );
    }
    return _fallback(context);
  }

  Widget _fallback(BuildContext context) {
    return Container(
      color: Theme.of(context).colorScheme.surfaceContainerHighest,
      child: Icon(icon),
    );
  }
}

class _EmptySavedList extends StatelessWidget {
  const _EmptySavedList({
    required this.icon,
    required this.title,
    required this.message,
  });

  final IconData icon;
  final String title;
  final String message;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;

    return ListView(
      padding: const EdgeInsets.symmetric(horizontal: 28),
      children: [
        SizedBox(height: MediaQuery.of(context).size.height * 0.18),
        Icon(icon, size: 64, color: scheme.outline),
        const SizedBox(height: 16),
        Text(
          title,
          textAlign: TextAlign.center,
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w800,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          message,
          textAlign: TextAlign.center,
          style: theme.textTheme.bodyMedium?.copyWith(
            color: scheme.onSurfaceVariant,
          ),
        ),
      ],
    );
  }
}

class _SavedError extends StatelessWidget {
  const _SavedError({required this.message, required this.onRetry});

  final String message;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(message, textAlign: TextAlign.center),
            const SizedBox(height: 12),
            FilledButton(onPressed: onRetry, child: const Text('Retry')),
          ],
        ),
      ),
    );
  }
}

Future<void> _toggleSaved(
  BuildContext context,
  WidgetRef ref,
  Future<dynamic> Function() action,
) async {
  final messenger = ScaffoldMessenger.of(context);
  final result = await action();
  if (!context.mounted) return;

  result.fold(
    (failure) =>
        messenger.showSnackBar(SnackBar(content: Text(failure.message))),
    (_) {
      ref.invalidate(savedCollectionProvider);
      messenger.showSnackBar(
        const SnackBar(content: Text('Removed from saved')),
      );
    },
  );
}

String? _relativeTime(DateTime? value) {
  if (value == null) return null;
  final now = DateTime.now();
  final local = value.toLocal();
  final difference = now.difference(local);
  if (difference.inMinutes < 1) return 'saved just now';
  if (difference.inHours < 1) return 'saved ${difference.inMinutes}m ago';
  if (difference.inDays < 1) return 'saved ${difference.inHours}h ago';
  if (difference.inDays < 7) return 'saved ${difference.inDays}d ago';
  return 'saved ${local.day}/${local.month}/${local.year}';
}
