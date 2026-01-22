import 'package:flutter/material.dart';

class SliverSpaceHeader extends StatelessWidget {
  const SliverSpaceHeader(
    {
      super.key, 
      required this.title, 
    }
  );

  final String title;

  @override
  Widget build(BuildContext context) {
    return SliverPadding(
      padding: EdgeInsets.only(top: 20, left: 10, bottom: 30), 
      sliver: SliverToBoxAdapter(
        child: Text(
          title,
          style: Theme.of(context).textTheme.headlineLarge?.copyWith(
            fontSize: 16,
            fontWeight: FontWeight.w600
          ),
        ),
      ), 
    );
  }
}