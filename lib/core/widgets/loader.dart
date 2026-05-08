import 'package:flutter/material.dart';
import 'package:africa_beuty/core/widgets/skeleton.dart';

class Loader extends StatelessWidget {
  const Loader({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Padding(
        padding: EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SkeletonCard(width: 220, height: 18),
            SizedBox(height: 12),
            SkeletonCard(width: 180, height: 14),
            SizedBox(height: 24),
            SkeletonCard(width: 260, height: 120),
          ],
        ),
      ),
    );
  }
}
