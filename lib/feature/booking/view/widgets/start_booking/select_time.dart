import 'package:africa_beuty/feature/booking/provider/booking_draft.dart';
import 'package:africa_beuty/feature/booking/view/widgets/start_booking/confirm.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

class PickDateTimePage extends ConsumerStatefulWidget {
  const PickDateTimePage({super.key});

  @override
  ConsumerState<PickDateTimePage> createState() =>
      _PickDateTimePageState();
}

class _PickDateTimePageState
    extends ConsumerState<PickDateTimePage> {
  DateTime _selectedDate = DateTime.now();
  TimeOfDay? _selectedTime;

  late List<DateTime> _dates;

  @override
  void initState() {
    super.initState();
    _dates = List.generate(
      3,
      (i) => DateTime.now().add(Duration(days: i)),
    );
  }

  void _openDatePicker() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );

    if (picked != null) {
      setState(() => _selectedDate = picked);
    }
  }

  void _pickTime() async {
    final picked = await showTimePicker(
      context: context,
      initialTime: _selectedTime ?? TimeOfDay.now(),
    );

    if (picked != null) {
      setState(() => _selectedTime = picked);
    }
  }

  void _continue() {
    if (_selectedTime == null) return;

    final draft = ref.read(bookingDraftProvider);

    // 🚨 SAFETY CHECK
    if (draft.salonServicePriceId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please select a salon first'),
        ),
      );
      return;
    }

    final startAt = DateTime(
      _selectedDate.year,
      _selectedDate.month,
      _selectedDate.day,
      _selectedTime!.hour,
      _selectedTime!.minute,
    ).toUtc();

    // ✅ Save to booking draft
    ref
        .read(bookingDraftProvider.notifier)
        .setStartAt(startAt);

    // 👉 Go to confirmation
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => const ConfirmBookingPage(),
      ),
    );
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Select Date & Time'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // DATE
            Text(
              'Select Date',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 12),
            _buildDateList(),

            const SizedBox(height: 24),

            // TIME
            const Text(
              'Select Time',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            _buildTimeSelector(),

            const Spacer(),

            SizedBox(
              width: double.infinity,
              height: 54,
              child: FilledButton(
                onPressed: _selectedTime == null ? null : _continue,
                child: const Text('Continue'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDateList() {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;

    return SizedBox(
      height: 96,
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: [
          ..._dates.map((date) {
            final isSelected = DateUtils.isSameDay(date, _selectedDate);

            return GestureDetector(
              onTap: () => setState(() => _selectedDate = date),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 250),
                width: 86,
                margin: const EdgeInsets.only(right: 12),
                decoration: BoxDecoration(
                  color: isSelected
                      ? scheme.primary
                      : scheme.surfaceContainerHighest,
                  borderRadius: BorderRadius.circular(18),
                  border: Border.all(
                    color: isSelected
                        ? scheme.primary
                        : scheme.outlineVariant,
                  ),
                  boxShadow: isSelected
                      ? [
                          BoxShadow(
                            color: scheme.primary.withOpacity(.25),
                            blurRadius: 12,
                            offset: const Offset(0, 4),
                          )
                        ]
                      : [],
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      DateFormat('EEE').format(date),
                      style: theme.textTheme.labelMedium?.copyWith(
                        color: isSelected
                            ? scheme.onPrimary
                            : scheme.onSurfaceVariant,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      DateFormat('d').format(date),
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: isSelected
                            ? scheme.onPrimary
                            : scheme.onSurface,
                      ),
                    ),
                  ],
                ),
              ),
            );
          }),

          /// calendar picker
          GestureDetector(
            onTap: _openDatePicker,
            child: Container(
              width: 86,
              decoration: BoxDecoration(
                color: scheme.surfaceContainerHighest,
                borderRadius: BorderRadius.circular(18),
                border: Border.all(color: scheme.outlineVariant),
              ),
              child: Icon(
                Icons.calendar_month_rounded,
                color: scheme.primary,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTimeSelector() {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;

    return InkWell(
      onTap: _pickTime,
      borderRadius: BorderRadius.circular(18),
      child: Ink(
        height: 60,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        decoration: BoxDecoration(
          color: scheme.surfaceContainerHighest,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: scheme.outlineVariant),
        ),
        child: Row(
          children: [
            Icon(
              Icons.schedule_rounded,
              color: scheme.primary,
            ),
            const SizedBox(width: 12),

            Expanded(
              child: Text(
                _selectedTime == null
                    ? 'Select time'
                    : _selectedTime!.format(context),
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),

            Icon(
              Icons.arrow_forward_ios_rounded,
              size: 16,
              color: scheme.outline,
            ),
          ],
        ),
      ),
    );
  }
}
