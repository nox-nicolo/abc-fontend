
/* ---------------------------------------------------
   POST STATS
--------------------------------------------------- */

import 'package:flutter/material.dart';

class PostStatsRow extends StatefulWidget {
  final int likes;
  final int comments;
  final int shares;
  final bool isLiked;
  final bool isSaved;

  const PostStatsRow({
    super.key,
    required this.likes,
    required this.comments,
    required this.shares,
    this.isLiked = false,
    this.isSaved = false,
  });

  @override
  State<PostStatsRow> createState() => _PostStatsRowState();
}

class _PostStatsRowState extends State<PostStatsRow> {
  late int _likes;
  late bool _liked;
  late bool _saved;

  @override
  void initState() {
    super.initState();
    _likes = widget.likes;
    _liked = widget.isLiked;
    _saved = widget.isSaved;
  }

  void _toggleLike() {
    setState(() {
      _liked = !_liked;
      _likes += _liked ? 1 : -1;
    });
  }

  void _toggleSave() {
    setState(() => _saved = !_saved);
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      child: Row(
        children: [
          _IconCount(
            icon: _liked ? Icons.favorite : Icons.favorite_border,
            count: _likes,
            color: _liked ? Colors.red : scheme.onSurface,
            onTap: _toggleLike,
          ),
          const SizedBox(width: 16),
          _IconCount(
            icon: Icons.chat_bubble_outline,
            count: widget.comments,
            onTap: () {
              // open comments later
            },
          ),
          const SizedBox(width: 16),
          _IconCount(
            icon: Icons.send_outlined,
            count: widget.shares,
            onTap: () {
              // share later
            },
          ),
          const Spacer(),
          IconButton(
            splashRadius: 22,
            icon: Icon(
              _saved ? Icons.bookmark : Icons.bookmark_border,
            ),
            onPressed: _toggleSave,
          ),
        ],
      ),
    );
  }
}

/* ---------------------------------------------------
   ICON + COUNT
--------------------------------------------------- */

class _IconCount extends StatelessWidget {
  final IconData icon;
  final int count;
  final VoidCallback onTap;
  final Color? color;

  const _IconCount({
    required this.icon,
    required this.count,
    required this.onTap,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return InkWell(
      borderRadius: BorderRadius.circular(20),
      onTap: onTap,
      child: Row(
        children: [
          Icon(
            icon,
            size: 24,
            color: color,
          ),
          const SizedBox(width: 4),
          Text(
            count.toString(),
            style: textTheme.labelLarge,
          ),
        ],
      ),
    );
  }
}

