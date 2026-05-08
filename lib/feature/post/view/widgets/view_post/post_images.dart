/* ---------------------------------------------------
   POST IMAGES
--------------------------------------------------- */
import 'package:cached_network_image/cached_network_image.dart';
import 'package:africa_beuty/core/widgets/skeleton.dart';
import 'package:flutter/material.dart';

// Corretcions ++++++=============###############@@@@@@@@@@@@@@@@@@@
// Single Image not shown good

class PostImages extends StatefulWidget {
  final List<String> imageUrls;

  /// Aspect ratio for post media (e.g. 4/5 for Instagram portrait, 1 for square)
  final double aspectRatio;

  const PostImages({
    super.key,
    required this.imageUrls,
    this.aspectRatio = 4 / 5, // nice default for beauty posts
  });

  @override
  State<PostImages> createState() => _PostImagesState();
}

class _PostImagesState extends State<PostImages> {
  late final PageController _controller;
  int _index = 0;

  bool get _isCarousel => widget.imageUrls.length > 1;

  @override
  void initState() {
    super.initState();
    _controller = PageController();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final urls = widget.imageUrls;

    if (urls.isEmpty) {
      return AspectRatio(
        aspectRatio: widget.aspectRatio,
        child: _EmptyMediaPlaceholder(),
      );
    }

    return AspectRatio(
      aspectRatio: widget.aspectRatio,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(0), // keep 0 for full-bleed
        child: Stack(
          children: [
            // MEDIA
            if (_isCarousel)
              PageView.builder(
                controller: _controller,
                itemCount: urls.length,
                onPageChanged: (i) => setState(() => _index = i),
                itemBuilder: (_, i) => _CachedImage(url: urls[i]),
              )
            else
              _CachedImage(url: urls.first),

            // TOP-RIGHT COUNTER (only if carousel)
            if (_isCarousel)
              Positioned(
                top: 12,
                right: 12,
                child: _CounterPill(text: '${_index + 1}/${urls.length}'),
              ),

            // BOTTOM DOTS (only if carousel)
            if (_isCarousel)
              Positioned(
                bottom: 12,
                left: 0,
                right: 0,
                child: _Dots(count: urls.length, index: _index),
              ),
          ],
        ),
      ),
    );
  }
}

/* ------------------------- helpers ------------------------- */

class _CachedImage extends StatelessWidget {
  final String url;

  const _CachedImage({required this.url});

  @override
  Widget build(BuildContext context) {
    return CachedNetworkImage(
      imageUrl: url,
      fit: BoxFit.cover,
      fadeInDuration: const Duration(milliseconds: 150),
      placeholder: (_, _) => const _MediaLoading(),
      errorWidget: (_, _, _) => const _MediaError(),
    );
  }
}

class _MediaLoading extends StatelessWidget {
  const _MediaLoading();

  @override
  Widget build(BuildContext context) {
    return const SkeletonCard(
      width: double.infinity,
      height: double.infinity,
      radius: 0,
    );
  }
}

class _MediaError extends StatelessWidget {
  const _MediaError();

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Container(
      color: scheme.surfaceContainerHighest,
      alignment: Alignment.center,
      child: Icon(Icons.broken_image_outlined, color: scheme.outline),
    );
  }
}

class _EmptyMediaPlaceholder extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Container(
      color: scheme.surfaceContainerHighest,
      alignment: Alignment.center,
      child: Icon(Icons.photo_outlined, color: scheme.outline),
    );
  }
}

class _CounterPill extends StatelessWidget {
  final String text;

  const _CounterPill({required this.text});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.black.withValues(alpha: 0.55),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(
          color: scheme.outlineVariant.withValues(alpha: 0.25),
        ),
      ),
      child: Text(
        text,
        style: Theme.of(context).textTheme.labelMedium?.copyWith(
          color: Colors.white,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}

class _Dots extends StatelessWidget {
  final int count;
  final int index;

  const _Dots({required this.count, required this.index});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(count, (i) {
        final selected = i == index;
        return AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          margin: const EdgeInsets.symmetric(horizontal: 3),
          height: 6,
          width: selected ? 18 : 6,
          decoration: BoxDecoration(
            color: selected
                ? scheme.primary
                : scheme.onSurface.withValues(alpha: 0.25),
            borderRadius: BorderRadius.circular(999),
          ),
        );
      }),
    );
  }
}
