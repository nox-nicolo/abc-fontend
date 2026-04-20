import 'package:africa_beuty/feature/notifications/view/page/notifications_page.dart';
import 'package:africa_beuty/feature/notifications/view_model/notification.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:icons_plus/icons_plus.dart';

class NotificationsBell extends ConsumerWidget {
  final double iconSize;

  const NotificationsBell({super.key, this.iconSize = 24});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final unread = ref.watch(unreadCountProvider);

    return IconButton(
      onPressed: () async {
        await Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const NotificationsPage()),
        );
        ref.invalidate(unreadCountProvider);
      },
      icon: Stack(
        clipBehavior: Clip.none,
        children: [
          Icon(Bootstrap.bell, size: iconSize),
          unread.when(
            loading: () => const SizedBox.shrink(),
            error: (_, __) => const SizedBox.shrink(),
            data: (count) {
              if (count <= 0) return const SizedBox.shrink();
              final label = count > 99 ? '99+' : '$count';
              return Positioned(
                right: -6,
                top: -4,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 5,
                    vertical: 2,
                  ),
                  constraints: const BoxConstraints(minWidth: 16, minHeight: 16),
                  decoration: BoxDecoration(
                    color: Colors.red,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: Colors.white, width: 1.2),
                  ),
                  child: Text(
                    label,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 10,
                      fontWeight: FontWeight.w600,
                      height: 1.1,
                    ),
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
