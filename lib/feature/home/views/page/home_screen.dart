import 'package:africa_beuty/core/page/chats.dart';
import 'package:africa_beuty/feature/home/view_model/post_like.dart';
import 'package:africa_beuty/feature/post/view/page/single_post.dart';
import 'package:africa_beuty/core/widgets/spacing.dart';
import 'package:africa_beuty/feature/home/view_model/category.dart';
import 'package:africa_beuty/feature/home/view_model/home_posts.dart';
import 'package:africa_beuty/feature/home/view_model/top_salon.dart';
import 'package:africa_beuty/feature/post/view/page/view_post.dart';
import 'package:africa_beuty/feature/profile/view/page/view_profile.dart';
import 'package:africa_beuty/feature/profile/view/widget/view_salon_profile.dart';
import 'package:africa_beuty/feature/search/view/page/search.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:icons_plus/icons_plus.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    // final size = MediaQuery.of(context).size;
    final topSalons = ref.watch(topSalonViewModelProvider);
    final feed = ref.watch(feedViewModelProvider);
    final categories = ref.watch(homeCategoriesViewModelProvider);
    final size = MediaQuery.of(context).size;
    
    return Scaffold(
      body: SafeArea(
        child: PageView(
          children: [
            // Home Screen
            CustomScrollView(
              slivers: [
                // App Brand
                SliverToBoxAdapter(
                  child: Padding(
                    padding: EdgeInsets.only(top: 16, left: 16, bottom: 5, right: 16),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Icon(
                              Icons.face, 
                              size: 24,
                            ),
                            SizedBox(width: 10,), 
                            Text(
                              'African Beauty', 
                              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                fontFamily: 'Pacifico', 
                                fontWeight: FontWeight.w200, 
                                fontSize: 32,
                              ),
                            )
                          ],
                        ), 
                        IconButton(
                          onPressed: () {},
                          icon: Icon(
                            Bootstrap.bell, 
                            size: 24, 
                          ),
                        )
                      ],
                    ),
                  ),
                ),
                
                // Search and notification
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                    child: Row(
                      children: [
                        Expanded(
                          child: GestureDetector(
                            onTap: () {
                              // Navigate to the search page
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const SearchPage(),
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
                                border: Border.all(color: Colors.grey.shade500),
                              ),
                              child: Row(
                                children: [
                                  const Icon(Icons.search,),
                                  const SizedBox(width: 8),
                                  Text(
                                    'What are you looking for?',
                                    style: TextStyle(
                                      fontSize: 16,
                                    ),
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
                  child: SizedBox(
                    height: 72,
                    child: categories.when(
                      loading: () => const Center(
                        child: CircularProgressIndicator(),
                      ),

                      error: (e, _) => const SizedBox.shrink(),

                      data: (items) => ListView.builder(
                        scrollDirection: Axis.horizontal,
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        itemCount: items.length,
                        itemBuilder: (context, index) {
                          final category = items[index];
                          return Container(
                            margin: const EdgeInsets.only(right: 4),
                            padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 8),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(40),
                              color: Theme.of(context).colorScheme.surface,
                            ),
                            child: Column(
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(10),
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
                      loading: () => const Center(
                        child: CircularProgressIndicator(),
                      ),

                      error: (e, _) => Center(
                        child: Text(
                          e.toString(),
                          style: const TextStyle(color: Colors.red),
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
                                  builder: (context) =>  ViewProfilePage(isServiceProfile: true,
                                    userId: salon.salonId,
                                    )
                                  )
                                );
                            },
                            child: Container(
                              width: MediaQuery.of(context).size.width * 0.85,
                              margin: const EdgeInsets.only(right: 12),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(16),
                                color: Colors.grey.shade300, // fallback if no cover
                                image: salon.coverUrl.isNotEmpty &&
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
                                      Colors.black.withOpacity(0.7),
                                    ],
                                  ),
                                ),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    CircleAvatar(
                                      radius: 28,
                                      backgroundImage: salon.logoUrl.isNotEmpty
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
                        loading: () => const Padding(
                          padding: EdgeInsets.all(24),
                          child: Center(child: CircularProgressIndicator()),
                        ),

                        error: (e, _) => Padding(
                          padding: const EdgeInsets.all(24),
                          child: Text(
                            e.toString(),
                            style: const TextStyle(color: Colors.red),
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
                          }

                          // FIX index shift due to ads
                          final postIndex = index - (index ~/ 5);
                          if (postIndex >= posts.length) return null;

                          final post = posts[postIndex];

                          // Trigger pagination
                          if (postIndex == posts.length - 1) {
                            ref.read(feedViewModelProvider.notifier).loadMore();
                          }
                          return GestureDetector(
                            behavior: HitTestBehavior.opaque,

                            // ---------------- SINGLE TAP → OPEN POST ----------------
                            onTap: () {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (_) => PostViewPage(
                                    postId: post.id,
                                  ),
                                ),
                              );
                            },

                            // ---------------- DOUBLE TAP → LIKE ----------------
                            onDoubleTap: () {
                              ref
                                .read(
                                    postLikeViewModelProvider.notifier)
                                .toggleLike(
                                  postId: post.id,
                                );
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
                              images: post.media.map((e) => e.url).toList(),
                              aspectRatio:
                                  post.media.isNotEmpty ? post.media.first.aspectRatio : 1,
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

            // Chats Screen (Placeholder)
            ChatsPage(),
          ],
        ),
      ),
    );
  }
}