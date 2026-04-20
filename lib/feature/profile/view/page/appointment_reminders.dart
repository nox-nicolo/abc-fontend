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

    return Scaffold(
      appBar: AppBar(title: const Text('Reminders')),
      body: state.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, _) => Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Text(
              err.toString(),
              textAlign: TextAlign.center,
              style: TextStyle(color: theme.colorScheme.error),
            ),
          ),
        ),
        data: (prefs) => ListView(
          children: [
            SwitchListTile(
              value: prefs.allowReminders,
              onChanged: (v) => vm.update(allowReminders: v),
              title: const Text('Allow reminders'),
              subtitle: const Text(
                'Get a local notification before your booking starts',
              ),
            ),
            const Divider(height: 1),
            ListTile(
              enabled: prefs.allowReminders,
              title: const Text('Remind me'),
              subtitle: Text(_labelFor(prefs.reminderLeadMinutes)),
              trailing: const Icon(Icons.chevron_right),
              onTap: prefs.allowReminders
                  ? () => _pickLeadTime(context, prefs, vm)
                  : null,
            ),
            const SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                'Reminders are scheduled on this device. They will fire even without an internet connection, but may not work if you reinstall the app or clear its data.',
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
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
      builder: (ctx) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Padding(
              padding: EdgeInsets.all(16),
              child: Text(
                'Remind me before',
                style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
              ),
            ),
            for (final m in NotificationPreferences.allowedLeadMinutes)
              RadioListTile<int>(
                value: m,
                groupValue: prefs.reminderLeadMinutes,
                onChanged: (v) => Navigator.pop(ctx, v),
                title: Text(_labelFor(m)),
              ),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
    if (picked != null && picked != prefs.reminderLeadMinutes) {
      await vm.update(reminderLeadMinutes: picked);
    }
  }
}
