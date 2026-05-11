import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

/// A reusable, "dumb" grid widget that renders a list of posts.
/// It doesn't care about the state management, only about displaying data.
class UniversalPostGrid extends StatelessWidget {
  final List<dynamic> posts; // Pass your list of post models here
  final Function(dynamic post) onPostTap;

  const UniversalPostGrid({
    super.key,
    required this.posts,
    required this.onPostTap,
  });

  @override
  Widget build(BuildContext context) {
    // If the list is empty, we return an empty sliver to avoid layout errors
    if (posts.isEmpty) {
      return const SliverToBoxAdapter(child: SizedBox.shrink());
    }

    return SliverGrid(
      gridDelegate: SliverQuiltedGridDelegate(
        crossAxisCount: 3,
        mainAxisSpacing: 1.5,
        crossAxisSpacing: 1.5,
        repeatPattern: QuiltedGridRepeatPattern.same,
        pattern: const [
          QuiltedGridTile(1, 1), // Regular square
          QuiltedGridTile(1, 1), // Regular square
          QuiltedGridTile(2, 1), // Tall rectangle (spanning 2 rows, 1 col)
          QuiltedGridTile(1, 1),
          QuiltedGridTile(1, 1),
        ],
      ),
      delegate: SliverChildBuilderDelegate((context, index) {
        final post = posts[index];

        // Helper to get the first image safely based on your JSON structure
        final String imageUrl = (post.media != null && post.media.isNotEmpty)
            ? post.media[0].url
            : '';
        final hasMedia = imageUrl.isNotEmpty;

        final scheme = Theme.of(context).colorScheme;
        return GestureDetector(
          onTap: () => onPostTap(post),
          child: Container(
            color: scheme.surfaceContainerHighest,
            child: Stack(
              fit: StackFit.expand,
              children: [
                if (hasMedia)
                  Image.network(
                    imageUrl,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) =>
                        Icon(Icons.broken_image, color: scheme.outline),
                  )
                else
                  Padding(
                    padding: const EdgeInsets.all(10),
                    child: Align(
                      alignment: Alignment.topLeft,
                      child: Text(
                        post.caption ?? '',
                        maxLines: 5,
                        overflow: TextOverflow.ellipsis,
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                    ),
                  ),

                // Overlay for Multiple Images (Carousel Indicator)
                if (post.media != null && post.media.length > 1)
                  const Positioned(
                    top: 8,
                    right: 8,
                    child: Icon(
                      Icons.collections_rounded,
                      color: Colors.white,
                      size: 16,
                      shadows: [
                        Shadow(
                          blurRadius: 4,
                          color: Colors.black45,
                          offset: Offset(0, 1),
                        ),
                      ],
                    ),
                  ),

                // Optional: Video Indicator
                if (post.media != null &&
                    post.media.isNotEmpty &&
                    post.media[0].type == "VIDEO")
                  const Positioned(
                    bottom: 8,
                    right: 8,
                    child: Icon(
                      Icons.play_arrow_rounded,
                      color: Colors.white,
                      size: 20,
                    ),
                  ),
              ],
            ),
          ),
        );
      }, childCount: posts.length),
    );
  }
}
