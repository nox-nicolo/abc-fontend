
/* ---------------------------------------------------
   DESCRIPTION
--------------------------------------------------- */

import 'package:flutter/material.dart';

class PostDescription extends StatefulWidget {
  final String text;
  final DateTime createdAt;
  final int maxLines;

  const PostDescription({
    super.key,
    required this.text,
    required this.createdAt,
    this.maxLines = 3,
  });

  @override
  State<PostDescription> createState() => _PostDescriptionState();
}

class _PostDescriptionState extends State<PostDescription> {
  bool _expanded = false;
  bool _overflow = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // DESCRIPTION
          LayoutBuilder(
            builder: (context, constraints) {
              final span = TextSpan(
                text: widget.text,
                style: textTheme.bodyMedium,
              );

              final tp = TextPainter(
                text: span,
                maxLines: widget.maxLines,
                textDirection: TextDirection.ltr,
              )..layout(maxWidth: constraints.maxWidth);

              _overflow = tp.didExceedMaxLines;

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.text,
                    maxLines: _expanded ? null : widget.maxLines,
                    overflow:
                        _expanded ? TextOverflow.visible : TextOverflow.ellipsis,
                    style: textTheme.bodyMedium,
                  ),
                  if (_overflow)
                    GestureDetector(
                      onTap: () => setState(() => _expanded = !_expanded),
                      child: Padding(
                        padding: const EdgeInsets.only(top: 4),
                        child: Text(
                          _expanded ? 'Show less' : 'Show more',
                          style: textTheme.labelMedium?.copyWith(
                            color: theme.colorScheme.primary,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                ],
              );
            },
          ),

          const SizedBox(height: 6),

          // TIME
          Text(
            _formatDate(widget.createdAt),
            style: textTheme.labelSmall?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime date) {
    final h = date.hour.toString().padLeft(2, '0');
    final m = date.minute.toString().padLeft(2, '0');
    final d = date.day.toString().padLeft(2, '0');
    final mo = date.month.toString().padLeft(2, '0');
    final y = date.year.toString();

    return '$h:$m  $d-$mo-$y';
  }
}
