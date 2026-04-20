import 'package:africa_beuty/feature/profile/view/page/appointment_reminders.dart';
import 'package:flutter/material.dart';

class AppointmentSettingsPage extends StatelessWidget {
  const AppointmentSettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(title: const Text('Appointments')),
      body: ListView(
        children: [
          const SizedBox(height: 8),
          ListTile(
            leading: Icon(
              Icons.notifications_active_outlined,
              color: theme.colorScheme.secondary,
            ),
            title: const Text('Reminders'),
            subtitle: const Text('Allow reminders, how long before'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const AppointmentRemindersPage(),
                ),
              );
            },
          ),
          ListTile(
            enabled: false,
            leading: Icon(
              Icons.chat_bubble_outline,
              color: theme.colorScheme.secondary,
            ),
            title: const Text('Communication'),
            subtitle: const Text('Coming soon'),
            trailing: const Icon(Icons.chevron_right),
          ),
          ListTile(
            enabled: false,
            leading: Icon(
              Icons.event_busy_outlined,
              color: theme.colorScheme.secondary,
            ),
            title: const Text('Cancellation policy'),
            subtitle: const Text('Coming soon'),
            trailing: const Icon(Icons.chevron_right),
          ),
        ],
      ),
    );
  }
}
