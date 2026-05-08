import 'package:africa_beuty/core/widgets/skeleton.dart';
import 'package:africa_beuty/feature/search/model/discover.dart';
import 'package:africa_beuty/feature/search/provider/discover.dart';
import 'package:africa_beuty/feature/search/view/widgets/section_header.dart';
import 'package:africa_beuty/feature/service/view/page/service_view_page.dart'
    hide SectionHeader;
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class TrendingStylesSection extends ConsumerWidget {
  const TrendingStylesSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(trendingStylesProvider);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SectionHeader(title: 'Trending styles', onSeeAll: () {}),
        const SizedBox(height: 12),
        state.when(
          loading: () => const _TrendingStylesSkeleton(),
          error: (e, _) => Center(
            child: Text(
              e.toString(),
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ),
          data: (items) => items.isEmpty
              ? Center(
                  child: Text(
                    'Nothing trending yet',
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                )
              : SizedBox(
                  height: 140,
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    itemCount: items.length,
                    separatorBuilder: (_, _) => const SizedBox(width: 12),
                    itemBuilder: (context, index) =>
                        _StyleCard(item: items[index]),
                  ),
                ),
        ),
      ],
    );
  }
}

class _TrendingStylesSkeleton extends StatelessWidget {
  const _TrendingStylesSkeleton();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 140,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: 4,
        separatorBuilder: (_, _) => const SizedBox(width: 12),
        itemBuilder: (_, _) =>
            const SkeletonCard(width: 110, height: 140, radius: 16),
      ),
    );
  }
}

class _StyleCard extends StatelessWidget {
  final TrendingStyleItem item;

  const _StyleCard({required this.item});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (_) => ServiceDetailsPage(serviceId: item.id),
          ),
        );
      },
      child: Container(
        width: 110,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          color: Theme.of(context).colorScheme.surfaceContainerHighest,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(16),
              ),
              child: SizedBox(
                height: 80,
                width: double.infinity,
                child: item.image != null
                    ? CachedNetworkImage(
                        imageUrl: item.image!,
                        fit: BoxFit.cover,
                        errorWidget: (_, _, e) => _placeholder(),
                      )
                    : _placeholder(),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 12,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    '${item.postCount} posts',
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _placeholder() => Container(
    color: Colors.grey.shade300,
    child: const Center(child: Icon(Icons.auto_awesome, size: 28)),
  );
}
