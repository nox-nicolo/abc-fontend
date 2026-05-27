import 'package:africa_beuty/feature/booking/view/pages/customer_booking.dart';
import 'package:africa_beuty/feature/chat/view/page/chats_page.dart';
import 'package:africa_beuty/feature/profile/view/page/account_security_page.dart';
import 'package:africa_beuty/feature/profile/view/page/appointment_reminders.dart';
import 'package:africa_beuty/feature/profile/view/page/audit_log_page.dart';
import 'package:africa_beuty/feature/profile/view/page/customer_personalization.dart';
import 'package:africa_beuty/feature/profile/view/page/edit_customer_profile.dart';
import 'package:africa_beuty/feature/profile/view/page/following_page.dart';
import 'package:africa_beuty/feature/profile/repositories/account_settings.dart';
import 'package:africa_beuty/feature/profile/view/widget/settings_polish.dart';
import 'package:africa_beuty/feature/saved/view/page/saved_page.dart';
import 'package:flutter/material.dart';
import 'package:icons_plus/icons_plus.dart';

class CustomerSettings extends StatefulWidget {
  const CustomerSettings({super.key});

  @override
  State<CustomerSettings> createState() => _CustomerSettingsState();
}

class _CustomerSettingsState extends State<CustomerSettings> {
  final _settingsRepo = AccountSettingsRepository();
  final _searchController = TextEditingController();

  static const Map<String, bool> _defaultToggles = {
    'profileDiscoverable': true,
    'privateSaved': true,
    'messageRequests': true,
    'mentions': true,
    'nearbyDiscovery': true,
    'personalizedRecommendations': true,
    'loginAlerts': true,
    'biometricLock': false,
    'wifiOnlyUploads': false,
    'dataSaver': false,
    'autoCache': true,
  };

  late Map<String, bool> _toggles = Map.of(_defaultToggles);

  String _followingVisibility = 'Only me';
  String _mediaQuality = 'Balanced';
  String _language = 'English';
  String _query = '';

  static const _prefix = 'customer_settings_';
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
        _followingVisibility =
            settings[_settingKey('followingVisibility')] as String? ??
            _followingVisibility;
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
      if (key == 'followingVisibility') _followingVisibility = value;
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
      initialChildSize: 0.86,
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
                  child: Icon(Icons.tune_rounded, color: scheme.primary),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Customer settings',
                        style: theme.textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        'Profile, privacy, bookings, alerts, and app controls',
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
              hintText: 'Search customer settings',
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
                    icon: Icons.person_rounded,
                    label: 'Profile',
                    onTap: () => _pushPage(const EditCustomerProfilePage()),
                  ),
                  FavoriteShortcut(
                    icon: FontAwesome.sliders_solid,
                    label: 'Preferences',
                    onTap: () =>
                        _pushPage(const CustomerBeautyPreferencesPage()),
                  ),
                  FavoriteShortcut(
                    icon: Icons.visibility_rounded,
                    label: 'Preview',
                    onTap: () =>
                        _pushPage(const CustomerProfilePreviewVisibilityPage()),
                  ),
                ],
              ),
            ],
            const SizedBox(height: 18),
            _SettingsGroup(
              title: 'Account',
              children: [
                _SettingsTile(
                  query: _query,
                  icon: Icons.person_rounded,
                  title: 'Profile',
                  subtitle: 'Name, photo, bio, city, country, and gender',
                  onTap: () => _pushPage(const EditCustomerProfilePage()),
                ),
                _SettingsTile(
                  query: _query,
                  icon: FontAwesome.sliders_solid,
                  title: 'Beauty preferences',
                  subtitle:
                      'Services, styles, salon discovery, and saved taste',
                  badgeLabel: 'Synced',
                  onTap: () => _pushPage(const CustomerBeautyPreferencesPage()),
                ),
                _SettingsTile(
                  query: _query,
                  icon: FontAwesome.bookmark_solid,
                  title: 'Saved salons and styles',
                  subtitle: 'Open your saved salons, services, and looks',
                  onTap: () => _pushPage(const SavedPage()),
                ),
                _SettingsTile(
                  query: _query,
                  icon: Icons.people_alt_rounded,
                  title: 'Following',
                  subtitle: 'Manage salons you follow',
                  onTap: () => _pushPage(const FollowingPage()),
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
                  subtitle: 'Visibility, messages, mentions, personalization',
                  onTap: _openPrivacy,
                ),
                _SettingsTile(
                  query: _query,
                  icon: FontAwesome.shield_solid,
                  title: 'Security',
                  subtitle: 'Password, biometric lock, devices, login alerts',
                  badgeLabel: 'Synced',
                  onTap: () =>
                      _pushPage(const AccountSecurityPage(isCustomer: true)),
                ),
                _SettingsTile(
                  query: _query,
                  icon: Icons.manage_history_rounded,
                  title: 'Activity log',
                  subtitle: 'Profile, security, and device changes',
                  badgeLabel: 'Synced',
                  onTap: () => _pushPage(const AuditLogPage(isCustomer: true)),
                ),
                _SettingsTile(
                  query: _query,
                  icon: Icons.block_rounded,
                  title: 'Muted and blocked',
                  subtitle: 'Review muted salons and blocked accounts',
                  onTap: () => _pushPage(const CustomerMutedBlockedPage()),
                ),
              ],
            ),
            const SizedBox(height: 14),
            _SettingsGroup(
              title: 'Bookings and messages',
              children: [
                _SettingsTile(
                  query: _query,
                  icon: FontAwesome.calendar_check,
                  title: 'Bookings',
                  subtitle: 'Upcoming, completed, cancelled, and requested',
                  onTap: () => _pushPage(const CustomerBookingPage()),
                ),
                _SettingsTile(
                  query: _query,
                  icon: FontAwesome.bell_solid,
                  title: 'Notifications',
                  subtitle: 'Comments, booking updates, offers, reminders',
                  onTap: () => _pushPage(const AppointmentRemindersPage()),
                ),
                _SettingsTile(
                  query: _query,
                  icon: Icons.chat_bubble_rounded,
                  title: 'Messages',
                  subtitle: 'Open salon chats and message requests',
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
                  subtitle: 'Cache, media quality, uploads, network usage',
                  trailingText: _mediaQuality,
                  badgeLabel: 'Local',
                  badgeTone: SettingsBadgeTone.local,
                  onTap: _openStorageAndData,
                ),
                _SettingsTile(
                  query: _query,
                  icon: Icons.download_rounded,
                  title: 'Download account data',
                  subtitle: 'Export profile and synced customer preferences',
                  onTap: () => _pushPage(const CustomerDataDownloadPage()),
                ),
                _SettingsTile(
                  query: _query,
                  icon: FontAwesome.globe_solid,
                  title: 'Language',
                  subtitle: 'Choose the language used in the app',
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
                      'You will need to sign in again to manage bookings, saved items, and profile settings.',
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
      subtitle:
          'Tune who can find you, contact you, and shape recommendations.',
      children: [
        _SwitchRow(
          value: _toggles['profileDiscoverable']!,
          icon: Icons.public_rounded,
          title: 'Discoverable profile',
          subtitle: 'Allow salons and people to find your profile.',
          onChanged: (value) => _setToggle('profileDiscoverable', value),
        ),
        _SwitchRow(
          value: _toggles['privateSaved']!,
          icon: Icons.favorite_rounded,
          title: 'Keep saved items private',
          subtitle: 'Saved salons and styles stay visible only to you.',
          onChanged: (value) => _setToggle('privateSaved', value),
        ),
        _OptionRow(
          icon: Icons.people_alt_rounded,
          title: 'Following visibility',
          subtitle: 'Who can see salons you follow.',
          value: _followingVisibility,
          options: const ['Only me', 'Followers', 'Everyone'],
          onSelected: (value) => _setString('followingVisibility', value),
        ),
        _SwitchRow(
          value: _toggles['messageRequests']!,
          icon: Icons.mark_chat_unread_rounded,
          title: 'Message requests',
          subtitle: 'Let salons message after bookings or inquiries.',
          onChanged: (value) => _setToggle('messageRequests', value),
        ),
        _SwitchRow(
          value: _toggles['nearbyDiscovery']!,
          icon: Icons.location_on_rounded,
          title: 'Nearby salon discovery',
          subtitle: 'Use approximate location for better salon results.',
          onChanged: (value) => _setToggle('nearbyDiscovery', value),
        ),
        _SwitchRow(
          value: _toggles['personalizedRecommendations']!,
          icon: Icons.auto_awesome_rounded,
          title: 'Personalized recommendations',
          subtitle: 'Use your activity to improve beauty discovery.',
          onChanged: (value) =>
              _setToggle('personalizedRecommendations', value),
        ),
      ],
    );
  }

  Future<void> _openStorageAndData() {
    return _openSheet(
      title: 'Storage and data',
      subtitle: 'Control network use, upload behavior, and local media cache.',
      children: [
        _OptionRow(
          icon: Icons.high_quality_rounded,
          title: 'Media quality',
          subtitle: 'Balance upload quality with speed.',
          value: _mediaQuality,
          options: const ['Data saver', 'Balanced', 'Original'],
          onSelected: (value) => _setString('mediaQuality', value),
        ),
        _SwitchRow(
          value: _toggles['wifiOnlyUploads']!,
          icon: Icons.wifi_rounded,
          title: 'Upload on Wi-Fi only',
          subtitle: 'Wait for Wi-Fi before uploading larger media.',
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
          subtitle: 'Keep frequently viewed salons quick to reopen.',
          onChanged: (value) => _setToggle('autoCache', value),
        ),
        _ActionRow(
          icon: Icons.cleaning_services_rounded,
          title: 'Clear local cache',
          subtitle: 'Removes temporary preferences and media hints.',
          action: 'Clear',
          onTap: _clearLocalCache,
        ),
      ],
    );
  }

  Future<void> _openLanguage() {
    return _openSheet(
      title: 'Language',
      subtitle: 'Pick your preferred language for customer settings.',
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
          'This resets cached customer display preferences. Backend-synced account settings can be restored by signing in again.',
      actionLabel: 'Clear',
      destructive: true,
    );
    if (!confirmed) return;
    await _settingsRepo.updateSettings({
      for (final key in _toggles.keys) _settingKey(key): null,
      _settingKey('followingVisibility'): null,
      _settingKey('mediaQuality'): null,
      _settingKey('language'): null,
    });
    if (!mounted) return;
    setState(() {
      _toggles = Map.of(_defaultToggles);
      _followingVisibility = 'Only me';
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
                Text(
                  trailingText!,
                  style: theme.textTheme.labelMedium?.copyWith(
                    color: scheme.primary,
                    fontWeight: FontWeight.w800,
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
          'Sign out from this customer account',
          style: TextStyle(color: scheme.error.withValues(alpha: 0.76)),
        ),
        onTap: onTap,
      ),
    );
  }
}
