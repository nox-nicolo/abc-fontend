import 'package:africa_beuty/core/page/bottom_nav.dart';
import 'package:africa_beuty/core/widgets/app_state.dart';
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
  ConsumerState<ConfirmBookingPage> createState() => _ConfirmBookingPageState();
}

class _ConfirmBookingPageState extends ConsumerState<ConfirmBookingPage> {
  final _noteController = TextEditingController();

  @override
  void initState() {
    super.initState();

    ref.listenManual(startBookingViewModelProvider, (prev, next) {
      next.whenOrNull(
        error: (err, _) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(err.toString()),
              behavior: SnackBarBehavior.floating,
              backgroundColor: Colors.redAccent,
            ),
          );
        },
        data: (booking) {
          if (booking != null) {
            ref.read(bookingDraftProvider.notifier).reset();
            _showSuccessDialog(context);
          }
        },
      );
    });
  }

  void _showSuccessDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(28),
          ),
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.green.withValues(alpha: 0.1),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.check_circle,
                    color: Colors.green,
                    size: 60,
                  ),
                ),
                const SizedBox(height: 20),
                const Text(
                  "Booking Confirmed!",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22),
                ),
                const SizedBox(height: 12),
                const Text(
                  "Your appointment has been successfully scheduled. You can view it in your bookings.",
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.grey, fontSize: 15),
                ),
                const SizedBox(height: 24),
                SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      // backgroundColor: Colors.black,
                      // foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                    onPressed: () {
                      Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(
                          builder: (_) =>
                              const BottomNavigationPage(initialIndex: 2),
                        ),
                        (_) => false,
                      );
                    },
                    child: const Text(
                      "Awesome!",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
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
    final loading = ref.watch(startBookingViewModelProvider).isLoading;

    final serviceName = draft.serviceName ?? draft.style?.name;

    if (serviceName == null ||
        draft.startAt == null ||
        draft.salonServicePriceId == null ||
        draft.salonName == null ||
        draft.price == null ||
        draft.currency == null) {
      return const Scaffold(
        body: AppEmptyState(
          icon: Icons.event_busy_rounded,
          title: 'Booking data incomplete',
          message: 'Choose a style, salon, and time before confirming.',
        ),
      );
    }

    final canConfirm =
        !loading && draft.salonServicePriceId != null && draft.startAt != null;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Review Booking',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Booking Summary",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),

            // SUMMARY CARD
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Theme.of(
                  context,
                ).colorScheme.primary.withValues(alpha: 0.5),
                borderRadius: BorderRadius.circular(24),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.5),
                    blurRadius: 20,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: Column(
                children: [
                  _SummaryTile(
                    label: 'Salon',
                    value: draft.salonName!,
                    icon: Icons.storefront_outlined,
                  ),
                  const Divider(height: 32, thickness: 0.8),
                  _SummaryTile(
                    label: 'Service',
                    value: serviceName,
                    icon: Icons.content_cut_outlined,
                  ),
                  const Divider(height: 32, thickness: 0.8),
                  _SummaryTile(
                    label: 'Date & Time',
                    value: DateFormat(
                      'EEEE, dd MMM • HH:mm',
                    ).format(draft.startAt!),
                    icon: Icons.calendar_today_outlined,
                  ),
                  const Divider(height: 32, thickness: 0.8),
                  _SummaryTile(
                    label: 'Total Price',
                    value:
                        '${draft.currency} ${draft.price!.toStringAsFixed(0)}',
                    icon: Icons.payments_outlined,
                    isPrice: true,
                  ),
                ],
              ),
            ),

            const SizedBox(height: 32),
            const Text(
              "Special Instructions",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),

            TextField(
              controller: _noteController,
              maxLines: 4,
              decoration: InputDecoration(
                hintText: 'Add a note for the salon...',
                // hintStyle: const TextStyle(color: Colors.grey),
                filled: true,
                fillColor: Theme.of(
                  context,
                ).colorScheme.primary.withValues(alpha: 0.4),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                  borderSide: BorderSide.none,
                ),
                contentPadding: const EdgeInsets.all(16),
              ),
              onChanged: (v) =>
                  ref.read(bookingDraftProvider.notifier).setNote(v),
            ),
            const SizedBox(height: 100), // Space for bottom button
          ],
        ),
      ),
      bottomSheet: Container(
        padding: const EdgeInsets.fromLTRB(20, 12, 20, 32),
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 10,
              offset: const Offset(0, -4),
            ),
          ],
        ),
        child: SizedBox(
          width: double.infinity,
          height: 60,
          child: ElevatedButton(
            onPressed: canConfirm ? () => _confirm(draft) : null,
            style: ElevatedButton.styleFrom(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              elevation: 0,
            ),
            child: loading
                ? const SizedBox(
                    height: 24,
                    width: 24,
                    child: CircularProgressIndicator(
                      color: Colors.white,
                      strokeWidth: 2,
                    ),
                  )
                : const Text(
                    'Confirm Appointment',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
          ),
        ),
      ),
    );
  }
}

class _SummaryTile extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;
  final bool isPrice;

  const _SummaryTile({
    required this.label,
    required this.value,
    required this.icon,
    this.isPrice = false,
  });

  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).colorScheme.secondary;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 22, color: color),
        const SizedBox(width: 12),

        // Left side label
        Expanded(
          flex: 3,
          child: Text(
            label,
            style: const TextStyle(fontSize: 15),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ),

        const SizedBox(width: 12),

        // Right side value
        Expanded(
          flex: 4,
          child: Text(
            value,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: isPrice ? 18 : 15,
              color: Colors.black,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.right,
          ),
        ),
      ],
    );
  }
}
