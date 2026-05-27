import 'package:africa_beuty/core/widgets/app_state.dart';
import 'package:africa_beuty/core/widgets/skeleton.dart';
import 'package:africa_beuty/feature/profile/view/widget/view_salon_profile.dart';
import 'package:africa_beuty/feature/search/provider/discover.dart';
import 'package:africa_beuty/feature/search/view/page/discover_list_page.dart';
import 'package:africa_beuty/feature/search/view/widgets/salon_card.dart';
import 'package:africa_beuty/feature/search/view/widgets/section_header.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class TopSalonsSection extends ConsumerWidget {
  const TopSalonsSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(topSalonsProvider);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SectionHeader(
          title: 'Top salons',
          onSeeAll: () => Navigator.of(context).push(
            MaterialPageRoute(
              builder: (_) =>
                  const DiscoverListPage(type: DiscoverListType.topSalons),
            ),
          ),
        ),
        const SizedBox(height: 12),
        SizedBox(
          height: 180,
          child: state.when(
            loading: () => const _SalonCardsSkeleton(),
            error: (e, _) => AppErrorState(
              message: e,
              onRetry: () => ref.invalidate(topSalonsProvider),
            ),
            data: (salons) => salons.isEmpty
                ? const AppEmptyState(
                    icon: Icons.storefront_outlined,
                    title: 'No salons yet',
                    message: 'Top salons will appear here.',
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
                        subtitle: s.city,
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
