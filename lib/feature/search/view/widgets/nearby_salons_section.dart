

import 'package:africa_beuty/feature/search/view/widgets/salon_card.dart';
import 'package:africa_beuty/feature/search/view/widgets/section_header.dart';
import 'package:flutter/material.dart';

class NearbySalonsSection extends StatelessWidget {
  const NearbySalonsSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SectionHeader(
          title: 'Nearby salons',
          onSeeAll: () {},
        ),
        const SizedBox(height: 12),
        SizedBox(
          height: 180,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: 6,
            separatorBuilder: (_, __) => const SizedBox(width: 12),
            itemBuilder: (context, index) {
              return const SalonCard();
            },
          ),
        ),
      ],
    );
  }
}
