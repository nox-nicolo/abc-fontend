import 'dart:convert';

import 'package:africa_beuty/feature/auth/repositories/local_storage_service.dart';
import 'package:africa_beuty/feature/profile/model/account_security.dart';
import 'package:africa_beuty/feature/profile/repositories/account_security.dart';
import 'package:africa_beuty/feature/profile/repositories/account_settings.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:share_plus/share_plus.dart';

class CustomerBeautyPreferencesPage extends StatefulWidget {
  const CustomerBeautyPreferencesPage({super.key});

  @override
  State<CustomerBeautyPreferencesPage> createState() =>
      _CustomerBeautyPreferencesPageState();
}

class _CustomerBeautyPreferencesPageState
    extends State<CustomerBeautyPreferencesPage> {
  final _repo = AccountSettingsRepository();
  final _city = TextEditingController();
  final Set<String> _styles = {};
  final Set<String> _services = {};
  RangeValues _budget = const RangeValues(25000, 150000);
  double _radiusKm = 15;
  bool _loading = true;
  bool _saving = false;

  static const _styleOptions = [
    'Braids',
    'Natural hair',
    'Wigs',
    'Nails',
    'Makeup',
    'Facial',
    'Lashes',
    'Color',
  ];

  static const _serviceOptions = [
    'Hair styling',
    'Protective styles',
    'Manicure',
    'Pedicure',
    'Makeup artist',
    'Skin care',
    'Massage',
    'Bridal',
  ];

  @override
  void initState() {
    super.initState();
    _load();
  }

  @override
  void dispose() {
    _city.dispose();
    super.dispose();
  }

  Future<void> _load() async {
    final result = await _repo.getSettings();
    if (!mounted) return;
    result.match((failure) => _snack(failure.message), (settings) {
      final data = Map<String, dynamic>.from(
        settings['customer_beauty_preferences'] as Map? ?? {},
      );
      setState(() {
        _styles
          ..clear()
          ..addAll((data['styles'] as List? ?? const []).map((e) => '$e'));
        _services
          ..clear()
          ..addAll((data['services'] as List? ?? const []).map((e) => '$e'));
        _budget = RangeValues(
          (data['budgetMin'] as num?)?.toDouble() ?? 25000,
          (data['budgetMax'] as num?)?.toDouble() ?? 150000,
        );
        _radiusKm = (data['radiusKm'] as num?)?.toDouble() ?? 15;
        _city.text = data['preferredArea']?.toString() ?? '';
        _loading = false;
      });
    });
  }

  Future<void> _save() async {
    setState(() => _saving = true);
    final result = await _repo.updateSettings({
      'customer_beauty_preferences': {
        'styles': _styles.toList(),
        'services': _services.toList(),
        'budgetMin': _budget.start.round(),
        'budgetMax': _budget.end.round(),
        'radiusKm': _radiusKm.round(),
        'preferredArea': _city.text.trim(),
      },
      'customer_settings_nearbyDiscovery': true,
      'customer_settings_personalizedRecommendations': true,
    });
    if (!mounted) return;
    result.match((failure) => _snack(failure.message), (_) {
      _snack('Beauty preferences saved');
    });
    setState(() => _saving = false);
  }

  void _toggle(Set<String> values, String value) {
    setState(() {
      values.contains(value) ? values.remove(value) : values.add(value);
    });
  }

  void _snack(String message) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) return const _LoadingScaffold(title: 'Beauty preferences');
    final currency = NumberFormat.compactCurrency(symbol: 'TZS ');
    return Scaffold(
      appBar: AppBar(title: const Text('Beauty preferences')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const _PageIntro(
            icon: Icons.auto_awesome_rounded,
            title: 'Personal beauty profile',
            subtitle:
                'Choose the styles, services, budget, and distance that should shape salon discovery.',
          ),
          const SizedBox(height: 16),
          _Section(
            title: 'Style interests',
            children: [
              _ChipSelector(
                options: _styleOptions,
                selected: _styles,
                onTap: (value) => _toggle(_styles, value),
              ),
            ],
          ),
          const SizedBox(height: 14),
          _Section(
            title: 'Services',
            children: [
              _ChipSelector(
                options: _serviceOptions,
                selected: _services,
                onTap: (value) => _toggle(_services, value),
              ),
            ],
          ),
          const SizedBox(height: 14),
          _Section(
            title: 'Budget and area',
            children: [
              Text(
                '${currency.format(_budget.start)} - ${currency.format(_budget.end)}',
              ),
              RangeSlider(
                values: _budget,
                min: 5000,
                max: 500000,
                divisions: 99,
                labels: RangeLabels(
                  currency.format(_budget.start),
                  currency.format(_budget.end),
                ),
                onChanged: (value) => setState(() => _budget = value),
              ),
              const SizedBox(height: 12),
              Text('Location radius: ${_radiusKm.round()} km'),
              Slider(
                value: _radiusKm,
                min: 1,
                max: 100,
                divisions: 99,
                label: '${_radiusKm.round()} km',
                onChanged: (value) => setState(() => _radiusKm = value),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: _city,
                textCapitalization: TextCapitalization.words,
                decoration: const InputDecoration(
                  labelText: 'Preferred area or city',
                  border: OutlineInputBorder(),
                ),
              ),
            ],
          ),
          const SizedBox(height: 18),
          FilledButton.icon(
            onPressed: _saving ? null : _save,
            icon: _saving
                ? const SizedBox.square(
                    dimension: 18,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : const Icon(Icons.save_rounded),
            label: const Text('Save preferences'),
          ),
        ],
      ),
    );
  }
}

class CustomerMutedBlockedPage extends StatefulWidget {
  const CustomerMutedBlockedPage({super.key});

  @override
  State<CustomerMutedBlockedPage> createState() =>
      _CustomerMutedBlockedPageState();
}

class _CustomerMutedBlockedPageState extends State<CustomerMutedBlockedPage> {
  final _securityRepo = AccountSecurityRepository();
  final _settingsRepo = AccountSettingsRepository();
  final _search = TextEditingController();
  List<MutedAccount> _mutes = const [];
  List<String> _blocked = const [];
  String _sort = 'newest';
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _search.addListener(() => setState(() {}));
    _load();
  }

  @override
  void dispose() {
    _search.dispose();
    super.dispose();
  }

  Future<void> _load() async {
    setState(() => _loading = true);
    final mutes = await _securityRepo.getMutedAccounts(
      query: _search.text,
      sort: _sort,
    );
    final settings = await _settingsRepo.getSettings();
    if (!mounted) return;
    mutes.match(
      (failure) => _snack(failure.message),
      (items) => _mutes = items,
    );
    settings.match((failure) => _snack(failure.message), (data) {
      _blocked = (data['customer_blocked_accounts'] as List? ?? const [])
          .map((item) => item.toString())
          .toList();
    });
    setState(() => _loading = false);
  }

  Future<void> _unmute(MutedAccount item) async {
    final confirmed = await _confirmDialog(
      context: context,
      title: 'Unmute account?',
      message:
          '${_targetLabel(item)} will be able to appear in your feed again.',
      actionLabel: 'Unmute',
    );
    if (confirmed != true) return;
    final result = await _securityRepo.unmute(item);
    if (!mounted) return;
    result.match((failure) => _snack(failure.message), (_) {
      _snack('Account unmuted');
      _load();
    });
  }

  Future<void> _addBlocked() async {
    final value = await _textDialog(
      context: context,
      title: 'Add blocked account',
      label: 'Username or profile id',
    );
    if (value == null || value.trim().isEmpty) return;
    setState(() => _blocked = {..._blocked, value.trim()}.toList());
    await _saveBlocked();
  }

  Future<void> _removeBlocked(String value) async {
    final confirmed = await _confirmDialog(
      context: context,
      title: 'Unblock account?',
      message: '$value will be removed from your blocked list.',
      actionLabel: 'Unblock',
    );
    if (confirmed != true) return;
    setState(() => _blocked = _blocked.where((item) => item != value).toList());
    await _saveBlocked();
  }

  Future<void> _saveBlocked() async {
    final result = await _settingsRepo.updateSettings({
      'customer_blocked_accounts': _blocked,
    });
    if (!mounted) return;
    result.match((failure) => _snack(failure.message), (_) {});
  }

  void _snack(String message) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
  }

  List<MutedAccount> get _visibleMutes {
    final query = _search.text.trim().toLowerCase();
    final items = query.isEmpty
        ? [..._mutes]
        : _mutes.where((item) {
            final haystack = [
              item.targetType,
              item.targetId,
              item.reason ?? '',
              _targetLabel(item),
            ].join(' ').toLowerCase();
            return haystack.contains(query);
          }).toList();
    items.sort((a, b) {
      if (_sort == 'type') {
        final byType = a.targetType.compareTo(b.targetType);
        if (byType != 0) return byType;
      }
      return (b.createdAt ?? DateTime.fromMillisecondsSinceEpoch(0)).compareTo(
        a.createdAt ?? DateTime.fromMillisecondsSinceEpoch(0),
      );
    });
    return items;
  }

  List<String> get _visibleBlocked {
    final query = _search.text.trim().toLowerCase();
    final items = query.isEmpty
        ? [..._blocked]
        : _blocked.where((item) => item.toLowerCase().contains(query)).toList();
    if (_sort == 'type') {
      items.sort((a, b) => a.toLowerCase().compareTo(b.toLowerCase()));
    } else {
      items.sort((a, b) => _blocked.indexOf(b).compareTo(_blocked.indexOf(a)));
    }
    return items;
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) return const _LoadingScaffold(title: 'Muted and blocked');
    final mutes = _visibleMutes;
    final blocked = _visibleBlocked;
    return Scaffold(
      appBar: AppBar(title: const Text('Muted and blocked')),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _addBlocked,
        icon: const Icon(Icons.add_rounded),
        label: const Text('Block'),
      ),
      body: RefreshIndicator(
        onRefresh: _load,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            const _PageIntro(
              icon: Icons.visibility_off_rounded,
              title: 'Safety list',
              subtitle:
                  'Review muted salons from backend controls and keep a synced customer block list.',
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _search,
              textInputAction: TextInputAction.search,
              decoration: InputDecoration(
                prefixIcon: const Icon(Icons.search_rounded),
                suffixIcon: _search.text.isEmpty
                    ? null
                    : IconButton(
                        tooltip: 'Clear search',
                        onPressed: _search.clear,
                        icon: const Icon(Icons.close_rounded),
                      ),
                labelText: 'Search muted and blocked',
                border: const OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 12),
            SegmentedButton<String>(
              segments: const [
                ButtonSegment(
                  value: 'newest',
                  icon: Icon(Icons.schedule_rounded),
                  label: Text('Newest'),
                ),
                ButtonSegment(
                  value: 'type',
                  icon: Icon(Icons.sort_by_alpha_rounded),
                  label: Text('Type'),
                ),
              ],
              selected: {_sort},
              onSelectionChanged: (values) {
                setState(() => _sort = values.first);
                _load();
              },
            ),
            const SizedBox(height: 16),
            _Section(
              title: 'Muted accounts',
              children: [
                if (mutes.isEmpty)
                  const ListTile(
                    contentPadding: EdgeInsets.zero,
                    title: Text('Nothing muted'),
                    subtitle: Text('Muted salons and profiles appear here.'),
                  )
                else
                  for (final item in mutes)
                    ListTile(
                      contentPadding: EdgeInsets.zero,
                      leading: const Icon(Icons.volume_off_rounded),
                      title: Text(_targetLabel(item)),
                      subtitle: Text(_muteDetails(item)),
                      trailing: TextButton(
                        onPressed: () => _unmute(item),
                        child: const Text('Unmute'),
                      ),
                    ),
              ],
            ),
            const SizedBox(height: 14),
            _Section(
              title: 'Blocked list',
              children: [
                if (blocked.isEmpty)
                  const ListTile(
                    contentPadding: EdgeInsets.zero,
                    title: Text('No blocked accounts'),
                    subtitle: Text('Add usernames or profile ids to hide.'),
                  )
                else
                  for (final item in blocked)
                    ListTile(
                      contentPadding: EdgeInsets.zero,
                      leading: const Icon(Icons.block_rounded),
                      title: Text(item),
                      subtitle: const Text(
                        'Reason: Manually blocked - Date not recorded',
                      ),
                      trailing: IconButton(
                        tooltip: 'Remove',
                        onPressed: () => _removeBlocked(item),
                        icon: const Icon(Icons.close_rounded),
                      ),
                    ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class CustomerRecommendationControlsPage extends StatefulWidget {
  const CustomerRecommendationControlsPage({super.key});

  @override
  State<CustomerRecommendationControlsPage> createState() =>
      _CustomerRecommendationControlsPageState();
}

class _CustomerRecommendationControlsPageState
    extends State<CustomerRecommendationControlsPage> {
  final _repo = AccountSettingsRepository();
  bool _useSaved = true;
  bool _useFollowing = true;
  bool _useBookings = true;
  bool _useLocation = true;
  bool _showTrending = true;
  bool _showPromotions = true;
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final result = await _repo.getSettings();
    if (!mounted) return;
    result.match((failure) => _snack(failure.message), (settings) {
      final data = Map<String, dynamic>.from(
        settings['customer_recommendation_controls'] as Map? ?? {},
      );
      setState(() {
        _useSaved = data['useSaved'] as bool? ?? true;
        _useFollowing = data['useFollowing'] as bool? ?? true;
        _useBookings = data['useBookings'] as bool? ?? true;
        _useLocation = data['useLocation'] as bool? ?? true;
        _showTrending = data['showTrending'] as bool? ?? true;
        _showPromotions = data['showPromotions'] as bool? ?? true;
        _loading = false;
      });
    });
  }

  Future<void> _save() async {
    final result = await _repo.updateSettings({
      'customer_recommendation_controls': {
        'useSaved': _useSaved,
        'useFollowing': _useFollowing,
        'useBookings': _useBookings,
        'useLocation': _useLocation,
        'showTrending': _showTrending,
        'showPromotions': _showPromotions,
      },
      'customer_settings_personalizedRecommendations':
          _useSaved || _useFollowing || _useBookings,
      'customer_settings_nearbyDiscovery': _useLocation,
    });
    if (!mounted) return;
    result.match((failure) => _snack(failure.message), (_) {});
  }

  Future<void> _set(
    bool Function() getter,
    void Function(bool) setter,
    bool v,
  ) {
    setState(() => setter(v));
    return _save();
  }

  Future<void> _reset() async {
    setState(() {
      _useSaved = true;
      _useFollowing = true;
      _useBookings = true;
      _useLocation = true;
      _showTrending = true;
      _showPromotions = true;
    });
    await _save();
    _snack('Recommendation controls reset');
  }

  void _snack(String message) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) return const _LoadingScaffold(title: 'Recommendations');
    return Scaffold(
      appBar: AppBar(title: const Text('Recommendations')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _PageIntro(
            icon: Icons.tune_rounded,
            title: 'Recommendation controls',
            subtitle:
                'Choose which customer signals can shape salon, service, and style suggestions.',
            action: OutlinedButton.icon(
              onPressed: _reset,
              icon: const Icon(Icons.restart_alt_rounded),
              label: const Text('Reset'),
            ),
          ),
          const SizedBox(height: 16),
          _Section(
            title: 'Personal signals',
            children: [
              _SwitchTile(
                value: _useSaved,
                title: 'Use saved salons and styles',
                subtitle: 'Recommend similar salons, services, and looks.',
                onChanged: (v) =>
                    _set(() => _useSaved, (x) => _useSaved = x, v),
              ),
              _SwitchTile(
                value: _useFollowing,
                title: 'Use following',
                subtitle: 'Use salons you follow as taste signals.',
                onChanged: (v) =>
                    _set(() => _useFollowing, (x) => _useFollowing = x, v),
              ),
              _SwitchTile(
                value: _useBookings,
                title: 'Use booking history',
                subtitle: 'Prioritize services you book or revisit.',
                onChanged: (v) =>
                    _set(() => _useBookings, (x) => _useBookings = x, v),
              ),
              _SwitchTile(
                value: _useLocation,
                title: 'Use approximate location',
                subtitle: 'Improve nearby salon discovery.',
                onChanged: (v) =>
                    _set(() => _useLocation, (x) => _useLocation = x, v),
              ),
            ],
          ),
          const SizedBox(height: 14),
          _Section(
            title: 'Discovery mix',
            children: [
              _SwitchTile(
                value: _showTrending,
                title: 'Show trending styles',
                subtitle: 'Include popular looks in discovery.',
                onChanged: (v) =>
                    _set(() => _showTrending, (x) => _showTrending = x, v),
              ),
              _SwitchTile(
                value: _showPromotions,
                title: 'Show promotions',
                subtitle: 'Include salon offers and campaign suggestions.',
                onChanged: (v) =>
                    _set(() => _showPromotions, (x) => _showPromotions = x, v),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class CustomerDataDownloadPage extends StatefulWidget {
  const CustomerDataDownloadPage({super.key});

  @override
  State<CustomerDataDownloadPage> createState() =>
      _CustomerDataDownloadPageState();
}

class _CustomerDataDownloadPageState extends State<CustomerDataDownloadPage> {
  final _repo = AccountSettingsRepository();
  String _json = '';
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final user = await LocalStorageService.getUserData();
    final settings = await _repo.getSettings();
    if (!mounted) return;
    settings.match((failure) => _snack(failure.message), (data) {
      final export = {
        'exported_at': DateTime.now().toIso8601String(),
        'profile': user?.toMap(),
        'customer_settings': data.entries
            .where((entry) => entry.key.startsWith('customer_'))
            .fold<Map<String, dynamic>>({}, (map, entry) {
              map[entry.key] = entry.value;
              return map;
            }),
      };
      setState(() {
        _json = const JsonEncoder.withIndent('  ').convert(export);
        _loading = false;
      });
    });
  }

  Future<void> _copy() async {
    await Clipboard.setData(ClipboardData(text: _json));
    if (!mounted) return;
    _snack('Account data copied');
  }

  Future<void> _share() async {
    await SharePlus.instance.share(
      ShareParams(text: _json, subject: 'African Beauty customer data'),
    );
  }

  void _snack(String message) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) return const _LoadingScaffold(title: 'Account data');
    return Scaffold(
      appBar: AppBar(title: const Text('Account data')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _PageIntro(
            icon: Icons.download_rounded,
            title: 'Download account data',
            subtitle:
                'Export your profile snapshot and synced customer preferences as readable JSON.',
            action: Row(
              children: [
                Expanded(
                  child: FilledButton.icon(
                    onPressed: _share,
                    icon: const Icon(Icons.ios_share_rounded),
                    label: const Text('Share'),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: _copy,
                    icon: const Icon(Icons.copy_rounded),
                    label: const Text('Copy'),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: Theme.of(context).colorScheme.outlineVariant,
              ),
            ),
            child: SelectableText(
              _json,
              style: Theme.of(
                context,
              ).textTheme.bodySmall?.copyWith(fontFamily: 'Roboto'),
            ),
          ),
        ],
      ),
    );
  }
}

class CustomerProfilePreviewVisibilityPage extends StatefulWidget {
  const CustomerProfilePreviewVisibilityPage({super.key});

  @override
  State<CustomerProfilePreviewVisibilityPage> createState() =>
      _CustomerProfilePreviewVisibilityPageState();
}

class _CustomerProfilePreviewVisibilityPageState
    extends State<CustomerProfilePreviewVisibilityPage> {
  final _repo = AccountSettingsRepository();
  String _audience = 'Anyone with link';
  bool _discoverable = true;
  bool _photo = true;
  bool _bio = true;
  bool _city = true;
  bool _following = false;
  bool _saved = false;
  bool _bookingActivity = false;
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final result = await _repo.getSettings();
    if (!mounted) return;
    result.match((failure) => _snack(failure.message), (settings) {
      final data = Map<String, dynamic>.from(
        settings['customer_profile_preview_visibility'] as Map? ?? {},
      );
      setState(() {
        _audience =
            settings['customer_three_dots_shareAudience'] as String? ??
            data['audience'] as String? ??
            _audience;
        _discoverable =
            settings['customer_settings_profileDiscoverable'] as bool? ??
            data['discoverable'] as bool? ??
            true;
        _photo = data['photo'] as bool? ?? true;
        _bio = data['bio'] as bool? ?? true;
        _city = data['city'] as bool? ?? true;
        _following = data['following'] as bool? ?? false;
        _saved = data['saved'] as bool? ?? false;
        _bookingActivity = data['bookingActivity'] as bool? ?? false;
        _loading = false;
      });
    });
  }

  Future<void> _save() async {
    final result = await _repo.updateSettings({
      'customer_three_dots_shareAudience': _audience,
      'customer_settings_profileDiscoverable': _discoverable,
      'customer_profile_preview_visibility': {
        'audience': _audience,
        'discoverable': _discoverable,
        'photo': _photo,
        'bio': _bio,
        'city': _city,
        'following': _following,
        'saved': _saved,
        'bookingActivity': _bookingActivity,
      },
    });
    if (!mounted) return;
    result.match((failure) => _snack(failure.message), (_) {});
  }

  Future<void> _set(void Function(bool) setter, bool value) async {
    setState(() => setter(value));
    await _save();
  }

  void _snack(String message) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) return const _LoadingScaffold(title: 'Profile preview');
    return Scaffold(
      appBar: AppBar(title: const Text('Profile preview')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const _PageIntro(
            icon: Icons.visibility_rounded,
            title: 'Preview visibility',
            subtitle:
                'Control what appears when salons or people open your customer profile preview.',
          ),
          const SizedBox(height: 16),
          _Section(
            title: 'Audience',
            children: [
              DropdownButtonFormField<String>(
                initialValue: _audience,
                decoration: const InputDecoration(
                  labelText: 'Profile link audience',
                  border: OutlineInputBorder(),
                ),
                items: const [
                  DropdownMenuItem(
                    value: 'Anyone with link',
                    child: Text('Anyone with link'),
                  ),
                  DropdownMenuItem(
                    value: 'Followers only',
                    child: Text('Followers only'),
                  ),
                  DropdownMenuItem(value: 'Only me', child: Text('Only me')),
                ],
                onChanged: (value) async {
                  if (value == null) return;
                  setState(() => _audience = value);
                  await _save();
                },
              ),
              _SwitchTile(
                value: _discoverable,
                title: 'Discoverable profile',
                subtitle: 'Allow salons and people to find your profile.',
                onChanged: (value) => _set((v) => _discoverable = v, value),
              ),
            ],
          ),
          const SizedBox(height: 14),
          _Section(
            title: 'Preview fields',
            children: [
              _SwitchTile(
                value: _photo,
                title: 'Photo',
                subtitle: 'Show your profile picture in previews.',
                onChanged: (value) => _set((v) => _photo = v, value),
              ),
              _SwitchTile(
                value: _bio,
                title: 'Bio',
                subtitle: 'Show your short profile note.',
                onChanged: (value) => _set((v) => _bio = v, value),
              ),
              _SwitchTile(
                value: _city,
                title: 'City',
                subtitle: 'Show approximate location in share previews.',
                onChanged: (value) => _set((v) => _city = v, value),
              ),
              _SwitchTile(
                value: _following,
                title: 'Following',
                subtitle: 'Show salons you follow.',
                onChanged: (value) => _set((v) => _following = v, value),
              ),
              _SwitchTile(
                value: _saved,
                title: 'Saved items',
                subtitle: 'Show saved style inspiration.',
                onChanged: (value) => _set((v) => _saved = v, value),
              ),
              _SwitchTile(
                value: _bookingActivity,
                title: 'Booking activity',
                subtitle: 'Show profile hints based on beauty bookings.',
                onChanged: (value) => _set((v) => _bookingActivity = v, value),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _PageIntro extends StatelessWidget {
  const _PageIntro({
    required this.icon,
    required this.title,
    required this.subtitle,
    this.action,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final Widget? action;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: scheme.surfaceContainerHighest.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: scheme.outlineVariant),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CircleAvatar(
                backgroundColor: scheme.primary.withValues(alpha: 0.12),
                child: Icon(icon, color: scheme.primary),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      subtitle,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: scheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          if (action != null) ...[const SizedBox(height: 14), action!],
        ],
      ),
    );
  }
}

class _Section extends StatelessWidget {
  const _Section({required this.title, required this.children});

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
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: scheme.outlineVariant),
          ),
          child: Column(children: children),
        ),
      ],
    );
  }
}

class _ChipSelector extends StatelessWidget {
  const _ChipSelector({
    required this.options,
    required this.selected,
    required this.onTap,
  });

  final List<String> options;
  final Set<String> selected;
  final ValueChanged<String> onTap;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Wrap(
        spacing: 8,
        runSpacing: 8,
        children: [
          for (final option in options)
            FilterChip(
              label: Text(option),
              selected: selected.contains(option),
              onSelected: (_) => onTap(option),
            ),
        ],
      ),
    );
  }
}

class _SwitchTile extends StatelessWidget {
  const _SwitchTile({
    required this.value,
    required this.title,
    required this.subtitle,
    required this.onChanged,
  });

  final bool value;
  final String title;
  final String subtitle;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    return SwitchListTile.adaptive(
      value: value,
      onChanged: onChanged,
      contentPadding: EdgeInsets.zero,
      title: Text(title, style: const TextStyle(fontWeight: FontWeight.w700)),
      subtitle: Text(subtitle),
    );
  }
}

class _LoadingScaffold extends StatelessWidget {
  const _LoadingScaffold({required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: const Center(child: CircularProgressIndicator()),
    );
  }
}

Future<String?> _textDialog({
  required BuildContext context,
  required String title,
  required String label,
}) {
  final controller = TextEditingController();
  return showDialog<String>(
    context: context,
    builder: (ctx) => AlertDialog(
      title: Text(title),
      content: TextField(
        controller: controller,
        decoration: InputDecoration(labelText: label),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(ctx),
          child: const Text('Cancel'),
        ),
        FilledButton(
          onPressed: () => Navigator.pop(ctx, controller.text.trim()),
          child: const Text('Save'),
        ),
      ],
    ),
  ).whenComplete(controller.dispose);
}

Future<bool?> _confirmDialog({
  required BuildContext context,
  required String title,
  required String message,
  required String actionLabel,
}) {
  return showDialog<bool>(
    context: context,
    builder: (ctx) => AlertDialog(
      title: Text(title),
      content: Text(message),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(ctx, false),
          child: const Text('Cancel'),
        ),
        FilledButton(
          onPressed: () => Navigator.pop(ctx, true),
          child: Text(actionLabel),
        ),
      ],
    ),
  );
}

String _targetLabel(MutedAccount item) {
  final type = item.targetType.trim().isEmpty ? 'Account' : item.targetType;
  return '$type ${item.targetId}';
}

String _muteDetails(MutedAccount item) {
  final reason = item.reason?.trim();
  final parts = <String>[
    'Reason: ${reason == null || reason.isEmpty ? 'Not provided' : reason}',
    _dateLabel(item.createdAt),
  ].where((part) => part.trim().isNotEmpty).toList();
  return parts.join(' - ');
}

String _dateLabel(DateTime? value) {
  if (value == null) return '';
  return 'Muted ${DateFormat.yMMMd().format(value.toLocal())}';
}
