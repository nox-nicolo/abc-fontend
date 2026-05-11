import 'package:africa_beuty/feature/profile/model/settings/availability_override.dart';
import 'package:africa_beuty/feature/profile/repositories/settings/availability_calendar.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class SalonAvailabilityCalendarPage extends StatefulWidget {
  const SalonAvailabilityCalendarPage({super.key});

  @override
  State<SalonAvailabilityCalendarPage> createState() =>
      _SalonAvailabilityCalendarPageState();
}

class _SalonAvailabilityCalendarPageState
    extends State<SalonAvailabilityCalendarPage> {
  final _repo = AvailabilityCalendarRepository();
  final _reasonController = TextEditingController();
  final Map<String, AvailabilityOverride> _overrides = {};

  DateTime _selectedDate = DateTime.now();
  bool _isClosed = true;
  TimeOfDay _openTime = const TimeOfDay(hour: 8, minute: 0);
  TimeOfDay _closeTime = const TimeOfDay(hour: 18, minute: 0);
  bool _loading = true;
  bool _saving = false;

  @override
  void initState() {
    super.initState();
    _loadOverrides();
  }

  @override
  void dispose() {
    _reasonController.dispose();
    super.dispose();
  }

  Future<void> _loadOverrides() async {
    setState(() => _loading = true);
    final now = DateTime.now();
    final result = await _repo.listOverrides(
      startDate: now.subtract(const Duration(days: 7)),
      endDate: now.add(const Duration(days: 120)),
    );
    if (!mounted) return;
    result.match((failure) => _showSnack(failure.message), (items) {
      _overrides
        ..clear()
        ..addEntries(items.map((item) => MapEntry(_key(item.date), item)));
      _applySelectedOverride();
    });
    setState(() => _loading = false);
  }

  void _applySelectedOverride() {
    final override = _overrides[_key(_selectedDate)];
    if (override == null) {
      _isClosed = true;
      _openTime = const TimeOfDay(hour: 8, minute: 0);
      _closeTime = const TimeOfDay(hour: 18, minute: 0);
      _reasonController.clear();
      return;
    }
    _isClosed = override.isClosed;
    _openTime = _parseTime(override.openTime) ?? _openTime;
    _closeTime = _parseTime(override.closeTime) ?? _closeTime;
    _reasonController.text = override.reason ?? '';
  }

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime.now().subtract(const Duration(days: 7)),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    if (picked == null) return;
    setState(() {
      _selectedDate = picked;
      _applySelectedOverride();
    });
  }

  Future<void> _pickTime({required bool open}) async {
    final picked = await showTimePicker(
      context: context,
      initialTime: open ? _openTime : _closeTime,
    );
    if (picked == null) return;
    setState(() {
      if (open) {
        _openTime = picked;
      } else {
        _closeTime = picked;
      }
    });
  }

  Future<void> _save() async {
    if (!_isClosed && _minutes(_closeTime) <= _minutes(_openTime)) {
      _showSnack('Closing time must be after opening time.');
      return;
    }
    setState(() => _saving = true);
    final result = await _repo.saveOverride(
      date: _selectedDate,
      isClosed: _isClosed,
      openTime: _formatApiTime(_openTime),
      closeTime: _formatApiTime(_closeTime),
      reason: _reasonController.text,
    );
    if (!mounted) return;
    result.match((failure) => _showSnack(failure.message), (override) {
      setState(() => _overrides[_key(override.date)] = override);
      _showSnack('Calendar updated');
    });
    setState(() => _saving = false);
  }

  Future<void> _delete() async {
    final override = _overrides[_key(_selectedDate)];
    if (override == null) return;
    setState(() => _saving = true);
    final result = await _repo.deleteOverride(override.id);
    if (!mounted) return;
    result.match((failure) => _showSnack(failure.message), (_) {
      setState(() {
        _overrides.remove(_key(_selectedDate));
        _applySelectedOverride();
      });
      _showSnack('Calendar override removed');
    });
    setState(() => _saving = false);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final selectedOverride = _overrides[_key(_selectedDate)];

    return Scaffold(
      appBar: AppBar(title: const Text('Availability Calendar')),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : ListView(
              padding: const EdgeInsets.all(16),
              children: [
                Text(
                  'Control special days without changing your weekly hours.',
                  style: theme.textTheme.bodyMedium,
                ),
                const SizedBox(height: 16),
                _DateCard(
                  date: _selectedDate,
                  hasOverride: selectedOverride != null,
                  onTap: _pickDate,
                ),
                const SizedBox(height: 16),
                SwitchListTile(
                  value: _isClosed,
                  onChanged: (value) => setState(() => _isClosed = value),
                  title: const Text('Closed all day'),
                  secondary: const Icon(Icons.block_rounded),
                  contentPadding: EdgeInsets.zero,
                ),
                if (!_isClosed) ...[
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Expanded(
                        child: _TimeTile(
                          label: 'Open',
                          value: _openTime.format(context),
                          onTap: () => _pickTime(open: true),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _TimeTile(
                          label: 'Close',
                          value: _closeTime.format(context),
                          onTap: () => _pickTime(open: false),
                        ),
                      ),
                    ],
                  ),
                ],
                const SizedBox(height: 16),
                TextField(
                  controller: _reasonController,
                  maxLength: 255,
                  decoration: const InputDecoration(
                    labelText: 'Reason or note',
                    hintText: 'Holiday, training, special event',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 16),
                FilledButton.icon(
                  onPressed: _saving ? null : _save,
                  icon: _saving
                      ? const SizedBox(
                          width: 18,
                          height: 18,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Icon(Icons.save_rounded),
                  label: const Text('Save day'),
                ),
                if (selectedOverride != null) ...[
                  const SizedBox(height: 8),
                  TextButton.icon(
                    onPressed: _saving ? null : _delete,
                    icon: const Icon(Icons.delete_outline_rounded),
                    label: const Text('Use normal weekly hours'),
                  ),
                ],
                const SizedBox(height: 24),
                Text(
                  'Upcoming special days',
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 8),
                ..._overrides.values.map(_OverrideRow.new),
              ],
            ),
    );
  }

  void _showSnack(String message) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
  }

  String _key(DateTime date) => DateFormat('yyyy-MM-dd').format(date);

  String _formatApiTime(TimeOfDay time) {
    final hour = time.hour.toString().padLeft(2, '0');
    final minute = time.minute.toString().padLeft(2, '0');
    return '$hour:$minute:00';
  }

  TimeOfDay? _parseTime(String? value) {
    if (value == null || value.isEmpty) return null;
    final parts = value.split(':');
    if (parts.length < 2) return null;
    return TimeOfDay(
      hour: int.tryParse(parts[0]) ?? 0,
      minute: int.tryParse(parts[1]) ?? 0,
    );
  }

  int _minutes(TimeOfDay time) => time.hour * 60 + time.minute;
}

class _DateCard extends StatelessWidget {
  const _DateCard({
    required this.date,
    required this.hasOverride,
    required this.onTap,
  });

  final DateTime date;
  final bool hasOverride;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return ListTile(
      onTap: onTap,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
        side: BorderSide(color: theme.colorScheme.outlineVariant),
      ),
      leading: const Icon(Icons.calendar_today_rounded),
      title: Text(DateFormat('EEEE, d MMM yyyy').format(date)),
      subtitle: Text(hasOverride ? 'Special day set' : 'Using weekly hours'),
      trailing: const Icon(Icons.edit_calendar_rounded),
    );
  }
}

class _TimeTile extends StatelessWidget {
  const _TimeTile({
    required this.label,
    required this.value,
    required this.onTap,
  });

  final String label;
  final String value;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: onTap,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
        side: BorderSide(color: Theme.of(context).colorScheme.outlineVariant),
      ),
      title: Text(label),
      subtitle: Text(value),
      trailing: const Icon(Icons.schedule_rounded),
    );
  }
}

class _OverrideRow extends StatelessWidget {
  const _OverrideRow(this.item);

  final AvailabilityOverride item;

  @override
  Widget build(BuildContext context) {
    final time = item.isClosed
        ? 'Closed'
        : '${_short(item.openTime)} - ${_short(item.closeTime)}';
    return ListTile(
      dense: true,
      contentPadding: EdgeInsets.zero,
      leading: Icon(
        item.isClosed ? Icons.block_rounded : Icons.schedule_rounded,
      ),
      title: Text(DateFormat('EEE, d MMM').format(item.date)),
      subtitle: Text(
        item.reason?.isNotEmpty == true ? '$time - ${item.reason}' : time,
      ),
    );
  }

  String _short(String? value) {
    if (value == null || value.length < 5) return '';
    return value.substring(0, 5);
  }
}
