import 'package:africa_beuty/feature/booking/view/widgets/start_booking/choose_salon.dart';
import 'package:africa_beuty/feature/post/model/single_post_view.dart';
import 'package:africa_beuty/feature/post/providers/post_repository_provider.dart';
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
        actions: [
          const Icon(Icons.share_outlined),
          const SizedBox(width: 4),
          _PostActionsMenu(
            postId: postId,
            isMyPost: state.asData?.value.post.viewerState.isMyPost ?? false,
          ),
          const SizedBox(width: 4),
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

// ─────────────────────────────────────────────────────────────────────────────

class _PostViewBody extends ConsumerStatefulWidget {
  final SinglePostViewModel data;

  const _PostViewBody({required this.data});

  @override
  ConsumerState<_PostViewBody> createState() => _PostViewBodyState();
}

class _PostViewBodyState extends ConsumerState<_PostViewBody> {
  late final ScrollController _scrollCtrl;
  bool _loadingMore = false;

  @override
  void initState() {
    super.initState();
    _scrollCtrl = ScrollController()..addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollCtrl.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_loadingMore) return;
    final pos = _scrollCtrl.position;
    if (pos.pixels >= pos.maxScrollExtent - 300) {
      _loadingMore = true;
      ref
          .read(singlePostViewModelProvider(widget.data.post.id).notifier)
          .loadMoreOtherPosts()
          .whenComplete(() => _loadingMore = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    // Watch so the list rebuilds when more posts are loaded
    final data = ref
            .watch(singlePostViewModelProvider(widget.data.post.id))
            .asData
            ?.value ??
        widget.data;

    final post = data.post;

    return CustomScrollView(
      controller: _scrollCtrl,
      physics: const BouncingScrollPhysics(),
      slivers: [
        // ─────────── Author header ───────────
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 28,
                  backgroundColor: Colors.grey.shade300,
                  child: ClipOval(
                    child: post.author.displayPicture != null &&
                            post.author.displayPicture!.isNotEmpty
                        ? Image.network(
                            post.author.displayPicture!,
                            width: 56,
                            height: 56,
                            fit: BoxFit.cover,
                          )
                        : const Icon(Icons.person, size: 48),
                  ),
                ),
                const SizedBox(width: 10),

                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Salon name + verified badge
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              post.author.salonName,
                              style: Theme.of(context).textTheme.labelLarge,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          const SizedBox(width: 5),
                          Icon(
                            OctIcons.verified,
                            size: 12,
                            color: Colors.blue.shade500,
                          ),
                        ],
                      ),
                      const SizedBox(height: 2),
                      // Username
                      Text(
                        post.author.username,
                        style: Theme.of(context).textTheme.labelSmall,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      // FIX 1: location line
                      if (post.author.location != null) ...[
                        const SizedBox(height: 2),
                        Text(
                          _locationLabel(post.author.location!),
                          style: Theme.of(context)
                              .textTheme
                              .labelSmall
                              ?.copyWith(
                                color: Theme.of(context)
                                    .colorScheme
                                    .onSurfaceVariant,
                              ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),

        // ─────────── Images ───────────
        if (post.images.isNotEmpty)
          SliverToBoxAdapter(
            child: GestureDetector(
              behavior: HitTestBehavior.opaque,
              onDoubleTap: () => HapticFeedback.lightImpact(),
              onLongPress: () {},
              child: PostImages(
                imageUrls: post.images.map((e) => e.url).toList(),
                aspectRatio: post.images.first.aspectRatio,
              ),
            ),
          ),

        // ─────────── Stats (FIX 2 & 3: postId + no counts) ───────────
        SliverToBoxAdapter(
          child: PostStatsRow(
            postId: post.id,
            likes: post.stats.likes,
            comments: post.stats.comments,
            shares: post.stats.shares,
            isLiked: post.viewerState.isLiked,
            isSaved: post.viewerState.isSaved,
          ),
        ),

        // ─────────── Description ───────────
        if (post.description.isNotEmpty)
          SliverToBoxAdapter(
            child: PostDescription(
              text: post.description,
              createdAt: post.createdAt,
            ),
          ),

        // ─────────── Book Now (FIX 4: navigate to booking flow) ───────────
        if (data.booking.canBook && data.service.id.isNotEmpty)
          SliverToBoxAdapter(
            child: BookingNowGlowButton(
              onPressed: () => Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) =>
                      ChooseSalonPage(subServiceId: data.service.id),
                ),
              ),
            ),
          ),

        // ─────────── Service details (FIX 5: guard name) ───────────
        if (data.service.name.isNotEmpty)
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

        // ─────────── Stylists (FIX 6: nullable avatar) ───────────
        if (data.stylists.isNotEmpty)
          SliverToBoxAdapter(
            child: PostStylistSection(
              stylists: data.stylists
                  .map(
                    (s) => StylistPreview(
                      id: s.id,
                      name: s.name,
                      avatarUrl: s.avatar ?? '',
                      role: s.title,
                    ),
                  )
                  .toList(),
              onView: () {},
            ),
          ),

        // ─────────── Reviews ───────────
        SliverToBoxAdapter(
          child: ServiceReviewsSection(
            reviews: data.reviews.items
                .map(
                  (r) => ServiceReview(
                    id: r.id,
                    avatarUrl: r.userAvatar ?? '',
                    rating: r.rating.toDouble(),
                    text: r.comment,
                  ),
                )
                .toList(),
          ),
        ),

        // ─────────── Similar (FIX 7: wire onTap) ───────────
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
                    onTap: () => Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) => PostViewPage(postId: e.id),
                      ),
                    ),
                  ),
                ),
                ...data.similar.byStylist.map(
                  (e) => SimilarResultItem(
                    id: e.id,
                    imageUrl: e.coverImage,
                    label: 'Same stylist',
                    onTap: () => Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) => PostViewPage(postId: e.id),
                      ),
                    ),
                  ),
                ),
                ...data.similar.bySalon.map(
                  (e) => SimilarResultItem(
                    id: e.id,
                    imageUrl: e.coverImage,
                    label: 'Same salon',
                    onTap: () => Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) => PostViewPage(postId: e.id),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),

        // ─────────── Sponsored ───────────
        if (data.sponsoredSalons.isNotEmpty)
          SliverToBoxAdapter(
            child: SponsoredSalonsSection(
              salons: data.sponsoredSalons
                  .map(
                    (s) => SponsoredSalon(
                      id: s.salonId,
                      name: s.name,
                      imageUrl: '',
                      location: s.location ?? '',
                      price: '${s.price} ${s.currency}',
                      rating: s.rating,
                      onTap: () {},
                    ),
                  )
                  .toList(),
            ),
          ),

        // ─────────── Other posts (FIX 8: infinite scroll via _onScroll) ───────────
        if (data.otherPosts.items.isNotEmpty)
          SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, index) {
                final p = data.otherPosts.items[index];

                return GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTap: () => Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => PostViewPage(postId: p.id),
                    ),
                  ),
                  onDoubleTap: () => HapticFeedback.lightImpact(),
                  onLongPress: () {},
                  child: Post(
                    postId: p.id,
                    isLiked: p.viewerState.isLiked,
                    images: p.images.map((e) => e.url).toList(),
                    aspectRatio: p.images.isNotEmpty
                        ? p.images.first.aspectRatio
                        : 1.0,
                    username: p.author.username,
                    profileImage: p.author.displayPicture ?? '',
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

        // Loading indicator at bottom while fetching more
        if (_loadingMore)
          const SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.all(16),
              child: Center(child: CircularProgressIndicator()),
            ),
          ),

        const SliverToBoxAdapter(child: SizedBox(height: 32)),
      ],
    );
  }

  String _locationLabel(AuthorLocationModel loc) {
    final parts = [loc.city, loc.country].where((s) => s.isNotEmpty).toList();
    return parts.join(', ');
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// AppBar actions: shows delete option when the viewer owns the post
// ─────────────────────────────────────────────────────────────────────────────

class _PostActionsMenu extends ConsumerStatefulWidget {
  final String postId;
  final bool isMyPost;

  const _PostActionsMenu({required this.postId, required this.isMyPost});

  @override
  ConsumerState<_PostActionsMenu> createState() => _PostActionsMenuState();
}

class _PostActionsMenuState extends ConsumerState<_PostActionsMenu> {
  Future<void> _deletePost() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Delete post'),
        content: const Text('This will permanently remove the post. Continue?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          FilledButton(
            style: FilledButton.styleFrom(
              backgroundColor: Theme.of(context).colorScheme.error,
            ),
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
    if (confirmed != true || !mounted) return;

    final result = await ref
        .read(postRemoteRepoProviderProvider)
        .deletePost(widget.postId);

    if (!mounted) return;

    result.fold(
      (failure) => ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(failure.message)),
      ),
      (_) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Post deleted')),
        );
        Navigator.of(context).pop();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    if (!widget.isMyPost) {
      return const Icon(Icons.more_vert_outlined);
    }

    return PopupMenuButton<String>(
      icon: const Icon(Icons.more_vert_outlined),
      onSelected: (action) {
        if (action == 'delete') _deletePost();
      },
      itemBuilder: (_) => [
        PopupMenuItem(
          value: 'delete',
          child: ListTile(
            leading: Icon(Icons.delete_outline,
                color: Theme.of(context).colorScheme.error),
            title: Text('Delete post',
                style:
                    TextStyle(color: Theme.of(context).colorScheme.error)),
            contentPadding: EdgeInsets.zero,
          ),
        ),
      ],
    );
  }
}
