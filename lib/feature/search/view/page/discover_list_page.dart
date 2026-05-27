import 'package:africa_beuty/core/widgets/app_state.dart';
import 'package:africa_beuty/core/widgets/skeleton.dart';
import 'package:africa_beuty/feature/profile/view/widget/view_salon_profile.dart';
import 'package:africa_beuty/feature/search/model/discover.dart';
import 'package:africa_beuty/feature/search/provider/discover.dart';
import 'package:africa_beuty/feature/service/view/page/service_view_page.dart'
    hide SectionHeader;
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

enum DiscoverListType { nearbySalons, topSalons, trendingStyles }

class DiscoverListPage extends ConsumerWidget {
  final DiscoverListType type;

  const DiscoverListPage({super.key, required this.type});

  String get _title => switch (type) {
    DiscoverListType.nearbySalons => 'Nearby salons',
    DiscoverListType.topSalons => 'Top salons',
    DiscoverListType.trendingStyles => 'Trending styles',
  };

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(title: Text(_title)),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: switch (type) {
            DiscoverListType.nearbySalons => _NearbySalonList(
              state: ref.watch(nearbySalonsAllProvider),
              onRetry: () => ref.invalidate(nearbySalonsAllProvider),
            ),
            DiscoverListType.topSalons => _TopSalonList(
              state: ref.watch(topSalonsAllProvider),
              onRetry: () => ref.invalidate(topSalonsAllProvider),
            ),
            DiscoverListType.trendingStyles => _TrendingStyleList(
              state: ref.watch(trendingStylesAllProvider),
              onRetry: () => ref.invalidate(trendingStylesAllProvider),
            ),
          },
        ),
      ),
    );
  }
}

class _NearbySalonList extends StatelessWidget {
  final AsyncValue<List<NearbySalonItem>> state;
  final VoidCallback onRetry;

  const _NearbySalonList({required this.state, required this.onRetry});

  @override
  Widget build(BuildContext context) {
    return state.when(
      loading: () => const _ListSkeleton(),
      error: (e, _) => AppErrorState(message: e, onRetry: onRetry),
      data: (salons) => salons.isEmpty
          ? const AppEmptyState(
              icon: Icons.location_off_outlined,
              title: 'No salons nearby',
              message: 'Nearby salons will appear here.',
            )
          : ListView.separated(
              itemCount: salons.length,
              separatorBuilder: (_, _) => const Divider(height: 1),
              itemBuilder: (context, index) {
                final salon = salons[index];
                return _SalonTile(
                  title: salon.title,
                  subtitle: '${salon.distanceKm} km away',
                  coverImage: salon.coverImage,
                  onTap: () => _openSalon(context, salon.id),
                );
              },
            ),
    );
  }
}

class _TopSalonList extends StatelessWidget {
  final AsyncValue<List<TopSalonItem>> state;
  final VoidCallback onRetry;

  const _TopSalonList({required this.state, required this.onRetry});

  @override
  Widget build(BuildContext context) {
    return state.when(
      loading: () => const _ListSkeleton(),
      error: (e, _) => AppErrorState(message: e, onRetry: onRetry),
      data: (salons) => salons.isEmpty
          ? const AppEmptyState(
              icon: Icons.storefront_outlined,
              title: 'No salons yet',
              message: 'Top salons will appear here.',
            )
          : ListView.separated(
              itemCount: salons.length,
              separatorBuilder: (_, _) => const Divider(height: 1),
              itemBuilder: (context, index) {
                final salon = salons[index];
                return _SalonTile(
                  title: salon.title,
                  subtitle: salon.city ?? '${salon.bookingCount} bookings',
                  coverImage: salon.coverImage,
                  onTap: () => _openSalon(context, salon.id),
                );
              },
            ),
    );
  }
}

class _TrendingStyleList extends StatelessWidget {
  final AsyncValue<List<TrendingStyleItem>> state;
  final VoidCallback onRetry;

  const _TrendingStyleList({required this.state, required this.onRetry});

  @override
  Widget build(BuildContext context) {
    return state.when(
      loading: () => const _ListSkeleton(),
      error: (e, _) => AppErrorState(message: e, onRetry: onRetry),
      data: (items) => items.isEmpty
          ? const AppEmptyState(
              icon: Icons.auto_awesome_outlined,
              title: 'Nothing trending yet',
              message: 'Popular styles will appear here.',
            )
          : ListView.separated(
              itemCount: items.length,
              separatorBuilder: (_, _) => const Divider(height: 1),
              itemBuilder: (context, index) {
                final item = items[index];
                return ListTile(
                  contentPadding: const EdgeInsets.symmetric(vertical: 8),
                  leading: _ImageThumb(
                    imageUrl: item.image,
                    fallbackIcon: Icons.auto_awesome_outlined,
                  ),
                  title: Text(item.name),
                  subtitle: Text('${item.postCount} posts'),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () => Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => ServiceDetailsPage(serviceId: item.id),
                    ),
                  ),
                );
              },
            ),
    );
  }
}

class _SalonTile extends StatelessWidget {
  final String title;
  final String subtitle;
  final String? coverImage;
  final VoidCallback onTap;

  const _SalonTile({
    required this.title,
    required this.subtitle,
    required this.coverImage,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(vertical: 8),
      leading: _ImageThumb(
        imageUrl: coverImage,
        fallbackIcon: Icons.storefront_outlined,
      ),
      title: Text(title),
      subtitle: Text(subtitle),
      trailing: const Icon(Icons.chevron_right),
      onTap: onTap,
    );
  }
}

class _ImageThumb extends StatelessWidget {
  final String? imageUrl;
  final IconData fallbackIcon;

  const _ImageThumb({required this.imageUrl, required this.fallbackIcon});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return ClipRRect(
      borderRadius: BorderRadius.circular(8),
      child: SizedBox(
        width: 72,
        height: 72,
        child: imageUrl == null
            ? _fallback(scheme)
            : CachedNetworkImage(
                imageUrl: imageUrl!,
                fit: BoxFit.cover,
                errorWidget: (_, _, _) => _fallback(scheme),
              ),
      ),
    );
  }

  Widget _fallback(ColorScheme scheme) {
    return ColoredBox(
      color: scheme.surfaceContainerHighest,
      child: Icon(fallbackIcon, color: scheme.onSurfaceVariant),
    );
  }
}

class _ListSkeleton extends StatelessWidget {
  const _ListSkeleton();

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      itemCount: 8,
      separatorBuilder: (_, _) => const SizedBox(height: 4),
      itemBuilder: (_, _) => const SkeletonListTile(
        roundLeading: false,
        trailingWidth: 24,
        padding: EdgeInsets.symmetric(vertical: 10),
      ),
    );
  }
}

void _openSalon(BuildContext context, String salonId) {
  Navigator.of(context).push(
    MaterialPageRoute(builder: (_) => ViewServiceProfilePage(salonId: salonId)),
  );
}
