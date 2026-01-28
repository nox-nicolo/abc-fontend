import 'package:flutter/material.dart';

class SliverSpaceHeader extends StatelessWidget {
  const SliverSpaceHeader(
    {
      super.key, 
      required this.title, 
      this.iconData,
    }
  );

  final String title;
  final IconData? iconData;

  @override
  Widget build(BuildContext context) {
    return SliverPadding(
      padding: EdgeInsets.only(top: 20, left: 10, bottom: 30), 
      sliver: SliverToBoxAdapter(
        child: Row(
          children: [
            if (iconData == null)
              const SizedBox(width: 10,),
            if (iconData != null) 
              Icon(
                iconData, size: 20,
                color: Colors.green[600],
              ),
            const SizedBox(width: 10,),
            Text(
              title,
              style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                fontSize: 16,
                fontWeight: FontWeight.w600
              ),
            ),
          ],
        ),
      ), 
    );
  }
}