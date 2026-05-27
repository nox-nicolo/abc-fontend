import 'package:africa_beuty/feature/booking/view/pages/booking.dart';
import 'package:africa_beuty/feature/chat/view/page/chats_page.dart';
import 'package:africa_beuty/feature/profile/view/page/account_security_page.dart';
import 'package:africa_beuty/feature/profile/view/page/appointment_reminders.dart';
import 'package:africa_beuty/feature/profile/view/page/audit_log_page.dart';
import 'package:africa_beuty/feature/profile/view/page/salon_event_campaign.dart';
import 'package:africa_beuty/feature/profile/view/widget/settings/edit_salon_profile.dart';
import 'package:africa_beuty/feature/profile/view/widget/settings/salon_availability_calendar.dart';
import 'package:africa_beuty/feature/profile/view/widget/settings/salon_contacts.dart';
import 'package:africa_beuty/feature/profile/view/widget/settings/salon_gallery.dart';
import 'package:africa_beuty/feature/profile/view/widget/settings/salon_prof_cover_photo.dart';
import 'package:africa_beuty/feature/profile/view/widget/settings/salon_details.dart';
import 'package:africa_beuty/feature/profile/view/widget/settings/salon_working_hours.dart';
import 'package:africa_beuty/feature/profile/view/widget/three_dots/service/salon_service.dart';
import 'package:africa_beuty/feature/profile/view/widget/three_dots/stylist/stylist_management.dart';
import 'package:africa_beuty/feature/profile/repositories/account_settings.dart';
import 'package:africa_beuty/feature/profile/view/widget/settings_polish.dart';
import 'package:flutter/material.dart';
import 'package:icons_plus/icons_plus.dart';

class SalonSetting extends StatefulWidget {
  const SalonSetting({super.key});

  @override
  State<SalonSetting> createState() => _SalonSettingState();
}

class _SalonSettingState extends State<SalonSetting> {
  final _settingsRepo = AccountSettingsRepository();
  final _searchController = TextEditingController();

  static const Map<String, bool> _defaultToggles = {
    'publicProfile': true,
    'showLocation': true,
    'showReviews': true,
    'messageRequests': true,
    'bookingRequests': true,
    'analytics': true,
    'ownerApproval': true,
    'criticalAlerts': true,
    'wifiOnlyUploads': false,
    'dataSaver': false,
    'autoCache': true,
    'autoInvoices': true,
  };

  late Map<String, bool> _toggles = Map.of(_defaultToggles);
  String _bookingWindow = '30 days';
  String _cancellationPolicy = 'Flexible';
  String _paymentMethod = 'Cash at salon';
  String _mediaQuality = 'Balanced';
  String _language = 'English';
  String _query = '';

  static const _prefix = 'salon_settings_';
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
        _bookingWindow =
            settings[_settingKey('bookingWindow')] as String? ?? _bookingWindow;
        _cancellationPolicy =
            settings[_settingKey('cancellationPolicy')] as String? ??
            _cancellationPolicy;
        _paymentMethod =
            settings[_settingKey('paymentMethod')] as String? ?? _paymentMethod;
        _mediaQuality =
            settings[_settingKey('mediaQuality')] as String? ?? _mediaQuality;
        _language = settings[_settingKey('language')] as String? ?? _language;
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
      if (key == 'bookingWindow') _bookingWindow = value;
      if (key == 'cancellationPolicy') _cancellationPolicy = value;
      if (key == 'paymentMethod') _paymentMethod = value;
      if (key == 'mediaQuality') _mediaQuality = value;
      if (key == 'language') _language = value;
    });
  }

  void _pushPage(Widget page) {
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
          initialChildSize: 0.72,
          minChildSize: 0.36,
          maxChildSize: 0.94,
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
      initialChildSize: 0.88,
      minChildSize: 0.42,
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
                  child: Icon(Icons.storefront_rounded, color: scheme.primary),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Salon settings',
                        style: theme.textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        'Profile, bookings, services, team, campaigns, and app controls',
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
              hintText: 'Search salon settings',
              onChanged: (value) => setState(() => _query = value),
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: const [
                SettingsStatusBadge(
                  label: 'Synced',
                  tone: SettingsBadgeTone.synced,
                ),
                SettingsStatusBadge(
                  label: 'Premium',
                  tone: SettingsBadgeTone.premium,
                ),
                SettingsStatusBadge(
                  label: 'Local cache',
                  tone: SettingsBadgeTone.local,
                ),
              ],
            ),
            if (_query.trim().isEmpty) ...[
              const SizedBox(height: 12),
              FavoriteShortcutBar(
                children: [
                  FavoriteShortcut(
                    icon: Icons.storefront_rounded,
                    label: 'Profile',
                    onTap: () => _pushPage(const SalonProfileInformationPage()),
                  ),
                  FavoriteShortcut(
                    icon: Icons.calendar_today_rounded,
                    label: 'Bookings',
                    onTap: () => _pushPage(const BookingPage()),
                  ),
                  FavoriteShortcut(
                    icon: Icons.design_services_rounded,
                    label: 'Services',
                    onTap: () => _pushPage(const SelectServicePage()),
                  ),
                ],
              ),
            ],
            const SizedBox(height: 18),
            _SettingsGroup(
              title: 'Salon profile',
              children: [
                _SettingsTile(
                  query: _query,
                  icon: Icons.dashboard_customize_rounded,
                  title: 'Profile overview',
                  subtitle:
                      'Cover, profile, contacts, hours, calendar, gallery',
                  onTap: () => _pushPage(const SalonProfileInformationPage()),
                ),
                _SettingsTile(
                  query: _query,
                  icon: Icons.edit_rounded,
                  title: 'Details',
                  subtitle: 'Salon name, username, slogan, description',
                  onTap: () => _pushPage(const ProfileDetailsPage()),
                ),
                _SettingsTile(
                  query: _query,
                  icon: Icons.photo_camera_rounded,
                  title: 'Cover and profile photo',
                  subtitle: 'Update the main images customers see first',
                  onTap: () => _pushPage(const ProfileCoverPhoto()),
                ),
                _SettingsTile(
                  query: _query,
                  icon: Icons.location_on_rounded,
                  title: 'Contact and location',
                  subtitle: 'Phone, WhatsApp, email, map and address',
                  onTap: () => _pushPage(const ContactsLocationPage()),
                ),
                _SettingsTile(
                  query: _query,
                  icon: Icons.photo_library_rounded,
                  title: 'Gallery',
                  subtitle: 'Add, remove, and reorder salon gallery images',
                  onTap: () => _pushPage(const GalleryPage()),
                ),
              ],
            ),
            const SizedBox(height: 14),
            _SettingsGroup(
              title: 'Operations',
              children: [
                _SettingsTile(
                  query: _query,
                  icon: FontAwesome.calendar_check,
                  title: 'Bookings',
                  subtitle: 'Requests, confirmed visits, completed, cancelled',
                  onTap: () => _pushPage(const BookingPage()),
                ),
                _SettingsTile(
                  query: _query,
                  icon: Icons.schedule_rounded,
                  title: 'Working hours',
                  subtitle: 'Weekly opening hours and closed days',
                  onTap: () => _pushPage(const WorkingHoursPage()),
                ),
                _SettingsTile(
                  query: _query,
                  icon: Icons.event_available_rounded,
                  title: 'Availability calendar',
                  subtitle: 'Special dates, closures, and custom hours',
                  onTap: () => _pushPage(const SalonAvailabilityCalendarPage()),
                ),
                _SettingsTile(
                  query: _query,
                  icon: Icons.rule_rounded,
                  title: 'Booking rules',
                  subtitle: 'Booking window and cancellation policy',
                  trailingText: _bookingWindow,
                  onTap: _openBookingRules,
                ),
              ],
            ),
            const SizedBox(height: 14),
            _SettingsGroup(
              title: 'Business tools',
              children: [
                _SettingsTile(
                  query: _query,
                  icon: Icons.design_services_rounded,
                  title: 'Services and pricing',
                  subtitle: 'Configure services, duration, price, products',
                  badgeLabel: 'Synced',
                  onTap: () => _pushPage(const SelectServicePage()),
                ),
                _SettingsTile(
                  query: _query,
                  icon: Icons.groups_rounded,
                  title: 'Stylists',
                  subtitle: 'Add stylists, edit roles, assign services',
                  onTap: () => _pushPage(const SalonStylistsPage()),
                ),
                _SettingsTile(
                  query: _query,
                  icon: Icons.campaign_rounded,
                  title: 'Campaigns',
                  subtitle: 'Promotions, events, customer notifications',
                  badgeLabel: 'Premium',
                  badgeTone: SettingsBadgeTone.premium,
                  onTap: () => _pushPage(const SalonEventCampaignPage()),
                ),
                _SettingsTile(
                  query: _query,
                  icon: FontAwesome.money_bill_solid,
                  title: 'Payments',
                  subtitle: 'Payment method, receipts, and invoices',
                  trailingText: _paymentMethod,
                  badgeLabel: 'Synced',
                  onTap: _openPayments,
                ),
              ],
            ),
            const SizedBox(height: 14),
            _SettingsGroup(
              title: 'Privacy and safety',
              children: [
                _SettingsTile(
                  query: _query,
                  icon: FontAwesome.lock_solid,
                  title: 'Privacy',
                  subtitle: 'Visibility, location, messages, booking requests',
                  onTap: _openPrivacy,
                ),
                _SettingsTile(
                  query: _query,
                  icon: FontAwesome.shield_solid,
                  title: 'Security',
                  subtitle: 'Owner approvals, active devices, alerts',
                  onTap: () =>
                      _pushPage(const AccountSecurityPage(isCustomer: false)),
                ),
                _SettingsTile(
                  query: _query,
                  icon: Icons.manage_history_rounded,
                  title: 'Activity log',
                  subtitle: 'Profile, bookings, staff, campaigns, and devices',
                  badgeLabel: 'Synced',
                  onTap: () => _pushPage(const AuditLogPage(isCustomer: false)),
                ),
                _SettingsTile(
                  query: _query,
                  icon: FontAwesome.bell_solid,
                  title: 'Notifications',
                  subtitle: 'Bookings, messages, comments, campaigns',
                  onTap: () => _pushPage(const AppointmentRemindersPage()),
                ),
                _SettingsTile(
                  query: _query,
                  icon: Icons.chat_bubble_rounded,
                  title: 'Messages',
                  subtitle: 'Open customer conversations',
                  onTap: () => _pushPage(const ChatsPage()),
                ),
              ],
            ),
            const SizedBox(height: 14),
            _SettingsGroup(
              title: 'App preferences',
              children: [
                _SettingsTile(
                  query: _query,
                  icon: FontAwesome.database_solid,
                  title: 'Storage and data',
                  subtitle: 'Gallery cache, upload quality, network usage',
                  trailingText: _mediaQuality,
                  badgeLabel: 'Local',
                  badgeTone: SettingsBadgeTone.local,
                  onTap: _openStorageAndData,
                ),
                _SettingsTile(
                  query: _query,
                  icon: FontAwesome.earth_africa_solid,
                  title: 'Language',
                  subtitle: 'Choose the language used in salon tools',
                  trailingText: _language,
                  onTap: _openLanguage,
                ),
              ],
            ),
            const SizedBox(height: 18),
            _DangerTile(
              onTap: () async {
                final confirmed = await showSettingsConfirmationSheet(
                  context: context,
                  title: 'Logout?',
                  subtitle:
                      'You will need to sign in again to manage salon bookings, services, and business tools.',
                  actionLabel: 'Logout',
                  destructive: true,
                );
                if (!confirmed || !context.mounted) return;
                Navigator.pop(context);
                Navigator.pushNamed(context, '/logout');
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> _openPrivacy() {
    return _openSheet(
      title: 'Privacy',
      subtitle: 'Control how customers discover, contact, and book your salon.',
      children: [
        _SwitchRow(
          value: _toggles['publicProfile']!,
          icon: Icons.storefront_rounded,
          title: 'Public salon profile',
          subtitle: 'Allow customers to view services, posts, and gallery.',
          onChanged: (value) => _setToggle('publicProfile', value),
        ),
        _SwitchRow(
          value: _toggles['showLocation']!,
          icon: Icons.location_on_rounded,
          title: 'Show salon location',
          subtitle: 'Display your map location on the salon profile.',
          onChanged: (value) => _setToggle('showLocation', value),
        ),
        _SwitchRow(
          value: _toggles['showReviews']!,
          icon: Icons.star_rounded,
          title: 'Show reviews',
          subtitle: 'Display customer review and rating signals.',
          onChanged: (value) => _setToggle('showReviews', value),
        ),
        _SwitchRow(
          value: _toggles['messageRequests']!,
          icon: Icons.mark_chat_unread_rounded,
          title: 'Customer message requests',
          subtitle: 'Let customers start chats from your salon profile.',
          onChanged: (value) => _setToggle('messageRequests', value),
        ),
        _SwitchRow(
          value: _toggles['bookingRequests']!,
          icon: Icons.calendar_month_rounded,
          title: 'Booking requests',
          subtitle: 'Show available slots for active services.',
          onChanged: (value) => _setToggle('bookingRequests', value),
        ),
        _SwitchRow(
          value: _toggles['analytics']!,
          icon: Icons.insights_rounded,
          title: 'Analytics personalization',
          subtitle: 'Use bookings and engagement data for salon insights.',
          onChanged: (value) => _setToggle('analytics', value),
        ),
      ],
    );
  }

  Future<void> _openBookingRules() {
    return _openSheet(
      title: 'Booking rules',
      subtitle: 'Set simple operating rules for customer booking flow.',
      children: [
        _OptionRow(
          icon: Icons.date_range_rounded,
          title: 'Booking window',
          subtitle: 'How far ahead customers can request appointments.',
          value: _bookingWindow,
          options: const ['7 days', '14 days', '30 days', '60 days'],
          onSelected: (value) => _setString('bookingWindow', value),
        ),
        _OptionRow(
          icon: Icons.event_busy_rounded,
          title: 'Cancellation policy',
          subtitle: 'Policy label shown to the salon owner on this device.',
          value: _cancellationPolicy,
          options: const ['Flexible', '12 hours notice', '24 hours notice'],
          onSelected: (value) => _setString('cancellationPolicy', value),
        ),
        _ActionRow(
          icon: Icons.schedule_rounded,
          title: 'Edit working hours',
          subtitle: 'Backend-synced weekly availability.',
          action: 'Open',
          onTap: () {
            Navigator.pop(context);
            _pushPage(const WorkingHoursPage());
          },
        ),
      ],
    );
  }

  Future<void> _openPayments() {
    return _openSheet(
      title: 'Payments',
      subtitle: 'Configure how the salon records customer payment preferences.',
      children: [
        _OptionRow(
          icon: Icons.payments_rounded,
          title: 'Default payment method',
          subtitle: 'Shown as your preferred payment mode.',
          value: _paymentMethod,
          options: const ['Cash at salon', 'Mobile money', 'Bank transfer'],
          onSelected: (value) => _setString('paymentMethod', value),
        ),
        _SwitchRow(
          value: _toggles['autoInvoices']!,
          icon: Icons.receipt_long_rounded,
          title: 'Auto invoice labels',
          subtitle: 'Prepare invoice labels for completed bookings.',
          onChanged: (value) => _setToggle('autoInvoices', value),
        ),
      ],
    );
  }

  Future<void> _openStorageAndData() {
    return _openSheet(
      title: 'Storage and data',
      subtitle: 'Control gallery uploads, media quality, and local cache.',
      children: [
        _OptionRow(
          icon: Icons.high_quality_rounded,
          title: 'Media quality',
          subtitle: 'Balance gallery quality with upload speed.',
          value: _mediaQuality,
          options: const ['Data saver', 'Balanced', 'Original'],
          onSelected: (value) => _setString('mediaQuality', value),
        ),
        _SwitchRow(
          value: _toggles['wifiOnlyUploads']!,
          icon: Icons.wifi_rounded,
          title: 'Upload on Wi-Fi only',
          subtitle: 'Wait for Wi-Fi before uploading large gallery media.',
          onChanged: (value) => _setToggle('wifiOnlyUploads', value),
        ),
        _SwitchRow(
          value: _toggles['dataSaver']!,
          icon: Icons.network_check_rounded,
          title: 'Data saver',
          subtitle: 'Reduce previews and background network usage.',
          onChanged: (value) => _setToggle('dataSaver', value),
        ),
        _SwitchRow(
          value: _toggles['autoCache']!,
          icon: Icons.cached_rounded,
          title: 'Smart cache',
          subtitle: 'Keep salon tools and recent gallery fast to reopen.',
          onChanged: (value) => _setToggle('autoCache', value),
        ),
        _ActionRow(
          icon: Icons.cleaning_services_rounded,
          title: 'Clear local cache',
          subtitle: 'Resets local salon settings stored on this device.',
          action: 'Clear',
          onTap: _clearLocalCache,
        ),
      ],
    );
  }

  Future<void> _openLanguage() {
    return _openSheet(
      title: 'Language',
      subtitle: 'Pick your preferred language for salon settings.',
      children: [
        _OptionRow(
          icon: Icons.language_rounded,
          title: 'App language',
          subtitle: 'Saved on this device.',
          value: _language,
          options: const ['English', 'Swahili', 'French'],
          onSelected: (value) => _setString('language', value),
        ),
      ],
    );
  }

  Future<void> _clearLocalCache() async {
    final confirmed = await showSettingsConfirmationSheet(
      context: context,
      title: 'Clear local cache?',
      subtitle:
          'This resets cached salon display preferences. Backend-synced account settings can be restored by signing in again.',
      actionLabel: 'Clear',
      destructive: true,
    );
    if (!confirmed) return;
    await _settingsRepo.updateSettings({
      for (final key in _toggles.keys) _settingKey(key): null,
      _settingKey('bookingWindow'): null,
      _settingKey('cancellationPolicy'): null,
      _settingKey('paymentMethod'): null,
      _settingKey('mediaQuality'): null,
      _settingKey('language'): null,
    });
    if (!mounted) return;
    setState(() {
      _toggles = Map.of(_defaultToggles);
      _bookingWindow = '30 days';
      _cancellationPolicy = 'Flexible';
      _paymentMethod = 'Cash at salon';
      _mediaQuality = 'Balanced';
      _language = 'English';
    });
    showSettingsSnack(context, 'Local settings reset');
  }
}

class _SettingsGroup extends StatelessWidget {
  const _SettingsGroup({required this.title, required this.children});

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

class _SettingsTile extends StatelessWidget {
  const _SettingsTile({
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
                  constraints: const BoxConstraints(maxWidth: 96),
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

class _DangerTile extends StatelessWidget {
  const _DangerTile({required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    return DecoratedBox(
      decoration: BoxDecoration(
        color: scheme.errorContainer.withValues(alpha: 0.36),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: scheme.error.withValues(alpha: 0.2)),
      ),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: scheme.error.withValues(alpha: 0.12),
          child: Icon(Icons.logout_rounded, color: scheme.error),
        ),
        title: Text(
          'Logout',
          style: theme.textTheme.bodyLarge?.copyWith(
            color: scheme.error,
            fontWeight: FontWeight.w800,
          ),
        ),
        subtitle: Text(
          'Sign out from this salon account',
          style: TextStyle(color: scheme.error.withValues(alpha: 0.76)),
        ),
        onTap: onTap,
      ),
    );
  }
}
