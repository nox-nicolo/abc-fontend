import 'package:africa_beuty/feature/profile/view/page/appointment_settings.dart';
import 'package:africa_beuty/feature/profile/view/page/salon_event_campaign.dart';
import 'package:africa_beuty/feature/profile/view/widget/settings/edit_salon_profile.dart';
import 'package:flutter/material.dart';
import 'package:icons_plus/icons_plus.dart';

class SalonSetting extends StatefulWidget {
  const SalonSetting({super.key});

  @override
  State<SalonSetting> createState() => _SalonSettingState();
}

class _SalonSettingState extends State<SalonSetting> {
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
            const SizedBox(height: 16),
            Center(
              child: Text(
                'Settings',
                style: Theme.of(context).textTheme.titleLarge,
              ),
            ),
            const SizedBox(height: 16),
            ListTile(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const SalonProfileInformationPage(),
                  ),
                );
              },
              leading: Icon(Icons.edit, color: theme.colorScheme.secondary),
              title: Text('Edit'),
              subtitle: Text('username, phone number ...'),
            ),
            const SizedBox(height: 10),
            ListTile(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const SalonEventCampaignPage(),
                  ),
                );
              },
              leading: Icon(
                Icons.campaign_rounded,
                color: theme.colorScheme.secondary,
              ),
              title: Text('Campaigns'),
              subtitle: Text('Promotions, discount codes, event notifications'),
            ),
            const SizedBox(height: 10),
            ListTile(
              leading: Icon(
                FontAwesome.lock_solid,
                color: theme.colorScheme.secondary,
              ),
              title: Text('Privacy'),
              subtitle: Text('user data'),
            ),
            const SizedBox(height: 10),
            ListTile(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const AppointmentSettingsPage(),
                  ),
                );
              },
              leading: Icon(
                FontAwesome.person_falling_solid,
                color: theme.colorScheme.secondary,
              ),
              title: Text('Appointment'),
              subtitle: Text('Reminders'),
            ),
            const SizedBox(height: 10),
            ListTile(
              leading: Icon(
                FontAwesome.shield_solid,
                color: theme.colorScheme.secondary,
              ),
              title: Text('Security'),
              subtitle: Text('Two-factor authentication, Change password'),
            ),
            ListTile(
              leading: Icon(
                FontAwesome.money_bill_solid,
                color: theme.colorScheme.secondary,
              ),
              title: Text('Payments'),
              subtitle: Text('default payment, Add/manage payments'),
            ),
            const SizedBox(height: 10),
            ListTile(
              leading: Icon(
                FontAwesome.circle_check_solid,
                color: theme.colorScheme.secondary,
              ),
              title: Text('Storage and Data'),
              subtitle: Text('Network usage, Storage'),
            ),
            const SizedBox(height: 10),
            ListTile(
              leading: Icon(
                FontAwesome.bell_solid,
                color: theme.colorScheme.secondary,
              ),
              title: Text('Notification'),
              subtitle: Text('Notification preferences'),
            ),
            const SizedBox(height: 10),
            ListTile(
              leading: Icon(
                FontAwesome.key_solid,
                color: theme.colorScheme.secondary,
              ),
              title: Text('Account'),
              subtitle: Text('Delete, Manage contents'),
            ),
            const SizedBox(height: 10),
            ListTile(
              leading: Icon(
                FontAwesome.earth_africa_solid,
                color: theme.colorScheme.secondary,
              ),
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
                  color: theme.colorScheme.error.withOpacity(0.75),
                ),
              ),
            ),

            // And make su
          ],
        ),
      ),
    );
  }
}
