import 'package:africa_beuty/core/widgets/app_state.dart';
import 'package:africa_beuty/core/widgets/skeleton.dart';
import 'package:africa_beuty/feature/profile/view/widget/view_salon_profile.dart';
import 'package:africa_beuty/feature/search/provider/discover.dart';
import 'package:africa_beuty/feature/search/view/page/discover_list_page.dart';
import 'package:africa_beuty/feature/search/view/widgets/salon_card.dart';
import 'package:africa_beuty/feature/search/view/widgets/section_header.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';

class NearbySalonsSection extends ConsumerStatefulWidget {
  const NearbySalonsSection({super.key});

  @override
  ConsumerState<NearbySalonsSection> createState() =>
      _NearbySalonsSectionState();
}

class _NearbySalonsSectionState extends ConsumerState<NearbySalonsSection> {
  bool _locationRequested = false;

  @override
  Widget build(BuildContext context) {
    final state = _locationRequested ? ref.watch(nearbySalonsProvider) : null;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (_locationRequested)
          SectionHeader(
            title: 'Nearby salons',
            onSeeAll: () => Navigator.of(context).push(
              MaterialPageRoute(
                builder: (_) =>
                    const DiscoverListPage(type: DiscoverListType.nearbySalons),
              ),
            ),
          )
        else
          Text('Nearby salons', style: Theme.of(context).textTheme.titleMedium),
        const SizedBox(height: 12),
        if (state == null)
          _NearbyPrompt(onFind: () => setState(() => _locationRequested = true))
        else
          SizedBox(
            height: 180,
            child: state.when(
              loading: () => const _SalonCardsSkeleton(),
              error: (e, _) => _NearbyError(
                error: e,
                onRetry: () => ref.invalidate(nearbySalonsProvider),
              ),
              data: (salons) => salons.isEmpty
                  ? const AppEmptyState(
                      icon: Icons.location_off_outlined,
                      title: 'No salons nearby',
                      message: 'Nearby salons will appear here.',
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

class _NearbyPrompt extends StatelessWidget {
  final VoidCallback onFind;

  const _NearbyPrompt({required this.onFind});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: scheme.surface,
        border: Border.all(color: scheme.outlineVariant),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.location_on_outlined, color: scheme.primary),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Find salons near you',
                  style: Theme.of(
                    context,
                  ).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w800),
                ),
                const SizedBox(height: 4),
                Text(
                  'Use your current location to show nearby salons.',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: scheme.onSurfaceVariant,
                    height: 1.3,
                  ),
                ),
                const SizedBox(height: 10),
                FilledButton.icon(
                  onPressed: onFind,
                  icon: const Icon(Icons.my_location_rounded, size: 18),
                  label: const Text('Find nearby'),
                ),
              ],
            ),
          ),
        ],
      ),
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
    final scheme = Theme.of(context).colorScheme;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: scheme.surface,
          border: Border.all(color: scheme.outlineVariant),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(Icons.location_on_outlined, color: scheme.primary),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Find salons near you',
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    locationError?.message ?? error.toString(),
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: scheme.onSurfaceVariant,
                      height: 1.3,
                    ),
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
                      locationError == null
                          ? Icons.refresh
                          : Icons.settings_outlined,
                      size: 18,
                    ),
                    label: Text(label),
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
