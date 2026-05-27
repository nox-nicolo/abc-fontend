import 'package:africa_beuty/feature/home/model/post_like.dart';
import 'package:africa_beuty/feature/post/providers/post_repository_provider.dart';
import 'package:africa_beuty/feature/post/view/widgets/comments_sheet.dart';
import 'package:africa_beuty/feature/post/view/widgets/post_share_sheet.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:africa_beuty/feature/home/view_model/post_like.dart';

class Post extends ConsumerStatefulWidget {
  const Post({
    super.key,
    required this.postId,
    required this.aspectRatio,
    required this.username,
    required this.profileImage,
    required this.images,
    required this.likesCount,
    required this.isLiked,
    required this.sharesCount,
    required this.commentsCount,
    required this.description,
    required this.datePosted,
    this.isSaved = false,
  });

  final String postId;
  final double aspectRatio;
  final String username;
  final String profileImage;
  final List<String> images;
  final int likesCount;
  final bool isLiked;
  final int sharesCount;
  final int commentsCount;
  final String description;
  final String datePosted;
  final bool isSaved;

  @override
  ConsumerState<Post> createState() => _PostState();
}

class _PostState extends ConsumerState<Post> {
  bool isExpanded = false;
  late bool _isLiked;
  late int _likesCount;
  late int _sharesCount;
  late bool _isSaved;
  bool _likeInFlight = false;

  final PageController _pageController = PageController();
  int _currentPage = 0; // Track the active image index

  late final ProviderSubscription _likeSub;

  @override
  void initState() {
    super.initState();

    _isLiked = widget.isLiked;
    _likesCount = widget.likesCount;
    _sharesCount = widget.sharesCount;
    _isSaved = widget.isSaved;

    _likeSub = ref.listenManual(postLikeViewModelProvider, (previous, next) {
      if (next is AsyncData<PostLikeModel>) {
        final data = next.value;

        if (data.postId == widget.postId && mounted) {
          setState(() {
            _isLiked = data.liked;
            _likesCount = data.likesCount;
          });
        }
      }
    });
  }

  // Impotant for cleanup
  @override
  void dispose() {
    _likeSub.close();
    _pageController.dispose();
    super.dispose();
  }

  Future<void> _toggleSave() async {
    setState(() => _isSaved = !_isSaved);
    final res = await ref
        .read(postRemoteRepoProviderProvider)
        .toggleBookmark(widget.postId);
    if (!mounted) return;
    res.fold(
      (_) => setState(() => _isSaved = !_isSaved),
      (saved) => setState(() => _isSaved = saved),
    );
  }

  Future<void> _toggleLike() async {
    if (_likeInFlight) return;

    final previousLiked = _isLiked;
    final previousCount = _likesCount;

    setState(() {
      _likeInFlight = true;
      _isLiked = !_isLiked;
      _likesCount += _isLiked ? 1 : -1;
      if (_likesCount < 0) _likesCount = 0;
    });

    await ref
        .read(postLikeViewModelProvider.notifier)
        .toggleLike(postId: widget.postId);

    final result = ref.read(postLikeViewModelProvider);
    if (!mounted) return;

    result?.whenOrNull(
      error: (_, _) {
        setState(() {
          _isLiked = previousLiked;
          _likesCount = previousCount;
          _likeInFlight = false;
        });
      },
      data: (m) {
        if (m.postId != widget.postId) {
          setState(() => _likeInFlight = false);
          return;
        }

        setState(() {
          _isLiked = m.liked;
          _likesCount = m.likesCount;
          _likeInFlight = false;
        });
      },
    );
  }

  Future<void> _sharePost() async {
    final sharedCount = await showPostShareSheet(context, ref, widget.postId);
    if (!mounted || sharedCount == null || sharedCount <= 0) return;
    setState(() => _sharesCount += sharedCount);
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 0, vertical: 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // --------------------------------------------------
          // POST IMAGES
          // --------------------------------------------------
          if (widget.images.isNotEmpty)
            Stack(
              alignment: Alignment.bottomCenter,
              children: [
                AspectRatio(
                  aspectRatio: widget.aspectRatio,
                  child: ClipRRect(
                    borderRadius: const BorderRadius.vertical(
                      top: Radius.circular(12),
                      bottom: Radius.circular(12),
                    ),
                    child: PageView.builder(
                      controller: _pageController,
                      onPageChanged: (int page) {
                        setState(() {
                          _currentPage = page;
                        });
                      },
                      itemCount: widget.images.length,
                      itemBuilder: (context, index) {
                        return CachedNetworkImage(
                          imageUrl: widget.images[index],
                          fit: BoxFit.cover,
                          memCacheWidth: 1080,
                          fadeOutDuration: const Duration(milliseconds: 300),
                          filterQuality: FilterQuality.low,
                          placeholder: (context, url) => Container(
                            color: Theme.of(
                              context,
                            ).colorScheme.surfaceContainerHighest,
                          ),
                          errorWidget: (context, url, error) =>
                              const Icon(Icons.error),
                        );
                      },
                    ),
                  ),
                ),
                if (widget.images.length > 1)
                  Positioned(
                    bottom: 10,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(widget.images.length, (index) {
                        bool isActive = _currentPage == index;
                        return AnimatedContainer(
                          duration: const Duration(
                            milliseconds: 300,
                          ), // Smoothly transition
                          margin: const EdgeInsets.symmetric(horizontal: 3),
                          width: isActive ? 12 : 6, // Active dot is wider
                          height: 6,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(3),
                            // Active dot is solid white, others are faded
                            color: isActive
                                ? Colors.white
                                : Colors.white.withValues(alpha: 0.5),
                          ),
                        );
                      }),
                    ),
                  ),
              ],
            ),
          // --------------------------------------------------
          // USER INFO
          // --------------------------------------------------
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 16,
                  backgroundColor: Theme.of(
                    context,
                  ).colorScheme.surfaceContainerHighest,
                  child: ClipOval(
                    child: widget.profileImage.isNotEmpty
                        ? Image.network(
                            widget.profileImage,
                            width: 32,
                            height: 32,
                            fit: BoxFit.cover,
                          )
                        : const Icon(Icons.person, size: 16),
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
                          widget.username,
                          style: Theme.of(context).textTheme.labelMedium,
                        ),
                        const SizedBox(width: 5),
                        Icon(
                          OctIcons.verified,
                          size: 12,
                          color: colorScheme.primary,
                        ),
                      ],
                    ),
                    // const SizedBox(height: 5,),
                    // Text(
                    //   widget.username,
                    //   style: Theme.of(context).textTheme.labelSmall,
                    // ),
                  ],
                ),
              ],
            ),
          ),

          // --------------------------------------------------
          // POST METRICS (LIKE FIXED)
          // --------------------------------------------------
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: 4,
                  horizontal: 16,
                ),
                child: Row(
                  children: [
                    Row(
                      children: [
                        IconButton(
                          onPressed: _toggleLike,
                          icon: Icon(
                            _isLiked ? Icons.favorite : Icons.favorite_border,
                            color: _isLiked
                                ? colorScheme.error
                                : colorScheme.primary,
                            size: 26,
                          ),
                        ),
                        Text(
                          _likesCount.toString(),
                          style: Theme.of(context).textTheme.labelLarge,
                        ),
                      ],
                    ),

                    const SizedBox(width: 24),

                    GestureDetector(
                      onTap: _sharePost,
                      behavior: HitTestBehavior.opaque,
                      child: Row(
                        children: [
                          Icon(
                            FontAwesome.paper_plane_solid,
                            color: colorScheme.primary,
                            size: 24,
                          ),
                          const SizedBox(width: 12),
                          Text(
                            _sharesCount.toString(),
                            style: Theme.of(context).textTheme.labelLarge,
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(width: 24),

                    GestureDetector(
                      onTap: () => showCommentsSheet(context, widget.postId),
                      behavior: HitTestBehavior.opaque,
                      child: Row(
                        children: [
                          Icon(
                            FontAwesome.comment,
                            size: 24,
                            color: colorScheme.primary,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            widget.commentsCount.toString(),
                            style: Theme.of(context).textTheme.labelLarge,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              IconButton(
                onPressed: _toggleSave,
                icon: Icon(
                  _isSaved
                      ? Icons.bookmark_rounded
                      : Icons.bookmark_border_rounded,
                  size: 32,
                  color: colorScheme.primary,
                ),
              ),
            ],
          ),

          // --------------------------------------------------
          // DESCRIPTION
          // --------------------------------------------------
          SizedBox(
            width: size.width * .95,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.description,
                  maxLines: isExpanded ? 100 : null,
                  overflow: TextOverflow.ellipsis,
                ),
                if (widget.description.length > 100)
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        isExpanded = !isExpanded;
                      });
                    },
                    child: Padding(
                      padding: const EdgeInsets.only(top: 4),
                      child: Text(
                        isExpanded ? 'Show Less' : 'Read More',
                        style: TextStyle(
                          fontSize: 10,
                          color: Theme.of(
                            context,
                          ).colorScheme.onPrimaryFixedVariant,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),

          // --------------------------------------------------
          // DATE
          // --------------------------------------------------
          Padding(
            padding: const EdgeInsets.only(left: 8, top: 4),
            child: Text(
              widget.datePosted,
              style: Theme.of(
                context,
              ).textTheme.labelSmall?.copyWith(fontWeight: FontWeight.bold),
            ),
          ),

          const SizedBox(height: 30),
        ],
      ),
    );
  }
}
