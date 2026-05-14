import 'package:africa_beuty/feature/profile/view/page/appointment_settings.dart';
import 'package:africa_beuty/feature/profile/view/page/appointment_reminders.dart';
import 'package:africa_beuty/feature/profile/view/page/salon_event_campaign.dart';
import 'package:africa_beuty/feature/profile/view/page/settings/account_privacy_security.dart';
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
              title: const Text('Salon profile'),
              subtitle: const Text('Name, cover, gallery, contacts, location'),
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
              title: const Text('Campaigns'),
              subtitle: const Text('Promotions, discount codes, event notifications'),
            ),
            const SizedBox(height: 10),
            ListTile(
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const SalonPrivacySettingsPage(),
                  ),
                );
              },
              leading: Icon(
                FontAwesome.lock_solid,
                color: theme.colorScheme.secondary,
              ),
              title: const Text('Privacy'),
              subtitle: const Text('Salon visibility, messages, blocked customers'),
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
              title: const Text('Bookings'),
              subtitle: const Text('Working hours, booking rules, reminders'),
            ),
            const SizedBox(height: 10),
            ListTile(
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const SalonSecuritySettingsPage(),
                  ),
                );
              },
              leading: Icon(
                FontAwesome.shield_solid,
                color: theme.colorScheme.secondary,
              ),
              title: const Text('Security'),
              subtitle: const Text('2-step, owner approvals, devices, alerts'),
            ),
            ListTile(
              leading: Icon(
                FontAwesome.money_bill_solid,
                color: theme.colorScheme.secondary,
              ),
              title: const Text('Payments'),
              subtitle: const Text('Payment methods, payouts, invoices'),
            ),
            const SizedBox(height: 10),
            ListTile(
              leading: Icon(
                FontAwesome.circle_check_solid,
                color: theme.colorScheme.secondary,
              ),
              title: const Text('Storage and Data'),
              subtitle: const Text('Gallery cache, uploads, network usage'),
            ),
            const SizedBox(height: 10),
            ListTile(
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const AppointmentRemindersPage(),
                  ),
                );
              },
              leading: Icon(
                FontAwesome.bell_solid,
                color: theme.colorScheme.secondary,
              ),
              title: const Text('Notifications'),
              subtitle: const Text('Bookings, messages, comments, campaigns'),
            ),
            const SizedBox(height: 10),
            ListTile(
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const SalonAccountSettingsPage(),
                  ),
                );
              },
              leading: Icon(
                FontAwesome.key_solid,
                color: theme.colorScheme.secondary,
              ),
              title: const Text('Account'),
              subtitle: const Text('Services, stylists, ownership, closure'),
            ),
            const SizedBox(height: 10),
            ListTile(
              leading: Icon(
                FontAwesome.earth_africa_solid,
                color: theme.colorScheme.secondary,
              ),
              title: const Text('Language'),
              subtitle: const Text('English, device language'),
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
