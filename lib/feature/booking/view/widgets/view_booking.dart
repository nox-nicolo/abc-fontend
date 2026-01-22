import 'package:africa_beuty/feature/booking/model/booking_status.dart';
import 'package:africa_beuty/feature/booking/view_modal/booking_action.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

class BookingDetailPage extends ConsumerStatefulWidget {
  final BookingListItem booking;

  const BookingDetailPage({
    super.key,
    required this.booking,
  });

  @override
  ConsumerState<BookingDetailPage> createState() =>
      _BookingDetailPageState();
}

class _BookingDetailPageState
    extends ConsumerState<BookingDetailPage> {
  @override
  void initState() {
    super.initState();

    // ----------------------------------------------
    // Listen to booking actions (accept / reject / complete)
    // ----------------------------------------------
    ref.listenManual(
      bookingActionViewModelProvider,
      (prev, next) {
        next.whenOrNull(
          error: (err, _) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(err.toString())),
            );
          },
          data: (_) {
            // Action success → go back
            Navigator.pop(context);
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final actionState = ref.watch(bookingActionViewModelProvider);
    final isLoading = actionState.isLoading;

    final booking = widget.booking;

    return Scaffold(
      appBar: AppBar(title: const Text('Booking Details')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _section('Customer'),
            _info(Icons.person_outline, booking.customerName),

            const SizedBox(height: 16),

            _section('Service'),
            _info(Icons.cut, booking.serviceName),

            const SizedBox(height: 16),

            _section('Appointment'),
            _info(
              Icons.calendar_today_outlined,
              DateFormat('EEEE, MMM dd yyyy').format(booking.startAt),
            ),
            _info(
              Icons.schedule,
              '${DateFormat('HH:mm').format(booking.startAt)} – '
              '${DateFormat('HH:mm').format(booking.endAt)}'
              ' (${booking.durationMinutes} mins)',
            ),

            const SizedBox(height: 16),

            _section('Price'),
            _info(
              Icons.payments_outlined,
              '${booking.currency} ${booking.price.toStringAsFixed(0)}',
            ),

            if (booking.note != null && booking.note!.isNotEmpty) ...[
              const SizedBox(height: 16),
              _section('Note'),
              _box(booking.note!),
            ],

            if (booking.status == 'cancelled' &&
                booking.cancelReason != null) ...[
              const SizedBox(height: 16),
              _section('Cancel Reason'),
              _box(
                booking.cancelReason!,
                bg: Colors.red.shade50,
                fg: Colors.redAccent,
              ),
            ],

            const Spacer(),

            _ActionButtons(
              booking: booking,
              loading: isLoading,
            ),
          ],
        ),
      ),
    );
  }

  // --------------------------------------------------
  // UI HELPERS
  // --------------------------------------------------

  Widget _section(String t) => Padding(
        padding: const EdgeInsets.only(bottom: 6),
        child: Text(
          t,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 14,
          ),
        ),
      );

  Widget _info(IconData i, String t) => ListTile(
        contentPadding: EdgeInsets.zero,
        leading: Icon(i, size: 20),
        title: Text(t),
      );

  Widget _box(
    String t, {
    Color bg = const Color(0xFFF5F5F5),
    Color fg = Colors.black,
  }) =>
      Container(
        width: double.infinity,
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: bg,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Text(
          t,
          style: TextStyle(fontSize: 14, color: fg),
        ),
      );
}

// --------------------------------------------------
// ACTION BUTTONS
// --------------------------------------------------
class _ActionButtons extends ConsumerWidget {
  final BookingListItem booking;
  final bool loading;

  const _ActionButtons({
    required this.booking,
    required this.loading,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final vm =
        ref.read(bookingActionViewModelProvider.notifier);

    switch (booking.status) {
      case 'pending':
        return Row(
          children: [
            Expanded(
              child: OutlinedButton.icon(
                icon: const Icon(Icons.close),
                label: const Text('Reject'),
                onPressed:
                    loading ? null : () => vm.reject(booking.id),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: ElevatedButton.icon(
                icon: const Icon(Icons.check),
                label: const Text('Accept'),
                onPressed:
                    loading ? null : () => vm.accept(booking.id),
              ),
            ),
          ],
        );

      case 'confirmed':
        return SizedBox(
          width: double.infinity,
          height: 52,
          child: ElevatedButton.icon(
            icon: const Icon(Icons.check_circle_outline),
            label: const Text('Mark as Completed'),
            onPressed:
                loading ? null : () => vm.complete(booking.id),
          ),
        );

      default:
        return const SizedBox.shrink();
    }
  }
}
