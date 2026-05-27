import 'package:africa_beuty/feature/auth/repositories/local_storage_service.dart';
import 'package:africa_beuty/feature/profile/model/account_security.dart';
import 'package:africa_beuty/feature/profile/repositories/account_settings.dart';
import 'package:africa_beuty/feature/profile/repositories/account_security.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class AccountSecurityPage extends StatefulWidget {
  const AccountSecurityPage({super.key, required this.isCustomer});

  final bool isCustomer;

  @override
  State<AccountSecurityPage> createState() => _AccountSecurityPageState();
}

class _AccountSecurityPageState extends State<AccountSecurityPage> {
  final _repo = AccountSecurityRepository();
  final _settingsRepo = AccountSettingsRepository();
  final _currentPassword = TextEditingController();
  final _newPassword = TextEditingController();
  final _confirmPassword = TextEditingController();

  bool _loadingDevices = true;
  bool _loadingMutes = true;
  bool _loadingHistory = true;
  bool _savingPassword = false;
  bool _twoStepEnabled = false;
  bool _loginAlerts = true;
  List<AccountDevice> _devices = const [];
  List<MutedAccount> _mutes = const [];
  List<LoginActivity> _history = const [];
  String? _devicesError;
  String? _mutesError;
  String? _historyError;

  String get _roleName => widget.isCustomer ? 'Customer' : 'Salon';
  String get _ownerCopy => widget.isCustomer
      ? 'Protect your profile, bookings, saved salons, and conversations.'
      : 'Protect salon tools, bookings, services, campaigns, and customer conversations.';

  @override
  void initState() {
    super.initState();
    _loadLocalPreferences();
    _loadDevices();
    _loadMutes();
    _loadLoginHistory();
  }

  @override
  void dispose() {
    _currentPassword.dispose();
    _newPassword.dispose();
    _confirmPassword.dispose();
    super.dispose();
  }

  Future<void> _loadLocalPreferences() async {
    final result = await _settingsRepo.getSettings();
    if (!mounted) return;
    result.match((_) {}, (settings) {
      setState(() {
        _twoStepEnabled =
            settings[_settingKey('two_step_enabled')] as bool? ?? false;
        _loginAlerts = settings[_settingKey('login_alerts')] as bool? ?? true;
      });
    });
  }

  String get _prefPrefix => widget.isCustomer
      ? 'customer_account_security_'
      : 'salon_account_security_';
  String _settingKey(String key) => '$_prefPrefix$key';

  Future<void> _setTwoStep(bool value) async {
    await _settingsRepo.updateSettings({
      _settingKey('two_step_enabled'): value,
    });
    if (mounted) setState(() => _twoStepEnabled = value);
  }

  Future<void> _setLoginAlerts(bool value) async {
    await _settingsRepo.updateSettings({_settingKey('login_alerts'): value});
    if (mounted) setState(() => _loginAlerts = value);
  }

  Future<void> _loadDevices() async {
    setState(() {
      _loadingDevices = true;
      _devicesError = null;
    });

    final result = await _repo.getDevices();
    if (!mounted) return;
    result.match(
      (failure) => setState(() {
        _devicesError = failure.message;
        _loadingDevices = false;
      }),
      (devices) => setState(() {
        _devices = devices;
        _loadingDevices = false;
      }),
    );
  }

  Future<void> _loadMutes() async {
    setState(() {
      _loadingMutes = true;
      _mutesError = null;
    });

    final result = await _repo.getMutedAccounts();
    if (!mounted) return;
    result.match(
      (failure) => setState(() {
        _mutesError = failure.message;
        _loadingMutes = false;
      }),
      (mutes) => setState(() {
        _mutes = mutes;
        _loadingMutes = false;
      }),
    );
  }

  Future<void> _loadLoginHistory() async {
    setState(() {
      _loadingHistory = true;
      _historyError = null;
    });

    final result = await _repo.getLoginHistory();
    if (!mounted) return;
    result.match(
      (failure) => setState(() {
        _historyError = failure.message;
        _loadingHistory = false;
      }),
      (history) => setState(() {
        _history = history;
        _loadingHistory = false;
      }),
    );
  }

  Future<void> _changePassword() async {
    final current = _currentPassword.text.trim();
    final next = _newPassword.text.trim();
    final confirm = _confirmPassword.text.trim();

    if (current.isEmpty || next.isEmpty || confirm.isEmpty) {
      _snack('Fill in all password fields');
      return;
    }
    if (next.length < 8) {
      _snack('New password must be at least 8 characters');
      return;
    }
    if (next != confirm) {
      _snack('New passwords do not match');
      return;
    }

    setState(() => _savingPassword = true);
    final result = await _repo.changePassword(
      currentPassword: current,
      newPassword: next,
    );
    if (!mounted) return;
    setState(() => _savingPassword = false);

    result.match((failure) => _snack(failure.message), (_) {
      _currentPassword.clear();
      _newPassword.clear();
      _confirmPassword.clear();
      _snack('Password updated. Please sign in again.');
      LocalStorageService.clearAuthData();
      Navigator.of(context).pushNamedAndRemoveUntil('/signin', (_) => false);
    });
  }

  Future<void> _removeDevice(AccountDevice device) async {
    final confirmed = await _confirm(
      title: 'Remove device?',
      message:
          'This will deactivate push access for ${device.platformLabel}. You may need to sign in again on that device.',
      action: 'Remove',
    );
    if (!confirmed) return;

    final result = await _repo.removeDevice(device.deviceId);
    if (!mounted) return;
    result.match((failure) => _snack(failure.message), (_) {
      _snack('Device removed');
      _loadDevices();
    });
  }

  Future<void> _unmute(MutedAccount item) async {
    final result = await _repo.unmute(item);
    if (!mounted) return;
    result.match((failure) => _snack(failure.message), (_) {
      _snack('${item.targetLabel} unmuted');
      _loadMutes();
    });
  }

  Future<void> _deactivateOrDelete({required bool delete}) async {
    final title = delete ? 'Delete account?' : 'Deactivate account?';
    final impact = widget.isCustomer
        ? delete
              ? 'Your customer profile, bookings, saved items, and chats would be scheduled for removal.'
              : 'Your customer profile would be hidden until you sign back in.'
        : delete
        ? 'Your salon profile, services, stylists, gallery, campaigns, and bookings would be scheduled for removal.'
        : 'Your salon profile would stop accepting discovery and booking actions until restored.';
    final password = await _passwordConfirm(
      title: title,
      message: '$impact Confirm your password to continue.',
      action: delete ? 'Delete account' : 'Deactivate',
      destructive: delete,
    );
    if (password == null || password.isEmpty) return;

    final result = delete
        ? await _repo.deleteAccount(password: password)
        : await _repo.deactivateAccount(password: password);
    if (!mounted) return;
    result.match((failure) => _snack(failure.message), (_) {
      _snack(delete ? 'Account deleted' : 'Account deactivated');
      LocalStorageService.clearAuthData();
      Navigator.of(context).pushNamedAndRemoveUntil('/signin', (_) => false);
    });
  }

  Future<bool> _confirm({
    required String title,
    required String message,
    required String action,
    bool destructive = true,
  }) async {
    final result = await showDialog<bool>(
      context: context,
      builder: (ctx) {
        final scheme = Theme.of(ctx).colorScheme;
        return AlertDialog(
          title: Text(title),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx, false),
              child: const Text('Cancel'),
            ),
            FilledButton(
              style: destructive
                  ? FilledButton.styleFrom(backgroundColor: scheme.error)
                  : null,
              onPressed: () => Navigator.pop(ctx, true),
              child: Text(action),
            ),
          ],
        );
      },
    );
    return result == true;
  }

  Future<String?> _passwordConfirm({
    required String title,
    required String message,
    required String action,
    bool destructive = true,
  }) async {
    final controller = TextEditingController();
    final result = await showDialog<String>(
      context: context,
      builder: (ctx) {
        final scheme = Theme.of(ctx).colorScheme;
        return AlertDialog(
          title: Text(title),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(message),
              const SizedBox(height: 14),
              TextField(
                controller: controller,
                obscureText: true,
                decoration: const InputDecoration(
                  labelText: 'Confirm password',
                  prefixIcon: Icon(Icons.lock_outline_rounded),
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: const Text('Cancel'),
            ),
            FilledButton(
              style: destructive
                  ? FilledButton.styleFrom(backgroundColor: scheme.error)
                  : null,
              onPressed: () => Navigator.pop(ctx, controller.text.trim()),
              child: Text(action),
            ),
          ],
        );
      },
    );
    controller.dispose();
    return result;
  }

  void _snack(Object message) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(message.toString())));
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;

    return Scaffold(
      appBar: AppBar(title: Text('$_roleName account security')),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 28),
        children: [
          _HeaderCard(
            icon: widget.isCustomer
                ? Icons.verified_user_rounded
                : Icons.admin_panel_settings_rounded,
            title: widget.isCustomer
                ? 'Personal account protection'
                : 'Salon owner protection',
            subtitle: _ownerCopy,
          ),
          const SizedBox(height: 18),
          _Section(
            title: 'Password',
            children: [
              _PasswordField(
                controller: _currentPassword,
                label: 'Current password',
              ),
              const SizedBox(height: 10),
              _PasswordField(controller: _newPassword, label: 'New password'),
              const SizedBox(height: 10),
              _PasswordField(
                controller: _confirmPassword,
                label: 'Confirm new password',
              ),
              const SizedBox(height: 12),
              SizedBox(
                height: 48,
                child: FilledButton.icon(
                  onPressed: _savingPassword ? null : _changePassword,
                  icon: _savingPassword
                      ? SizedBox(
                          width: 18,
                          height: 18,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: scheme.onPrimary,
                          ),
                        )
                      : const Icon(Icons.password_rounded),
                  label: Text(_savingPassword ? 'Updating' : 'Change password'),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          _Section(
            title: 'Two-step verification',
            children: [
              SwitchListTile.adaptive(
                value: _twoStepEnabled,
                onChanged: _setTwoStep,
                secondary: Icon(
                  Icons.verified_user_rounded,
                  color: scheme.secondary,
                ),
                title: const Text('Require verification code'),
                subtitle: Text(
                  widget.isCustomer
                      ? 'Adds an extra local protection step for customer account actions.'
                      : 'Adds an extra local protection step before sensitive salon owner actions.',
                ),
              ),
              SwitchListTile.adaptive(
                value: _loginAlerts,
                onChanged: _setLoginAlerts,
                secondary: Icon(
                  Icons.notifications_active_rounded,
                  color: scheme.secondary,
                ),
                title: const Text('Login alerts'),
                subtitle: const Text(
                  'Notify this account when a new sign-in is detected.',
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          _Section(
            title: 'Active devices',
            trailing: IconButton(
              tooltip: 'Refresh devices',
              onPressed: _loadDevices,
              icon: const Icon(Icons.refresh_rounded),
            ),
            children: [
              if (_loadingDevices)
                const _InlineLoading(label: 'Loading devices')
              else if (_devicesError != null)
                _InlineError(message: _devicesError!, onRetry: _loadDevices)
              else if (_devices.isEmpty)
                const _EmptyLine(
                  icon: Icons.devices_rounded,
                  title: 'No registered devices yet',
                  subtitle: 'Push-enabled devices will appear here.',
                )
              else
                for (final device in _devices)
                  _DeviceTile(
                    device: device,
                    onRemove: () => _removeDevice(device),
                  ),
            ],
          ),
          const SizedBox(height: 16),
          _Section(
            title: 'Login history',
            trailing: IconButton(
              tooltip: 'Refresh login history',
              onPressed: _loadLoginHistory,
              icon: const Icon(Icons.refresh_rounded),
            ),
            children: [
              if (_loadingHistory)
                const _InlineLoading(label: 'Loading login history')
              else if (_historyError != null)
                _InlineError(
                  message: _historyError!,
                  onRetry: _loadLoginHistory,
                )
              else if (_history.isEmpty)
                const _EmptyLine(
                  icon: Icons.history_rounded,
                  title: 'No login history yet',
                  subtitle: 'Recent sign-ins will appear here.',
                )
              else
                for (final item in _history) _LoginTile(activity: item),
            ],
          ),
          const SizedBox(height: 16),
          _Section(
            title: widget.isCustomer
                ? 'Blocked and muted accounts'
                : 'Muted customers and content',
            trailing: IconButton(
              tooltip: 'Refresh muted accounts',
              onPressed: _loadMutes,
              icon: const Icon(Icons.refresh_rounded),
            ),
            children: [
              if (_loadingMutes)
                const _InlineLoading(label: 'Loading muted accounts')
              else if (_mutesError != null)
                _InlineError(message: _mutesError!, onRetry: _loadMutes)
              else if (_mutes.isEmpty)
                const _EmptyLine(
                  icon: Icons.volume_off_rounded,
                  title: 'Nothing muted',
                  subtitle: 'Muted salons, users, or posts will appear here.',
                )
              else
                for (final item in _mutes)
                  _MutedTile(item: item, onUnmute: () => _unmute(item)),
            ],
          ),
          const SizedBox(height: 16),
          _Section(
            title: 'Account status',
            children: [
              _DangerAction(
                icon: Icons.pause_circle_rounded,
                title: widget.isCustomer
                    ? 'Deactivate customer account'
                    : 'Pause salon account',
                subtitle: widget.isCustomer
                    ? 'Temporarily hide your customer profile.'
                    : 'Temporarily stop salon discovery and booking actions.',
                label: 'Review',
                onTap: () => _deactivateOrDelete(delete: false),
              ),
              Divider(height: 1, color: scheme.outlineVariant),
              _DangerAction(
                icon: Icons.delete_forever_rounded,
                title: widget.isCustomer
                    ? 'Delete customer account'
                    : 'Close salon account',
                subtitle: widget.isCustomer
                    ? 'Permanently remove customer profile and account data.'
                    : 'Permanently remove salon profile, services, and business data.',
                label: 'Danger',
                onTap: () => _deactivateOrDelete(delete: true),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _HeaderCard extends StatelessWidget {
  const _HeaderCard({
    required this.icon,
    required this.title,
    required this.subtitle,
  });

  final IconData icon;
  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: scheme.primaryContainer.withValues(alpha: 0.44),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: scheme.primary.withValues(alpha: 0.12)),
      ),
      child: Row(
        children: [
          CircleAvatar(
            backgroundColor: scheme.primary.withValues(alpha: 0.13),
            child: Icon(icon, color: scheme.primary),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(fontWeight: FontWeight.w800),
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: TextStyle(color: scheme.onSurfaceVariant),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _Section extends StatelessWidget {
  const _Section({required this.title, required this.children, this.trailing});

  final String title;
  final List<Widget> children;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                title,
                style: theme.textTheme.labelLarge?.copyWith(
                  color: scheme.primary,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),
            if (trailing != null) trailing!,
          ],
        ),
        const SizedBox(height: 8),
        DecoratedBox(
          decoration: BoxDecoration(
            color: scheme.surfaceContainerHighest.withValues(alpha: 0.5),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: scheme.outlineVariant),
          ),
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Column(children: children),
          ),
        ),
      ],
    );
  }
}

class _PasswordField extends StatelessWidget {
  const _PasswordField({required this.controller, required this.label});

  final TextEditingController controller;
  final String label;

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      obscureText: true,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: const Icon(Icons.lock_outline_rounded),
      ),
    );
  }
}

class _DeviceTile extends StatelessWidget {
  const _DeviceTile({required this.device, required this.onRemove});

  final AccountDevice device;
  final VoidCallback onRemove;

  @override
  Widget build(BuildContext context) {
    final lastSeen = device.lastSeenAt == null
        ? 'Unknown activity'
        : 'Last seen ${DateFormat.yMMMd().add_jm().format(device.lastSeenAt!)}';
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: const Icon(Icons.devices_rounded),
      title: Text(device.platformLabel),
      subtitle: Text('${device.deviceId}\n$lastSeen'),
      isThreeLine: true,
      trailing: TextButton(onPressed: onRemove, child: const Text('Remove')),
    );
  }
}

class _LoginTile extends StatelessWidget {
  const _LoginTile({required this.activity});

  final LoginActivity activity;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: Icon(
        activity.isCurrent
            ? Icons.radio_button_checked_rounded
            : Icons.history_rounded,
      ),
      title: Text(activity.title),
      subtitle: Text(
        '${activity.subtitle}\n${DateFormat.yMMMd().add_jm().format(activity.createdAt)}',
      ),
      isThreeLine: true,
      trailing: activity.isCurrent ? const Text('Current') : null,
    );
  }
}

class _MutedTile extends StatelessWidget {
  const _MutedTile({required this.item, required this.onUnmute});

  final MutedAccount item;
  final VoidCallback onUnmute;

  @override
  Widget build(BuildContext context) {
    final created = item.createdAt == null
        ? 'Unknown date'
        : DateFormat.yMMMd().format(item.createdAt!);
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: const Icon(Icons.volume_off_rounded),
      title: Text(item.targetLabel),
      subtitle: Text('${item.targetType} • ${item.targetId}\nMuted $created'),
      isThreeLine: true,
      trailing: TextButton(onPressed: onUnmute, child: const Text('Unmute')),
    );
  }
}

class _DangerAction extends StatelessWidget {
  const _DangerAction({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.label,
    required this.onTap,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: Icon(icon, color: scheme.error),
      title: Text(title, style: TextStyle(color: scheme.error)),
      subtitle: Text(subtitle),
      trailing: Text(label, style: TextStyle(color: scheme.error)),
      onTap: onTap,
    );
  }
}

class _InlineLoading extends StatelessWidget {
  const _InlineLoading({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(18),
      child: Row(
        children: [
          const SizedBox(
            width: 20,
            height: 20,
            child: CircularProgressIndicator(strokeWidth: 2),
          ),
          const SizedBox(width: 12),
          Text(label),
        ],
      ),
    );
  }
}

class _InlineError extends StatelessWidget {
  const _InlineError({required this.message, required this.onRetry});

  final String message;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: Icon(
        Icons.error_outline,
        color: Theme.of(context).colorScheme.error,
      ),
      title: Text(message),
      trailing: TextButton(onPressed: onRetry, child: const Text('Retry')),
    );
  }
}

class _EmptyLine extends StatelessWidget {
  const _EmptyLine({
    required this.icon,
    required this.title,
    required this.subtitle,
  });

  final IconData icon;
  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: Icon(icon),
      title: Text(title),
      subtitle: Text(subtitle),
    );
  }
}

extension on AccountDevice {
  String get platformLabel {
    final raw = platform.trim();
    if (raw.isEmpty) return 'Unknown device';
    return '${raw[0].toUpperCase()}${raw.substring(1)}';
  }
}

extension on MutedAccount {
  String get targetLabel {
    final raw = targetType.trim();
    if (raw.isEmpty) return 'Muted item';
    return 'Muted ${raw[0].toUpperCase()}${raw.substring(1)}';
  }
}
