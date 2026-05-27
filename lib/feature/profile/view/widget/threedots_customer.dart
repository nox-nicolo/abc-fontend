import 'package:africa_beuty/feature/booking/view/pages/customer_booking.dart';
import 'package:africa_beuty/feature/chat/view/page/chats_page.dart';
import 'package:africa_beuty/feature/notifications/view/page/notifications_page.dart';
import 'package:africa_beuty/feature/profile/view/page/appointment_reminders.dart';
import 'package:africa_beuty/feature/profile/view/page/customer_personalization.dart';
import 'package:africa_beuty/feature/profile/view/page/edit_customer_profile.dart';
import 'package:africa_beuty/feature/profile/view/page/following_page.dart';
import 'package:africa_beuty/feature/profile/repositories/account_settings.dart';
import 'package:africa_beuty/feature/profile/view/widget/profile_share_sheet.dart';
import 'package:africa_beuty/feature/profile/view/widget/settings_polish.dart';
import 'package:africa_beuty/feature/search/view/page/search.dart';
import 'package:africa_beuty/feature/saved/view/page/saved_page.dart';
import 'package:flutter/material.dart';
import 'package:icons_plus/icons_plus.dart';

class ThreedotsCustomer extends StatefulWidget {
  const ThreedotsCustomer({super.key});

  @override
  State<ThreedotsCustomer> createState() => _ThreedotsCustomerState();
}

class _ThreedotsCustomerState extends State<ThreedotsCustomer> {
  final _settingsRepo = AccountSettingsRepository();
  final _searchController = TextEditingController();

  String _shareAudience = 'Anyone with link';
  String _activityRange = 'Last 30 days';
  String _query = '';

  static const _prefix = 'customer_three_dots_';
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
        _shareAudience =
            settings[_settingKey('shareAudience')] as String? ?? _shareAudience;
        _activityRange =
            settings[_settingKey('activityRange')] as String? ?? _activityRange;
      });
    });
  }

  void _open(Widget page) {
    Navigator.pop(context);
    Navigator.of(context).push(MaterialPageRoute(builder: (_) => page));
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;

    return DraggableScrollableSheet(
      expand: false,
      initialChildSize: 0.82,
      minChildSize: 0.36,
      maxChildSize: 0.95,
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
                        'Customer tools',
                        style: theme.textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        'Quick actions, activity, sharing, and discovery controls',
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
              hintText: 'Search customer tools',
              onChanged: (value) => setState(() => _query = value),
            ),
            const SizedBox(height: 12),
            if (_query.trim().isEmpty)
              FavoriteShortcutBar(
                children: [
                  FavoriteShortcut(
                    icon: FontAwesome.share_nodes_solid,
                    label: 'Share',
                    onTap: _shareProfile,
                  ),
                  FavoriteShortcut(
                    icon: FontAwesome.calendar_check_solid,
                    label: 'Bookings',
                    onTap: () => _open(const CustomerBookingPage()),
                  ),
                  FavoriteShortcut(
                    icon: FontAwesome.sliders_solid,
                    label: 'Preferences',
                    onTap: () => _open(const CustomerBeautyPreferencesPage()),
                  ),
                ],
              ),
            if (_query.trim().isEmpty) const SizedBox(height: 18),
            _ToolsGroup(
              title: 'Profile actions',
              children: [
                _ToolTile(
                  query: _query,
                  icon: Icons.edit_rounded,
                  title: 'Edit profile',
                  subtitle: 'Name, photo, bio, city, country, and gender',
                  onTap: () => _open(const EditCustomerProfilePage()),
                ),
                _ToolTile(
                  query: _query,
                  icon: FontAwesome.share_nodes_solid,
                  title: 'Share profile',
                  subtitle: 'Preview card, deep link, QR code, native share',
                  trailingText: _shareAudience,
                  badgeLabel: 'Synced',
                  onTap: _shareProfile,
                ),
                _ToolTile(
                  query: _query,
                  icon: Icons.manage_accounts_rounded,
                  title: 'Share settings',
                  subtitle: 'Audience, public link, and location details',
                  onTap: () =>
                      _open(const CustomerProfilePreviewVisibilityPage()),
                ),
                _ToolTile(
                  query: _query,
                  icon: Icons.download_rounded,
                  title: 'Download account data',
                  subtitle: 'Export profile and synced customer preferences',
                  onTap: () => _open(const CustomerDataDownloadPage()),
                ),
              ],
            ),
            const SizedBox(height: 14),
            _ToolsGroup(
              title: 'Customer hub',
              children: [
                _ToolTile(
                  query: _query,
                  icon: FontAwesome.face_smile_beam_solid,
                  title: 'Following',
                  subtitle: 'Salons you follow',
                  onTap: () => _open(const FollowingPage()),
                ),
                _ToolTile(
                  query: _query,
                  icon: FontAwesome.calendar_check_solid,
                  title: 'Bookings',
                  subtitle: 'Upcoming, requested, completed, and cancelled',
                  onTap: () => _open(const CustomerBookingPage()),
                ),
                _ToolTile(
                  query: _query,
                  icon: Bootstrap.bookmark_fill,
                  title: 'Saved',
                  subtitle: 'Saved salons, services, and styles',
                  onTap: () => _open(const SavedPage()),
                ),
                _ToolTile(
                  query: _query,
                  icon: FontAwesome.comment_dots_solid,
                  title: 'Chats',
                  subtitle: 'Messages with salons',
                  onTap: () => _open(const ChatsPage()),
                ),
              ],
            ),
            const SizedBox(height: 14),
            _ToolsGroup(
              title: 'Activity and discovery',
              children: [
                _ToolTile(
                  query: _query,
                  icon: Icons.notifications_rounded,
                  title: 'Notifications inbox',
                  subtitle: 'Booking updates, replies, offers, and reminders',
                  onTap: () => _open(const NotificationsPage()),
                ),
                _ToolTile(
                  query: _query,
                  icon: Icons.notifications_active_rounded,
                  title: 'Reminder controls',
                  subtitle: 'Smart reminders and notification channels',
                  onTap: () => _open(const AppointmentRemindersPage()),
                ),
                _ToolTile(
                  query: _query,
                  icon: Icons.insights_rounded,
                  title: 'Recommendation controls',
                  subtitle: 'Saved, following, booking, location signals',
                  trailingText: _activityRange,
                  badgeLabel: 'Synced',
                  onTap: () =>
                      _open(const CustomerRecommendationControlsPage()),
                ),
                _ToolTile(
                  query: _query,
                  icon: FontAwesome.sliders_solid,
                  title: 'Beauty preferences',
                  subtitle: 'Styles, services, budget, and location radius',
                  onTap: () => _open(const CustomerBeautyPreferencesPage()),
                ),
                _ToolTile(
                  query: _query,
                  icon: Icons.search_rounded,
                  title: 'Discover salons',
                  subtitle: 'Search salons, services, and style inspiration',
                  onTap: () => _open(const SearchPage()),
                ),
              ],
            ),
            const SizedBox(height: 14),
            _ToolsGroup(
              title: 'Safety shortcuts',
              children: [
                _ToolTile(
                  query: _query,
                  icon: Icons.visibility_off_rounded,
                  title: 'Muted and blocked',
                  subtitle: 'Review muted salons and blocked accounts',
                  onTap: () => _open(const CustomerMutedBlockedPage()),
                ),
                _ToolTile(
                  query: _query,
                  icon: Icons.lock_rounded,
                  title: 'Profile preview visibility',
                  subtitle: 'Control what appears in public previews',
                  onTap: () =>
                      _open(const CustomerProfilePreviewVisibilityPage()),
                ),
              ],
            ),
          ],
        );
      },
    );
  }

  Future<void> _shareProfile() {
    return ProfileShareSheet.show(context, type: ProfileShareType.customer);
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
  });

  final String query;
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;
  final String? trailingText;
  final String? badgeLabel;

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
            SettingsStatusBadge(
              label: badgeLabel!,
              tone: SettingsBadgeTone.synced,
            ),
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
