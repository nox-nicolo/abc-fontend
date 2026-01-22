import 'package:africa_beuty/core/page/bottom_nav.dart';
import 'package:africa_beuty/feature/booking/model/booking_draft.dart';
import 'package:africa_beuty/feature/booking/model/start_booking.dart';
import 'package:africa_beuty/feature/booking/provider/booking_draft.dart';
import 'package:africa_beuty/feature/booking/view_modal/start_booking.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

class ConfirmBookingPage extends ConsumerStatefulWidget {
  const ConfirmBookingPage({super.key});

  @override
  ConsumerState<ConfirmBookingPage> createState() =>
      _ConfirmBookingPageState();
}

class _ConfirmBookingPageState
    extends ConsumerState<ConfirmBookingPage> {
  final _noteController = TextEditingController();

  @override
  void initState() {
    super.initState();

    ref.listenManual(
      startBookingViewModelProvider,
      (prev, next) {
        next.whenOrNull(
          error: (err, _) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(err.toString())),
            );
          },
          data: (booking) {
            if (booking != null) {
              // 1. Clear the draft
              ref.read(bookingDraftProvider.notifier).reset();

              // 2. Show the success modal
              _showSuccessDialog(context);
            }
          },
        );
      },
    );
  }

  // The Success Modal Function
  void _showSuccessDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false, // User must click the button
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          title: const Icon(
            Icons.check_circle_outline,
            color: Colors.green,
            size: 60,
          ),
          content: const Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                "Booking Confirmed!",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
              ),
              SizedBox(height: 8),
              Text(
                "Your appointment has been successfully scheduled. You can view it in your bookings.",
                textAlign: TextAlign.center,
              ),
            ],
          ),
          actions: [
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  // 3. Navigate away ONLY after clicking OK
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const BottomNavigationPage(initialIndex: 2,),
                    ),
                    (_) => false,
                  );
                },
                child: const Text("Okay!"),
              ),
            ),
          ],
        );
      },
    );
  }


  void _confirm(BookingDraft draft) {
    final request = CreateBookingRequestModel(
      salonServicePriceId: draft.salonServicePriceId!,
      startAt: draft.startAt!,
      note: draft.note,
    );

    ref
        .read(startBookingViewModelProvider.notifier)
        .createBooking(request: request);
  }

  @override
  Widget build(BuildContext context) {
    final draft = ref.watch(bookingDraftProvider);
    final loading =
        ref.watch(startBookingViewModelProvider).isLoading;

    if (draft.style == null ||
        draft.startAt == null ||
        draft.salonServicePriceId == null ||
        draft.price == null ||
        draft.currency == null) {
      return const Scaffold(
        body: Center(child: Text('Booking data incomplete')),
      );
    }


    final canConfirm =
      !loading &&
      draft.salonServicePriceId != null &&
      draft.startAt != null;

    return Scaffold(
      appBar: AppBar(title: const Text('Confirm Booking')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            _SummaryTile(
              label: 'Salon',
              value: draft.salonName!,
            ),
            _SummaryTile(
              label: 'Service',
              value: draft.style!.name,
            ),
            _SummaryTile(
              label: 'Date & Time',
              value: DateFormat('dd MMM • HH:mm')
                  .format(draft.startAt!),
            ),
            _SummaryTile(
              label: 'Price',
              value:
                  '${draft.currency} ${draft.price!.toStringAsFixed(0)}',
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _noteController,
              maxLines: 3,
              decoration: InputDecoration(
                hintText: 'Add a note for the salon (optional)',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
              onChanged: (v) {
                ref
                    .read(bookingDraftProvider.notifier)
                    .setNote(v);
              },
            ),
            const Spacer(),
            
            SizedBox(
              width: double.infinity,
              height: 52,
              child: ElevatedButton(
                onPressed: canConfirm ? () => _confirm(draft) : null,
                child: loading
                    ? const CircularProgressIndicator(
                        color: Colors.white,
                      )
                    : const Text('Confirm Booking'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SummaryTile extends StatelessWidget {
  final String label;
  final String value;

  const _SummaryTile({
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      title: Text(label),
      trailing: Text(
        value,
        style: const TextStyle(fontWeight: FontWeight.w600),
      ),
    );
  }
}
