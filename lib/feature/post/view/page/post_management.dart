import 'package:africa_beuty/core/utils/api_datetime.dart';
import 'package:africa_beuty/core/widgets/skeleton.dart';
import 'package:africa_beuty/feature/post/providers/post_repository_provider.dart';
import 'package:africa_beuty/feature/post/view/page/view_post.dart';
import 'package:africa_beuty/feature/profile/view_model/salon.dart';
import 'package:africa_beuty/feature/profile/view_model/salon_profile_post.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

class PostManagementPage extends ConsumerStatefulWidget {
  const PostManagementPage({super.key});

  @override
  ConsumerState<PostManagementPage> createState() => _PostManagementPageState();
}

class _PostManagementPageState extends ConsumerState<PostManagementPage> {
  String? _salonId;
  bool _deleting = false;

  @override
  void initState() {
    super.initState();
    Future.microtask(_initLoad);
  }

  Future<void> _initLoad() async {
    final salon = ref.read(salonProfileViewModelProvider).value;
    if (salon == null || !mounted) return;
    setState(() => _salonId = salon.id);
    ref
        .read(profilePostsViewModelProvider(salon.id).notifier)
        .getInitialPosts();
  }

  Future<void> _deletePost(BuildContext ctx, String postId) async {
    final confirmed = await showDialog<bool>(
      context: ctx,
      builder: (_) => AlertDialog(
        title: const Text('Delete post'),
        content: const Text('This will permanently remove the post. Continue?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Cancel'),
          ),
          FilledButton(
            style: FilledButton.styleFrom(
              backgroundColor: Theme.of(ctx).colorScheme.error,
            ),
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
    if (confirmed != true || !mounted) return;

    setState(() => _deleting = true);

    final result = await ref
        .read(postRemoteRepoProviderProvider)
        .deletePost(postId);

    if (!mounted) return;
    setState(() => _deleting = false);

    result.fold(
      (failure) => ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(failure.message))),
      (_) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('Post deleted')));
        if (_salonId != null) {
          ref
              .read(profilePostsViewModelProvider(_salonId!).notifier)
              .getInitialPosts();
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;

    if (_salonId == null) {
      return const Scaffold(body: _ManagedPostsSkeletonList());
    }

    final postsState = ref.watch(profilePostsViewModelProvider(_salonId!));

    return Scaffold(
      appBar: AppBar(title: const Text('Content Management')),
      body: Stack(
        children: [
          postsState.when(
            loading: () => const _ManagedPostsSkeletonList(),
            error: (e, _) => Center(child: Text(e.toString())),
            data: (posts) {
              if (posts.isEmpty) {
                return Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.photo_library_outlined,
                        size: 56,
                        color: scheme.outline,
                      ),
                      const SizedBox(height: 12),
                      Text(
                        'No posts yet',
                        style: theme.textTheme.bodyLarge?.copyWith(
                          color: scheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                );
              }

              return RefreshIndicator(
                onRefresh: () => ref
                    .read(profilePostsViewModelProvider(_salonId!).notifier)
                    .getInitialPosts(),
                child: ListView.separated(
                  padding: const EdgeInsets.all(16),
                  itemCount: posts.length,
                  separatorBuilder: (context, i) => const SizedBox(height: 12),
                  itemBuilder: (ctx, i) {
                    final p = posts[i];
                    final cover = p.media.isNotEmpty ? p.media.first.url : '';

                    return InkWell(
                      borderRadius: BorderRadius.circular(16),
                      onTap: () => Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) => PostViewPage(postId: p.id),
                        ),
                      ),
                      child: Container(
                        decoration: BoxDecoration(
                          color: scheme.surfaceContainerLowest,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: scheme.outlineVariant),
                        ),
                        child: Row(
                          children: [
                            // Thumbnail
                            ClipRRect(
                              borderRadius: const BorderRadius.only(
                                topLeft: Radius.circular(16),
                                bottomLeft: Radius.circular(16),
                              ),
                              child: cover.isNotEmpty
                                  ? CachedNetworkImage(
                                      imageUrl: cover,
                                      width: 80,
                                      height: 80,
                                      fit: BoxFit.cover,
                                      errorWidget: (_, url, e) => Container(
                                        width: 80,
                                        height: 80,
                                        color: scheme.surfaceContainerHigh,
                                        child: Icon(
                                          Icons.broken_image,
                                          color: scheme.outline,
                                        ),
                                      ),
                                    )
                                  : Container(
                                      width: 80,
                                      height: 80,
                                      color: scheme.surfaceContainerHigh,
                                      child: Icon(
                                        Icons.image_outlined,
                                        color: scheme.outline,
                                      ),
                                    ),
                            ),

                            // Info
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 10,
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    if (p.caption.isNotEmpty)
                                      Text(
                                        p.caption,
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                        style: theme.textTheme.bodyMedium,
                                      ),
                                    const SizedBox(height: 4),
                                    Text(
                                      _formatDate(p.createdAt),
                                      style: theme.textTheme.labelSmall
                                          ?.copyWith(
                                            color: scheme.onSurfaceVariant,
                                          ),
                                    ),
                                    const SizedBox(height: 6),
                                    Row(
                                      children: [
                                        Icon(
                                          Icons.favorite_border,
                                          size: 14,
                                          color: scheme.outline,
                                        ),
                                        const SizedBox(width: 4),
                                        Text(
                                          '${p.stats.likes}',
                                          style: theme.textTheme.labelSmall,
                                        ),
                                        const SizedBox(width: 12),
                                        Icon(
                                          Icons.chat_bubble_outline,
                                          size: 14,
                                          color: scheme.outline,
                                        ),
                                        const SizedBox(width: 4),
                                        Text(
                                          '${p.stats.comments}',
                                          style: theme.textTheme.labelSmall,
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),

                            // Action menu
                            PopupMenuButton<String>(
                              icon: const Icon(Icons.more_vert),
                              onSelected: (action) {
                                if (action == 'delete') {
                                  _deletePost(ctx, p.id);
                                } else if (action == 'view') {
                                  Navigator.of(context).push(
                                    MaterialPageRoute(
                                      builder: (_) =>
                                          PostViewPage(postId: p.id),
                                    ),
                                  );
                                }
                              },
                              itemBuilder: (_) => [
                                const PopupMenuItem(
                                  value: 'view',
                                  child: ListTile(
                                    leading: Icon(Icons.open_in_new_rounded),
                                    title: Text('View post'),
                                    contentPadding: EdgeInsets.zero,
                                  ),
                                ),
                                PopupMenuItem(
                                  value: 'delete',
                                  child: ListTile(
                                    leading: Icon(
                                      Icons.delete_outline,
                                      color: scheme.error,
                                    ),
                                    title: Text(
                                      'Delete',
                                      style: TextStyle(color: scheme.error),
                                    ),
                                    contentPadding: EdgeInsets.zero,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              );
            },
          ),

          // Full-screen loading overlay while deleting
          if (_deleting)
            const ColoredBox(
              color: Colors.black26,
              child: Center(child: CircularProgressIndicator()),
            ),
        ],
      ),
    );
  }

  String _formatDate(String raw) {
    try {
      final dt = parseApiDateTime(raw).toLocal();
      return DateFormat('MMM d, yyyy').format(dt);
    } catch (_) {
      return raw;
    }
  }
}

class _ManagedPostsSkeletonList extends StatelessWidget {
  const _ManagedPostsSkeletonList();

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: const EdgeInsets.all(16),
      itemCount: 5,
      separatorBuilder: (_, _) => const SizedBox(height: 12),
      itemBuilder: (_, _) => const SkeletonListTile(
        roundLeading: false,
        leadingSize: 80,
        trailingWidth: 24,
        padding: EdgeInsets.all(12),
      ),
    );
  }
}
