import 'package:africa_beuty/core/widgets/skeleton.dart';
import 'package:africa_beuty/feature/post/model/comment.dart';
import 'package:africa_beuty/feature/post/providers/comment.dart';
import 'package:africa_beuty/feature/post/view_model/comment.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

Future<void> showCommentsSheet(BuildContext context, String postId) {
  return showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    useSafeArea: true,
    backgroundColor: Theme.of(context).colorScheme.surface,
    barrierColor: Colors.black.withValues(alpha: 0.5),
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
    ),
    builder: (_) => _CommentsSheet(postId: postId),
  );
}

Future<void> showRepliesSheet(
  BuildContext context,
  String postId,
  CommentModel parent,
) {
  return showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    useSafeArea: true,
    backgroundColor: Theme.of(context).colorScheme.surface,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
    ),
    builder: (_) => _RepliesSheet(postId: postId, parent: parent),
  );
}

class _CommentsSheet extends ConsumerStatefulWidget {
  final String postId;
  const _CommentsSheet({required this.postId});

  @override
  ConsumerState<_CommentsSheet> createState() => _CommentsSheetState();
}

class _RepliesSheet extends ConsumerStatefulWidget {
  const _RepliesSheet({required this.postId, required this.parent});

  final String postId;
  final CommentModel parent;

  @override
  ConsumerState<_RepliesSheet> createState() => _RepliesSheetState();
}

class _RepliesSheetState extends ConsumerState<_RepliesSheet> {
  late Future<CommentListPage> _future;
  final _controller = TextEditingController();
  bool _sending = false;

  @override
  void initState() {
    super.initState();
    _future = _load();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<CommentListPage> _load() async {
    final result = await ref
        .read(commentRepositoryProvider)
        .list(postId: widget.postId, parentCommentId: widget.parent.id);
    return result.fold((failure) => throw failure.message, (page) => page);
  }

  Future<void> _send() async {
    final text = _controller.text.trim();
    if (text.isEmpty || _sending) return;
    _controller.clear();
    setState(() => _sending = true);
    final result = await ref
        .read(commentRepositoryProvider)
        .create(
          postId: widget.postId,
          content: text,
          parentCommentId: widget.parent.id,
        );
    if (!mounted) return;
    setState(() {
      _sending = false;
      if (result.isRight()) _future = _load();
    });
    result.match(
      (failure) => ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(failure.message))),
      (_) {},
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return FractionallySizedBox(
      heightFactor: 0.82,
      child: Column(
        children: [
          const SizedBox(height: 12),
          Container(
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: theme.colorScheme.outlineVariant,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 14, 8, 8),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    'Replies to ${widget.parent.author.username}',
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
                IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(Icons.close_rounded),
                ),
              ],
            ),
          ),
          const Divider(height: 1),
          Expanded(
            child: FutureBuilder<CommentListPage>(
              future: _future,
              builder: (context, snapshot) {
                if (snapshot.connectionState != ConnectionState.done) {
                  return const _CommentsSkeletonList();
                }
                if (snapshot.hasError) {
                  return Center(child: Text(snapshot.error.toString()));
                }
                final replies = snapshot.data?.items ?? const <CommentModel>[];
                if (replies.isEmpty) {
                  return Center(
                    child: Text(
                      'No replies yet',
                      style: theme.textTheme.bodyMedium,
                    ),
                  );
                }
                return ListView.builder(
                  padding: const EdgeInsets.only(top: 8, bottom: 20),
                  itemCount: replies.length,
                  itemBuilder: (_, index) => _CommentTile(
                    comment: replies[index],
                    onLike: () async {
                      final result = await ref
                          .read(commentRepositoryProvider)
                          .toggleLike(
                            postId: widget.postId,
                            commentId: replies[index].id,
                          );
                      if (!mounted) return;
                      result.match(
                        (failure) => ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text(failure.message)),
                        ),
                        (_) => setState(() => _future = _load()),
                      );
                    },
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(
              16,
              10,
              16,
              MediaQuery.of(context).viewInsets.bottom + 16,
            ),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    decoration: InputDecoration(
                      hintText: 'Write a reply...',
                      filled: true,
                      fillColor: theme.colorScheme.surfaceContainerHighest
                          .withValues(alpha: 0.4),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(24),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                IconButton.filled(
                  onPressed: _sending ? null : _send,
                  icon: _sending
                      ? const SizedBox(
                          width: 18,
                          height: 18,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Icon(Icons.arrow_upward_rounded),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _CommentsSheetState extends ConsumerState<_CommentsSheet> {
  final _controller = TextEditingController();
  final _scrollCtrl = ScrollController();
  CommentModel? _replyingTo;
  bool _sending = false;

  @override
  void initState() {
    super.initState();
    _scrollCtrl.addListener(() {
      final pos = _scrollCtrl.position;
      if (pos.pixels >= pos.maxScrollExtent - 200) {
        ref.read(commentsViewModelProvider(widget.postId).notifier).loadMore();
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    _scrollCtrl.dispose();
    super.dispose();
  }

  Future<void> _send() async {
    final text = _controller.text.trim();
    if (text.isEmpty || _sending) return;

    _controller.clear();
    setState(() => _sending = true);
    final ok = await ref
        .read(commentsViewModelProvider(widget.postId).notifier)
        .add(content: text, parentCommentId: _replyingTo?.id);
    if (!mounted) return;
    setState(() {
      _sending = false;
      if (ok) _replyingTo = null;
    });
    if (ok) {
      // Scroll to bottom to see new comment
      _scrollCtrl.animateTo(
        0,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    } else {
      _controller.text = text;
    }
  }

  Future<void> _confirmDelete(CommentModel c) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Delete comment'),
        content: const Text('This will permanently remove your comment.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          FilledButton(
            style: FilledButton.styleFrom(
              backgroundColor: Theme.of(context).colorScheme.error,
            ),
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
    if (confirmed != true || !mounted) return;
    await ref
        .read(commentsViewModelProvider(widget.postId).notifier)
        .remove(c.id);
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(commentsViewModelProvider(widget.postId));
    final theme = Theme.of(context);

    return FractionallySizedBox(
      heightFactor: 0.9,
      child: Column(
        children: [
          // Drag Handle & Header
          Column(
            children: [
              const SizedBox(height: 12),
              Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: theme.colorScheme.outlineVariant,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 16, 8, 8),
                child: Row(
                  children: [
                    Text(
                      'Comments',
                      style: theme.textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.w800,
                        letterSpacing: -0.5,
                      ),
                    ),
                    const Spacer(),
                    IconButton(
                      icon: const Icon(Icons.close_rounded),
                      onPressed: () => Navigator.of(context).pop(),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const Divider(height: 1, thickness: 0.5),

          // Comments List
          Expanded(child: _buildList(state, theme)),

          // Input Section
          _buildInputArea(theme),
        ],
      ),
    );
  }

  Widget _buildInputArea(ThemeData theme) {
    return Container(
      padding: EdgeInsets.fromLTRB(
        16,
        12,
        16,
        MediaQuery.of(context).viewInsets.bottom + 16,
      ),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        border: Border(
          top: BorderSide(color: theme.colorScheme.outlineVariant, width: 0.5),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (_replyingTo != null) ...[
            Row(
              children: [
                Expanded(
                  child: Text(
                    'Replying to ${_replyingTo!.author.username}',
                    style: theme.textTheme.labelMedium?.copyWith(
                      color: theme.colorScheme.primary,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                IconButton(
                  visualDensity: VisualDensity.compact,
                  onPressed: () => setState(() => _replyingTo = null),
                  icon: const Icon(Icons.close, size: 18),
                ),
              ],
            ),
            const SizedBox(height: 6),
          ],
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Expanded(
                child: TextField(
                  controller: _controller,
                  minLines: 1,
                  maxLines: 5,
                  style: theme.textTheme.bodyMedium,
                  decoration: InputDecoration(
                    hintText: _replyingTo == null
                        ? 'Add a comment...'
                        : 'Write a reply...',
                    hintStyle: TextStyle(
                      color: theme.colorScheme.onSurfaceVariant.withValues(
                        alpha: 0.7,
                      ),
                    ),
                    filled: true,
                    fillColor: theme.colorScheme.surfaceContainerHighest
                        .withValues(alpha: 0.4),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(24),
                      borderSide: BorderSide.none,
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 10,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              GestureDetector(
                onTap: _send,
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.primary,
                    shape: BoxShape.circle,
                  ),
                  child: _sending
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.white,
                          ),
                        )
                      : const Icon(
                          Icons.arrow_upward_rounded,
                          color: Colors.white,
                          size: 20,
                        ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildList(CommentsState state, ThemeData theme) {
    if (state.isLoading && state.items.isEmpty) {
      return const _CommentsSkeletonList();
    }
    if (state.items.isEmpty) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.chat_bubble_outline_rounded,
              size: 48,
              color: theme.colorScheme.outlineVariant,
            ),
            const SizedBox(height: 12),
            Text('No comments yet', style: theme.textTheme.bodyLarge),
            Text(
              'Be the first to join the conversation.',
              style: theme.textTheme.bodySmall,
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      controller: _scrollCtrl,
      padding: const EdgeInsets.only(top: 8, bottom: 20),
      itemCount: state.items.length + (state.isLoadingMore ? 1 : 0),
      itemBuilder: (_, i) {
        if (i >= state.items.length) {
          return const Padding(
            padding: EdgeInsets.all(20),
            child: SkeletonListTile(),
          );
        }
        final c = state.items[i];
        return _CommentTile(
          comment: c,
          onDelete: c.isMine ? () => _confirmDelete(c) : null,
          onLike: () => ref
              .read(commentsViewModelProvider(widget.postId).notifier)
              .toggleLike(c.id),
          onReply: () => setState(() => _replyingTo = c),
          onViewReplies: c.replyCount > 0
              ? () => showRepliesSheet(context, widget.postId, c)
              : null,
        );
      },
    );
  }
}

class _CommentsSkeletonList extends StatelessWidget {
  const _CommentsSkeletonList();

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.only(top: 8, bottom: 20),
      itemCount: 7,
      itemBuilder: (_, i) => SkeletonListTile(
        padding: EdgeInsets.fromLTRB(16, i == 0 ? 8 : 12, 16, 12),
      ),
    );
  }
}

class _CommentTile extends StatelessWidget {
  final CommentModel comment;
  final VoidCallback? onDelete;
  final VoidCallback? onLike;
  final VoidCallback? onReply;
  final VoidCallback? onViewReplies;

  const _CommentTile({
    required this.comment,
    this.onDelete,
    this.onLike,
    this.onReply,
    this.onViewReplies,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Opacity(
      opacity: comment.isPending ? 0.65 : 1,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Avatar with subtle border
            Container(
              padding: const EdgeInsets.all(1.5),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: theme.colorScheme.primary.withValues(alpha: 0.1),
                ),
              ),
              child: CircleAvatar(
                radius: 16,
                backgroundColor: theme.colorScheme.surfaceContainerHighest,
                backgroundImage:
                    (comment.author.profilePicture != null &&
                        comment.author.profilePicture!.isNotEmpty)
                    ? NetworkImage(comment.author.profilePicture!)
                    : null,
                child:
                    (comment.author.profilePicture == null ||
                        comment.author.profilePicture!.isEmpty)
                    ? Icon(
                        Icons.person,
                        size: 18,
                        color: theme.colorScheme.primary,
                      )
                    : null,
              ),
            ),
            const SizedBox(width: 12),
            // Content Bubble
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 10,
                    ),
                    decoration: BoxDecoration(
                      color: theme.colorScheme.surfaceContainerLow,
                      borderRadius: const BorderRadius.only(
                        topRight: Radius.circular(18),
                        bottomLeft: Radius.circular(18),
                        bottomRight: Radius.circular(18),
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          comment.author.username,
                          style: theme.textTheme.labelLarge?.copyWith(
                            fontWeight: FontWeight.w800,
                            fontSize: 13,
                            color: theme.colorScheme.primary,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          comment.content,
                          style: theme.textTheme.bodyMedium?.copyWith(
                            height: 1.3,
                            color: theme.colorScheme.onSurface,
                          ),
                        ),
                      ],
                    ),
                  ),
                  // Timestamp and Actions
                  Padding(
                    padding: const EdgeInsets.only(top: 6, left: 4),
                    child: Row(
                      children: [
                        Text(
                          comment.isPending
                              ? 'Sending...'
                              : _relative(comment.createdAt),
                          style: theme.textTheme.labelSmall?.copyWith(
                            color: theme.colorScheme.onSurfaceVariant,
                          ),
                        ),
                        if (onDelete != null) ...[
                          const SizedBox(width: 16),
                          GestureDetector(
                            onTap: onDelete,
                            child: Text(
                              'Delete',
                              style: theme.textTheme.labelSmall?.copyWith(
                                color: theme.colorScheme.error,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                        const SizedBox(width: 16),
                        GestureDetector(
                          onTap: onLike,
                          child: Text(
                            comment.isLiked ? 'Liked' : 'Like',
                            style: theme.textTheme.labelSmall?.copyWith(
                              color: comment.isLiked
                                  ? theme.colorScheme.primary
                                  : theme.colorScheme.onSurfaceVariant,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        if (comment.likesCount > 0) ...[
                          const SizedBox(width: 6),
                          Text(
                            '${comment.likesCount}',
                            style: theme.textTheme.labelSmall?.copyWith(
                              color: theme.colorScheme.onSurfaceVariant,
                            ),
                          ),
                        ],
                        const SizedBox(width: 16),
                        GestureDetector(
                          onTap: onReply,
                          child: Text(
                            'Reply',
                            style: theme.textTheme.labelSmall?.copyWith(
                              color: theme.colorScheme.onSurfaceVariant,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  if (onViewReplies != null)
                    TextButton(
                      onPressed: onViewReplies,
                      child: Text('View ${comment.replyCount} replies'),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _relative(DateTime dt) {
    final now = DateTime.now().toUtc();
    final diff = now.difference(dt.toUtc());

    if (diff.inSeconds < 60) return 'Just now';
    if (diff.inMinutes < 60) return '${diff.inMinutes}m ago';
    if (diff.inHours < 24) return '${diff.inHours}h ago';
    if (diff.inDays < 7) return '${diff.inDays}d ago';
    return '${dt.day}/${dt.month}/${dt.year}';
  }
}
