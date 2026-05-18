import 'package:africa_beuty/core/widgets/app_state.dart';
import 'package:africa_beuty/feature/booking/model/availability.dart';
import 'package:africa_beuty/feature/booking/provider/availability.dart';
import 'package:africa_beuty/feature/booking/provider/booking_draft.dart';
import 'package:africa_beuty/feature/booking/view/widgets/start_booking/confirm.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

class PickDateTimePage extends ConsumerStatefulWidget {
  const PickDateTimePage({super.key});

  @override
  ConsumerState<PickDateTimePage> createState() => _PickDateTimePageState();
}

class _PickDateTimePageState extends ConsumerState<PickDateTimePage> {
  DateTime _startDate = DateTime.now();
  DateTime? _selectedDay;
  AvailabilitySlot? _selectedSlot;

  void _selectSlot(AvailabilitySlot slot) {
    setState(() => _selectedSlot = slot);
  }

  Future<void> _openDatePicker() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDay ?? _startDate,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    if (picked == null) return;
    setState(() {
      _startDate = picked;
      _selectedDay = picked;
      _selectedSlot = null;
    });
  }

  void _continue() {
    final slot = _selectedSlot;
    if (slot == null) return;

    ref.read(bookingDraftProvider.notifier).setStartAt(slot.startAt.toUtc());
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const ConfirmBookingPage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    final draft = ref.watch(bookingDraftProvider);
    final salonServicePriceId = draft.salonServicePriceId;

    if (salonServicePriceId == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Select Date & Time')),
        body: const AppEmptyState(
          icon: Icons.storefront_outlined,
          title: 'Select a salon first',
          message: 'Choose a salon before picking an appointment time.',
        ),
      );
    }

    final request = AvailabilityRequest(
      salonServicePriceId: salonServicePriceId,
      startDate: _startDate,
      days: 14,
    );
    final availability = ref.watch(availabilityProvider(request));

    return Scaffold(
      appBar: AppBar(
        title: const Text('Select Date & Time'),
        centerTitle: true,
      ),
      body: availability.when(
        loading: () => const AppLoadingState(),
        error: (error, _) => AppErrorState(
          message: error,
          onRetry: () => ref.invalidate(availabilityProvider(request)),
        ),
        data: (days) {
          final selectedDay = _resolveSelectedDay(days);
          final slots = selectedDay?.slots ?? const <AvailabilitySlot>[];

          return Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        'Choose an available slot',
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                    ),
                    IconButton.filledTonal(
                      tooltip: 'Pick date',
                      onPressed: _openDatePicker,
                      icon: const Icon(Icons.calendar_month_rounded),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                _DateStrip(
                  days: days,
                  selectedDate: selectedDay?.date,
                  onSelected: (day) {
                    setState(() {
                      _selectedDay = day.date;
                      _selectedSlot = null;
                    });
                  },
                ),
                const SizedBox(height: 24),
                Text(
                  selectedDay == null
                      ? 'Available times'
                      : DateFormat('EEEE, d MMM').format(selectedDay.date),
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 12),
                Expanded(
                  child: slots.isEmpty
                      ? _NoSlots(day: selectedDay)
                      : _SlotGrid(
                          slots: slots,
                          selectedSlot: _selectedSlot,
                          onSelected: _selectSlot,
                        ),
                ),
                SizedBox(
                  width: double.infinity,
                  height: 54,
                  child: FilledButton(
                    onPressed: _selectedSlot == null ? null : _continue,
                    child: const Text('Continue'),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  AvailabilityDay? _resolveSelectedDay(List<AvailabilityDay> days) {
    if (days.isEmpty) return null;
    final selected = _selectedDay;
    if (selected != null) {
      for (final day in days) {
        if (DateUtils.isSameDay(day.date, selected)) return day;
      }
    }
    for (final day in days) {
      if (day.slots.isNotEmpty) return day;
    }
    return days.first;
  }
}

class _DateStrip extends StatelessWidget {
  const _DateStrip({
    required this.days,
    required this.selectedDate,
    required this.onSelected,
  });

  final List<AvailabilityDay> days;
  final DateTime? selectedDate;
  final ValueChanged<AvailabilityDay> onSelected;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    return SizedBox(
      height: 104,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: days.length,
        separatorBuilder: (_, _) => const SizedBox(width: 10),
        itemBuilder: (context, index) {
          final day = days[index];
          final isSelected = DateUtils.isSameDay(day.date, selectedDate);
          final hasSlots = day.slots.isNotEmpty;
          return InkWell(
            onTap: hasSlots ? () => onSelected(day) : null,
            borderRadius: BorderRadius.circular(8),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 180),
              width: 84,
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: isSelected
                    ? scheme.primary
                    : scheme.surfaceContainerHighest,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: isSelected ? scheme.primary : scheme.outlineVariant,
                ),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    DateFormat('EEE').format(day.date),
                    style: theme.textTheme.labelMedium?.copyWith(
                      color: isSelected
                          ? scheme.onPrimary
                          : scheme.onSurfaceVariant,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    DateFormat('d').format(day.date),
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w800,
                      color: isSelected ? scheme.onPrimary : scheme.onSurface,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    hasSlots ? '${day.slots.length} slots' : 'Closed',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: theme.textTheme.labelSmall?.copyWith(
                      color: isSelected
                          ? scheme.onPrimary
                          : scheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

class _SlotGrid extends StatelessWidget {
  const _SlotGrid({
    required this.slots,
    required this.selectedSlot,
    required this.onSelected,
  });

  final List<AvailabilitySlot> slots;
  final AvailabilitySlot? selectedSlot;
  final ValueChanged<AvailabilitySlot> onSelected;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    return GridView.builder(
      itemCount: slots.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        mainAxisSpacing: 10,
        crossAxisSpacing: 10,
        childAspectRatio: 2.25,
      ),
      itemBuilder: (context, index) {
        final slot = slots[index];
        final selected = identical(slot, selectedSlot);
        return OutlinedButton(
          onPressed: () => onSelected(slot),
          style: OutlinedButton.styleFrom(
            backgroundColor: selected
                ? scheme.primary
                : scheme.surfaceContainerHighest,
            foregroundColor: selected ? scheme.onPrimary : scheme.onSurface,
            side: BorderSide(
              color: selected ? scheme.primary : scheme.outlineVariant,
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            padding: EdgeInsets.zero,
          ),
          child: Text(
            DateFormat('HH:mm').format(slot.startAt),
            style: theme.textTheme.labelLarge?.copyWith(
              color: selected ? scheme.onPrimary : scheme.onSurface,
              fontWeight: FontWeight.w700,
            ),
          ),
        );
      },
    );
  }
}

class _NoSlots extends StatelessWidget {
  const _NoSlots({required this.day});

  final AvailabilityDay? day;

  @override
  Widget build(BuildContext context) {
    final reason = day?.reason;
    return Center(
      child: Text(
        reason == null || reason.isEmpty
            ? 'No available times for this day.'
            : 'No available times: $reason',
        textAlign: TextAlign.center,
      ),
    );
  }
}
