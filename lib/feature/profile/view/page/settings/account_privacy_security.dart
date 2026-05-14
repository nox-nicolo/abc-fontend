import 'package:flutter/material.dart';

class CustomerPrivacySettingsPage extends StatelessWidget {
  const CustomerPrivacySettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const _SettingsDetailPage(
      title: 'Privacy',
      subtitle: 'Control who can find you, message you, and see your activity.',
      groups: [
        _SettingsGroupData(
          title: 'Profile visibility',
          rows: [
            _SettingsRowData(
              icon: Icons.public_rounded,
              title: 'Discoverable profile',
              subtitle: 'Allow salons and people to find your profile.',
              toggle: true,
              initialValue: true,
            ),
            _SettingsRowData(
              icon: Icons.favorite_rounded,
              title: 'Show saved salons privately',
              subtitle: 'Keep saved salons visible only to you.',
              toggle: true,
              initialValue: true,
            ),
            _SettingsRowData(
              icon: Icons.people_alt_rounded,
              title: 'Following visibility',
              subtitle: 'Choose whether others can see salons you follow.',
              trailingText: 'Only me',
            ),
          ],
        ),
        _SettingsGroupData(
          title: 'Interactions',
          rows: [
            _SettingsRowData(
              icon: Icons.chat_bubble_rounded,
              title: 'Message requests',
              subtitle: 'Let salons message you after bookings or inquiries.',
              toggle: true,
              initialValue: true,
            ),
            _SettingsRowData(
              icon: Icons.alternate_email_rounded,
              title: 'Mentions and replies',
              subtitle: 'Control who can mention or reply to you.',
              trailingText: 'Everyone',
            ),
            _SettingsRowData(
              icon: Icons.block_rounded,
              title: 'Blocked and muted accounts',
              subtitle: 'Review salons, users, and posts you have hidden.',
              trailingText: 'Manage',
            ),
          ],
        ),
        _SettingsGroupData(
          title: 'Location and personalization',
          rows: [
            _SettingsRowData(
              icon: Icons.location_on_rounded,
              title: 'Nearby salon discovery',
              subtitle: 'Use approximate location to recommend salons.',
              toggle: true,
              initialValue: true,
            ),
            _SettingsRowData(
              icon: Icons.tune_rounded,
              title: 'Personalized recommendations',
              subtitle: 'Use your beauty interests to improve discovery.',
              toggle: true,
              initialValue: true,
            ),
          ],
        ),
      ],
    );
  }
}

class SalonPrivacySettingsPage extends StatelessWidget {
  const SalonPrivacySettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const _SettingsDetailPage(
      title: 'Privacy',
      subtitle: 'Shape how customers discover, contact, and interact with your salon.',
      groups: [
        _SettingsGroupData(
          title: 'Salon visibility',
          rows: [
            _SettingsRowData(
              icon: Icons.storefront_rounded,
              title: 'Public salon profile',
              subtitle: 'Allow customers to view services, posts, and location.',
              toggle: true,
              initialValue: true,
            ),
            _SettingsRowData(
              icon: Icons.location_on_rounded,
              title: 'Show salon location',
              subtitle: 'Display your map location on the salon profile.',
              toggle: true,
              initialValue: true,
            ),
            _SettingsRowData(
              icon: Icons.star_rounded,
              title: 'Reviews visibility',
              subtitle: 'Show customer reviews and rating signals.',
              toggle: true,
              initialValue: true,
            ),
          ],
        ),
        _SettingsGroupData(
          title: 'Customer interactions',
          rows: [
            _SettingsRowData(
              icon: Icons.chat_rounded,
              title: 'Customer message requests',
              subtitle: 'Let customers start chats from your salon profile.',
              toggle: true,
              initialValue: true,
            ),
            _SettingsRowData(
              icon: Icons.calendar_month_rounded,
              title: 'Booking request visibility',
              subtitle: 'Show available slots for active services.',
              toggle: true,
              initialValue: true,
            ),
            _SettingsRowData(
              icon: Icons.block_rounded,
              title: 'Blocked customers',
              subtitle: 'Manage customers who cannot message or book.',
              trailingText: 'Manage',
            ),
          ],
        ),
        _SettingsGroupData(
          title: 'Business data',
          rows: [
            _SettingsRowData(
              icon: Icons.insights_rounded,
              title: 'Analytics personalization',
              subtitle: 'Use booking and engagement data for salon insights.',
              toggle: true,
              initialValue: true,
            ),
            _SettingsRowData(
              icon: Icons.campaign_rounded,
              title: 'Marketing audience rules',
              subtitle: 'Control how followers receive campaigns and offers.',
              trailingText: 'Premium',
            ),
          ],
        ),
      ],
    );
  }
}

class CustomerSecuritySettingsPage extends StatelessWidget {
  const CustomerSecuritySettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const _SettingsDetailPage(
      title: 'Security',
      subtitle: 'Protect your account, bookings, and conversations.',
      groups: [
        _SettingsGroupData(
          title: 'Account protection',
          rows: [
            _SettingsRowData(
              icon: Icons.password_rounded,
              title: 'Change password',
              subtitle: 'Update your password regularly.',
              trailingText: 'Update',
            ),
            _SettingsRowData(
              icon: Icons.verified_user_rounded,
              title: 'Two-step verification',
              subtitle: 'Require a verification code when signing in.',
              toggle: true,
              initialValue: false,
            ),
            _SettingsRowData(
              icon: Icons.fingerprint_rounded,
              title: 'Biometric app lock',
              subtitle: 'Use fingerprint or face unlock for this app.',
              toggle: true,
              initialValue: false,
            ),
          ],
        ),
        _SettingsGroupData(
          title: 'Session safety',
          rows: [
            _SettingsRowData(
              icon: Icons.devices_rounded,
              title: 'Trusted devices',
              subtitle: 'Review phones currently signed in.',
              trailingText: 'This phone',
            ),
            _SettingsRowData(
              icon: Icons.notifications_active_rounded,
              title: 'Login alerts',
              subtitle: 'Notify me when a new device signs in.',
              toggle: true,
              initialValue: true,
            ),
          ],
        ),
      ],
    );
  }
}

class SalonSecuritySettingsPage extends StatelessWidget {
  const SalonSecuritySettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const _SettingsDetailPage(
      title: 'Security',
      subtitle: 'Keep your salon profile, bookings, and business tools protected.',
      groups: [
        _SettingsGroupData(
          title: 'Business account protection',
          rows: [
            _SettingsRowData(
              icon: Icons.password_rounded,
              title: 'Change password',
              subtitle: 'Secure the salon owner login.',
              trailingText: 'Update',
            ),
            _SettingsRowData(
              icon: Icons.verified_user_rounded,
              title: 'Two-step verification',
              subtitle: 'Require a code before accessing salon tools.',
              toggle: true,
              initialValue: true,
            ),
            _SettingsRowData(
              icon: Icons.admin_panel_settings_rounded,
              title: 'Owner approval for changes',
              subtitle: 'Protect services, hours, payouts, and campaigns.',
              toggle: true,
              initialValue: true,
            ),
          ],
        ),
        _SettingsGroupData(
          title: 'Operational safety',
          rows: [
            _SettingsRowData(
              icon: Icons.devices_rounded,
              title: 'Active devices',
              subtitle: 'See devices signed into the salon account.',
              trailingText: 'Manage',
            ),
            _SettingsRowData(
              icon: Icons.history_rounded,
              title: 'Security activity',
              subtitle: 'Review recent logins and sensitive changes.',
              trailingText: 'View',
            ),
            _SettingsRowData(
              icon: Icons.notifications_active_rounded,
              title: 'Critical alerts',
              subtitle: 'Alert owner for password, booking, and payout changes.',
              toggle: true,
              initialValue: true,
            ),
          ],
        ),
      ],
    );
  }
}

class CustomerAccountSettingsPage extends StatelessWidget {
  const CustomerAccountSettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const _SettingsDetailPage(
      title: 'Account',
      subtitle: 'Manage customer profile, booking history, and account data.',
      groups: [
        _SettingsGroupData(
          title: 'Customer profile',
          rows: [
            _SettingsRowData(
              icon: Icons.person_rounded,
              title: 'Profile information',
              subtitle: 'Name, username, photo, bio, city, and country.',
              trailingText: 'Edit',
            ),
            _SettingsRowData(
              icon: Icons.content_cut_rounded,
              title: 'Beauty preferences',
              subtitle: 'Services, styles, and salons you want recommended.',
              trailingText: 'Tune',
            ),
            _SettingsRowData(
              icon: Icons.bookmark_rounded,
              title: 'Saved and following',
              subtitle: 'Saved salons, saved services, and following list.',
              trailingText: 'Manage',
            ),
          ],
        ),
        _SettingsGroupData(
          title: 'Bookings and conversations',
          rows: [
            _SettingsRowData(
              icon: Icons.event_available_rounded,
              title: 'Booking history',
              subtitle: 'Upcoming, completed, cancelled, and requested bookings.',
              trailingText: 'View',
            ),
            _SettingsRowData(
              icon: Icons.chat_bubble_rounded,
              title: 'Chat controls',
              subtitle: 'Manage salon conversations and message requests.',
              trailingText: 'Open',
            ),
          ],
        ),
        _SettingsGroupData(
          title: 'Data and account status',
          rows: [
            _SettingsRowData(
              icon: Icons.download_rounded,
              title: 'Download your data',
              subtitle: 'Request a copy of your account and activity data.',
              trailingText: 'Request',
            ),
            _SettingsRowData(
              icon: Icons.pause_circle_rounded,
              title: 'Deactivate account',
              subtitle: 'Temporarily hide your customer account.',
              trailingText: 'Review',
            ),
            _SettingsRowData(
              icon: Icons.delete_forever_rounded,
              title: 'Delete account',
              subtitle: 'Permanently remove your customer account and data.',
              trailingText: 'Danger',
              destructive: true,
            ),
          ],
        ),
      ],
    );
  }
}

class SalonAccountSettingsPage extends StatelessWidget {
  const SalonAccountSettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const _SettingsDetailPage(
      title: 'Account',
      subtitle: 'Manage salon identity, team access, booking tools, and business data.',
      groups: [
        _SettingsGroupData(
          title: 'Salon identity',
          rows: [
            _SettingsRowData(
              icon: Icons.storefront_rounded,
              title: 'Salon profile',
              subtitle: 'Name, cover, logo, bio, gallery, location, and contact.',
              trailingText: 'Edit',
            ),
            _SettingsRowData(
              icon: Icons.design_services_rounded,
              title: 'Services and pricing',
              subtitle: 'Manage service menu, durations, prices, and stylists.',
              trailingText: 'Manage',
            ),
            _SettingsRowData(
              icon: Icons.schedule_rounded,
              title: 'Working hours',
              subtitle: 'Availability, exceptions, holidays, and time off.',
              trailingText: 'Edit',
            ),
          ],
        ),
        _SettingsGroupData(
          title: 'Business tools',
          rows: [
            _SettingsRowData(
              icon: Icons.groups_rounded,
              title: 'Team and stylists',
              subtitle: 'Invite stylists and assign services.',
              trailingText: 'Manage',
            ),
            _SettingsRowData(
              icon: Icons.campaign_rounded,
              title: 'Campaigns and offers',
              subtitle: 'Promotions, events, rebooking, and follower messages.',
              trailingText: 'Premium',
            ),
            _SettingsRowData(
              icon: Icons.payments_rounded,
              title: 'Payments and payouts',
              subtitle: 'Default payment methods, payout setup, and invoices.',
              trailingText: 'Setup',
            ),
          ],
        ),
        _SettingsGroupData(
          title: 'Ownership',
          rows: [
            _SettingsRowData(
              icon: Icons.switch_account_rounded,
              title: 'Transfer ownership',
              subtitle: 'Move salon ownership to another verified account.',
              trailingText: 'Review',
            ),
            _SettingsRowData(
              icon: Icons.pause_circle_rounded,
              title: 'Pause salon profile',
              subtitle: 'Temporarily stop bookings while keeping your profile.',
              trailingText: 'Pause',
            ),
            _SettingsRowData(
              icon: Icons.delete_forever_rounded,
              title: 'Close salon account',
              subtitle: 'Permanently remove salon profile and business data.',
              trailingText: 'Danger',
              destructive: true,
            ),
          ],
        ),
      ],
    );
  }
}

class _SettingsDetailPage extends StatelessWidget {
  final String title;
  final String subtitle;
  final List<_SettingsGroupData> groups;

  const _SettingsDetailPage({
    required this.title,
    required this.subtitle,
    required this.groups,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;

    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 28),
        children: [
          Text(
            subtitle,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: scheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 18),
          for (final group in groups) ...[
            _SettingsGroup(group: group),
            const SizedBox(height: 18),
          ],
        ],
      ),
    );
  }
}

class _SettingsGroup extends StatelessWidget {
  final _SettingsGroupData group;

  const _SettingsGroup({required this.group});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 4, bottom: 8),
          child: Text(
            group.title,
            style: theme.textTheme.titleSmall?.copyWith(
              fontWeight: FontWeight.w800,
              color: scheme.primary,
            ),
          ),
        ),
        DecoratedBox(
          decoration: BoxDecoration(
            color: scheme.surfaceContainerHighest.withValues(alpha: 0.55),
            borderRadius: BorderRadius.circular(18),
            border: Border.all(
              color: scheme.outlineVariant.withValues(alpha: 0.5),
            ),
          ),
          child: Column(
            children: [
              for (var i = 0; i < group.rows.length; i++) ...[
                _SettingsRow(data: group.rows[i]),
                if (i != group.rows.length - 1)
                  Divider(
                    height: 1,
                    indent: 60,
                    color: scheme.outlineVariant.withValues(alpha: 0.6),
                  ),
              ],
            ],
          ),
        ),
      ],
    );
  }
}

class _SettingsRow extends StatefulWidget {
  final _SettingsRowData data;

  const _SettingsRow({required this.data});

  @override
  State<_SettingsRow> createState() => _SettingsRowState();
}

class _SettingsRowState extends State<_SettingsRow> {
  late bool value = widget.data.initialValue;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final data = widget.data;
    final color = data.destructive ? scheme.error : scheme.primary;

    return ListTile(
      minLeadingWidth: 36,
      leading: CircleAvatar(
        radius: 18,
        backgroundColor: color.withValues(alpha: 0.11),
        child: Icon(data.icon, size: 19, color: color),
      ),
      title: Text(
        data.title,
        style: theme.textTheme.bodyLarge?.copyWith(
          fontWeight: FontWeight.w700,
          color: data.destructive ? scheme.error : null,
        ),
      ),
      subtitle: Padding(
        padding: const EdgeInsets.only(top: 3),
        child: Text(data.subtitle),
      ),
      trailing: data.toggle
          ? Switch.adaptive(
              value: value,
              onChanged: (next) => setState(() => value = next),
            )
          : Text(
              data.trailingText ?? '',
              style: theme.textTheme.labelMedium?.copyWith(
                color: data.destructive ? scheme.error : scheme.primary,
                fontWeight: FontWeight.w800,
              ),
            ),
    );
  }
}

class _SettingsGroupData {
  final String title;
  final List<_SettingsRowData> rows;

  const _SettingsGroupData({required this.title, required this.rows});
}

class _SettingsRowData {
  final IconData icon;
  final String title;
  final String subtitle;
  final bool toggle;
  final bool initialValue;
  final String? trailingText;
  final bool destructive;

  const _SettingsRowData({
    required this.icon,
    required this.title,
    required this.subtitle,
    this.toggle = false,
    this.initialValue = false,
    this.trailingText,
    this.destructive = false,
  });
}
