import 'package:flutter/material.dart';

class ViewCustomerProfilePage extends StatelessWidget {
  const ViewCustomerProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          // 🔹 PROFILE HEADER
          SliverAppBar(
            pinned: true,
            expandedHeight: 280,
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.vertical(
                bottom: Radius.circular(20),
              ),
            ),
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                padding: const EdgeInsets.all(20),
                decoration: const BoxDecoration(
                  borderRadius: BorderRadius.vertical(
                    bottom: Radius.circular(20),
                  ),
                ),
                alignment: Alignment.bottomLeft,
                child: Row(
                  children: [
                    const CircleAvatar(
                      radius: 45,
                    ),
                    const SizedBox(width: 16),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Customer Name',
                          style: Theme.of(context)
                              .textTheme
                              .headlineSmall,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '@username',
                          style: Theme.of(context)
                              .textTheme
                              .bodyMedium
                              ?.copyWith(color: Theme.of(context).colorScheme.onSurfaceVariant),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),

          // 🔹 BIO (optional but useful)
          const _SectionTitle(title: 'Bio'),
          const _CustomerBio(),

          // 🔹 POSTS
          const _SectionTitle(title: 'Posts'),
          const _CustomerPostsGrid(),
        ],
      ),
    );
  }
}


class _CustomerBio extends StatelessWidget {
  const _CustomerBio();

  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: Text(
          'This is a short customer bio. It can describe interests, '
          'style preferences, or a short personal note.',
          maxLines: 3,
          overflow: TextOverflow.ellipsis,
          style: Theme.of(context).textTheme.bodyMedium,
        ),
      ),
    );
  }
}


class _CustomerPostsGrid extends StatelessWidget {
  const _CustomerPostsGrid();

  @override
  Widget build(BuildContext context) {
    return SliverPadding(
      padding: const EdgeInsets.all(4),
      sliver: SliverGrid(
        delegate: SliverChildBuilderDelegate(
          (context, index) {
            return Container(
              margin: const EdgeInsets.all(4),
              color: Theme.of(context).colorScheme.surfaceContainerHighest,
              child: Center(
                child: Text('Post $index'),
              ),
            );
          },
          childCount: 12,
        ),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          crossAxisSpacing: 4,
          mainAxisSpacing: 4,
        ),
      ),
    );
  }
}


class _SectionTitle extends StatelessWidget {
  final String title;

  const _SectionTitle({required this.title});

  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Text(
          title,
          style: Theme.of(context).textTheme.titleMedium,
        ),
      ),
    );
  }
}
