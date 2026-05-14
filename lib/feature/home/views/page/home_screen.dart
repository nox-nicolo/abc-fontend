import 'package:africa_beuty/core/page/bottom_nav.dart';
import 'package:africa_beuty/core/widgets/skeleton.dart';
import 'package:africa_beuty/feature/auth/view_model/me_viewmodel.dart';
import 'package:africa_beuty/feature/chat/view/page/chats_page.dart';
import 'package:africa_beuty/feature/home/view_model/post_like.dart';
import 'package:africa_beuty/feature/post/view/page/single_post.dart';
import 'package:africa_beuty/core/widgets/spacing.dart';
import 'package:africa_beuty/feature/home/view_model/category.dart';
import 'package:africa_beuty/feature/home/view_model/home_posts.dart';
import 'package:africa_beuty/feature/home/view_model/top_salon.dart';
import 'package:africa_beuty/feature/notifications/view/widget/notifications_bell.dart';
import 'package:africa_beuty/feature/post/view/page/view_post.dart';
import 'package:africa_beuty/feature/profile/view/page/view_profile.dart';
import 'package:africa_beuty/feature/profile/view/widget/view_salon_profile.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  late final ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController()..addListener(_onScroll);
    Future.microtask(() {
      if (mounted) {
        ref.read(meViewModelProvider.notifier).getMeeData();
      }
    });
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 400) {
      ref.read(feedViewModelProvider.notifier).loadMore();
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final topSalons = ref.watch(topSalonViewModelProvider);
    final feed = ref.watch(feedViewModelProvider);
    final categories = ref.watch(homeCategoriesViewModelProvider);
    final colorScheme = Theme.of(context).colorScheme;

    Future<void> refreshHome() async {
      await Future.wait([
        ref.read(meViewModelProvider.notifier).getMeeData(),
        ref.read(topSalonViewModelProvider.notifier).refresh(),
        ref.read(feedViewModelProvider.notifier).refresh(),
      ]);
    }

    return Scaffold(
      body: SafeArea(
        child: PageView(
          children: [
            // Home Screen
            RefreshIndicator(
              onRefresh: refreshHome,
              child: CustomScrollView(
                controller: _scrollController,
                slivers: [
                  // App Brand
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: EdgeInsets.only(
                        top: 16,
                        left: 16,
                        bottom: 5,
                        right: 16,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Image.asset(
                                'android/app/src/main/res/mipmap-xxxhdpi/ic_launcher.png',
                                width: 28,
                                height: 28,
                              ),
                              const SizedBox(width: 10),
                              Text(
                                'African Beauty',
                                style: Theme.of(context).textTheme.titleLarge
                                    ?.copyWith(
                                      fontFamily: 'Pacifico',
                                      fontWeight: FontWeight.w200,
                                      fontSize: 32,
                                    ),
                              ),
                            ],
                          ),
                          const NotificationsBell(),
                        ],
                      ),
                    ),
                  ),

                  // Search and notification
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 8,
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: GestureDetector(
                              onTap: () {
                                // Navigate to the search page
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        const BottomNavigationPage(
                                          initialIndex: 1,
                                        ),
                                  ),
                                );
                              },
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                  vertical: 12,
                                  horizontal: 16,
                                ),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(8),
                                  border: Border.all(
                                    color: colorScheme.outline,
                                  ),
                                ),
                                child: Row(
                                  children: [
                                    const Icon(Icons.search),
                                    const SizedBox(width: 8),
                                    Text(
                                      'What are you looking for?',
                                      style: TextStyle(fontSize: 16),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          // const SizedBox(width: 16),
                          // const Icon(FontAwesome.bell),
                        ],
                      ),
                    ),
                  ),

                  // Top list of categories
                  SliverToBoxAdapter(
                    child: categories.when(
                      loading: () => const _CategorySkeletonList(),

                      error: (e, _) => const SizedBox.shrink(),

                      data: (items) => items.isEmpty
                          ? const SizedBox.shrink()
                          : SizedBox(
                              height: 72,
                              child: ListView.builder(
                                scrollDirection: Axis.horizontal,
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                ),
                                itemCount: items.length,
                                itemBuilder: (context, index) {
                                  final category = items[index];
                                  return Container(
                                    margin: const EdgeInsets.only(right: 4),
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 4,
                                      vertical: 8,
                                    ),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(40),
                                      color: Theme.of(
                                        context,
                                      ).colorScheme.surface,
                                    ),
                                    child: Column(
                                      children: [
                                        ClipRRect(
                                          borderRadius: BorderRadius.circular(
                                            10,
                                          ),
                                          child: Image.network(
                                            category.servicePicture,
                                            width: 36,
                                            height: 36,
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                        const SizedBox(width: 8),
                                        Text(category.serviceName),
                                      ],
                                    ),
                                  );
                                },
                              ),
                            ),
                    ),
                  ),

                  // SliverToBoxAdapter(
                  //   child: SizedBox(
                  //     height: 300,
                  //     child: ListView.builder(
                  //       scrollDirection: Axis.horizontal,
                  //       itemCount: 2,
                  //       itemBuilder: (context, index) => Container(
                  //         margin: const EdgeInsets.only(right: 10),
                  //         width: size.width * 0.9,
                  //         decoration: BoxDecoration(
                  //           borderRadius: BorderRadius.circular(8),
                  //           // image: const DecorationImage(
                  //           //   image: AssetImage(''), // Replace with actual image
                  //           //   fit: BoxFit.cover,
                  //           // ),
                  //         ),
                  //         child: Padding(
                  //           padding: const EdgeInsets.all(16),
                  //           child: Column(
                  //             crossAxisAlignment: CrossAxisAlignment.start,
                  //             mainAxisAlignment: MainAxisAlignment.end,
                  //             children: [
                  //               Text(
                  //                 'Special Offer!',
                  //                 style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  //                       fontWeight: FontWeight.bold,
                  //                       color: Colors.white
                  //                     ),
                  //               ),
                  //               const SizedBox(height: 8),
                  //               Text(
                  //                 'Get 50% off on your first booking',
                  //                 style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  //                       color: Colors.white,
                  //                     ),
                  //               ),
                  //               const SizedBox(height: 16),
                  //               ElevatedButton(
                  //                 onPressed: () {
                  //                   // Handle CTA
                  //                 },
                  //                 child: const Text('Book Now'),
                  //               ),
                  //             ],
                  //           ),
                  //         ),
                  //       ),
                  //     ),
                  //   ),
                  // ),

                  // Top Salons
                  SliverSpaceHeader(title: 'Top Salons'),
                  SliverToBoxAdapter(
                    child: SizedBox(
                      height: 300, // same visual weight as before
                      child: topSalons.when(
                        loading: () => const _TopSalonSkeletonList(),

                        error: (e, _) => Center(
                          child: Text(
                            e.toString(),
                            style: TextStyle(color: colorScheme.error),
                          ),
                        ),

                        data: (salons) => ListView.builder(
                          scrollDirection: Axis.horizontal,
                          padding: const EdgeInsets.symmetric(horizontal: 12),
                          itemCount: salons.length,
                          itemBuilder: (context, index) {
                            final salon = salons[index];

                            return GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => ViewProfilePage(
                                      isServiceProfile: true,
                                      userId: salon.salonId,
                                    ),
                                  ),
                                );
                              },
                              child: Container(
                                width: MediaQuery.of(context).size.width * 0.85,
                                margin: const EdgeInsets.only(right: 12),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(16),
                                  color: colorScheme
                                      .surfaceContainerHighest, // fallback if no cover
                                  image:
                                      salon.coverUrl.isNotEmpty &&
                                          salon.coverUrl != 'Not Set'
                                      ? DecorationImage(
                                          image: NetworkImage(salon.coverUrl),
                                          fit: BoxFit.cover,
                                        )
                                      : null,
                                ),
                                child: Container(
                                  padding: const EdgeInsets.all(16),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(16),
                                    gradient: LinearGradient(
                                      begin: Alignment.topCenter,
                                      end: Alignment.bottomCenter,
                                      colors: [
                                        Colors.transparent,
                                        Colors.black.withValues(alpha: 0.7),
                                      ],
                                    ),
                                  ),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      CircleAvatar(
                                        radius: 28,
                                        backgroundImage:
                                            salon.logoUrl.isNotEmpty
                                            ? NetworkImage(salon.logoUrl)
                                            : null,
                                        child: salon.logoUrl.isEmpty
                                            ? const Icon(Icons.store)
                                            : null,
                                      ),
                                      // Salon name
                                      Text(
                                        salon.name,
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: Theme.of(context)
                                            .textTheme
                                            .headlineSmall
                                            ?.copyWith(
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold,
                                            ),
                                      ),

                                      const SizedBox(height: 4),

                                      // Tagline
                                      Text(
                                        salon.tagline,
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyMedium
                                            ?.copyWith(color: Colors.white70),
                                      ),

                                      const SizedBox(height: 8),

                                      // City (optional)
                                      if (salon.city.isNotEmpty &&
                                          salon.city != 'Not Set')
                                        Text(
                                          salon.city,
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodySmall
                                              ?.copyWith(color: Colors.white60),
                                        ),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                  ),

                  // Content & Ads (some)
                  SliverSpaceHeader(title: ''),
                  SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (context, index) {
                        return feed.when(
                          loading: () => const _FeedPostSkeleton(),

                          error: (e, _) => Padding(
                            padding: const EdgeInsets.all(24),
                            child: Text(
                              e.toString(),
                              style: TextStyle(color: colorScheme.error),
                            ),
                          ),

                          data: (posts) {
                            // ADS — unchanged logic
                            if (index % 5 == 0 && index != 0) {
                              return Container(
                                margin: const EdgeInsets.symmetric(vertical: 8),
                                height: 200,
                                child: Card(
                                  elevation: 4,
                                  child: const Center(child: Text('Ad')),
                                ),
                              );
                              // implement the ads data here!
                            }

                            // FIX index shift due to ads
                            final postIndex = index - (index ~/ 5);
                            if (postIndex >= posts.length) return null;

                            final post = posts[postIndex];

                            return GestureDetector(
                              behavior: HitTestBehavior.opaque,

                              // ---------------- SINGLE TAP → OPEN POST ----------------
                              onTap: () {
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (_) =>
                                        PostViewPage(postId: post.id),
                                  ),
                                );
                              },

                              // ---------------- DOUBLE TAP → LIKE ----------------
                              onDoubleTap: () {
                                ref
                                    .read(postLikeViewModelProvider.notifier)
                                    .toggleLike(postId: post.id);
                                // Style more
                                HapticFeedback.lightImpact();
                              },

                              // ---------------- LONG PRESS (FUTURE) ----------------
                              onLongPress: () {
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (_) => ViewServiceProfilePage(
                                      salonId: post.author.salon.id,
                                    ),
                                  ),
                                );
                              },

                              child: Post(
                                postId: post.id,
                                isLiked: post.viewerState.isLiked,
                                isSaved: post.viewerState.isSaved,
                                images: post.media.map((e) => e.url).toList(),
                                aspectRatio: post.media.isNotEmpty
                                    ? post.media.first.aspectRatio
                                    : 1,
                                username: post.author.username,
                                profileImage: post.author.profilePicture,
                                likesCount: post.stats.likes,
                                sharesCount: post.stats.shares,
                                commentsCount: post.stats.comments,
                                description: post.caption,
                                datePosted: post.createdAt.toIso8601String(),
                              ),
                            );
                          },
                        );
                      },
                      childCount: feed.maybeWhen(
                        data: (posts) => posts.length + (posts.length ~/ 4),
                        orElse: () => 1,
                      ),
                    ),
                  ),

                  // Feed footer — loading more / end of feed
                  SliverToBoxAdapter(
                    child: feed.maybeWhen(
                      data: (_) {
                        final notifier = ref.read(
                          feedViewModelProvider.notifier,
                        );
                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 24),
                          child: Center(
                            child: notifier.hasMore
                                ? const _FeedFooterSkeleton()
                                : Text(
                                    "You're all caught up",
                                    style: TextStyle(
                                      color: colorScheme.onSurfaceVariant,
                                    ),
                                  ),
                          ),
                        );
                      },
                      orElse: () => const SizedBox.shrink(),
                    ),
                  ),

                  // Events
                  // SliverSpaceHeader(title: 'Events'),
                  // SliverGrid(
                  //   delegate: SliverChildBuilderDelegate(
                  //     (context, index) => Container(
                  //       decoration: BoxDecoration(
                  //         color: Colors.grey.shade200,
                  //         borderRadius: BorderRadius.circular(8),
                  //       ),
                  //       child: Center(child: Text('Event $index')),
                  //     ),
                  //     childCount: 4, // Replace with actual event count
                  //   ),
                  //   gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  //     crossAxisCount: 2,
                  //     mainAxisSpacing: 1,
                  //     crossAxisSpacing: 1,
                  //     childAspectRatio: .9,
                  //   ),
                  // ),
                ],
              ),
            ),

            // Chats Screen (Placeholder)
            Navigator(
              onGenerateRoute: (settings) {
                return MaterialPageRoute(
                  builder: (context) => const ChatsPage(),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

class _CategorySkeletonList extends StatelessWidget {
  const _CategorySkeletonList();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 72,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        itemCount: 6,
        separatorBuilder: (_, _) => const SizedBox(width: 10),
        itemBuilder: (_, _) => const Column(
          children: [
            SkeletonCard(width: 36, height: 36, radius: 10),
            SizedBox(height: 6),
            SkeletonText(width: 54, height: 10),
          ],
        ),
      ),
    );
  }
}

class _TopSalonSkeletonList extends StatelessWidget {
  const _TopSalonSkeletonList();

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width * 0.85;

    return ListView.separated(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: 12),
      itemCount: 2,
      separatorBuilder: (_, _) => const SizedBox(width: 12),
      itemBuilder: (_, _) => SizedBox(
        width: width,
        child: const Stack(
          children: [
            Positioned.fill(
              child: SkeletonCard(
                width: double.infinity,
                height: 300,
                radius: 16,
              ),
            ),
            Positioned(
              left: 16,
              right: 16,
              bottom: 18,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Skeleton.circle(size: 56),
                  SizedBox(height: 12),
                  SkeletonText(width: 180, height: 20),
                  SizedBox(height: 8),
                  SkeletonText(width: 240, height: 12),
                  SizedBox(height: 8),
                  SkeletonText(width: 90, height: 10),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _FeedPostSkeleton extends StatelessWidget {
  const _FeedPostSkeleton();

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.only(bottom: 22),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SkeletonListTile(),
          SkeletonCard(width: double.infinity, height: 420, radius: 0),
          SizedBox(height: 12),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SkeletonText(width: 180, height: 13),
                SizedBox(height: 8),
                SkeletonText(width: double.infinity, height: 12),
                SizedBox(height: 6),
                SkeletonText(width: 230, height: 12),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _FeedFooterSkeleton extends StatelessWidget {
  const _FeedFooterSkeleton();

  @override
  Widget build(BuildContext context) {
    return const Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        SkeletonCard(width: 220, height: 14),
        SizedBox(height: 10),
        SkeletonCard(width: 160, height: 12),
      ],
    );
  }
}
