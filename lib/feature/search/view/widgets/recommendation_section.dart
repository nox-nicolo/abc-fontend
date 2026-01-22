import 'package:flutter/material.dart';
import 'section_header.dart';
import 'recommendation_tile.dart';

class RecommendationSection extends StatelessWidget {
  const RecommendationSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SectionHeader(
          title: 'Recommended for you',
          onSeeAll: () {},
        ),
        const SizedBox(height: 12),
        Column(
          children: List.generate(
            6,
            (index) => const RecommendationTile(),
          ),
        ),
      ],
    );
  }
}
