import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:africa_beuty/feature/post/view/page/single_post.dart'; // Import your Post widget

class TrendingPage extends StatefulWidget {
  const TrendingPage({super.key});

  @override
  State<TrendingPage> createState() => _TrendingPageState();
}

class _TrendingPageState extends State<TrendingPage> {
  String? selectedTrend; // Track the selected trend

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: selectedTrend == null
            ? _buildGridView()
            : _buildListView(selectedTrend!),
      ),
    );
  }

  // Grid View
  Widget _buildGridView() {
    return GridView.builder(
      padding: const EdgeInsets.all(1),
      gridDelegate: SliverQuiltedGridDelegate(
        crossAxisCount: 3,
        mainAxisSpacing: 1,
        crossAxisSpacing: 1,
        pattern: [
          QuiltedGridTile(2, 1),
          QuiltedGridTile(1, 1),
          QuiltedGridTile(1, 1),
          QuiltedGridTile(1, 1),
          QuiltedGridTile(1, 1),
          QuiltedGridTile(1, 1),
          QuiltedGridTile(1, 1),
          QuiltedGridTile(2, 1),
          QuiltedGridTile(1, 1),
          QuiltedGridTile(1, 1),
        ],
      ),
      itemCount: 30, // Or your actual item count
      itemBuilder: (context, index) {
        return GestureDetector(
          onTap: () {
            setState(() {
              selectedTrend = index.toString(); // Or a more meaningful ID
            });
          },
          child: Container(
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surfaceContainerHighest,
              borderRadius: BorderRadius.circular(2),
            ),
            child: Image.asset(
              (index % 3 == 0 && index != 0)
                  ? 'assets/images/nails.jpeg'
                  : 'assets/images/dp.jpg',
              fit: BoxFit.cover,
            ),
          ),
        );
      },
    );
  }

  // List View
  Widget _buildListView(String trend) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            setState(() {
              selectedTrend = null;
            });
          },
        ),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(1),
        itemCount: 5, // Or a dynamic count based on the trend
        itemBuilder: (context, index) {
          return Post(
            postId: 'postId_$index',
            isLiked: false,
            aspectRatio: (index % 3 == 0 && index != 0) ? 1 : .5,
            username: 'user123',
            profileImage: 'assets/images/dp1.jpg',
            images: [
              (index % 3 == 0 && index != 0)
                  ? 'assets/images/nails.jpeg'
                  : 'assets/images/dp.jpg',
            ],
            likesCount: 1400,
            sharesCount: 1200,
            commentsCount: 450,
            description:
                'This is a sample post description, showcasing how to pass dynamic data to the Post widget. The description is quite long to show the "Read More" functionality.',
            datePosted: '12/02/2025 18:12:32',
          );
        },
      ),
    );
  }
}
