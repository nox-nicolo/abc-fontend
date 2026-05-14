import 'package:africa_beuty/feature/profile/model/notification_preferences.dart';
import 'package:africa_beuty/feature/profile/view_model/notification_preferences.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AppointmentRemindersPage extends ConsumerWidget {
  const AppointmentRemindersPage({super.key});

  String _labelFor(int minutes) {
    if (minutes < 60) return '$minutes minutes before';
    final hours = minutes ~/ 60;
    return hours == 1 ? '1 hour before' : '$hours hours before';
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(notificationPreferencesViewModelProvider);
    final vm = ref.read(notificationPreferencesViewModelProvider.notifier);
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;

    return Scaffold(
      appBar: AppBar(title: const Text('Notifications')),
      body: state.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, _) => Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Text(
              err.toString(),
              textAlign: TextAlign.center,
              style: TextStyle(color: scheme.error),
            ),
          ),
        ),
        data: (prefs) => ListView(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
          children: [
            _PremiumHeader(
              enabledCount: [
                prefs.allowComments,
                prefs.allowBookings,
                prefs.allowPromotions,
                prefs.allowReminders,
              ].where((enabled) => enabled).length,
            ),
            const SizedBox(height: 16),
            _SettingsGroup(
              title: 'Activity',
              children: [
                _PremiumSwitchTile(
                  value: prefs.allowComments,
                  title: 'Comments & replies',
                  subtitle: 'Replies from salons and updates on conversations',
                  icon: Icons.mode_comment_outlined,
                  onChanged: (v) => vm.update(allowComments: v),
                ),
              ],
            ),
            const SizedBox(height: 14),
            _SettingsGroup(
              title: 'Bookings',
              children: [
                _PremiumSwitchTile(
                  value: prefs.allowBookings,
                  title: 'Booking updates',
                  subtitle:
                      'Confirmations, schedule changes, and status alerts',
                  icon: Icons.event_available_outlined,
                  onChanged: (v) => vm.update(allowBookings: v),
                ),
                _PremiumSwitchTile(
                  value: prefs.allowReminders,
                  title: 'Smart reminders',
                  subtitle: 'A local alert before your appointment starts',
                  icon: Icons.notifications_active_outlined,
                  onChanged: (v) => vm.update(allowReminders: v),
                ),
                _ReminderTimingTile(
                  enabled: prefs.allowReminders,
                  label: _labelFor(prefs.reminderLeadMinutes),
                  onTap: prefs.allowReminders
                      ? () => _pickLeadTime(context, prefs, vm)
                      : null,
                ),
              ],
            ),
            const SizedBox(height: 14),
            _SettingsGroup(
              title: 'Salons',
              children: [
                _PremiumSwitchTile(
                  value: prefs.allowPromotions,
                  title: 'Offers & events',
                  subtitle:
                      'Promotions and campaigns from salons you engage with',
                  icon: Icons.campaign_outlined,
                  onChanged: (v) => vm.update(allowPromotions: v),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _pickLeadTime(
    BuildContext context,
    NotificationPreferences prefs,
    NotificationPreferencesViewModel vm,
  ) async {
    final picked = await showModalBottomSheet<int>(
      context: context,
      useSafeArea: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(8)),
      ),
      builder: (ctx) {
        final scheme = Theme.of(ctx).colorScheme;

        return Padding(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: scheme.outlineVariant,
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
              const SizedBox(height: 18),
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Reminder timing',
                  style: Theme.of(ctx).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
              const SizedBox(height: 8),
              for (final minutes in NotificationPreferences.allowedLeadMinutes)
                _LeadTimeOption(
                  selected: minutes == prefs.reminderLeadMinutes,
                  label: _labelFor(minutes),
                  onTap: () => Navigator.pop(ctx, minutes),
                ),
            ],
          ),
        );
      },
    );

    if (picked != null && picked != prefs.reminderLeadMinutes) {
      await vm.update(reminderLeadMinutes: picked);
    }
  }
}

class _PremiumHeader extends StatelessWidget {
  const _PremiumHeader({required this.enabledCount});

  final int enabledCount;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: scheme.secondaryContainer,
      ),
      child: Row(
        children: [
          Container(
            width: 46,
            height: 46,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: scheme.onSecondaryContainer.withValues(alpha: 0.12),
            ),
            child: Icon(
              Icons.notifications_active_outlined,
              color: scheme.onSecondaryContainer,
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Customer notification suite',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: scheme.onSecondaryContainer,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '$enabledCount of 4 channels active',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: scheme.onSecondaryContainer.withValues(alpha: 0.78),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _SettingsGroup extends StatelessWidget {
  const _SettingsGroup({required this.title, required this.children});

  final String title;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 4, bottom: 8),
          child: Text(
            title,
            style: Theme.of(context).textTheme.labelLarge?.copyWith(
              color: scheme.onSurfaceVariant,
              fontWeight: FontWeight.w800,
            ),
          ),
        ),
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            color: scheme.surface,
            border: Border.all(color: scheme.outlineVariant),
          ),
          child: Column(children: children),
        ),
      ],
    );
  }
}

class _PremiumSwitchTile extends StatelessWidget {
  const _PremiumSwitchTile({
    required this.value,
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.onChanged,
  });

  final bool value;
  final String title;
  final String subtitle;
  final IconData icon;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return Column(
      children: [
        ListTile(
          minVerticalPadding: 14,
          leading: _IconBadge(icon: icon, active: value),
          title: Text(
            title,
            style: const TextStyle(fontWeight: FontWeight.w700),
          ),
          subtitle: Padding(
            padding: const EdgeInsets.only(top: 3),
            child: Text(subtitle),
          ),
          trailing: Switch.adaptive(value: value, onChanged: onChanged),
        ),
        Divider(height: 1, indent: 72, color: scheme.outlineVariant),
      ],
    );
  }
}

class _ReminderTimingTile extends StatelessWidget {
  const _ReminderTimingTile({
    required this.enabled,
    required this.label,
    required this.onTap,
  });

  final bool enabled;
  final String label;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return ListTile(
      enabled: enabled,
      minVerticalPadding: 14,
      leading: _IconBadge(icon: Icons.schedule_outlined, active: enabled),
      title: const Text(
        'Reminder timing',
        style: TextStyle(fontWeight: FontWeight.w700),
      ),
      subtitle: Padding(
        padding: const EdgeInsets.only(top: 3),
        child: Text(label),
      ),
      trailing: Icon(Icons.chevron_right, color: scheme.onSurfaceVariant),
      onTap: onTap,
    );
  }
}

class _LeadTimeOption extends StatelessWidget {
  const _LeadTimeOption({
    required this.selected,
    required this.label,
    required this.onTap,
  });

  final bool selected;
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return Padding(
      padding: const EdgeInsets.only(top: 8),
      child: Material(
        color: selected ? scheme.secondaryContainer : scheme.surface,
        borderRadius: BorderRadius.circular(8),
        child: InkWell(
          borderRadius: BorderRadius.circular(8),
          onTap: onTap,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: selected ? scheme.secondary : scheme.outlineVariant,
              ),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    label,
                    style: TextStyle(
                      fontWeight: selected ? FontWeight.w800 : FontWeight.w600,
                    ),
                  ),
                ),
                if (selected) Icon(Icons.check_circle, color: scheme.secondary),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _IconBadge extends StatelessWidget {
  const _IconBadge({required this.icon, required this.active});

  final IconData icon;
  final bool active;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return Container(
      width: 42,
      height: 42,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: active
            ? scheme.secondaryContainer
            : scheme.surfaceContainerHighest,
      ),
      child: Icon(
        icon,
        color: active ? scheme.onSecondaryContainer : scheme.onSurfaceVariant,
      ),
    );
  }
}
