import 'package:africa_beuty/core/theme/colors_pallete.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class Skeleton extends StatelessWidget {
  final double? width;
  final double height;
  final BorderRadiusGeometry borderRadius;
  final BoxShape shape;

  const Skeleton({
    super.key,
    this.width,
    required this.height,
    this.borderRadius = const BorderRadius.all(Radius.circular(8)),
  }) : shape = BoxShape.rectangle;

  const Skeleton.circle({super.key, required double size})
    : width = size,
      height = size,
      borderRadius = BorderRadius.zero,
      shape = BoxShape.circle;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final isLight = scheme.brightness == Brightness.light;
    final base = isLight
        ? AppColors.shimmerLight
        : AppColors.shimmerDark.withValues(alpha: 0.9);
    final highlight = isLight
        ? Colors.white.withValues(alpha: 0.82)
        : scheme.surfaceContainerHighest.withValues(alpha: 0.72);

    return Shimmer.fromColors(
      baseColor: base,
      highlightColor: highlight,
      period: const Duration(milliseconds: 1300),
      child: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          color: base,
          shape: shape,
          borderRadius: shape == BoxShape.circle ? null : borderRadius,
        ),
      ),
    );
  }
}

class SkeletonText extends StatelessWidget {
  final double? width;
  final double height;

  const SkeletonText({super.key, this.width, this.height = 12});

  @override
  Widget build(BuildContext context) {
    return Skeleton(
      width: width,
      height: height,
      borderRadius: BorderRadius.circular(height / 2),
    );
  }
}

class SkeletonListTile extends StatelessWidget {
  final bool roundLeading;
  final double leadingSize;
  final double trailingWidth;
  final EdgeInsetsGeometry padding;

  const SkeletonListTile({
    super.key,
    this.roundLeading = true,
    this.leadingSize = 44,
    this.trailingWidth = 0,
    this.padding = const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding,
      child: Row(
        children: [
          roundLeading
              ? Skeleton.circle(size: leadingSize)
              : Skeleton(
                  width: leadingSize,
                  height: leadingSize,
                  borderRadius: BorderRadius.circular(10),
                ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                SkeletonText(width: 160, height: 14),
                SizedBox(height: 8),
                SkeletonText(width: 220, height: 11),
              ],
            ),
          ),
          if (trailingWidth > 0) ...[
            const SizedBox(width: 12),
            SkeletonText(width: trailingWidth, height: 18),
          ],
        ],
      ),
    );
  }
}

class SkeletonCard extends StatelessWidget {
  final double width;
  final double height;
  final double radius;

  const SkeletonCard({
    super.key,
    required this.width,
    required this.height,
    this.radius = 12,
  });

  @override
  Widget build(BuildContext context) {
    return Skeleton(
      width: width,
      height: height,
      borderRadius: BorderRadius.circular(radius),
    );
  }
}
