import 'package:africa_beuty/core/widgets/skeleton.dart';
import 'package:africa_beuty/feature/profile/view/widget/view_salon_profile.dart';
import 'package:africa_beuty/feature/search/provider/discover.dart';
import 'package:africa_beuty/feature/search/view/widgets/salon_card.dart';
import 'package:africa_beuty/feature/search/view/widgets/section_header.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';

class NearbySalonsSection extends ConsumerWidget {
  const NearbySalonsSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(nearbySalonsProvider);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SectionHeader(title: 'Nearby salons', onSeeAll: () {}),
        const SizedBox(height: 12),
        SizedBox(
          height: 180,
          child: state.when(
            loading: () => const _SalonCardsSkeleton(),
            error: (e, _) => _NearbyError(
              error: e,
              onRetry: () => ref.invalidate(nearbySalonsProvider),
            ),
            data: (salons) => salons.isEmpty
                ? Center(
                    child: Text(
                      'No salons nearby',
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  )
                : ListView.separated(
                    scrollDirection: Axis.horizontal,
                    itemCount: salons.length,
                    separatorBuilder: (_, _) => const SizedBox(width: 12),
                    itemBuilder: (context, i) {
                      final s = salons[i];
                      return SalonCard(
                        title: s.title,
                        coverImage: s.coverImage,
                        subtitle: '${s.distanceKm} km away',
                        onTap: () => Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (_) =>
                                ViewServiceProfilePage(salonId: s.id),
                          ),
                        ),
                      );
                    },
                  ),
          ),
        ),
      ],
    );
  }
}

class _NearbyError extends StatelessWidget {
  final Object error;
  final VoidCallback onRetry;

  const _NearbyError({required this.error, required this.onRetry});

  @override
  Widget build(BuildContext context) {
    final locationError = error is LocationDiscoveryException
        ? error as LocationDiscoveryException
        : null;
    final label = locationError == null ? 'Try again' : 'Open settings';

    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              locationError?.message ?? error.toString(),
              style: Theme.of(context).textTheme.bodySmall,
              textAlign: TextAlign.center,
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 8),
            TextButton.icon(
              onPressed: () async {
                if (locationError?.action ==
                    LocationDiscoveryAction.openLocationSettings) {
                  await Geolocator.openLocationSettings();
                } else if (locationError?.action ==
                    LocationDiscoveryAction.openAppSettings) {
                  await Geolocator.openAppSettings();
                }
                onRetry();
              },
              icon: Icon(
                locationError == null ? Icons.refresh : Icons.location_on,
                size: 18,
              ),
              label: Text(label),
            ),
          ],
        ),
      ),
    );
  }
}

class _SalonCardsSkeleton extends StatelessWidget {
  const _SalonCardsSkeleton();

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      scrollDirection: Axis.horizontal,
      itemCount: 3,
      separatorBuilder: (_, _) => const SizedBox(width: 12),
      itemBuilder: (_, _) =>
          const SkeletonCard(width: 150, height: 180, radius: 16),
    );
  }
}
