import 'package:africa_beuty/feature/ads/model/ad_campaign.dart';
import 'package:africa_beuty/feature/ads/provider/ad_provider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:video_player/video_player.dart';

class SponsoredAdPost extends ConsumerStatefulWidget {
  final AdCampaign ad;

  const SponsoredAdPost({super.key, required this.ad});

  @override
  ConsumerState<SponsoredAdPost> createState() => _SponsoredAdPostState();
}

class _SponsoredAdPostState extends ConsumerState<SponsoredAdPost> {
  bool _reportedImpression = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted || _reportedImpression) return;
      _reportedImpression = true;
      ref.read(adRepositoryProvider).recordImpression(widget.ad);
    });
  }

  Future<void> _open() async {
    await ref.read(adRepositoryProvider).recordClick(widget.ad);
    final uri = Uri.tryParse(widget.ad.destinationUrl);
    if (uri == null) return;
    await launchUrl(uri, mode: LaunchMode.externalApplication);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final ad = widget.ad;

    return InkWell(
      onTap: _open,
      child: Padding(
        padding: const EdgeInsets.only(bottom: 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AspectRatio(
              aspectRatio: 1,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: ad.mediaType == 'video'
                    ? _AdVideo(url: ad.mediaUrl)
                    : CachedNetworkImage(
                        imageUrl: ad.mediaUrl,
                        fit: BoxFit.cover,
                        placeholder: (_, _) => ColoredBox(
                          color: theme.colorScheme.surfaceContainerHighest,
                        ),
                        errorWidget: (_, _, _) =>
                            const Center(child: Icon(Icons.campaign_outlined)),
                      ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 10, 16, 0),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 16,
                    backgroundColor: theme.colorScheme.primaryContainer,
                    child: Icon(
                      Icons.campaign_outlined,
                      size: 18,
                      color: theme.colorScheme.onPrimaryContainer,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          ad.advertiserName,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: theme.textTheme.labelMedium,
                        ),
                        Text(
                          ad.sponsoredLabel,
                          style: theme.textTheme.labelSmall?.copyWith(
                            color: theme.colorScheme.onSurfaceVariant,
                          ),
                        ),
                      ],
                    ),
                  ),
                  FilledButton.tonal(
                    onPressed: _open,
                    child: Text(ad.ctaLabel),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
              child: Text(
                ad.title,
                style: theme.textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),
            if (ad.body != null && ad.body!.trim().isNotEmpty)
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 4, 16, 0),
                child: Text(
                  ad.body!,
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                  style: theme.textTheme.bodyMedium,
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _AdVideo extends StatefulWidget {
  final String url;

  const _AdVideo({required this.url});

  @override
  State<_AdVideo> createState() => _AdVideoState();
}

class _AdVideoState extends State<_AdVideo> {
  late final VideoPlayerController _controller;
  bool _ready = false;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.networkUrl(Uri.parse(widget.url))
      ..setLooping(true)
      ..setVolume(0)
      ..initialize().then((_) {
        if (!mounted) return;
        setState(() => _ready = true);
        _controller.play();
      });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!_ready) {
      return ColoredBox(
        color: Theme.of(context).colorScheme.surfaceContainerHighest,
        child: const Center(child: Icon(Icons.play_circle_outline)),
      );
    }

    return Stack(
      fit: StackFit.expand,
      children: [
        VideoPlayer(_controller),
        const Align(
          alignment: Alignment.bottomRight,
          child: Padding(
            padding: EdgeInsets.all(10),
            child: Icon(Icons.volume_off, color: Colors.white),
          ),
        ),
      ],
    );
  }
}
