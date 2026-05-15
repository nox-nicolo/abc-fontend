import 'package:africa_beuty/core/widgets/skeleton.dart';
import 'package:africa_beuty/feature/booking/view/widgets/start_booking/choose_salon.dart';
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
import 'package:africa_beuty/feature/post/view/widgets/view_post/service_datails.dart';
import 'package:africa_beuty/feature/post/view/widgets/view_post/service_review.dart';
import 'package:africa_beuty/feature/post/view/widgets/view_post/sponsored_salon.dart';
import 'package:africa_beuty/feature/post/view/widgets/view_post/stylist.dart';
import 'package:africa_beuty/feature/post/view_model/single_post_view.dart';
import 'package:africa_beuty/feature/profile/view/page/view_profile.dart';
import 'package:africa_beuty/feature/search/model/search.dart';
import 'package:africa_beuty/feature/search/repository/search.dart';
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
        if (isServicePost && data.booking.canBook && data.service.id.isNotEmpty)
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
              onView: () {},
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
}

// ─────────────────────────────────────────────────────────────────────────────
// Reactions
// ─────────────────────────────────────────────────────────────────────────────

class _PostReactionsBar extends ConsumerWidget {
  const _PostReactionsBar({
    required this.postId,
    required this.myReaction,
    required this.reactions,
  });

  final String postId;
  final String? myReaction;
  final Map<String, int> reactions;

  static const _items = [
    ('love', 'Love', Icons.favorite_rounded),
    ('wow', 'Wow', Icons.auto_awesome_rounded),
    ('excited', 'Excited', Icons.sentiment_very_satisfied_rounded),
    ('fire', 'Fire', Icons.local_fire_department_rounded),
    ('beautiful', 'Beautiful', Icons.spa_rounded),
  ];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 2, 16, 10),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: _items.map((item) {
            final selected = myReaction == item.$1;
            final count = reactions[item.$1] ?? 0;
            return Padding(
              padding: const EdgeInsets.only(right: 8),
              child: Tooltip(
                message: item.$2,
                child: InkWell(
                  borderRadius: BorderRadius.circular(20),
                  onTap: () async {
                    final result = await ref
                        .read(postRemoteRepoProviderProvider)
                        .reactToPost(postId: postId, reaction: item.$1);
                    if (!context.mounted) return;
                    result.match(
                      (failure) => ScaffoldMessenger.of(
                        context,
                      ).showSnackBar(SnackBar(content: Text(failure.message))),
                      (_) =>
                          ref.invalidate(singlePostViewModelProvider(postId)),
                    );
                  },
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 160),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      color: selected
                          ? theme.colorScheme.primaryContainer
                          : theme.colorScheme.surfaceContainerHighest
                                .withValues(alpha: 0.55),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: selected
                            ? theme.colorScheme.primary
                            : Colors.transparent,
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          item.$3,
                          size: 18,
                          color: selected
                              ? theme.colorScheme.primary
                              : theme.colorScheme.onSurfaceVariant,
                        ),
                        if (count > 0) ...[
                          const SizedBox(width: 5),
                          Text(
                            '$count',
                            style: theme.textTheme.labelMedium?.copyWith(
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}

Future<void> showPostShareSheet(
  BuildContext context,
  WidgetRef ref,
  String postId,
) {
  return showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    useSafeArea: true,
    builder: (_) => _PostShareSheet(parentRef: ref, postId: postId),
  );
}

class _PostShareSheet extends StatefulWidget {
  const _PostShareSheet({required this.parentRef, required this.postId});

  final WidgetRef parentRef;
  final String postId;

  @override
  State<_PostShareSheet> createState() => _PostShareSheetState();
}

class _PostShareSheetState extends State<_PostShareSheet> {
  final _search = TextEditingController();
  final _message = TextEditingController();
  final _repo = SearchRepositoryImpl();
  List<SearchUserResult> _users = const [];
  final Set<String> _selected = {};
  bool _loading = false;
  bool _sending = false;

  @override
  void dispose() {
    _search.dispose();
    _message.dispose();
    super.dispose();
  }

  Future<void> _runSearch(String value) async {
    final query = value.trim();
    if (query.isEmpty) {
      setState(() => _users = const []);
      return;
    }
    setState(() => _loading = true);
    final result = await _repo.search(query: query, limit: 12);
    if (!mounted) return;
    result.match(
      (_) => setState(() {
        _loading = false;
        _users = const [];
      }),
      (items) => setState(() {
        _loading = false;
        _users = items.whereType<SearchUserResult>().toList();
      }),
    );
  }

  Future<void> _share() async {
    if (_selected.isEmpty || _sending) return;
    setState(() => _sending = true);
    final result = await widget.parentRef
        .read(postRemoteRepoProviderProvider)
        .sharePost(
          postId: widget.postId,
          userIds: _selected.toList(),
          message: _message.text,
        );
    if (!mounted) return;
    setState(() => _sending = false);
    result.match(
      (failure) => ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(failure.message))),
      (count) {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(count == 0 ? 'Already shared' : 'Post shared'),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return FractionallySizedBox(
      heightFactor: 0.82,
      child: Padding(
        padding: EdgeInsets.fromLTRB(
          16,
          16,
          16,
          MediaQuery.of(context).viewInsets.bottom + 16,
        ),
        child: Column(
          children: [
            Row(
              children: [
                Text(
                  'Share post',
                  style: theme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const Spacer(),
                IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(Icons.close_rounded),
                ),
              ],
            ),
            TextField(
              controller: _search,
              onChanged: _runSearch,
              decoration: const InputDecoration(
                prefixIcon: Icon(Icons.search),
                hintText: 'Search friends or users',
              ),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _message,
              maxLines: 2,
              decoration: const InputDecoration(hintText: 'Add a message...'),
            ),
            const SizedBox(height: 10),
            Expanded(
              child: _loading
                  ? const Center(child: CircularProgressIndicator())
                  : ListView.builder(
                      itemCount: _users.length,
                      itemBuilder: (_, index) {
                        final user = _users[index];
                        final selected = _selected.contains(user.id);
                        return CheckboxListTile(
                          value: selected,
                          onChanged: (value) {
                            setState(() {
                              if (value == true) {
                                _selected.add(user.id);
                              } else {
                                _selected.remove(user.id);
                              }
                            });
                          },
                          secondary: CircleAvatar(
                            backgroundImage:
                                user.avatarUrl != null &&
                                    user.avatarUrl!.isNotEmpty
                                ? NetworkImage(user.avatarUrl!)
                                : null,
                            child:
                                user.avatarUrl == null ||
                                    user.avatarUrl!.isEmpty
                                ? const Icon(Icons.person)
                                : null,
                          ),
                          title: Text(user.fullName ?? user.username),
                          subtitle: Text('@${user.username}'),
                        );
                      },
                    ),
            ),
            SizedBox(
              width: double.infinity,
              child: FilledButton.icon(
                onPressed: _selected.isEmpty || _sending ? null : _share,
                icon: _sending
                    ? const SizedBox(
                        width: 18,
                        height: 18,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Icon(Icons.send_rounded),
                label: Text(
                  _selected.isEmpty
                      ? 'Select people'
                      : 'Send to ${_selected.length}',
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
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
