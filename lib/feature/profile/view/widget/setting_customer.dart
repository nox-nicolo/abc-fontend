import 'package:africa_beuty/feature/profile/view/page/appointment_settings.dart';
import 'package:africa_beuty/feature/profile/view/page/edit_customer_profile.dart';
import 'package:flutter/material.dart';
import 'package:icons_plus/icons_plus.dart';

class CustomerSettings extends StatefulWidget {
  const CustomerSettings({super.key});

  @override
  State<CustomerSettings> createState() => _CustomerSettingsState();
}

class _CustomerSettingsState extends State<CustomerSettings> {

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return SingleChildScrollView(
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.only(bottom: 16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 16,),
            Center(
              child: Text(
                'Settings', 
                style: Theme.of(context).textTheme.titleLarge,
              ),
            ), 
            const SizedBox(height: 16,), 
            ListTile(
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const EditCustomerProfilePage(),
                  ),
                );
              },
              leading: Icon(Icons.edit, color: theme.colorScheme.secondary),
              title: const Text('Edit'),
              subtitle: const Text('Name, bio, city, country...'),
            ),
            const SizedBox(height: 10,), 
            ListTile(
              leading: Icon(FontAwesome.lock_solid, color: theme.colorScheme.secondary,),
              title: Text('Privacy'),
              subtitle: Text('user data'),
            ),
            const SizedBox(height: 10,), 
            ListTile(
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const AppointmentSettingsPage(),
                  ),
                );
              },
              leading: Icon(FontAwesome.calendar_check, color: theme.colorScheme.secondary,),
              title: Text('Appointment'),
              subtitle: Text('Reminders'),
            ),
            const SizedBox(height: 10,), 
            ListTile(
              leading: Icon(FontAwesome.shield_solid, color: theme.colorScheme.secondary,),
              title: Text('Security'),
              subtitle: Text('Two-factor authentication, Change password'),
            ), 
            const SizedBox(height: 10,), 
            ListTile(
              leading: Icon(FontAwesome.database_solid, color: theme.colorScheme.secondary,),
              title: Text('Storage and Data'),
              subtitle: Text('Network usage, Storage'),
            ), 
            const SizedBox(height: 10,), 
            ListTile(
              leading: Icon(FontAwesome.bell_solid, color: theme.colorScheme.secondary,),
              title: Text('Notification'),
              subtitle: Text('Notification preferences'),
            ), 
            const SizedBox(height: 10,), 
            ListTile(
              leading: Icon(FontAwesome.sliders_solid, color: theme.colorScheme.secondary,),
              title: Text('Account'),
              subtitle: Text('Delete, Manage contents'),
            ), 
            const SizedBox(height: 10,), 
            ListTile(
              leading: Icon(FontAwesome.globe_solid, color: theme.colorScheme.secondary,),
              title: Text('Language'),
              subtitle: Text('English, Device language'),
            ),

            const SizedBox(height: 18),
            const Divider(),
            const SizedBox(height: 8),

            ListTile(
              onTap: () {
                Navigator.pushNamed(context, '/logout');
              },
              leading: Icon(
                Icons.logout_rounded,
                color: theme.colorScheme.error,
              ),
              title: Text(
                'Logout',
                style: TextStyle(
                  color: theme.colorScheme.error,
                  fontWeight: FontWeight.w600,
                ),
              ),
              subtitle: Text(
                'Sign out from this account',
                style: TextStyle(
                  color: theme.colorScheme.error.withValues(alpha: 0.75),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}