import 'package:africa_beuty/feature/post/view/page/create_post.dart';
import 'package:africa_beuty/feature/profile/view/widget/salon_widget.dart';
import 'package:flutter/material.dart';

class SalonProfileSliverWidget extends StatefulWidget {
  const SalonProfileSliverWidget({super.key});

  @override
  State<SalonProfileSliverWidget> createState() => _SalonProfileSliverWidgetState();
}

class _SalonProfileSliverWidgetState extends State<SalonProfileSliverWidget> {
  final PageController _pageController = PageController(initialPage: 1); // start at CreatePostPage

  void switchToProfile() {
    _pageController.animateToPage(
      1,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    return PageView(
      controller: _pageController, // optional, to control programmatically
      children: [
        CreatePostPage(onPostSubmit: switchToProfile),

        const SalonCustomWidget(),
      ],
    );
  }
}
