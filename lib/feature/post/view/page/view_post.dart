import 'package:africa_beuty/feature/home/view_model/post_like.dart';
import 'package:africa_beuty/feature/post/model/single_post_view.dart';
import 'package:africa_beuty/feature/post/view/page/single_post.dart';
import 'package:africa_beuty/feature/post/view/widgets/view_post/booking.dart';
import 'package:africa_beuty/feature/post/view/widgets/view_post/look_alike.dart';
import 'package:africa_beuty/feature/post/view/widgets/view_post/post_description.dart';
import 'package:africa_beuty/feature/post/view/widgets/view_post/post_images.dart';
import 'package:africa_beuty/feature/post/view/widgets/view_post/post_stats.dart';
import 'package:africa_beuty/feature/post/view/widgets/view_post/service_datails.dart';
import 'package:africa_beuty/feature/post/view/widgets/view_post/service_review.dart';
import 'package:africa_beuty/feature/post/view/widgets/view_post/sponsored_salon.dart';
import 'package:africa_beuty/feature/post/view/widgets/view_post/stylist.dart';
import 'package:africa_beuty/feature/post/view_model/single_post_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:icons_plus/icons_plus.dart';

class PostViewPage extends ConsumerWidget {
  final String postId;

  const PostViewPage({
    super.key,
    required this.postId,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(singlePostViewModelProvider(postId));

    return Scaffold(
      appBar: AppBar(
        title: const Text('Post'),
        actions: const [
          Icon(Icons.share_outlined),
          SizedBox(width: 12),
          Icon(Icons.more_vert_outlined),
          SizedBox(width: 12),
        ],
      ),
      body: state.when(
        loading: () =>
            const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text(e.toString())),
        data: (data) => _PostViewBody(data: data),
      ),
    );
  }
}

class _PostViewBody extends StatelessWidget {
  final SinglePostViewModel data;

  const _PostViewBody({
    required this.data,
  });

  @override
  Widget build(BuildContext context) {
    final post = data.post;

    return CustomScrollView(
      physics: const BouncingScrollPhysics(),
      slivers: [
        // ------------- User Details -------------
        SliverToBoxAdapter(
          child: SizedBox(
            child: Row(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: Row(
                    children: [
                      CircleAvatar(
                        radius: 28,
                        backgroundColor: Colors.grey.shade300,
                        child: ClipOval(
                          child: post.author.displayPicture!.isNotEmpty
                              ? Image.network(
                                  post.author.displayPicture.toString(),
                                  width: 48,
                                  height: 48,
                                  fit: BoxFit.cover,
                                )
                              : const Icon(Icons.person, size: 48),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // show salon title
                          Row(
                            children: [
                              Text(
                                post.author.salonName,
                                style: Theme.of(context).textTheme.labelLarge,
                              ),
                              const SizedBox(width: 5),
                              Icon(
                                OctIcons.verified,
                                size: 12,
                                color: Colors.blue.shade500,
                              ),
                            ],
                          ),
                          const SizedBox(height: 5,),
                          Text(
                            post.author.username,
                            style: Theme.of(context).textTheme.labelSmall,
                          ),
                        ],
                      ),
                      
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        // ---------------- Images ----------------
        if (post.images.isNotEmpty)
          SliverToBoxAdapter(
            child: GestureDetector(
              behavior: HitTestBehavior.opaque,

              // Single tap → (What)
              onTap: () {
                // Navigator.of(context).push(
                //   MaterialPageRoute(
                //     builder: (_) => PostViewPage(postId: post.id),
                //   ),
                // );
              },

              //  Double tap → like post
              onDoubleTap: () {
                // TODO: trigger like action
                // Example:
                // ref.read(postLikeViewModelProvider(post.id).notifier).toggleLike();
                
                // Style more
                HapticFeedback.lightImpact();
              },

              // Long press → future action
              onLongPress: () {
                // TODO: open bottom sheet / post actions
                // Not implemented yet
                // show the salon
              },

              child: PostImages(
                imageUrls: post.images.map((e) => e.url).toList(),
                aspectRatio: post.images.first.aspectRatio,
              ),
            ),
          ),


        // ---------------- Stats ----------------
        SliverToBoxAdapter(
          child: PostStatsRow(
            likes: post.stats.likes,
            comments: post.stats.comments,
            shares: post.stats.shares,
            isLiked: post.viewerState.isLiked,
            isSaved: post.viewerState.isSaved,
          ),
        ),

        // ---------------- Description ----------------
        if (post.description.isNotEmpty)
          SliverToBoxAdapter(
            child: PostDescription(
              text: post.description,
              createdAt: post.createdAt,
            ),
          ),

        // ---------------- Booking ----------------
        if (data.booking.canBook)
          SliverToBoxAdapter(
            child: BookingNowGlowButton(
              onPressed: () {},
            ),
          ),

        // ---------------- Service ----------------
        SliverToBoxAdapter(
          child: LuxuryServiceDetails(
            serviceName: data.service.name,
            price:
                '${data.service.price.min} - ${data.service.price.max} ${data.service.price.currency}',
            duration: '${data.service.durationMinutes} min',
            benefits: data.service.benefits,
            products:
                data.service.products.map((e) => e.name).toList(),
          ),
        ),

        // ---------------- Stylists ----------------
        if (data.stylists.isNotEmpty)
          SliverToBoxAdapter(
            child: PostStylistSection(
              stylists: data.stylists
                  .map(
                    (s) => StylistPreview(
                      id: s.id,
                      name: s.name,
                      avatarUrl: s.avatar.toString(),
                      role: s.title,
                    ),
                  )
                  .toList(),
              onView: () {},
            ),
          ),

        // ---------------- Reviews ----------------
        SliverToBoxAdapter(
          child: ServiceReviewsSection(
            reviews: data.reviews.items
                .map(
                  (r) => ServiceReview(
                    id: r.id,
                    avatarUrl: r.userAvatar.toString(),
                    rating: r.rating.toDouble(),
                    text: r.comment,
                  ),
                )
                .toList(),
          ),
        ),

        // ---------------- Similar ----------------
        if (data.similar.byService.isNotEmpty ||
            data.similar.byStylist.isNotEmpty ||
            data.similar.bySalon.isNotEmpty)
          SliverToBoxAdapter(
            child: SimilarResultsSection(
              items: [
                ...data.similar.byService.map(
                  (e) => SimilarResultItem(
                    id: e.id,
                    imageUrl: e.coverImage,
                    label: 'Similar service',
                    onTap: () {},
                  ),
                ),
                ...data.similar.byStylist.map(
                  (e) => SimilarResultItem(
                    id: e.id,
                    imageUrl: e.coverImage,
                    label: 'Same stylist',
                    onTap: () {},
                  ),
                ),
                ...data.similar.bySalon.map(
                  (e) => SimilarResultItem(
                    id: e.id,
                    imageUrl: e.coverImage,
                    label: 'Same salon',
                    onTap: () {},
                  ),
                ),
              ],
            ),
          ),

        // ---------------- Sponsored ----------------
        if (data.sponsoredSalons.isNotEmpty)
          SliverToBoxAdapter(
            child: SponsoredSalonsSection(
              salons: data.sponsoredSalons
                  .map(
                    (s) => SponsoredSalon(
                      id: s.salonId,
                      name: s.name,
                      imageUrl: "", // model has no image
                      location: s.location ?? '',
                      price: '${s.price} ${s.currency}',
                      rating: s.rating,
                      onTap: () {},
                    ),
                  )
                  .toList(),
            ),
          ),

        // ---------------- Other Posts ----------------
        if (data.otherPosts.items.isNotEmpty)
          SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, index) {
                final p = data.otherPosts.items[index];

                return GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  // Single tap → open post
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) => PostViewPage(postId: p.id),
                      ),
                    );
                  },

                  //  Double tap → like post
                  onDoubleTap: () {
                    // TODO: trigger like action
                    // Example:
                    // ref.read(postLikeViewModelProvider(post.id).notifier).toggleLike();
                    
                    // Style more
                    HapticFeedback.lightImpact();
                  },

                  // Long press → future action
                  onLongPress: () {
                    // TODO: open bottom sheet / post actions
                    // Not implemented yet
                  },

                  child: Post(
                    postId: p.id,
                    isLiked: p.viewerState.isLiked,
                    images: p.images.map((e) => e.url).toList(),
                    aspectRatio: p.images.first.aspectRatio,
                    username: p.author.username,
                    profileImage: p.author.displayPicture.toString(),
                    likesCount: p.stats.likes,
                    sharesCount: p.stats.shares,
                    commentsCount: p.stats.comments,
                    description: p.description,
                    datePosted: p.createdAt.toIso8601String(),
                  ),
                );
              },
              childCount: data.otherPosts.items.length,
            ),
          ),

        const SliverToBoxAdapter(
          child: SizedBox(height: 32),
        ),
      ],
    );
  }
}
