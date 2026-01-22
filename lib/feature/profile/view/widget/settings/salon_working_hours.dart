import 'package:africa_beuty/feature/profile/view_model/settings/profile_cover.dart'; // Adjust path to SalonUpdateViewModel
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class WorkingHoursPage extends ConsumerStatefulWidget {
  const WorkingHoursPage({super.key});

  @override
  ConsumerState<WorkingHoursPage> createState() => _WorkingHoursPageState();
}

class _WorkingHoursPageState extends ConsumerState<WorkingHoursPage> {
  // 0=Monday, 6=Sunday as per your Backend requirement
  final List<String> _dayNames = [
    "Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday", "Sunday"
  ];

  late List<WorkingDayState> _workingDays;

  @override
  void initState() {
    super.initState();
    // Initialize with default values (You can later map existing data from salonProfileViewModelProvider here)
    _workingDays = List.generate(7, (index) => WorkingDayState(
      dayName: _dayNames[index],
      dayIndex: index,
      isOpen: index < 5, // Mon-Fri open by default
      openTime: const TimeOfDay(hour: 8, minute: 0),
      closeTime: const TimeOfDay(hour: 18, minute: 0),
    ));
  }

  // Helper to format TimeOfDay to HH:mm:ss for FastAPI
  String _to24hString(TimeOfDay time) {
    final hour = time.hour.toString().padLeft(2, '0');
    final minute = time.minute.toString().padLeft(2, '0');
    return "$hour:$minute:00";
  }

  Future<void> _selectTime(int index, bool isOpenTime) async {
    final initialTime = isOpenTime ? _workingDays[index].openTime : _workingDays[index].closeTime;
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: initialTime,
    );

    if (picked != null) {
      setState(() {
        if (isOpenTime) {
          _workingDays[index].openTime = picked;
        } else {
          _workingDays[index].closeTime = picked;
        }
      });
    }
  }

  Future<void> _saveForm() async {
    // 1. Prepare Payload
    final List<Map<String, dynamic>> payload = _workingDays.map((day) {
      return {
        "day_of_week": day.dayIndex,
        "is_open": day.isOpen,
        "open_time": day.isOpen ? _to24hString(day.openTime) : null,
        "close_time": day.isOpen ? _to24hString(day.closeTime) : null,
      };
    }).toList();

    // 2. Call ViewModel
    await ref.read(salonUpdateViewModelProvider.notifier).updateWorkingHours(payload);

    // 3. Handle Success/Navigation
    final state = ref.read(salonUpdateViewModelProvider);
    if (state is AsyncData && mounted) {
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Working hours updated successfully!')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final updateState = ref.watch(salonUpdateViewModelProvider);

    // Error Listener
    ref.listen<AsyncValue>(salonUpdateViewModelProvider, (prev, next) {
      if (next is AsyncError) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(next.error.toString()), backgroundColor: Colors.red),
        );
      }
    });

    return Scaffold(
      appBar: AppBar(
        title: const Text('Working Hours'),
        actions: [
          updateState.isLoading
              ? const Center(child: Padding(padding: EdgeInsets.all(16), child: SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2))))
              : TextButton(
                  onPressed: _saveForm,
                  child: const Text('Save', style: TextStyle(fontWeight: FontWeight.bold)),
                ),
        ],
      ),
      body: ListView.separated(
        padding: const EdgeInsets.all(16),
        itemCount: _workingDays.length,
        separatorBuilder: (context, index) => const Divider(height: 32),
        itemBuilder: (context, index) {
          final day = _workingDays[index];
          return Column(
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(day.dayName, style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
                  ),
                  Text(
                    day.isOpen ? "Open" : "Closed",
                    style: TextStyle(
                      color: day.isOpen ? theme.colorScheme.primary : theme.colorScheme.error,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  Switch(
                    value: day.isOpen,
                    onChanged: (bool value) => setState(() => day.isOpen = value),
                  ),
                ],
              ),
              if (day.isOpen)
                Padding(
                  padding: const EdgeInsets.only(top: 12),
                  child: Row(
                    children: [
                      Expanded(
                        child: _timeTile(
                          label: "Open From",
                          time: day.openTime.format(context),
                          onTap: () => _selectTime(index, true),
                          theme: theme,
                        ),
                      ),
                      const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 12),
                        child: Icon(Icons.arrow_forward, size: 16, color: Colors.grey),
                      ),
                      Expanded(
                        child: _timeTile(
                          label: "Close At",
                          time: day.closeTime.format(context),
                          onTap: () => _selectTime(index, false),
                          theme: theme,
                        ),
                      ),
                    ],
                  ),
                ),
            ],
          );
        },
      ),
    );
  }

  Widget _timeTile({required String label, required String time, required VoidCallback onTap, required ThemeData theme}) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 12),
        decoration: BoxDecoration(
          color: theme.colorScheme.surfaceVariant.withOpacity(0.3),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: theme.colorScheme.outlineVariant),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(label, style: theme.textTheme.labelSmall),
            const SizedBox(height: 4),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(time, style: const TextStyle(fontWeight: FontWeight.bold)),
                const Icon(Icons.access_time, size: 16),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

// Local state class for the UI
class WorkingDayState {
  final String dayName;
  final int dayIndex;
  bool isOpen;
  TimeOfDay openTime;
  TimeOfDay closeTime;

  WorkingDayState({
    required this.dayName,
    required this.dayIndex,
    required this.isOpen,
    required this.openTime,
    required this.closeTime,
  });
}