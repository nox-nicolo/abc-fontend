import 'package:africa_beuty/feature/booking/view/pages/salon_booking.dart';
import 'package:africa_beuty/feature/chat/view/page/chats_page.dart';
import 'package:africa_beuty/feature/notifications/view/page/notifications_page.dart';
import 'package:africa_beuty/feature/post/view/page/post_management.dart';
import 'package:africa_beuty/feature/profile/view/page/appointment_reminders.dart';
import 'package:africa_beuty/feature/profile/view/page/salon_business_tools.dart';
import 'package:africa_beuty/feature/profile/view/page/salon_event_campaign.dart';
import 'package:africa_beuty/feature/profile/view/widget/settings/edit_salon_profile.dart';
import 'package:africa_beuty/feature/profile/view/widget/settings/salon_contacts.dart';
import 'package:africa_beuty/feature/profile/view/widget/settings/salon_gallery.dart';
import 'package:africa_beuty/feature/profile/repositories/account_settings.dart';
import 'package:africa_beuty/feature/profile/view/widget/profile_share_sheet.dart';
import 'package:africa_beuty/feature/profile/view/widget/settings_polish.dart';
import 'package:africa_beuty/feature/profile/view/widget/three_dots/service/salon_service.dart';
import 'package:africa_beuty/feature/profile/view/widget/three_dots/stylist/stylist_management.dart';
import 'package:africa_beuty/feature/saved/view/page/saved_page.dart';
import 'package:flutter/material.dart';

class ThreedotsSalon extends StatefulWidget {
  const ThreedotsSalon({super.key});

  @override
  State<ThreedotsSalon> createState() => _ThreedotsSalonState();
}

class _ThreedotsSalonState extends State<ThreedotsSalon> {
  final _settingsRepo = AccountSettingsRepository();
  final _searchController = TextEditingController();

  static const Map<String, bool> _defaultToggles = {
    'contentReview': true,
    'commentControls': true,
    'campaignDrafts': true,
    'bookingDigest': true,
    'analyticsSummary': true,
    'customerInsights': true,
    'profileReach': true,
    'autoReceipts': true,
    'depositProtection': false,
    'payoutAlerts': true,
  };

  final Map<String, bool> _toggles = Map.of(_defaultToggles);
  String _analyticsRange = 'Last 30 days';
  String _paymentMode = 'Cash at salon';
  String _campaignAudience = 'Followers';
  String _query = '';

  static const _prefix = 'salon_three_dots_';
  String _settingKey(String key) => '$_prefix$key';

  @override
  void initState() {
    super.initState();
    _loadPrefs();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _loadPrefs() async {
    final result = await _settingsRepo.getSettings();
    if (!mounted) return;
    result.match((_) {}, (settings) {
      setState(() {
        for (final entry in _toggles.entries) {
          _toggles[entry.key] =
              settings[_settingKey(entry.key)] as bool? ?? entry.value;
        }
        _analyticsRange =
            settings[_settingKey('analyticsRange')] as String? ??
            _analyticsRange;
        _paymentMode =
            settings[_settingKey('paymentMode')] as String? ?? _paymentMode;
        _campaignAudience =
            settings[_settingKey('campaignAudience')] as String? ??
            _campaignAudience;
      });
    });
  }

  Future<void> _setToggle(String key, bool value) async {
    await _settingsRepo.updateSettings({_settingKey(key): value});
    if (mounted) setState(() => _toggles[key] = value);
  }

  Future<void> _setString(String key, String value) async {
    await _settingsRepo.updateSettings({_settingKey(key): value});
    if (!mounted) return;
    setState(() {
      if (key == 'analyticsRange') _analyticsRange = value;
      if (key == 'paymentMode') _paymentMode = value;
      if (key == 'campaignAudience') _campaignAudience = value;
    });
  }

  void _open(Widget page) {
    Navigator.pop(context);
    Navigator.of(context).push(MaterialPageRoute(builder: (_) => page));
  }

  Future<void> _openSheet({
    required String title,
    required String subtitle,
    required List<Widget> children,
  }) {
    return showModalBottomSheet<void>(
      context: context,
      useSafeArea: true,
      showDragHandle: true,
      isScrollControlled: true,
      backgroundColor: Theme.of(context).colorScheme.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(8)),
      ),
      builder: (ctx) {
        final theme = Theme.of(ctx);
        final scheme = theme.colorScheme;
        return DraggableScrollableSheet(
          expand: false,
          initialChildSize: 0.7,
          minChildSize: 0.34,
          maxChildSize: 0.92,
          builder: (context, controller) {
            return ListView(
              controller: controller,
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
              children: [
                Text(
                  title,
                  style: theme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  subtitle,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: scheme.onSurfaceVariant,
                  ),
                ),
                const SizedBox(height: 18),
                ...children,
              ],
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;

    return DraggableScrollableSheet(
      expand: false,
      initialChildSize: 0.86,
      minChildSize: 0.38,
      maxChildSize: 0.96,
      builder: (context, controller) {
        return ListView(
          controller: controller,
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
          children: [
            Row(
              children: [
                Container(
                  width: 46,
                  height: 46,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: scheme.primary.withValues(alpha: 0.12),
                  ),
                  child: Icon(Icons.more_horiz_rounded, color: scheme.primary),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Salon tools',
                        style: theme.textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        'Content, bookings, team, marketing, insights, and shortcuts',
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: scheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 18),
            SettingsSearchField(
              controller: _searchController,
              hintText: 'Search salon tools',
              onChanged: (value) => setState(() => _query = value),
            ),
            const SizedBox(height: 12),
            if (_query.trim().isEmpty)
              FavoriteShortcutBar(
                children: [
                  FavoriteShortcut(
                    icon: Icons.calendar_today_rounded,
                    label: 'Bookings',
                    onTap: () => _open(const SalonBookingPage()),
                  ),
                  FavoriteShortcut(
                    icon: Icons.analytics_outlined,
                    label: 'Analytics',
                    onTap: () => _open(const SalonAnalyticsPage()),
                  ),
                  FavoriteShortcut(
                    icon: Icons.monetization_on,
                    label: 'Payments',
                    onTap: () => _open(const SalonPaymentsPage()),
                  ),
                ],
              ),
            if (_query.trim().isEmpty) const SizedBox(height: 18),
            _ToolsGroup(
              title: 'Management',
              children: [
                _ToolTile(
                  query: _query,
                  icon: Icons.photo_library_outlined,
                  title: 'Content management',
                  subtitle: 'View, manage, and delete salon posts',
                  onTap: () => _open(const PostManagementPage()),
                ),
                _ToolTile(
                  query: _query,
                  icon: Icons.design_services_rounded,
                  title: 'Service management',
                  subtitle: 'Create services, pricing, durations, products',
                  onTap: () => _open(const SelectServicePage()),
                ),
                _ToolTile(
                  query: _query,
                  icon: Icons.face_2_rounded,
                  title: 'Stylists management',
                  subtitle: 'Add, edit, assign, remove, and permission staff',
                  onTap: () => _open(const SalonStylistsPage()),
                ),
                _ToolTile(
                  query: _query,
                  icon: Icons.storefront_rounded,
                  title: 'Salon profile tools',
                  subtitle: 'Contacts, gallery, working hours, location',
                  onTap: _openProfileTools,
                ),
                _ToolTile(
                  query: _query,
                  icon: Icons.ios_share_rounded,
                  title: 'Share salon profile',
                  subtitle:
                      'Preview card, salon deep link, QR code, native share',
                  onTap: _shareSalonProfile,
                ),
              ],
            ),
            const SizedBox(height: 14),
            _ToolsGroup(
              title: 'Bookings and customers',
              children: [
                _ToolTile(
                  query: _query,
                  icon: Icons.calendar_today_rounded,
                  title: 'Booking management',
                  subtitle: 'Requests, schedule, confirmations, completed',
                  onTap: () => _open(const SalonBookingPage()),
                ),
                _ToolTile(
                  query: _query,
                  icon: Icons.schedule_rounded,
                  title: 'Booking rules',
                  subtitle: 'Notice, cancellation, slot intervals, workflow',
                  onTap: () => _open(const SalonBookingRulesPage()),
                ),
                _ToolTile(
                  query: _query,
                  icon: Icons.chat_bubble_rounded,
                  title: 'Customer messages',
                  subtitle: 'Open chats with customers',
                  onTap: () => _open(const ChatsPage()),
                ),
                _ToolTile(
                  query: _query,
                  icon: Icons.notifications_rounded,
                  title: 'Notifications inbox',
                  subtitle: 'Bookings, campaigns, comments, and messages',
                  onTap: () => _open(const NotificationsPage()),
                ),
              ],
            ),
            const SizedBox(height: 14),
            _ToolsGroup(
              title: 'Marketing and insights',
              children: [
                _ToolTile(
                  query: _query,
                  icon: Icons.sell_rounded,
                  title: 'Marketing and promotion',
                  subtitle: 'Campaign composer, drafts, and history',
                  trailingText: _campaignAudience,
                  onTap: () => _open(const SalonCampaignManagerPage()),
                ),
                _ToolTile(
                  query: _query,
                  icon: Icons.campaign_rounded,
                  title: 'Campaign controls',
                  subtitle: 'Audience and draft preferences',
                  onTap: _openCampaignControls,
                ),
                _ToolTile(
                  query: _query,
                  icon: Icons.analytics_outlined,
                  title: 'Reports and analytics',
                  subtitle: 'Revenue, booking status, ratings, top services',
                  trailingText: _analyticsRange,
                  badgeLabel: 'Premium',
                  badgeTone: SettingsBadgeTone.premium,
                  onTap: () => _open(const SalonAnalyticsPage()),
                ),
              ],
            ),
            const SizedBox(height: 14),
            _ToolsGroup(
              title: 'Finance and saved',
              children: [
                _ToolTile(
                  query: _query,
                  icon: Icons.monetization_on,
                  title: 'Payments',
                  subtitle: 'Payout account, payment labels, receipts',
                  trailingText: _paymentMode,
                  badgeLabel: 'Synced',
                  onTap: () => _open(const SalonPaymentsPage()),
                ),
                _ToolTile(
                  query: _query,
                  icon: Icons.admin_panel_settings_rounded,
                  title: 'Team permissions',
                  subtitle: 'Control staff access for salon tools',
                  onTap: () => _open(const SalonTeamPermissionsPage()),
                ),
                _ToolTile(
                  query: _query,
                  icon: Icons.bookmark_border,
                  title: 'Saved',
                  subtitle: 'Saved services, salons, and styles',
                  onTap: () => _open(const SavedPage()),
                ),
                _ToolTile(
                  query: _query,
                  icon: Icons.notifications_active_rounded,
                  title: 'Reminder controls',
                  subtitle: 'Booking reminders and notification channels',
                  onTap: () => _open(const AppointmentRemindersPage()),
                ),
              ],
            ),
          ],
        );
      },
    );
  }

  Future<void> _openProfileTools() {
    return _openSheet(
      title: 'Salon profile tools',
      subtitle: 'Jump straight into backend-synced salon profile sections.',
      children: [
        _ActionRow(
          icon: Icons.dashboard_customize_rounded,
          title: 'Profile overview',
          subtitle: 'Cover, profile, contacts, hours, calendar, gallery.',
          action: 'Open',
          onTap: () {
            Navigator.pop(context);
            _open(const SalonProfileInformationPage());
          },
        ),
        _ActionRow(
          icon: Icons.location_on_rounded,
          title: 'Contacts and location',
          subtitle: 'Phone, WhatsApp, email, address, and map.',
          action: 'Edit',
          onTap: () {
            Navigator.pop(context);
            _open(const ContactsLocationPage());
          },
        ),
        _ActionRow(
          icon: Icons.photo_library_rounded,
          title: 'Gallery',
          subtitle: 'Add, remove, and reorder salon gallery images.',
          action: 'Edit',
          onTap: () {
            Navigator.pop(context);
            _open(const GalleryPage());
          },
        ),
      ],
    );
  }

  Future<void> _shareSalonProfile() {
    return ProfileShareSheet.show(context, type: ProfileShareType.salon);
  }

  Future<void> _openCampaignControls() {
    return _openSheet(
      title: 'Campaign controls',
      subtitle: 'Prepare promotion defaults before opening campaign composer.',
      children: [
        _OptionRow(
          icon: Icons.group_rounded,
          title: 'Default audience',
          subtitle: 'Saved locally for the campaign tools shortcut.',
          value: _campaignAudience,
          options: const ['Followers', 'Recent customers', 'All customers'],
          onSelected: (value) => _setString('campaignAudience', value),
        ),
        _SwitchRow(
          value: _toggles['campaignDrafts']!,
          icon: Icons.drafts_rounded,
          title: 'Campaign draft prompts',
          subtitle: 'Show draft reminders before sending offers.',
          onChanged: (value) => _setToggle('campaignDrafts', value),
        ),
        _ActionRow(
          icon: Icons.sell_rounded,
          title: 'Open campaign composer',
          subtitle: 'Send promotions or event notifications.',
          action: 'Open',
          onTap: () {
            Navigator.pop(context);
            _open(const SalonEventCampaignPage());
          },
        ),
      ],
    );
  }
}

class _ToolsGroup extends StatelessWidget {
  const _ToolsGroup({required this.title, required this.children});

  final String title;
  final List<Widget> children;

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
            title,
            style: theme.textTheme.labelLarge?.copyWith(
              color: scheme.primary,
              fontWeight: FontWeight.w800,
            ),
          ),
        ),
        DecoratedBox(
          decoration: BoxDecoration(
            color: scheme.surfaceContainerHighest.withValues(alpha: 0.5),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: scheme.outlineVariant),
          ),
          child: Column(
            children: [
              for (var i = 0; i < children.length; i++) ...[
                children[i],
                if (i != children.length - 1)
                  Divider(
                    height: 1,
                    indent: 62,
                    color: scheme.outlineVariant.withValues(alpha: 0.7),
                  ),
              ],
            ],
          ),
        ),
      ],
    );
  }
}

class _ToolTile extends StatelessWidget {
  const _ToolTile({
    this.query = '',
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
    this.trailingText,
    this.badgeLabel,
    this.badgeTone = SettingsBadgeTone.synced,
  });

  final String query;
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;
  final String? trailingText;
  final String? badgeLabel;
  final SettingsBadgeTone badgeTone;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final haystack = '$title $subtitle $trailingText $badgeLabel'.toLowerCase();
    if (query.trim().isNotEmpty &&
        !haystack.contains(query.trim().toLowerCase())) {
      return const SizedBox.shrink();
    }
    return ListTile(
      minLeadingWidth: 38,
      contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
      leading: CircleAvatar(
        radius: 19,
        backgroundColor: scheme.secondary.withValues(alpha: 0.12),
        child: Icon(icon, size: 19, color: scheme.secondary),
      ),
      title: Row(
        children: [
          Expanded(
            child: Text(
              title,
              style: theme.textTheme.bodyLarge?.copyWith(
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          if (badgeLabel != null) ...[
            const SizedBox(width: 8),
            SettingsStatusBadge(label: badgeLabel!, tone: badgeTone),
          ],
        ],
      ),
      subtitle: Padding(
        padding: const EdgeInsets.only(top: 2),
        child: Text(subtitle, maxLines: 2, overflow: TextOverflow.ellipsis),
      ),
      trailing: trailingText == null
          ? const Icon(Icons.chevron_right_rounded)
          : Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 108),
                  child: Text(
                    trailingText!,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: theme.textTheme.labelMedium?.copyWith(
                      color: scheme.primary,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
                const SizedBox(width: 4),
                const Icon(Icons.chevron_right_rounded),
              ],
            ),
      onTap: onTap,
    );
  }
}

class _SwitchRow extends StatelessWidget {
  const _SwitchRow({
    required this.value,
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onChanged,
  });

  final bool value;
  final IconData icon;
  final String title;
  final String subtitle;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    return SwitchListTile.adaptive(
      value: value,
      onChanged: onChanged,
      secondary: Icon(icon),
      title: Text(title, style: const TextStyle(fontWeight: FontWeight.w700)),
      subtitle: Text(subtitle),
      contentPadding: const EdgeInsets.symmetric(horizontal: 4),
    );
  }
}

class _OptionRow extends StatelessWidget {
  const _OptionRow({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.value,
    required this.options,
    required this.onSelected,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final String value;
  final List<String> options;
  final ValueChanged<String> onSelected;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ListTile(
            contentPadding: EdgeInsets.zero,
            leading: Icon(icon, color: scheme.secondary),
            title: Text(
              title,
              style: const TextStyle(fontWeight: FontWeight.w700),
            ),
            subtitle: Text(subtitle),
          ),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              for (final option in options)
                ChoiceChip(
                  label: Text(option),
                  selected: option == value,
                  onSelected: (_) => onSelected(option),
                ),
            ],
          ),
          const SizedBox(height: 8),
        ],
      ),
    );
  }
}

class _ActionRow extends StatelessWidget {
  const _ActionRow({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.action,
    required this.onTap,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final String action;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: Icon(icon, color: scheme.secondary),
      title: Text(title, style: const TextStyle(fontWeight: FontWeight.w700)),
      subtitle: Text(subtitle),
      trailing: Text(
        action,
        style: TextStyle(color: scheme.primary, fontWeight: FontWeight.w800),
      ),
      onTap: onTap,
    );
  }
}
