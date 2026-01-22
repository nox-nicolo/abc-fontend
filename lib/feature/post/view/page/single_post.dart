import 'package:africa_beuty/feature/home/model/post_like.dart';
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

  @override
  ConsumerState<Post> createState() => _PostState();
}

class _PostState extends ConsumerState<Post> {
  bool isExpanded = false;
  late bool _isLiked;
  late int _likesCount;

  late final ProviderSubscription _likeSub;

  @override
  void initState() {
    super.initState();

    _isLiked = widget.isLiked;
    _likesCount = widget.likesCount;

    _likeSub = ref.listenManual(
      postLikeViewModelProvider,
      (previous, next) {
        if (next is AsyncData<PostLikeModel>) {
          final data = next.value;

          if (data.postId == widget.postId && mounted) {
            setState(() {
              _isLiked = data.liked;
              _likesCount = data.likesCount;
            });
          }
        }
      },
    );
  }

  @override
  void dispose() {
    _likeSub.close(); 
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

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
                      itemCount: widget.images.length,
                      itemBuilder: (context, index) {
                        return CachedNetworkImage(
                          imageUrl: widget.images[index],
                          fit: BoxFit.cover,
                          memCacheWidth: 1080,
                          filterQuality: FilterQuality.low,
                          placeholder: (context, url) => Container(
                            color: Theme.of(context).colorScheme.surfaceVariant,
                          ),
                          errorWidget: (context, url, error) => const Icon(Icons.error),
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
                      children: List.generate(
                        widget.images.length,
                        (index) => Container(
                          margin: const EdgeInsets.symmetric(horizontal: 3),
                          width: 8,
                          height: 8,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.white.withOpacity(0.8),
                          ),
                        ),
                      ),
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
                  backgroundColor: Colors.grey.shade300,
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
                Text(
                  widget.username,
                  style: Theme.of(context).textTheme.labelMedium,
                ),
                const SizedBox(width: 5),
                Icon(
                  OctIcons.verified,
                  size: 12,
                  color: Colors.blue.shade500,
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
                padding:
                    const EdgeInsets.symmetric(vertical: 4, horizontal: 16),
                child: Row(
                  children: [
                    Row(
                      children: [
                        IconButton(
                          onPressed: () {
                            ref
                                .read(
                                    postLikeViewModelProvider.notifier)
                                .toggleLike(
                                  postId: widget.postId,
                                );
                          },
                          icon: Icon(
                            _isLiked
                                ? Icons.favorite
                                : Icons.favorite_border,
                            color: _isLiked
                                ? Colors.red
                                : Colors.blue.shade500,
                            size: 26,
                          ),
                        ),
                        Text(
                          _likesCount.toString(),
                          style:
                              Theme.of(context).textTheme.labelLarge,
                        ),
                      ],
                    ),

                    const SizedBox(width: 24),

                    Column(
                      children: [
                        // Icon(
                        //   FontAwesome.paper_plane_solid,
                        //   color: Colors.blue.shade500,
                        //   size: 24,
                        // ),
                        // const SizedBox(height: 5),
                        // Text(
                        //   widget.sharesCount.toString(),
                        //   style:
                        //       Theme.of(context).textTheme.labelLarge,
                        // ),
                      ],
                    ),

                    const SizedBox(width: 24),

                    // Icon(
                    //   FontAwesome.comment,
                    //   size: 24,
                    //   color: Colors.blue.shade500,
                    // ),
                  ],
                ),
              ),
              // IconButton(
              //   onPressed: () {},
              //   icon: Icon(
              //     Icons.bookmark_rounded,
              //     size: 32,
              //     color: Colors.blue.shade500,
              //   ),
              // ),
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
                  maxLines: isExpanded ? null : 2,
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
                          color: Colors.blue.shade500,
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
            padding: const EdgeInsets.only(left: 16, top: 4),
            child: Text(
              widget.datePosted,
              style: Theme.of(context)
                  .textTheme
                  .labelSmall
                  ?.copyWith(fontWeight: FontWeight.bold),
            ),
          ),

          const SizedBox(height: 30),
        ],
      ),
    );
  }
}
