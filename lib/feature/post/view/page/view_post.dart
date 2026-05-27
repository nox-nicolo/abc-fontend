import 'package:africa_beuty/core/widgets/skeleton.dart';
import 'package:africa_beuty/feature/ads/provider/ad_provider.dart';
import 'package:africa_beuty/feature/ads/view/sponsored_ad_post.dart';
import 'package:africa_beuty/feature/booking/provider/booking_draft.dart';
import 'package:africa_beuty/feature/booking/view/widgets/start_booking/select_time.dart';
import 'package:africa_beuty/feature/mute/repository/mute_repository.dart';
import 'package:africa_beuty/feature/post/model/single_post_view.dart';
import 'package:africa_beuty/feature/post/providers/post_repository_provider.dart';
import 'package:africa_beuty/feature/post/view/page/single_post.dart';
import 'package:africa_beuty/feature/post/view/widgets/view_post/booking.dart';
import 'package:africa_beuty/feature/post/view/widgets/comments_sheet.dart';
import 'package:africa_beuty/feature/post/view/widgets/view_post/look_alike.dart';
import 'package:africa_beuty/feature/post/view/widgets/view_post/post_description.dart';
import 'package:africa_beuty/feature/post/view/widgets/view_post/post_images.dart';
import 'package:africa_beuty/feature/post/view/widgets/view_post/post_stats.dart';
import 'package:africa_beuty/feature/post/view/widgets/post_share_sheet.dart';
import 'package:africa_beuty/feature/post/view/widgets/view_post/service_datails.dart';
import 'package:africa_beuty/feature/post/view/widgets/view_post/service_review.dart';
import 'package:africa_beuty/feature/post/view/widgets/view_post/sponsored_salon.dart';
import 'package:africa_beuty/feature/post/view/widgets/view_post/stylist.dart';
import 'package:africa_beuty/feature/post/view_model/single_post_view.dart';
import 'package:africa_beuty/feature/profile/view/page/view_profile.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:icons_plus/icons_plus.dart';

class PostViewPage extends ConsumerWidget {
  final String postId;
  final bool openComments;

  const PostViewPage({
    super.key,
    required this.postId,
    this.openComments = false,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(singlePostViewModelProvider(postId));

    return Scaffold(
      appBar: AppBar(
        title: const Text('Post'),
        actions: [
          if (state.asData?.value.engagement.canShare ?? false) ...[
            IconButton(
              tooltip: 'Share',
              onPressed: () => showPostShareSheet(context, ref, postId),
              icon: const Icon(Icons.share_outlined),
            ),
            const SizedBox(width: 4),
          ],
          _PostActionsMenu(
            postId: postId,
            isMyPost: state.asData?.value.post.viewerState.isMyPost ?? false,
            authorId: state.asData?.value.post.author.id,
          ),
          const SizedBox(width: 4),
        ],
      ),
      body: state.when(
        loading: () => const _PostViewSkeleton(),
        error: (e, _) => Center(child: Text(e.toString())),
        data: (data) => _PostViewBody(data: data, openComments: openComments),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────

class _PostViewBody extends ConsumerStatefulWidget {
  final SinglePostViewModel data;
  final bool openComments;

  const _PostViewBody({required this.data, required this.openComments});

  @override
  ConsumerState<_PostViewBody> createState() => _PostViewBodyState();
}

class _PostViewBodyState extends ConsumerState<_PostViewBody> {
  late final ScrollController _scrollCtrl;
  bool _loadingMore = false;
  bool _openedComments = false;
  bool _shownOwnerReactionSummary = false;

  @override
  void initState() {
    super.initState();
    _scrollCtrl = ScrollController()..addListener(_onScroll);
    if (widget.openComments) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted && !_openedComments) {
          _openedComments = true;
          showCommentsSheet(context, widget.data.post.id);
        }
      });
    }
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
    final data =
        ref
            .watch(singlePostViewModelProvider(widget.data.post.id))
            .asData
            ?.value ??
        widget.data;

    final post = data.post;
    final isServicePost = post.postType == 'service';
    final postViewAds = ref.watch(adsByPlacementProvider(adPlacementPostView));

    if (post.viewerState.isMyPost &&
        !_shownOwnerReactionSummary &&
        _reactionTotal(post.reactions) > 0) {
      _shownOwnerReactionSummary = true;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) _showOwnerReactionSummary(context, post.reactions);
      });
    }

    return CustomScrollView(
      controller: _scrollCtrl,
      physics: const BouncingScrollPhysics(),
      slivers: [
        // ─────────── Author header ───────────
        SliverToBoxAdapter(
          child: GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ViewProfilePage(
                    isServiceProfile: true,
                    userId: post.author.id,
                  ),
                ),
              );
            },
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 28,
                    backgroundColor: Theme.of(
                      context,
                    ).colorScheme.surfaceContainerHighest,
                    child: ClipOval(
                      child:
                          post.author.displayPicture != null &&
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
                            style: Theme.of(context).textTheme.labelSmall
                                ?.copyWith(
                                  color: Theme.of(
                                    context,
                                  ).colorScheme.onSurfaceVariant,
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
        ),

        // ─────────── Images ───────────
        if (post.images.isNotEmpty)
          SliverToBoxAdapter(
            child: GestureDetector(
              behavior: HitTestBehavior.opaque,
              onDoubleTap: () => HapticFeedback.lightImpact(),
              onLongPress: () {},
              child: AspectRatio(
                aspectRatio: post.images.first.aspectRatio,
                child: PostImages(
                  imageUrls: post.images.map((e) => e.url).toList(),
                  aspectRatio: post.images.first.aspectRatio,
                ),
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

        if (data.engagement.canReact)
          SliverToBoxAdapter(
            child: _PostReactionsBar(
              postId: post.id,
              myReaction:
                  data.engagement.myReaction ?? post.viewerState.reaction,
              reactions: post.reactions,
              isMyPost: post.viewerState.isMyPost,
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

        SliverToBoxAdapter(
          child: postViewAds.maybeWhen(
            data: (items) => items.isEmpty
                ? const SizedBox.shrink()
                : SponsoredAdPost(ad: items.first),
            orElse: () => const SizedBox.shrink(),
          ),
        ),

        // ─────────── Book Now (FIX 4: navigate to booking flow) ───────────
        if (isServicePost && data.booking.canBook && data.service.id.isNotEmpty)
          SliverToBoxAdapter(
            child: BookingNowGlowButton(
              onPressed: () => _startPostBooking(context, post, data.service),
            ),
          ),

        // ─────────── Service details (FIX 5: guard name) ───────────
        if (isServicePost && data.service.name.isNotEmpty)
          SliverToBoxAdapter(
            child: LuxuryServiceDetails(
              serviceName: data.service.name,
              price:
                  '${data.service.price.min} - ${data.service.price.max} ${data.service.price.currency}',
              duration: '${data.service.durationMinutes} min',
              benefits: data.service.benefits,
              products: data.service.products.map((e) => e.name).toList(),
            ),
          ),

        // ─────────── Stylists (FIX 6: nullable avatar) ───────────
        if (isServicePost && data.stylists.isNotEmpty)
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
            ),
          ),

        // ─────────── Reviews ───────────
        if (isServicePost)
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

        // ─────────── Similar ───────────
        if (isServicePost && data.similar.items.isNotEmpty)
          SliverToBoxAdapter(
            child: SimilarResultsSection(
              items: data.similar.items
                  .map(
                    (e) => SimilarResultItem(
                      id: e.id,
                      imageUrl: e.coverImage,
                      label: e.salonName,
                      onTap: () => Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) => PostViewPage(postId: e.id),
                        ),
                      ),
                    ),
                  )
                  .toList(),
            ),
          ),

        // ─────────── Sponsored ───────────
        if (isServicePost && data.sponsoredSalons.isNotEmpty)
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

        // ─────────── Other posts continuation ───────────
        if (data.otherPosts.items.isNotEmpty)
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 24, 16, 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'More for you',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    'From salons you follow and salons near you',
                    style: Theme.of(context).textTheme.labelSmall?.copyWith(
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),
          ),
        if (data.otherPosts.items.isNotEmpty)
          SliverList(
            delegate: SliverChildBuilderDelegate((context, index) {
              final p = data.otherPosts.items[index];

              return GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: () => Navigator.of(context).push(
                  MaterialPageRoute(builder: (_) => PostViewPage(postId: p.id)),
                ),
                onDoubleTap: () => HapticFeedback.lightImpact(),
                onLongPress: () {},
                child: Post(
                  postId: p.id,
                  isLiked: p.viewerState.isLiked,
                  isSaved: p.viewerState.isSaved,
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
            }, childCount: data.otherPosts.items.length),
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

  int _reactionTotal(Map<String, int> reactions) {
    return reactions.values.fold(0, (sum, count) => sum + count);
  }

  void _startPostBooking(
    BuildContext context,
    PostItemModel post,
    ServiceSectionModel service,
  ) {
    ref.read(bookingDraftProvider.notifier)
      ..reset()
      ..selectSalonOffer(
        salonServicePriceId: service.id,
        salonName: post.author.salonName,
        serviceName: service.bookingName,
        price: service.price.min,
        currency: service.price.currency,
        durationMinutes: service.durationMinutes > 0
            ? service.durationMinutes
            : 60,
      );

    Navigator.of(
      context,
    ).push(MaterialPageRoute(builder: (_) => const PickDateTimePage()));
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Reactions
// ─────────────────────────────────────────────────────────────────────────────

class _ReactionOption {
  final String value;
  final String label;
  final String emoji;
  final IconData icon;

  const _ReactionOption(this.value, this.label, this.emoji, this.icon);
}

const _reactionOptions = [
  _ReactionOption('love', 'Love', '❤️', Icons.favorite_rounded),
  _ReactionOption('wow', 'Wow', '😮', Icons.auto_awesome_rounded),
  _ReactionOption(
    'excited',
    'Excited',
    '😍',
    Icons.sentiment_very_satisfied_rounded,
  ),
  _ReactionOption('fire', 'Fire', '🔥', Icons.local_fire_department_rounded),
  _ReactionOption('beautiful', 'Beautiful', '✨', Icons.spa_rounded),
];

_ReactionOption? _reactionFor(String? value) {
  if (value == null) return null;
  for (final option in _reactionOptions) {
    if (option.value == value) return option;
  }
  return null;
}

int _reactionCountTotal(Map<String, int> reactions) {
  return reactions.values.fold(0, (sum, count) => sum + count);
}

class _PostReactionsBar extends ConsumerStatefulWidget {
  const _PostReactionsBar({
    required this.postId,
    required this.myReaction,
    required this.reactions,
    required this.isMyPost,
  });

  final String postId;
  final String? myReaction;
  final Map<String, int> reactions;
  final bool isMyPost;

  @override
  ConsumerState<_PostReactionsBar> createState() => _PostReactionsBarState();
}

class _PostReactionsBarState extends ConsumerState<_PostReactionsBar> {
  bool _sending = false;

  Future<void> _pickReaction() async {
    final selected = await showModalBottomSheet<String>(
      context: context,
      showDragHandle: true,
      builder: (_) => _ReactionPickerSheet(
        selected: widget.myReaction,
        reactions: widget.reactions,
      ),
    );

    if (selected == null) return;
    await _sendReaction(selected);
  }

  void _openReactionDetails() {
    if (widget.isMyPost) {
      _showOwnerReactionSummary(context, widget.reactions);
      return;
    }

    _pickReaction();
  }

  Future<void> _sendReaction(String reaction) async {
    if (_sending) return;

    HapticFeedback.selectionClick();
    setState(() => _sending = true);

    final result = await ref
        .read(postRemoteRepoProviderProvider)
        .reactToPost(postId: widget.postId, reaction: reaction);

    if (!mounted) return;
    setState(() => _sending = false);

    result.match(
      (failure) => ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(failure.message))),
      (_) => ref.invalidate(singlePostViewModelProvider(widget.postId)),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final selected = _reactionFor(widget.myReaction);
    final total = _reactionCountTotal(widget.reactions);

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 4, 16, 12),
      child: Container(
        padding: const EdgeInsets.fromLTRB(12, 10, 12, 12),
        decoration: BoxDecoration(
          color: scheme.surfaceContainerHighest.withValues(alpha: 0.38),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: scheme.outlineVariant.withValues(alpha: 0.7),
          ),
        ),
        child: Column(
          children: [
            Row(
              children: [
                Icon(
                  selected == null
                      ? Icons.add_reaction_outlined
                      : selected.icon,
                  size: 18,
                  color: selected == null ? scheme.primary : scheme.primary,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    selected == null
                        ? 'React'
                        : 'You reacted ${selected.label}',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: theme.textTheme.labelLarge?.copyWith(
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ),
                if (_sending)
                  SizedBox(
                    width: 18,
                    height: 18,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: scheme.primary,
                    ),
                  )
                else if (total > 0)
                  TextButton(
                    onPressed: _openReactionDetails,
                    style: TextButton.styleFrom(
                      minimumSize: const Size(44, 34),
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    ),
                    child: Text('$total total'),
                  ),
              ],
            ),
            const SizedBox(height: 10),
            SizedBox(
              height: 72,
              child: Row(
                children: _reactionOptions.map((option) {
                  return Expanded(
                    child: _ReactionBubbleButton(
                      option: option,
                      count: widget.reactions[option.value] ?? 0,
                      selected: widget.myReaction == option.value,
                      busy: _sending,
                      onTap: () => _sendReaction(option.value),
                      onLongPress: _pickReaction,
                    ),
                  );
                }).toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ReactionBubbleButton extends StatelessWidget {
  final _ReactionOption option;
  final int count;
  final bool selected;
  final bool busy;
  final VoidCallback onTap;
  final VoidCallback onLongPress;

  const _ReactionBubbleButton({
    required this.option,
    required this.count,
    required this.selected,
    required this.busy,
    required this.onTap,
    required this.onLongPress,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = Theme.of(context).colorScheme;

    return Tooltip(
      message: selected ? 'Tap to remove ${option.label}' : option.label,
      child: InkWell(
        borderRadius: BorderRadius.circular(18),
        onTap: busy ? null : onTap,
        onLongPress: busy ? null : onLongPress,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          margin: const EdgeInsets.symmetric(horizontal: 3),
          padding: const EdgeInsets.symmetric(vertical: 7),
          decoration: BoxDecoration(
            color: selected
                ? scheme.primaryContainer
                : scheme.surface.withValues(alpha: 0.62),
            borderRadius: BorderRadius.circular(18),
            border: Border.all(
              color: selected ? scheme.primary : Colors.transparent,
            ),
            boxShadow: selected
                ? [
                    BoxShadow(
                      color: scheme.primary.withValues(alpha: 0.18),
                      blurRadius: 12,
                      offset: const Offset(0, 5),
                    ),
                  ]
                : null,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              AnimatedScale(
                scale: selected ? 1.18 : 1,
                duration: const Duration(milliseconds: 180),
                curve: Curves.easeOutBack,
                child: Text(option.emoji, style: const TextStyle(fontSize: 25)),
              ),
              const SizedBox(height: 4),
              Text(
                count > 0 ? '$count' : option.label,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: theme.textTheme.labelSmall?.copyWith(
                  color: selected
                      ? scheme.onPrimaryContainer
                      : scheme.onSurfaceVariant,
                  fontWeight: selected ? FontWeight.w900 : FontWeight.w700,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ReactionPickerSheet extends StatelessWidget {
  final String? selected;
  final Map<String, int> reactions;

  const _ReactionPickerSheet({required this.selected, required this.reactions});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(18, 4, 18, 22),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'React to this post',
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w900,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              selected == null
                  ? 'Pick the feeling that fits.'
                  : 'Tap the same reaction again to remove it.',
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 16),
            GridView.count(
              crossAxisCount: 5,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              mainAxisSpacing: 10,
              crossAxisSpacing: 8,
              children: _reactionOptions.map((option) {
                final isSelected = selected == option.value;
                return _ReactionPickerItem(
                  option: option,
                  count: reactions[option.value] ?? 0,
                  selected: isSelected,
                  onTap: () => Navigator.of(context).pop(option.value),
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }
}

class _ReactionPickerItem extends StatelessWidget {
  final _ReactionOption option;
  final int count;
  final bool selected;
  final VoidCallback onTap;

  const _ReactionPickerItem({
    required this.option,
    required this.count,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return InkWell(
      borderRadius: BorderRadius.circular(18),
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 160),
        padding: const EdgeInsets.symmetric(vertical: 8),
        decoration: BoxDecoration(
          color: selected
              ? scheme.primaryContainer
              : scheme.surfaceContainerHighest.withValues(alpha: 0.45),
          borderRadius: BorderRadius.circular(18),
          border: Border.all(
            color: selected ? scheme.primary : Colors.transparent,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(option.emoji, style: const TextStyle(fontSize: 28)),
            const SizedBox(height: 5),
            Text(
              option.label,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: Theme.of(
                context,
              ).textTheme.labelSmall?.copyWith(fontWeight: FontWeight.w800),
            ),
            if (count > 0)
              Text(
                '$count',
                style: Theme.of(context).textTheme.labelSmall?.copyWith(
                  color: scheme.onSurfaceVariant,
                ),
              ),
          ],
        ),
      ),
    );
  }
}

void _showOwnerReactionSummary(
  BuildContext context,
  Map<String, int> reactions,
) {
  final total = _reactionCountTotal(reactions);
  if (total <= 0) return;

  showModalBottomSheet<void>(
    context: context,
    showDragHandle: true,
    builder: (_) => SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(18, 4, 18, 22),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '$total reaction${total == 1 ? '' : 's'} on this post',
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w900),
            ),
            const SizedBox(height: 4),
            Text(
              'Here is how people are responding right now.',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 16),
            ..._reactionOptions
                .where((option) => (reactions[option.value] ?? 0) > 0)
                .map(
                  (option) => Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: Row(
                      children: [
                        Text(
                          option.emoji,
                          style: const TextStyle(fontSize: 28),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            option.label,
                            style: Theme.of(context).textTheme.bodyLarge,
                          ),
                        ),
                        Text(
                          '${reactions[option.value] ?? 0}',
                          style: Theme.of(context).textTheme.titleMedium
                              ?.copyWith(fontWeight: FontWeight.w900),
                        ),
                      ],
                    ),
                  ),
                ),
          ],
        ),
      ),
    ),
  );
}

// ─────────────────────────────────────────────────────────────────────────────
// AppBar actions: shows delete option when the viewer owns the post
// ─────────────────────────────────────────────────────────────────────────────

class _PostActionsMenu extends ConsumerStatefulWidget {
  final String postId;
  final bool isMyPost;
  final String? authorId;

  const _PostActionsMenu({
    required this.postId,
    required this.isMyPost,
    required this.authorId,
  });

  @override
  ConsumerState<_PostActionsMenu> createState() => _PostActionsMenuState();
}

class _PostActionsMenuState extends ConsumerState<_PostActionsMenu> {
  Future<void> _mute(String targetType, String targetId, String label) async {
    final result = await MuteRepository().mute(
      targetType: targetType,
      targetId: targetId,
    );
    if (!mounted) return;
    result.match(
      (failure) => ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(failure.message))),
      (_) => ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('$label muted'))),
    );
  }

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
      (failure) => ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(failure.message))),
      (_) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('Post deleted')));
        Navigator.of(context).pop();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<String>(
      icon: const Icon(Icons.more_vert_outlined),
      onSelected: (action) {
        if (action == 'delete') _deletePost();
        if (action == 'mute_post') _mute('post', widget.postId, 'Post');
        if (action == 'mute_user' &&
            widget.authorId != null &&
            widget.authorId!.isNotEmpty) {
          _mute('user', widget.authorId!, 'User');
        }
      },
      itemBuilder: (_) => [
        if (!widget.isMyPost) ...[
          const PopupMenuItem(
            value: 'mute_post',
            child: ListTile(
              leading: Icon(Icons.visibility_off_outlined),
              title: Text('Mute post'),
              contentPadding: EdgeInsets.zero,
            ),
          ),
          const PopupMenuItem(
            value: 'mute_user',
            child: ListTile(
              leading: Icon(Icons.person_off_outlined),
              title: Text('Mute user'),
              contentPadding: EdgeInsets.zero,
            ),
          ),
        ],
        if (widget.isMyPost)
          PopupMenuItem(
            value: 'delete',
            child: ListTile(
              leading: Icon(
                Icons.delete_outline,
                color: Theme.of(context).colorScheme.error,
              ),
              title: Text(
                'Delete post',
                style: TextStyle(color: Theme.of(context).colorScheme.error),
              ),
              contentPadding: EdgeInsets.zero,
            ),
          ),
      ],
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Skeleton loader shown while the post view is loading
// ─────────────────────────────────────────────────────────────────────────────

class _PostViewSkeleton extends StatelessWidget {
  const _PostViewSkeleton();

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.symmetric(vertical: 12),
      children: const [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            children: [
              Skeleton.circle(size: 56),
              SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SkeletonText(width: 140, height: 14),
                    SizedBox(height: 8),
                    SkeletonText(width: 90, height: 10),
                  ],
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: 16),
        AspectRatio(
          aspectRatio: 1,
          child: SkeletonCard(
            width: double.infinity,
            height: double.infinity,
            radius: 0,
          ),
        ),
        SizedBox(height: 16),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SkeletonText(width: double.infinity),
              SizedBox(height: 8),
              SkeletonText(width: 220),
              SizedBox(height: 8),
              SkeletonText(width: 160),
            ],
          ),
        ),
      ],
    );
  }
}
