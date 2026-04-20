import 'package:africa_beuty/feature/post/view/page/view_post.dart';
import 'package:africa_beuty/feature/profile/model/salon_activity.dart';
import 'package:africa_beuty/feature/profile/view/page/view_profile.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:icons_plus/icons_plus.dart';

class ActivityFeedTile extends StatelessWidget {
  final ActivityItem item;

  const ActivityFeedTile({super.key, required this.item});

  bool get _isSystem =>
      item.type.startsWith('system_') || item.type.startsWith('admin_');

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final tappable = !_isSystem && _targetFor(item) != null;

    return ListTile(
      leading: _buildAvatar(scheme),
      title: Text(
        item.message,
        style: Theme.of(context).textTheme.bodyMedium,
        maxLines: 2,
        overflow: TextOverflow.ellipsis,
      ),
      subtitle: Text(
        _formatTimeAgo(item.createdAt),
        style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: scheme.onSurfaceVariant,
            ),
      ),
      trailing: _buildIcon(scheme),
      onTap: tappable ? () => _handleTap(context) : null,
    );
  }

  void _handleTap(BuildContext context) {
    final page = _targetFor(item);
    if (page == null) return;
    Navigator.of(context).push(MaterialPageRoute(builder: (_) => page));
  }

  /// Returns the destination page for this activity, or null if non-navigable.
  static Widget? _targetFor(ActivityItem item) {
    final refId = item.refId;
    if (refId == null || refId.isEmpty) return null;

    switch (item.type) {
      case 'post_like':
        return PostViewPage(postId: refId);
      case 'follower_new':
        // actor is a customer user; open their profile view
        return ViewProfilePage(isServiceProfile: false, userId: refId);
      default:
        return null;
    }
  }

  Widget _buildAvatar(ColorScheme scheme) {
    final pic = item.actor?.profilePicture;
    if (pic != null && pic.isNotEmpty) {
      return CircleAvatar(
        radius: 20,
        backgroundColor: scheme.surfaceContainerHighest,
        child: ClipOval(
          child: CachedNetworkImage(
            imageUrl: pic,
            width: 40,
            height: 40,
            fit: BoxFit.cover,
            errorWidget: (_, __, ___) => Icon(
              Icons.person,
              size: 20,
              color: scheme.onSurfaceVariant,
            ),
          ),
        ),
      );
    }

    if (_isSystem) {
      return CircleAvatar(
        radius: 20,
        backgroundColor: scheme.primaryContainer,
        child: Icon(Bootstrap.megaphone, size: 20, color: scheme.primary),
      );
    }

    return CircleAvatar(
      radius: 20,
      backgroundColor: scheme.surfaceContainerHighest,
      child: Icon(Icons.person, size: 20, color: scheme.onSurfaceVariant),
    );
  }

  Widget _buildIcon(ColorScheme scheme) {
    switch (item.type) {
      case 'booking_new':
        return Icon(Bootstrap.calendar_plus, size: 18, color: scheme.primary);
      case 'booking_completed':
        return Icon(Bootstrap.calendar_check, size: 18, color: Colors.green);
      case 'booking_cancelled':
        return Icon(Bootstrap.calendar_x, size: 18, color: Colors.red.shade400);
      case 'follower_new':
        return Icon(Bootstrap.person_plus, size: 18, color: scheme.primary);
      case 'review_new':
        return Icon(Bootstrap.star_fill, size: 18, color: Colors.amber);
      case 'post_like':
        return Icon(Bootstrap.heart_fill, size: 16, color: Colors.red.shade500);
      default:
        return Icon(Bootstrap.bell, size: 18, color: scheme.onSurfaceVariant);
    }
  }

  static String _formatTimeAgo(String isoString) {
    try {
      final dt = DateTime.parse(isoString);
      final diff = DateTime.now().difference(dt);

      if (diff.inSeconds < 60) return 'Just now';
      if (diff.inMinutes < 60) return '${diff.inMinutes}m ago';
      if (diff.inHours < 24) return '${diff.inHours}h ago';
      if (diff.inDays < 7) return '${diff.inDays}d ago';
      if (diff.inDays < 30) return '${(diff.inDays / 7).floor()}w ago';
      if (diff.inDays < 365) return '${(diff.inDays / 30).floor()}mo ago';
      return '${(diff.inDays / 365).floor()}y ago';
    } catch (_) {
      return isoString;
    }
  }
}
