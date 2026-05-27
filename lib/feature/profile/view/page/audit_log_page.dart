import 'package:africa_beuty/feature/profile/model/audit_log.dart';
import 'package:africa_beuty/feature/profile/repositories/audit_log.dart';
import 'package:africa_beuty/feature/profile/view/widget/settings_polish.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class AuditLogPage extends StatefulWidget {
  const AuditLogPage({super.key, required this.isCustomer});

  final bool isCustomer;

  @override
  State<AuditLogPage> createState() => _AuditLogPageState();
}

class _AuditLogPageState extends State<AuditLogPage> {
  final _repository = AuditLogRepository();
  late Future<AuditLogResponse> _future;

  @override
  void initState() {
    super.initState();
    _future = _load();
  }

  Future<AuditLogResponse> _load() async {
    final result = await _repository.getAuditLog();
    return result.match((failure) => throw failure.message, (data) => data);
  }

  Future<void> _refresh() async {
    setState(() => _future = _load());
    await _future;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Activity log'),
        actions: [
          IconButton(
            tooltip: 'Refresh',
            onPressed: _refresh,
            icon: const Icon(Icons.refresh_rounded),
          ),
        ],
      ),
      body: FutureBuilder<AuditLogResponse>(
        future: _future,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return ListView(
              padding: const EdgeInsets.all(16),
              children: [
                SettingsEmptyState(
                  icon: Icons.error_outline_rounded,
                  title: 'Activity could not load',
                  subtitle: snapshot.error.toString(),
                ),
                const SizedBox(height: 12),
                FilledButton.icon(
                  onPressed: _refresh,
                  icon: const Icon(Icons.refresh_rounded),
                  label: const Text('Try again'),
                ),
              ],
            );
          }

          final response = snapshot.data;
          final items = response?.items ?? const <AuditLogItem>[];
          if (items.isEmpty) {
            return RefreshIndicator(
              onRefresh: _refresh,
              child: ListView(
                padding: const EdgeInsets.all(16),
                children: [
                  SettingsEmptyState(
                    icon: Icons.manage_history_rounded,
                    title: 'No activity yet',
                    subtitle: widget.isCustomer
                        ? 'Profile edits, security updates, and device logins will appear here.'
                        : 'Profile edits, booking changes, staff updates, and campaign activity will appear here.',
                  ),
                ],
              ),
            );
          }

          return RefreshIndicator(
            onRefresh: _refresh,
            child: ListView.separated(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
              itemCount: items.length + 1,
              separatorBuilder: (_, index) => index == 0
                  ? const SizedBox(height: 10)
                  : Divider(color: theme.colorScheme.outlineVariant),
              itemBuilder: (context, index) {
                if (index == 0) {
                  return _HeaderCard(
                    count: response?.total ?? items.length,
                    isCustomer: widget.isCustomer,
                  );
                }
                return _AuditLogTile(item: items[index - 1]);
              },
            ),
          );
        },
      ),
    );
  }
}

class _HeaderCard extends StatelessWidget {
  const _HeaderCard({required this.count, required this.isCustomer});

  final int count;
  final bool isCustomer;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: scheme.surfaceContainerHighest.withValues(alpha: 0.55),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: scheme.outlineVariant),
      ),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: scheme.primary.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(Icons.history_rounded, color: scheme.primary),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '$count tracked ${count == 1 ? 'change' : 'changes'}',
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  isCustomer
                      ? 'Account, profile, security, and device history.'
                      : 'Salon profile, bookings, staff, campaigns, and security history.',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: scheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _AuditLogTile extends StatelessWidget {
  const _AuditLogTile({required this.item});

  final AuditLogItem item;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final icon = _iconFor(item.eventType);
    final color = _colorFor(context, item.eventType);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: color, size: 22),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Text(
                        item.title,
                        style: theme.textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      _formatDate(item.createdAt),
                      style: theme.textTheme.labelSmall?.copyWith(
                        color: scheme.onSurfaceVariant,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
                if ((item.description ?? '').isNotEmpty) ...[
                  const SizedBox(height: 4),
                  Text(
                    item.description!,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: scheme.onSurfaceVariant,
                    ),
                  ),
                ],
                const SizedBox(height: 8),
                SettingsStatusBadge(
                  label: _labelFor(item.eventType),
                  tone: SettingsBadgeTone.synced,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

IconData _iconFor(String eventType) {
  return switch (eventType) {
    'password_changed' => Icons.lock_reset_rounded,
    'booking_rules_changed' => Icons.rule_rounded,
    'campaign_draft_created' ||
    'campaign_drafts_updated' => Icons.campaign_rounded,
    'device_logged_in' => Icons.devices_rounded,
    'stylist_added' => Icons.group_add_rounded,
    'stylist_updated' => Icons.manage_accounts_rounded,
    'stylist_removed' => Icons.group_remove_rounded,
    'working_hours_changed' => Icons.schedule_rounded,
    'gallery_updated' => Icons.photo_library_rounded,
    _ => Icons.person_rounded,
  };
}

Color _colorFor(BuildContext context, String eventType) {
  final scheme = Theme.of(context).colorScheme;
  return switch (eventType) {
    'password_changed' => scheme.error,
    'device_logged_in' => scheme.tertiary,
    'stylist_added' ||
    'stylist_updated' ||
    'stylist_removed' => scheme.secondary,
    'booking_rules_changed' ||
    'working_hours_changed' ||
    'campaign_draft_created' ||
    'campaign_drafts_updated' => scheme.primary,
    _ => scheme.primary,
  };
}

String _labelFor(String eventType) {
  return switch (eventType) {
    'password_changed' => 'Security',
    'device_logged_in' => 'Device',
    'booking_rules_changed' => 'Bookings',
    'campaign_draft_created' || 'campaign_drafts_updated' => 'Campaign',
    'stylist_added' || 'stylist_updated' || 'stylist_removed' => 'Team',
    'working_hours_changed' => 'Hours',
    'gallery_updated' => 'Gallery',
    _ => 'Profile',
  };
}

String _formatDate(DateTime value) {
  final local = value.toLocal();
  final now = DateTime.now();
  final today = DateTime(now.year, now.month, now.day);
  final date = DateTime(local.year, local.month, local.day);
  if (date == today) return DateFormat.jm().format(local);
  return DateFormat.MMMd().format(local);
}
