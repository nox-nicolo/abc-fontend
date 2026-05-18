import 'package:africa_beuty/core/push/push_notification_service.dart';
import 'package:flutter/material.dart';

class WelcomePermissionsPage extends StatefulWidget {
  const WelcomePermissionsPage({super.key});

  @override
  State<WelcomePermissionsPage> createState() => _WelcomePermissionsPageState();
}

class _WelcomePermissionsPageState extends State<WelcomePermissionsPage> {
  bool _requesting = false;
  PushPermissionResult? _notificationResult;

  Future<void> _requestNotifications() async {
    if (_requesting) return;

    setState(() => _requesting = true);
    final result = await PushNotificationService.instance
        .requestNotificationPermission();
    if (!mounted) return;

    setState(() {
      _notificationResult = result;
      _requesting = false;
    });
  }

  Future<void> _openSettings() async {
    await PushNotificationService.instance.openNotificationSettings();
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return DecoratedBox(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            scheme.primaryContainer.withValues(alpha: 0.52),
            scheme.surface,
          ],
        ),
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(24, 48, 24, 128),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Stay in control',
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                'We ask only when it helps the experience. You can change these later in settings.',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: scheme.onSurfaceVariant,
                  height: 1.45,
                ),
              ),
              const SizedBox(height: 28),
              _PermissionTile(
                icon: Icons.notifications_active_outlined,
                title: 'Booking and message alerts',
                message:
                    'Get notified when a salon accepts a booking, sends a message, or updates your appointment.',
                action: _notificationAction(),
                status: _notificationStatus(),
              ),
              const SizedBox(height: 14),
              const _PermissionTile(
                icon: Icons.location_on_outlined,
                title: 'Nearby salons',
                message:
                    'Location is requested only when you use nearby search, so results can match where you are.',
                status: 'Asked later',
              ),
              const Spacer(),
              Text(
                'Tip: you can continue even if you skip notifications.',
                style: Theme.of(context).textTheme.labelMedium?.copyWith(
                  color: scheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _notificationAction() {
    if (_notificationResult == PushPermissionResult.granted) {
      return const Icon(Icons.check_circle_rounded);
    }

    if (_notificationResult == PushPermissionResult.permanentlyDenied) {
      return TextButton.icon(
        onPressed: _openSettings,
        icon: const Icon(Icons.settings_outlined),
        label: const Text('Open settings'),
      );
    }

    return FilledButton.icon(
      onPressed: _requesting ? null : _requestNotifications,
      icon: _requesting
          ? const SizedBox(
              width: 16,
              height: 16,
              child: CircularProgressIndicator(strokeWidth: 2),
            )
          : const Icon(Icons.notifications_active_outlined),
      label: Text(
        _notificationResult == PushPermissionResult.denied
            ? 'Try again'
            : 'Enable',
      ),
    );
  }

  String _notificationStatus() {
    return switch (_notificationResult) {
      PushPermissionResult.granted => 'Enabled',
      PushPermissionResult.denied => 'Not enabled. You can try again.',
      PushPermissionResult.permanentlyDenied => 'Disabled in system settings.',
      PushPermissionResult.unavailable => 'Unavailable on this device.',
      null => 'Recommended',
    };
  }
}

class _PermissionTile extends StatelessWidget {
  const _PermissionTile({
    required this.icon,
    required this.title,
    required this.message,
    required this.status,
    this.action,
  });

  final IconData icon;
  final String title;
  final String message;
  final String status;
  final Widget? action;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: scheme.surface,
        border: Border.all(color: scheme.outlineVariant),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(icon, color: scheme.primary),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      message,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: scheme.onSurfaceVariant,
                        height: 1.35,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          Row(
            children: [
              Expanded(
                child: Text(
                  status,
                  style: Theme.of(context).textTheme.labelMedium?.copyWith(
                    color: scheme.onSurfaceVariant,
                  ),
                ),
              ),
              if (action != null) action!,
            ],
          ),
        ],
      ),
    );
  }
}
