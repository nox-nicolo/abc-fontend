import 'package:africa_beuty/core/page/bottom_nav.dart';
import 'package:africa_beuty/core/widgets/skeleton.dart';
import 'package:africa_beuty/feature/notifications/model/notification.dart';
import 'package:africa_beuty/feature/notifications/view_model/notification.dart';
import 'package:africa_beuty/feature/post/view/page/view_post.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class NotificationsPage extends ConsumerStatefulWidget {
  const NotificationsPage({super.key});

  @override
  ConsumerState<NotificationsPage> createState() => _NotificationsPageState();
}

class _NotificationsPageState extends ConsumerState<NotificationsPage> {
  late final ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController()..addListener(_onScroll);
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 300) {
      ref.read(notificationsViewModelProvider.notifier).loadMore();
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(notificationsViewModelProvider);
    final vm = ref.read(notificationsViewModelProvider.notifier);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Notifications'),
        actions: [
          if (state.items.any((n) => !n.isRead))
            TextButton(
              onPressed: vm.markAllRead,
              child: const Text('Mark all read'),
            ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: vm.load,
        child: _body(context, state, vm),
      ),
    );
  }

  Widget _body(
    BuildContext context,
    NotificationsState state,
    NotificationsViewModel vm,
  ) {
    if (state.isLoading && state.items.isEmpty) {
      return const _NotificationsSkeletonList();
    }

    if (state.error != null && state.items.isEmpty) {
      return ListView(
        children: [
          const SizedBox(height: 120),
          Center(
            child: Column(
              children: [
                Text(state.error!),
                const SizedBox(height: 12),
                OutlinedButton(onPressed: vm.load, child: const Text('Retry')),
              ],
            ),
          ),
        ],
      );
    }

    if (state.items.isEmpty) {
      return ListView(
        children: const [
          SizedBox(height: 120),
          Center(child: Text('No notifications yet')),
        ],
      );
    }

    return ListView.separated(
      controller: _scrollController,
      itemCount: state.items.length + (state.isLoadingMore ? 1 : 0),
      separatorBuilder: (_, _) => const Divider(height: 1),
      itemBuilder: (context, index) {
        if (index >= state.items.length) {
          return const Padding(
            padding: EdgeInsets.all(16),
            child: SkeletonListTile(trailingWidth: 36),
          );
        }
        return _NotificationTile(
          item: state.items[index],
          onTap: () => _onTap(context, vm, state.items[index]),
        );
      },
    );
  }

  Future<void> _onTap(
    BuildContext context,
    NotificationsViewModel vm,
    NotificationModel item,
  ) async {
    if (!item.isRead) {
      vm.markRead(item.id);
    }
    if (item.bookingId != null) {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
          builder: (_) => const BottomNavigationPage(initialIndex: 2),
        ),
        (route) => false,
      );
      return;
    }
    if (item.postId != null) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => PostViewPage(postId: item.postId!)),
      );
    }
  }
}

class _NotificationsSkeletonList extends StatelessWidget {
  const _NotificationsSkeletonList();

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      itemCount: 8,
      separatorBuilder: (_, _) => const Divider(height: 1),
      itemBuilder: (_, _) => const SkeletonListTile(trailingWidth: 32),
    );
  }
}

class _NotificationTile extends StatelessWidget {
  final NotificationModel item;
  final VoidCallback onTap;

  const _NotificationTile({required this.item, required this.onTap});

  String _actionText(String type) {
    switch (type) {
      case 'like':
        return 'liked your post';
      case 'comment':
        return 'commented on your post';
      case 'reply':
        return 'replied to your comment';
      case 'booking_new':
        return 'booked your service';
      case 'booking_confirmed':
        return 'confirmed your booking';
      case 'booking_rejected':
        return 'declined your booking';
      case 'booking_cancelled':
        return 'cancelled their booking';
      case 'booking_completed':
        return 'marked your booking as completed';
      case 'booking_rescheduled':
        return 'rescheduled their booking';
      default:
        return 'sent you a notification';
    }
  }

  IconData _leadingIcon(String type) {
    switch (type) {
      case 'like':
        return Icons.favorite;
      case 'comment':
      case 'reply':
        return Icons.mode_comment;
      case 'booking_new':
        return Icons.event_available;
      case 'booking_confirmed':
      case 'booking_completed':
        return Icons.check_circle;
      case 'booking_rejected':
      case 'booking_cancelled':
        return Icons.cancel;
      case 'booking_rescheduled':
        return Icons.schedule;
      default:
        return Icons.notifications;
    }
  }

  Color _leadingColor(String type, ColorScheme scheme) {
    switch (type) {
      case 'like':
        return scheme.error;
      case 'comment':
      case 'reply':
        return scheme.primary;
      case 'booking_new':
      case 'booking_rescheduled':
        return scheme.tertiary;
      case 'booking_confirmed':
      case 'booking_completed':
        return scheme.secondary;
      case 'booking_rejected':
      case 'booking_cancelled':
        return scheme.error;
      default:
        return scheme.onSurfaceVariant;
    }
  }

  String _relativeTime(DateTime dt) {
    final diff = DateTime.now().difference(dt);
    if (diff.inSeconds < 60) return 'now';
    if (diff.inMinutes < 60) return '${diff.inMinutes}m';
    if (diff.inHours < 24) return '${diff.inHours}h';
    if (diff.inDays < 7) return '${diff.inDays}d';
    return '${(diff.inDays / 7).floor()}w';
  }

  @override
  Widget build(BuildContext context) {
    final avatar = item.actor.profilePicture;
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;

    return InkWell(
      onTap: onTap,
      child: Container(
        color: item.isRead
            ? null
            : theme.colorScheme.primary.withValues(alpha: 0.06),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              clipBehavior: Clip.none,
              children: [
                CircleAvatar(
                  radius: 22,
                  backgroundImage: avatar != null ? NetworkImage(avatar) : null,
                  child: avatar == null
                      ? Text(
                          item.actor.username.isNotEmpty
                              ? item.actor.username[0].toUpperCase()
                              : '?',
                        )
                      : null,
                ),
                Positioned(
                  right: -2,
                  bottom: -2,
                  child: Container(
                    padding: const EdgeInsets.all(3),
                    decoration: BoxDecoration(
                      color: _leadingColor(item.type, scheme),
                      shape: BoxShape.circle,
                      border: Border.all(color: scheme.surface, width: 1.5),
                    ),
                    child: Icon(
                      _leadingIcon(item.type),
                      color: scheme.surface,
                      size: 12,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  RichText(
                    text: TextSpan(
                      style: theme.textTheme.bodyMedium,
                      children: [
                        TextSpan(
                          text: item.actor.username,
                          style: const TextStyle(fontWeight: FontWeight.w600),
                        ),
                        const TextSpan(text: ' '),
                        TextSpan(text: _actionText(item.type)),
                      ],
                    ),
                  ),
                  if (item.preview != null && item.preview!.isNotEmpty) ...[
                    const SizedBox(height: 4),
                    Text(
                      item.preview!,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.onSurface.withValues(
                          alpha: 0.7,
                        ),
                      ),
                    ),
                  ],
                  const SizedBox(height: 4),
                  Text(
                    _relativeTime(item.createdAt),
                    style: theme.textTheme.labelSmall?.copyWith(
                      color: theme.colorScheme.onSurface.withValues(alpha: 0.5),
                    ),
                  ),
                ],
              ),
            ),
            if (!item.isRead)
              Container(
                margin: const EdgeInsets.only(left: 8, top: 6),
                width: 8,
                height: 8,
                decoration: BoxDecoration(
                  color: theme.colorScheme.primary,
                  shape: BoxShape.circle,
                ),
              ),
          ],
        ),
      ),
    );
  }
}
