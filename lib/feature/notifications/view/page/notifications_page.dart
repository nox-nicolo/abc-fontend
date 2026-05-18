import 'package:africa_beuty/core/widgets/app_state.dart';
import 'package:africa_beuty/core/push/push_notification_service.dart';
import 'package:africa_beuty/core/widgets/skeleton.dart';
import 'package:africa_beuty/feature/booking/view/pages/customer_booking_detail.dart';
import 'package:africa_beuty/feature/chat/view/page/chats_page.dart';
import 'package:africa_beuty/feature/notifications/model/notification.dart';
import 'package:africa_beuty/feature/notifications/view_model/notification.dart';
import 'package:africa_beuty/feature/post/view/page/view_post.dart';
import 'package:africa_beuty/feature/profile/view/page/view_profile.dart';
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
          AppErrorState(message: state.error!, onRetry: vm.load),
        ],
      );
    }

    if (state.items.isEmpty) {
      return ListView(
        children: const [
          _NotificationPermissionPrompt(),
          SizedBox(height: 120),
          AppEmptyState(
            icon: Icons.notifications_none_rounded,
            title: 'No notifications yet',
            message: 'Updates about bookings, posts, and messages show here.',
          ),
        ],
      );
    }

    return ListView.separated(
      controller: _scrollController,
      itemCount: state.items.length + (state.isLoadingMore ? 1 : 0) + 1,
      separatorBuilder: (_, _) => const Divider(height: 1),
      itemBuilder: (context, index) {
        if (index == 0) return const _NotificationPermissionPrompt();

        final itemIndex = index - 1;
        if (itemIndex >= state.items.length) {
          return const Padding(
            padding: EdgeInsets.all(16),
            child: SkeletonListTile(trailingWidth: 36),
          );
        }
        return _NotificationTile(
          item: state.items[itemIndex],
          onTap: () => _onTap(context, vm, state.items[itemIndex]),
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

    if (item.type == 'welcome') {
      return;
    }

    final bookingId = item.bookingId;
    if (bookingId != null && bookingId.isNotEmpty) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => CustomerBookingDetailPage(bookingId: bookingId),
        ),
      );
      return;
    }

    final postId = item.postId;
    if (postId != null && postId.isNotEmpty) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => PostViewPage(
            postId: postId,
            openComments: item.commentId != null && item.commentId!.isNotEmpty,
          ),
        ),
      );
      return;
    }

    if (item.type == 'message') {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => const ChatsPage()),
      );
      return;
    }

    final salonId = item.actor.salonId;
    if (item.actor.role == 'salon' && salonId != null && salonId.isNotEmpty) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) =>
              ViewProfilePage(isServiceProfile: true, userId: salonId),
        ),
      );
      return;
    }

    if (item.actor.id.isNotEmpty) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) =>
              ViewProfilePage(isServiceProfile: false, userId: item.actor.id),
        ),
      );
    }
  }
}

class _NotificationPermissionPrompt extends StatefulWidget {
  const _NotificationPermissionPrompt();

  @override
  State<_NotificationPermissionPrompt> createState() =>
      _NotificationPermissionPromptState();
}

class _NotificationPermissionPromptState
    extends State<_NotificationPermissionPrompt> {
  PushPermissionResult? _status;
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final status = await PushNotificationService.instance
        .notificationPermissionStatus();
    if (!mounted) return;
    setState(() {
      _status = status;
      _loading = false;
    });
  }

  Future<void> _request() async {
    setState(() => _loading = true);
    final status = await PushNotificationService.instance
        .requestNotificationPermission();
    if (!mounted) return;
    setState(() {
      _status = status;
      _loading = false;
    });
  }

  Future<void> _openSettings() async {
    await PushNotificationService.instance.openNotificationSettings();
    await _load();
  }

  @override
  Widget build(BuildContext context) {
    final status = _status;
    if (_loading || status == null || status == PushPermissionResult.granted) {
      return const SizedBox.shrink();
    }

    final scheme = Theme.of(context).colorScheme;
    final permanentlyDenied = status == PushPermissionResult.permanentlyDenied;

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: scheme.primaryContainer.withValues(alpha: 0.48),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: scheme.outlineVariant),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(Icons.notifications_active_outlined, color: scheme.primary),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Turn on notification alerts',
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    permanentlyDenied
                        ? 'Notifications are disabled in system settings.'
                        : 'Get booking, message, and salon updates as they happen.',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: scheme.onSurfaceVariant,
                      height: 1.35,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: TextButton.icon(
                      onPressed: permanentlyDenied ? _openSettings : _request,
                      icon: Icon(
                        permanentlyDenied
                            ? Icons.settings_outlined
                            : Icons.refresh_rounded,
                      ),
                      label: Text(
                        permanentlyDenied ? 'Open settings' : 'Try again',
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
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
      case 'welcome':
        return 'Welcome to African Beauty';
      case 'comment':
        return 'commented on your post';
      case 'reply':
        return 'replied to your comment';
      case 'message':
        return 'sent you a message';
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
      case 'booking_reminder_ai':
        return 'sent a booking reminder';
      default:
        return 'sent you a notification';
    }
  }

  IconData _leadingIcon(String type) {
    switch (type) {
      case 'like':
      case 'like_grouped':
        return Icons.favorite;
      case 'welcome':
        return Icons.auto_awesome;
      case 'comment':
      case 'reply':
        return Icons.mode_comment;
      case 'message':
        return Icons.chat_bubble;
      case 'booking_new':
        return Icons.event_available;
      case 'booking_confirmed':
      case 'booking_completed':
        return Icons.check_circle;
      case 'booking_rejected':
      case 'booking_cancelled':
        return Icons.cancel;
      case 'booking_rescheduled':
      case 'booking_reminder_ai':
        return Icons.schedule;
      default:
        return Icons.notifications;
    }
  }

  Color _leadingColor(String type, ColorScheme scheme) {
    switch (type) {
      case 'like':
      case 'like_grouped':
        return scheme.error;
      case 'welcome':
        return scheme.primary;
      case 'comment':
      case 'reply':
      case 'message':
        return scheme.primary;
      case 'booking_new':
      case 'booking_rescheduled':
      case 'booking_reminder_ai':
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
                  if (item.type == 'welcome')
                    Text(
                      _actionText(item.type),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                    )
                  else if (item.isGrouped &&
                      item.preview != null &&
                      item.preview!.isNotEmpty)
                    Text(
                      item.preview!,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    )
                  else
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
                  if (!item.isGrouped &&
                      item.preview != null &&
                      item.preview!.isNotEmpty) ...[
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
