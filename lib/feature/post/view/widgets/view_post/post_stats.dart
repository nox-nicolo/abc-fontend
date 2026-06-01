/* ---------------------------------------------------
   POST STATS
--------------------------------------------------- */

import 'package:africa_beuty/feature/home/view_model/post_like.dart';
import 'package:africa_beuty/feature/post/providers/post_repository_provider.dart';
import 'package:africa_beuty/feature/post/view/widgets/comments_sheet.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class PostStatsRow extends ConsumerStatefulWidget {
  final String postId;
  final int likes;
  final int comments;
  final int shares;
  final bool isLiked;
  final bool isSaved;
  final bool canComment;
  final VoidCallback? onShare;

  const PostStatsRow({
    super.key,
    required this.postId,
    required this.likes,
    required this.comments,
    required this.shares,
    this.isLiked = false,
    this.isSaved = false,
    this.canComment = true,
    this.onShare,
  });

  @override
  ConsumerState<PostStatsRow> createState() => _PostStatsRowState();
}

class _PostStatsRowState extends ConsumerState<PostStatsRow> {
  late bool _liked;
  late bool _saved;
  bool _likeInFlight = false;
  bool _saveInFlight = false;

  @override
  void initState() {
    super.initState();
    _liked = widget.isLiked;
    _saved = widget.isSaved;
  }

  @override
  void didUpdateWidget(covariant PostStatsRow oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.isLiked != widget.isLiked) {
      _liked = widget.isLiked;
    }
    if (oldWidget.isSaved != widget.isSaved) {
      _saved = widget.isSaved;
    }
  }

  void _toggleLike() {
    if (_likeInFlight) return;
    setState(() {
      _likeInFlight = true;
      _liked = !_liked;
    });
    _likeAsync();
  }

  Future<void> _likeAsync() async {
    await ref
        .read(postLikeViewModelProvider.notifier)
        .toggleLike(postId: widget.postId);
    final result = ref.read(postLikeViewModelProvider);
    if (result != null && mounted) {
      result.whenOrNull(
        data: (m) => setState(() {
          if (m.postId == widget.postId) {
            _liked = m.liked;
          }
          _likeInFlight = false;
        }),
        // revert optimistic update on error
        error: (_, e) => setState(() {
          _liked = !_liked;
          _likeInFlight = false;
        }),
      );
    } else if (mounted) {
      setState(() => _likeInFlight = false);
    }
  }

  void _toggleSave() {
    if (_saveInFlight) return;
    setState(() {
      _saveInFlight = true;
      _saved = !_saved;
    });
    _saveAsync();
  }

  Future<void> _saveAsync() async {
    final result = await ref
        .read(postRemoteRepoProviderProvider)
        .toggleBookmark(widget.postId);
    if (mounted) {
      result.fold(
        (failure) => setState(() {
          _saved = !_saved;
          _saveInFlight = false;
        }),
        (saved) => setState(() {
          _saved = saved;
          _saveInFlight = false;
        }),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      child: Row(
        children: [
          _IconBtn(
            icon: _liked ? Icons.favorite : Icons.favorite_border,
            color: _liked ? Colors.red : scheme.onSurface,
            onTap: _toggleLike,
          ),
          const SizedBox(width: 16),
          _IconBtn(
            icon: Icons.chat_bubble_outline,
            onTap: () => showCommentsSheet(
              context,
              widget.postId,
              canComment: widget.canComment,
            ),
          ),
          const SizedBox(width: 16),
          if (widget.onShare != null)
            _IconBtn(icon: Icons.send_outlined, onTap: widget.onShare!),
          const Spacer(),
          IconButton(
            splashRadius: 22,
            icon: Icon(_saved ? Icons.bookmark : Icons.bookmark_border),
            onPressed: _toggleSave,
          ),
        ],
      ),
    );
  }
}

/* ---------------------------------------------------
   ICON BUTTON (no count)
--------------------------------------------------- */

class _IconBtn extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;
  final Color? color;

  const _IconBtn({required this.icon, required this.onTap, this.color});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(20),
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.all(4),
        child: Icon(icon, size: 26, color: color),
      ),
    );
  }
}
