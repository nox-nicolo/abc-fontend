import 'package:africa_beuty/feature/chat/view/widget/single_chat_page.dart';
import 'package:africa_beuty/feature/notifications/model/notification.dart';
import 'package:africa_beuty/feature/profile/view/widget/view_salon_profile.dart';
import 'package:flutter/material.dart';

class CampaignNotificationPage extends StatelessWidget {
  const CampaignNotificationPage({super.key, required this.notification});

  final NotificationModel notification;

  bool get _isPromotion => notification.isPromotionCampaign;

  String? get _salonId {
    final salonId = notification.actor.salonId;
    if (salonId != null && salonId.isNotEmpty) return salonId;
    return null;
  }

  String get _title => _isPromotion ? 'Salon offer' : 'Salon event';

  String get _message {
    final preview = notification.preview?.trim();
    if (preview != null && preview.isNotEmpty) return preview;
    return _isPromotion
        ? '${notification.actor.username} shared a new promotion.'
        : '${notification.actor.username} shared a new event.';
  }

  String get _chatMessage {
    final subject = _isPromotion ? 'offer' : 'event';
    return 'Hi ${notification.actor.username}, I saw your $subject and I would like to know more.';
  }

  void _openSalon(BuildContext context) {
    final salonId = _salonId;
    if (salonId == null) return;
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => ViewServiceProfilePage(salonId: salonId),
      ),
    );
  }

  void _openChat(BuildContext context) {
    final salonId = _salonId;
    if (salonId == null) return;
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => SingleChatPage(
          salonId: salonId,
          initialTitle: notification.actor.username,
          initialMessage: _chatMessage,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final avatar = notification.actor.profilePicture;
    final hasSalonLink = _salonId != null;

    return Scaffold(
      appBar: AppBar(title: Text(_title)),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 28),
        children: [
          Container(
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              color: scheme.surfaceContainerHighest.withValues(alpha: 0.55),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: scheme.outlineVariant),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    CircleAvatar(
                      radius: 28,
                      backgroundImage: avatar != null
                          ? NetworkImage(avatar)
                          : null,
                      child: avatar == null
                          ? Text(
                              notification.actor.username.isNotEmpty
                                  ? notification.actor.username[0].toUpperCase()
                                  : '?',
                            )
                          : null,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            notification.actor.username,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: theme.textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                          const SizedBox(height: 3),
                          Text(
                            _isPromotion
                                ? 'Promotion campaign'
                                : 'Event invitation',
                            style: theme.textTheme.labelMedium?.copyWith(
                              color: scheme.onSurfaceVariant,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Icon(
                      _isPromotion
                          ? Icons.local_offer_rounded
                          : Icons.celebration_rounded,
                      color: scheme.primary,
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                Text(
                  _isPromotion ? 'Exclusive offer' : 'Upcoming event',
                  style: theme.textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  _message,
                  style: theme.textTheme.bodyLarge?.copyWith(height: 1.42),
                ),
                if (!hasSalonLink) ...[
                  const SizedBox(height: 16),
                  _Notice(
                    icon: Icons.link_off_rounded,
                    text:
                        'This notification is missing its salon link. New campaign notifications will open the salon directly.',
                  ),
                ],
              ],
            ),
          ),
          const SizedBox(height: 16),
          FilledButton.icon(
            onPressed: hasSalonLink ? () => _openSalon(context) : null,
            icon: const Icon(Icons.event_available_rounded),
            label: const Text('Book from salon'),
          ),
          const SizedBox(height: 10),
          OutlinedButton.icon(
            onPressed: hasSalonLink ? () => _openChat(context) : null,
            icon: const Icon(Icons.chat_bubble_outline_rounded),
            label: const Text('Ask salon'),
          ),
          const SizedBox(height: 10),
          TextButton.icon(
            onPressed: hasSalonLink ? () => _openSalon(context) : null,
            icon: const Icon(Icons.storefront_rounded),
            label: const Text('View salon profile'),
          ),
        ],
      ),
    );
  }
}

class _Notice extends StatelessWidget {
  const _Notice({required this.icon, required this.text});

  final IconData icon;
  final String text;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: scheme.errorContainer.withValues(alpha: 0.34),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 18, color: scheme.error),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              text,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: scheme.onSurface,
                height: 1.35,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
