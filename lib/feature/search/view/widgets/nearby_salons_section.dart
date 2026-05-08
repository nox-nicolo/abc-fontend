import 'package:africa_beuty/core/widgets/skeleton.dart';
import 'package:africa_beuty/feature/search/provider/discover.dart';
import 'package:africa_beuty/feature/search/view/widgets/salon_card.dart';
import 'package:africa_beuty/feature/search/view/widgets/section_header.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

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
            error: (e, _) => Center(
              child: Text(
                e.toString(),
                style: Theme.of(context).textTheme.bodySmall,
                textAlign: TextAlign.center,
              ),
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
                      );
                    },
                  ),
          ),
        ),
      ],
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
