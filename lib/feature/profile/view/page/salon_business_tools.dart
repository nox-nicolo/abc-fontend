import 'dart:math' as math;

import 'package:africa_beuty/feature/booking/model/booking_status.dart';
import 'package:africa_beuty/feature/booking/repository/booking_status.dart';
import 'package:africa_beuty/feature/profile/model/three_dots/stylists/view_stylists.dart';
import 'package:africa_beuty/feature/profile/repositories/account_settings.dart';
import 'package:africa_beuty/feature/profile/repositories/three_dots/stylists/stylists.dart';
import 'package:africa_beuty/feature/profile/view/page/salon_event_campaign.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class SalonPaymentsPage extends StatefulWidget {
  const SalonPaymentsPage({super.key});

  @override
  State<SalonPaymentsPage> createState() => _SalonPaymentsPageState();
}

class _SalonPaymentsPageState extends State<SalonPaymentsPage> {
  final _repo = AccountSettingsRepository();
  final _businessName = TextEditingController();
  final _mobileMoney = TextEditingController();
  final _bankName = TextEditingController();
  final _accountName = TextEditingController();
  final _accountNumber = TextEditingController();
  String _paymentMode = 'Cash at salon';
  bool _depositRequired = false;
  bool _autoReceipts = true;
  bool _payoutAlerts = true;
  bool _loading = true;
  bool _saving = false;

  @override
  void initState() {
    super.initState();
    _load();
  }

  @override
  void dispose() {
    _businessName.dispose();
    _mobileMoney.dispose();
    _bankName.dispose();
    _accountName.dispose();
    _accountNumber.dispose();
    super.dispose();
  }

  Future<void> _load() async {
    final result = await _repo.getSettings();
    if (!mounted) return;
    result.match((failure) => _snack(failure.message), (settings) {
      final data = Map<String, dynamic>.from(
        settings['salon_business_payments'] as Map? ?? {},
      );
      setState(() {
        _businessName.text = data['businessName']?.toString() ?? '';
        _mobileMoney.text = data['mobileMoney']?.toString() ?? '';
        _bankName.text = data['bankName']?.toString() ?? '';
        _accountName.text = data['accountName']?.toString() ?? '';
        _accountNumber.text = data['accountNumber']?.toString() ?? '';
        _paymentMode = data['paymentMode']?.toString() ?? _paymentMode;
        _depositRequired = data['depositRequired'] == true;
        _autoReceipts = data['autoReceipts'] as bool? ?? _autoReceipts;
        _payoutAlerts = data['payoutAlerts'] as bool? ?? _payoutAlerts;
        _loading = false;
      });
    });
  }

  Future<void> _save() async {
    setState(() => _saving = true);
    final result = await _repo.updateSettings({
      'salon_three_dots_paymentMode': _paymentMode,
      'salon_three_dots_autoReceipts': _autoReceipts,
      'salon_three_dots_depositProtection': _depositRequired,
      'salon_three_dots_payoutAlerts': _payoutAlerts,
      'salon_business_payments': {
        'businessName': _businessName.text.trim(),
        'mobileMoney': _mobileMoney.text.trim(),
        'bankName': _bankName.text.trim(),
        'accountName': _accountName.text.trim(),
        'accountNumber': _accountNumber.text.trim(),
        'paymentMode': _paymentMode,
        'depositRequired': _depositRequired,
        'autoReceipts': _autoReceipts,
        'payoutAlerts': _payoutAlerts,
      },
    });
    if (!mounted) return;
    result.match((failure) => _snack(failure.message), (_) {
      _snack('Payment setup saved');
    });
    setState(() => _saving = false);
  }

  void _snack(String message) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) return const _LoadingScaffold(title: 'Payments');
    return Scaffold(
      appBar: AppBar(title: const Text('Payments')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const _PageIntro(
            icon: Icons.payments_rounded,
            title: 'Payout and payment setup',
            subtitle:
                'Keep customer-facing payment labels, receipts, deposits, and payout details consistent across devices.',
          ),
          const SizedBox(height: 16),
          _Section(
            title: 'Customer payment preference',
            children: [
              DropdownButtonFormField<String>(
                initialValue: _paymentMode,
                decoration: const InputDecoration(
                  labelText: 'Preferred payment',
                  border: OutlineInputBorder(),
                ),
                items: const [
                  DropdownMenuItem(
                    value: 'Cash at salon',
                    child: Text('Cash at salon'),
                  ),
                  DropdownMenuItem(
                    value: 'Mobile money',
                    child: Text('Mobile money'),
                  ),
                  DropdownMenuItem(
                    value: 'Bank transfer',
                    child: Text('Bank transfer'),
                  ),
                ],
                onChanged: (value) {
                  if (value != null) setState(() => _paymentMode = value);
                },
              ),
              const SizedBox(height: 12),
              TextField(
                controller: _businessName,
                decoration: const InputDecoration(
                  labelText: 'Business display name',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: _mobileMoney,
                keyboardType: TextInputType.phone,
                decoration: const InputDecoration(
                  labelText: 'Mobile money number',
                  border: OutlineInputBorder(),
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          _Section(
            title: 'Payout account',
            children: [
              TextField(
                controller: _bankName,
                decoration: const InputDecoration(
                  labelText: 'Bank or wallet provider',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: _accountName,
                decoration: const InputDecoration(
                  labelText: 'Account holder name',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: _accountNumber,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Account or wallet number',
                  border: OutlineInputBorder(),
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          _Section(
            title: 'Automation',
            children: [
              SwitchListTile.adaptive(
                value: _depositRequired,
                onChanged: (value) => setState(() => _depositRequired = value),
                title: const Text('Show deposit required label'),
                subtitle: const Text('Useful for high-value or long bookings.'),
              ),
              SwitchListTile.adaptive(
                value: _autoReceipts,
                onChanged: (value) => setState(() => _autoReceipts = value),
                title: const Text('Receipt reminders'),
                subtitle: const Text(
                  'Prompt staff to record payment receipts.',
                ),
              ),
              SwitchListTile.adaptive(
                value: _payoutAlerts,
                onChanged: (value) => setState(() => _payoutAlerts = value),
                title: const Text('Payout alerts'),
                subtitle: const Text('Surface payout and payment follow-ups.'),
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
            label: const Text('Save payment setup'),
          ),
        ],
      ),
    );
  }
}

class SalonAnalyticsPage extends StatefulWidget {
  const SalonAnalyticsPage({super.key});

  @override
  State<SalonAnalyticsPage> createState() => _SalonAnalyticsPageState();
}

class _SalonAnalyticsPageState extends State<SalonAnalyticsPage> {
  final _repo = BookingListRepository();
  late Future<List<BookingListItem>> _future;

  @override
  void initState() {
    super.initState();
    _future = _load();
  }

  Future<List<BookingListItem>> _load() async {
    final result = await _repo.fetchBookings();
    return result.match((failure) => throw failure.message, (items) => items);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Analytics')),
      body: FutureBuilder<List<BookingListItem>>(
        future: _future,
        builder: (context, snapshot) {
          if (snapshot.connectionState != ConnectionState.done) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return _ErrorView(
              message: snapshot.error.toString(),
              onRetry: () => setState(() => _future = _load()),
            );
          }
          final metrics = _SalonMetrics(snapshot.data ?? const []);
          return RefreshIndicator(
            onRefresh: () async => setState(() => _future = _load()),
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                const _PageIntro(
                  icon: Icons.analytics_rounded,
                  title: 'Real booking metrics',
                  subtitle:
                      'Revenue, appointment status, review signal, and service demand are calculated from salon bookings.',
                ),
                const SizedBox(height: 16),
                GridView.count(
                  crossAxisCount: MediaQuery.sizeOf(context).width > 720
                      ? 4
                      : 2,
                  childAspectRatio: 1.35,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  mainAxisSpacing: 10,
                  crossAxisSpacing: 10,
                  children: [
                    _MetricCard(
                      label: 'Completed revenue',
                      value: metrics.money(metrics.completedRevenue),
                      icon: Icons.attach_money_rounded,
                    ),
                    _MetricCard(
                      label: 'Bookings',
                      value: metrics.total.toString(),
                      icon: Icons.calendar_month_rounded,
                    ),
                    _MetricCard(
                      label: 'Upcoming',
                      value: metrics.upcoming.toString(),
                      icon: Icons.event_available_rounded,
                    ),
                    _MetricCard(
                      label: 'Average rating',
                      value: metrics.averageRating == null
                          ? 'N/A'
                          : metrics.averageRating!.toStringAsFixed(1),
                      icon: Icons.star_rounded,
                    ),
                  ],
                ),
                const SizedBox(height: 14),
                _Section(
                  title: 'Booking status',
                  children: [
                    _ProgressRow(
                      label: 'Pending',
                      value: metrics.pending,
                      total: metrics.total,
                    ),
                    _ProgressRow(
                      label: 'Confirmed',
                      value: metrics.confirmed,
                      total: metrics.total,
                    ),
                    _ProgressRow(
                      label: 'Completed',
                      value: metrics.completed,
                      total: metrics.total,
                    ),
                    _ProgressRow(
                      label: 'Cancelled',
                      value: metrics.cancelled,
                      total: metrics.total,
                    ),
                  ],
                ),
                const SizedBox(height: 14),
                _Section(
                  title: 'Top services',
                  children: [
                    if (metrics.topServices.isEmpty)
                      const ListTile(
                        contentPadding: EdgeInsets.zero,
                        title: Text('No service data yet'),
                        subtitle: Text('Completed bookings will appear here.'),
                      )
                    else
                      for (final service in metrics.topServices)
                        ListTile(
                          contentPadding: EdgeInsets.zero,
                          leading: const Icon(Icons.design_services_rounded),
                          title: Text(service.name),
                          subtitle: Text('${service.count} bookings'),
                          trailing: Text(metrics.money(service.revenue)),
                        ),
                  ],
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class SalonCampaignManagerPage extends StatefulWidget {
  const SalonCampaignManagerPage({super.key});

  @override
  State<SalonCampaignManagerPage> createState() =>
      _SalonCampaignManagerPageState();
}

class _SalonCampaignManagerPageState extends State<SalonCampaignManagerPage> {
  final _repo = AccountSettingsRepository();
  List<Map<String, dynamic>> _drafts = [];
  List<Map<String, dynamic>> _history = [];
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
      setState(() {
        _drafts = _list(settings['salon_campaign_drafts']);
        _history = _list(settings['salon_campaign_history']);
        _loading = false;
      });
    });
  }

  Future<void> _save() async {
    final result = await _repo.updateSettings({
      'salon_campaign_drafts': _drafts,
      'salon_campaign_history': _history,
    });
    if (!mounted) return;
    result.match((failure) => _snack(failure.message), (_) {});
  }

  List<Map<String, dynamic>> _list(Object? value) {
    return (value as List? ?? const [])
        .whereType<Map>()
        .map((item) => Map<String, dynamic>.from(item))
        .toList();
  }

  Future<void> _addDraft() async {
    final draft = await showDialog<Map<String, dynamic>>(
      context: context,
      builder: (_) => const _CampaignDraftDialog(),
    );
    if (draft == null) return;
    setState(() => _drafts.insert(0, draft));
    await _save();
  }

  Future<void> _markSent(Map<String, dynamic> draft) async {
    setState(() {
      _drafts.remove(draft);
      _history.insert(0, {
        ...draft,
        'sentAt': DateTime.now().toIso8601String(),
        'status': 'Sent manually',
      });
    });
    await _save();
  }

  Future<void> _deleteDraft(Map<String, dynamic> draft) async {
    setState(() => _drafts.remove(draft));
    await _save();
  }

  void _snack(String message) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) return const _LoadingScaffold(title: 'Campaigns');
    return Scaffold(
      appBar: AppBar(title: const Text('Campaigns')),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _addDraft,
        icon: const Icon(Icons.add_rounded),
        label: const Text('Draft'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _PageIntro(
            icon: Icons.campaign_rounded,
            title: 'Campaign history and drafts',
            subtitle:
                'Prepare offers before sending and keep a lightweight record of salon campaign activity.',
            action: FilledButton.icon(
              onPressed: () => Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) => const SalonEventCampaignPage(),
                ),
              ),
              icon: const Icon(Icons.send_rounded),
              label: const Text('Compose'),
            ),
          ),
          const SizedBox(height: 16),
          _Section(
            title: 'Drafts',
            children: [
              if (_drafts.isEmpty)
                const ListTile(
                  contentPadding: EdgeInsets.zero,
                  title: Text('No drafts yet'),
                  subtitle: Text('Create reusable campaign ideas here.'),
                )
              else
                for (final draft in _drafts)
                  ListTile(
                    contentPadding: EdgeInsets.zero,
                    leading: const Icon(Icons.drafts_rounded),
                    title: Text(draft['title']?.toString() ?? 'Campaign draft'),
                    subtitle: Text(
                      draft['audience']?.toString() ?? 'Followers',
                    ),
                    trailing: PopupMenuButton<String>(
                      onSelected: (value) {
                        if (value == 'sent') _markSent(draft);
                        if (value == 'delete') _deleteDraft(draft);
                      },
                      itemBuilder: (_) => const [
                        PopupMenuItem(value: 'sent', child: Text('Mark sent')),
                        PopupMenuItem(value: 'delete', child: Text('Delete')),
                      ],
                    ),
                  ),
            ],
          ),
          const SizedBox(height: 14),
          _Section(
            title: 'History',
            children: [
              if (_history.isEmpty)
                const ListTile(
                  contentPadding: EdgeInsets.zero,
                  title: Text('No campaign history yet'),
                  subtitle: Text(
                    'Sent campaigns and manual marks appear here.',
                  ),
                )
              else
                for (final item in _history)
                  ListTile(
                    contentPadding: EdgeInsets.zero,
                    leading: const Icon(Icons.history_rounded),
                    title: Text(item['title']?.toString() ?? 'Campaign'),
                    subtitle: Text(item['status']?.toString() ?? 'Sent'),
                    trailing: Text(_dateLabel(item['sentAt']?.toString())),
                  ),
            ],
          ),
        ],
      ),
    );
  }
}

class SalonBookingRulesPage extends StatefulWidget {
  const SalonBookingRulesPage({super.key});

  @override
  State<SalonBookingRulesPage> createState() => _SalonBookingRulesPageState();
}

class _SalonBookingRulesPageState extends State<SalonBookingRulesPage> {
  final _repo = AccountSettingsRepository();
  double _minimumNotice = 4;
  double _cancelWindow = 12;
  double _slotInterval = 30;
  double _bufferMinutes = 15;
  bool _autoConfirm = false;
  bool _allowNotes = true;
  bool _loading = true;
  bool _saving = false;

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
        settings['salon_booking_rules'] as Map? ?? {},
      );
      setState(() {
        _minimumNotice = (data['minimumNoticeHours'] as num?)?.toDouble() ?? 4;
        _cancelWindow = (data['cancelWindowHours'] as num?)?.toDouble() ?? 12;
        _slotInterval = (data['slotIntervalMinutes'] as num?)?.toDouble() ?? 30;
        _bufferMinutes = (data['bufferMinutes'] as num?)?.toDouble() ?? 15;
        _autoConfirm = data['autoConfirm'] == true;
        _allowNotes = data['allowCustomerNotes'] as bool? ?? true;
        _loading = false;
      });
    });
  }

  Future<void> _save() async {
    setState(() => _saving = true);
    final result = await _repo.updateSettings({
      'salon_booking_rules': {
        'minimumNoticeHours': _minimumNotice.round(),
        'cancelWindowHours': _cancelWindow.round(),
        'slotIntervalMinutes': _slotInterval.round(),
        'bufferMinutes': _bufferMinutes.round(),
        'autoConfirm': _autoConfirm,
        'allowCustomerNotes': _allowNotes,
      },
    });
    if (!mounted) return;
    result.match((failure) => _snack(failure.message), (_) {
      _snack('Booking rules saved');
    });
    setState(() => _saving = false);
  }

  void _snack(String message) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) return const _LoadingScaffold(title: 'Booking rules');
    return Scaffold(
      appBar: AppBar(title: const Text('Booking rules')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const _PageIntro(
            icon: Icons.rule_rounded,
            title: 'Backend-synced booking rules',
            subtitle:
                'Control customer booking timing and staff workflow defaults across devices.',
          ),
          const SizedBox(height: 16),
          _Section(
            title: 'Timing',
            children: [
              _SliderTile(
                label: 'Minimum notice',
                value: _minimumNotice,
                suffix: 'hours',
                min: 0,
                max: 48,
                divisions: 24,
                onChanged: (value) => setState(() => _minimumNotice = value),
              ),
              _SliderTile(
                label: 'Cancellation window',
                value: _cancelWindow,
                suffix: 'hours',
                min: 0,
                max: 72,
                divisions: 24,
                onChanged: (value) => setState(() => _cancelWindow = value),
              ),
              _SliderTile(
                label: 'Slot interval',
                value: _slotInterval,
                suffix: 'minutes',
                min: 15,
                max: 120,
                divisions: 7,
                onChanged: (value) => setState(() => _slotInterval = value),
              ),
              _SliderTile(
                label: 'Buffer between bookings',
                value: _bufferMinutes,
                suffix: 'minutes',
                min: 0,
                max: 60,
                divisions: 12,
                onChanged: (value) => setState(() => _bufferMinutes = value),
              ),
            ],
          ),
          const SizedBox(height: 14),
          _Section(
            title: 'Workflow',
            children: [
              SwitchListTile.adaptive(
                value: _autoConfirm,
                onChanged: (value) => setState(() => _autoConfirm = value),
                title: const Text('Auto-confirm eligible bookings'),
                subtitle: const Text(
                  'Use when calendar availability is reliable.',
                ),
              ),
              SwitchListTile.adaptive(
                value: _allowNotes,
                onChanged: (value) => setState(() => _allowNotes = value),
                title: const Text('Allow customer notes'),
                subtitle: const Text(
                  'Let customers add context before arrival.',
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
            label: const Text('Save booking rules'),
          ),
        ],
      ),
    );
  }
}

class SalonTeamPermissionsPage extends StatefulWidget {
  const SalonTeamPermissionsPage({super.key});

  @override
  State<SalonTeamPermissionsPage> createState() =>
      _SalonTeamPermissionsPageState();
}

class _SalonTeamPermissionsPageState extends State<SalonTeamPermissionsPage> {
  final _settingsRepo = AccountSettingsRepository();
  final _stylistRepo = SalonStylistRepository();
  List<StylistItem> _stylists = [];
  Map<String, dynamic> _permissions = {};
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final stylists = await _stylistRepo.getSalonStylists(limit: 100);
    final settings = await _settingsRepo.getSettings();
    if (!mounted) return;
    stylists.match((failure) => _snack(failure.message), (response) {
      _stylists = response.items;
    });
    settings.match((failure) => _snack(failure.message), (data) {
      _permissions = Map<String, dynamic>.from(
        data['salon_team_permissions'] as Map? ?? {},
      );
    });
    setState(() => _loading = false);
  }

  Future<void> _setPermission(
    StylistItem stylist,
    String permission,
    bool value,
  ) async {
    final current = Map<String, dynamic>.from(
      _permissions[stylist.id] as Map? ?? {},
    );
    current[permission] = value;
    setState(() => _permissions[stylist.id] = current);
    final result = await _settingsRepo.updateSettings({
      'salon_team_permissions': _permissions,
    });
    if (!mounted) return;
    result.match((failure) => _snack(failure.message), (_) {});
  }

  bool _allowed(StylistItem stylist, String permission, bool fallback) {
    if (stylist.isOwner) return true;
    final current = Map<String, dynamic>.from(
      _permissions[stylist.id] as Map? ?? {},
    );
    return current[permission] as bool? ?? fallback;
  }

  void _snack(String message) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) return const _LoadingScaffold(title: 'Team permissions');
    return Scaffold(
      appBar: AppBar(title: const Text('Team permissions')),
      body: RefreshIndicator(
        onRefresh: _load,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            const _PageIntro(
              icon: Icons.admin_panel_settings_rounded,
              title: 'Stylist and staff access',
              subtitle:
                  'Owners keep full access. Staff permissions are synced to the salon account for consistent operations.',
            ),
            const SizedBox(height: 16),
            if (_stylists.isEmpty)
              const _Section(
                title: 'Staff',
                children: [
                  ListTile(
                    contentPadding: EdgeInsets.zero,
                    title: Text('No stylists yet'),
                    subtitle: Text(
                      'Add stylists before assigning permissions.',
                    ),
                  ),
                ],
              )
            else
              for (final stylist in _stylists) ...[
                _Section(
                  title: stylist.displayName.trim().isEmpty
                      ? 'Stylist'
                      : stylist.displayName,
                  children: [
                    ListTile(
                      contentPadding: EdgeInsets.zero,
                      leading: CircleAvatar(
                        backgroundImage: stylist.profileImageUrl.isEmpty
                            ? null
                            : NetworkImage(stylist.profileImageUrl),
                        child: stylist.profileImageUrl.isEmpty
                            ? const Icon(Icons.person_rounded)
                            : null,
                      ),
                      title: Text(
                        stylist.username.trim().isEmpty
                            ? stylist.title
                            : '@${stylist.username}',
                      ),
                      subtitle: Text(
                        stylist.isOwner
                            ? 'Owner - full access'
                            : stylist.isActive
                            ? 'Active staff'
                            : 'Inactive staff',
                      ),
                    ),
                    _PermissionSwitch(
                      label: 'Manage bookings',
                      value: _allowed(stylist, 'bookings', true),
                      locked: stylist.isOwner,
                      onChanged: (value) =>
                          _setPermission(stylist, 'bookings', value),
                    ),
                    _PermissionSwitch(
                      label: 'Edit services',
                      value: _allowed(stylist, 'services', false),
                      locked: stylist.isOwner,
                      onChanged: (value) =>
                          _setPermission(stylist, 'services', value),
                    ),
                    _PermissionSwitch(
                      label: 'Send campaigns',
                      value: _allowed(stylist, 'campaigns', false),
                      locked: stylist.isOwner,
                      onChanged: (value) =>
                          _setPermission(stylist, 'campaigns', value),
                    ),
                    _PermissionSwitch(
                      label: 'View analytics',
                      value: _allowed(stylist, 'analytics', false),
                      locked: stylist.isOwner,
                      onChanged: (value) =>
                          _setPermission(stylist, 'analytics', value),
                    ),
                    _PermissionSwitch(
                      label: 'View payments',
                      value: _allowed(stylist, 'payments', false),
                      locked: stylist.isOwner,
                      onChanged: (value) =>
                          _setPermission(stylist, 'payments', value),
                    ),
                  ],
                ),
                const SizedBox(height: 14),
              ],
          ],
        ),
      ),
    );
  }
}

class _SalonMetrics {
  _SalonMetrics(this.bookings);

  final List<BookingListItem> bookings;

  int get total => bookings.length;
  int get pending => _count('pending');
  int get confirmed => _count('confirmed') + _count('accepted');
  int get completed => _count('completed');
  int get cancelled => _count('cancelled') + _count('canceled');
  int get upcoming =>
      bookings.where((b) => b.startAt.isAfter(DateTime.now())).length;

  double get completedRevenue => bookings
      .where((b) => b.status.toLowerCase() == 'completed')
      .fold(0, (sum, booking) => sum + booking.price);

  double? get averageRating {
    final ratings = bookings
        .map((booking) => booking.reviewRating)
        .whereType<int>()
        .toList();
    if (ratings.isEmpty) return null;
    return ratings.reduce((a, b) => a + b) / ratings.length;
  }

  List<_ServiceMetric> get topServices {
    final grouped = <String, _ServiceMetric>{};
    for (final booking in bookings) {
      final name = booking.serviceName.trim().isEmpty
          ? 'Unnamed service'
          : booking.serviceName.trim();
      final current = grouped[name] ?? _ServiceMetric(name, 0, 0);
      grouped[name] = _ServiceMetric(
        name,
        current.count + 1,
        current.revenue + booking.price,
      );
    }
    final values = grouped.values.toList()
      ..sort((a, b) => b.count.compareTo(a.count));
    return values.take(5).toList();
  }

  int _count(String status) =>
      bookings.where((b) => b.status.toLowerCase() == status).length;

  String money(double amount) {
    final currency = bookings.isEmpty ? 'TZS' : bookings.first.currency;
    return '$currency ${NumberFormat.compact().format(amount)}';
  }
}

class _ServiceMetric {
  const _ServiceMetric(this.name, this.count, this.revenue);

  final String name;
  final int count;
  final double revenue;
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

class _MetricCard extends StatelessWidget {
  const _MetricCard({
    required this.label,
    required this.value,
    required this.icon,
  });

  final String label;
  final String value;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: scheme.surfaceContainerHighest.withValues(alpha: 0.45),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Icon(icon, color: scheme.secondary),
          Text(
            value,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: theme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.w800,
            ),
          ),
          Text(
            label,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: theme.textTheme.bodySmall,
          ),
        ],
      ),
    );
  }
}

class _ProgressRow extends StatelessWidget {
  const _ProgressRow({
    required this.label,
    required this.value,
    required this.total,
  });

  final String label;
  final int value;
  final int total;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final ratio = total == 0 ? 0.0 : value / total;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(child: Text(label)),
              Text('$value'),
            ],
          ),
          const SizedBox(height: 6),
          LinearProgressIndicator(
            value: math.min(1, ratio),
            minHeight: 8,
            borderRadius: BorderRadius.circular(8),
            backgroundColor: scheme.surfaceContainerHighest,
          ),
        ],
      ),
    );
  }
}

class _SliderTile extends StatelessWidget {
  const _SliderTile({
    required this.label,
    required this.value,
    required this.suffix,
    required this.min,
    required this.max,
    required this.divisions,
    required this.onChanged,
  });

  final String label;
  final double value;
  final String suffix;
  final double min;
  final double max;
  final int divisions;
  final ValueChanged<double> onChanged;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('$label: ${value.round()} $suffix'),
          Slider(
            value: value,
            min: min,
            max: max,
            divisions: divisions,
            label: '${value.round()}',
            onChanged: onChanged,
          ),
        ],
      ),
    );
  }
}

class _PermissionSwitch extends StatelessWidget {
  const _PermissionSwitch({
    required this.label,
    required this.value,
    required this.locked,
    required this.onChanged,
  });

  final String label;
  final bool value;
  final bool locked;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    return SwitchListTile.adaptive(
      contentPadding: EdgeInsets.zero,
      value: value,
      onChanged: locked ? null : onChanged,
      title: Text(label),
      subtitle: locked ? const Text('Included for salon owner') : null,
    );
  }
}

class _CampaignDraftDialog extends StatefulWidget {
  const _CampaignDraftDialog();

  @override
  State<_CampaignDraftDialog> createState() => _CampaignDraftDialogState();
}

class _CampaignDraftDialogState extends State<_CampaignDraftDialog> {
  final _title = TextEditingController();
  final _note = TextEditingController();
  String _audience = 'Followers';

  @override
  void dispose() {
    _title.dispose();
    _note.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Campaign draft'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: _title,
              decoration: const InputDecoration(
                labelText: 'Title',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 12),
            DropdownButtonFormField<String>(
              initialValue: _audience,
              decoration: const InputDecoration(
                labelText: 'Audience',
                border: OutlineInputBorder(),
              ),
              items: const [
                DropdownMenuItem(value: 'Followers', child: Text('Followers')),
                DropdownMenuItem(
                  value: 'Recent customers',
                  child: Text('Recent customers'),
                ),
                DropdownMenuItem(
                  value: 'All engaged',
                  child: Text('All engaged'),
                ),
              ],
              onChanged: (value) {
                if (value != null) setState(() => _audience = value);
              },
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _note,
              maxLines: 3,
              decoration: const InputDecoration(
                labelText: 'Message idea',
                border: OutlineInputBorder(),
              ),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        FilledButton(
          onPressed: () {
            final title = _title.text.trim();
            if (title.isEmpty) return;
            Navigator.pop(context, {
              'title': title,
              'audience': _audience,
              'note': _note.text.trim(),
              'createdAt': DateTime.now().toIso8601String(),
            });
          },
          child: const Text('Save'),
        ),
      ],
    );
  }
}

class _ErrorView extends StatelessWidget {
  const _ErrorView({required this.message, required this.onRetry});

  final String message;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.error_outline_rounded, size: 42),
            const SizedBox(height: 12),
            Text(message, textAlign: TextAlign.center),
            const SizedBox(height: 12),
            FilledButton(onPressed: onRetry, child: const Text('Retry')),
          ],
        ),
      ),
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

String _dateLabel(String? value) {
  final parsed = DateTime.tryParse(value ?? '');
  if (parsed == null) return '';
  return DateFormat.MMMd().format(parsed.toLocal());
}
