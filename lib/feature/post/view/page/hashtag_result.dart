
import 'package:africa_beuty/feature/post/view/page/view_post.dart';
import 'package:africa_beuty/feature/search/model/hashtag.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

import '../../../search/view_model/hashtags.dart';

class HashtagScreen extends ConsumerWidget {
  final String hashtagId;

  const HashtagScreen({
    super.key,
    required this.hashtagId,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(hashtagViewModelProvider(hashtagId));
    final notifier = ref.read(hashtagViewModelProvider(hashtagId).notifier);

    return Scaffold(
      body: state.when(
        loading: () => const Center(
          child: CircularProgressIndicator(),
        ),
        error: (e, _) => Center(
          child: Text(e.toString()),
        ),
        data: (data) {
          return _HashtagBody(
            data: data,
            onLoadMore: notifier.loadMore,
          );
        },
      ),
    );
  }
}


class _HashtagBody extends StatefulWidget {
  final HashtagGridModel data;
  final VoidCallback onLoadMore;

  const _HashtagBody({
    required this.data,
    required this.onLoadMore,
  });

  @override
  State<_HashtagBody> createState() => _HashtagBodyState();
}

class _HashtagBodyState extends State<_HashtagBody> {
  final ScrollController _controller = ScrollController();

  @override
  void initState() {
    super.initState();
    _controller.addListener(_onScroll);
  }

  void _onScroll() {
    if (_controller.position.pixels >
        _controller.position.maxScrollExtent - 300) {
      widget.onLoadMore();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final hashtag = widget.data.hashtag;
    final posts = widget.data.posts;

    return CustomScrollView(
      controller: _controller,
      slivers: [
        // ------------------------------------------------------
        // APP BAR
        // ------------------------------------------------------
        SliverAppBar(
          pinned: true,
          expandedHeight: 200,
          backgroundColor: Colors.black,
          elevation: 0,
          title: Text(
            hashtag.name,
            style: TextStyle(
              color: Theme.of(context).colorScheme.onPrimary,
              fontWeight: FontWeight.bold,
            ),
          ),
          flexibleSpace: FlexibleSpaceBar(
            background: Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const CircleAvatar(
                    radius: 30,
                    backgroundColor: Colors.blueAccent,
                    child: Icon(Icons.tag, color: Colors.white, size: 30),
                  ),
                  const SizedBox(width: 16),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        hashtag.name,
                        style: const TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Row(
                        children: [
                          Text(
                            _formatCount(hashtag.postCount),
                            style: const TextStyle(color: Colors.white70),
                          ),
                          const SizedBox(width: 8),
                          if (hashtag.isTrending)
                            const Icon(
                              Icons.trending_up,
                              color: Colors.amber,
                              size: 18,
                            ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),

        // ------------------------------------------------------
        // GRID
        // ------------------------------------------------------
        SliverMasonryGrid.count(
          crossAxisCount: 3,
          mainAxisSpacing: 1,
          crossAxisSpacing: 1,
          itemBuilder: (context, index) {
            final item = posts[index];
            
            return GestureDetector(
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) => PostViewPage(postId: item.postId),
                  ),
                );
              },
              child: CachedNetworkImage(
                imageUrl: item.imageUrl,
                fit: BoxFit.cover,
              ),
            );
          },
          childCount: posts.length,
        ),
      ],
    );
  }

  String _formatCount(int count) {
    if (count >= 1000000) {
      return '${(count / 1000000).toStringAsFixed(1)}M posts';
    } else if (count >= 1000) {
      return '${(count / 1000).toStringAsFixed(1)}K posts';
    }
    return '$count posts';
  }
}
