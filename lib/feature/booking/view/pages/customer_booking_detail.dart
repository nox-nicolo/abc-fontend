import 'package:africa_beuty/feature/booking/model/start_booking.dart';
import 'package:africa_beuty/feature/booking/view_modal/customer_booking.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

class CustomerBookingDetailPage extends ConsumerStatefulWidget {
  final String bookingId;
  const CustomerBookingDetailPage({super.key, required this.bookingId});

  @override
  ConsumerState<CustomerBookingDetailPage> createState() =>
      _CustomerBookingDetailPageState();
}

class _CustomerBookingDetailPageState
    extends ConsumerState<CustomerBookingDetailPage> {
  @override
  void initState() {
    super.initState();
    ref.listenManual(customerBookingActionViewModelProvider, (_, next) {
      next.whenOrNull(
        error: (err, _) => ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(err.toString())),
        ),
        data: (_) {
          // Refresh the detail and pop any bottom sheet that may be open.
          ref.invalidate(bookingDetailViewModelProvider(widget.bookingId));
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Done')),
          );
        },
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final detailState =
        ref.watch(bookingDetailViewModelProvider(widget.bookingId));
    final actionState = ref.watch(customerBookingActionViewModelProvider);
    final isLoading = actionState.isLoading;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Booking Details'),
        centerTitle: true,
      ),
      body: detailState.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text(e.toString())),
        data: (booking) => Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _HeroCard(booking: booking),
                    const SizedBox(height: 16),
                    _SectionCard(
                      title: 'Service',
                      icon: Icons.content_cut_rounded,
                      children: [
                        _InfoRow(
                          icon: Icons.spa_outlined,
                          label: 'Service',
                          value: booking.serviceNameSnapshot,
                        ),
                        const SizedBox(height: 12),
                        _InfoRow(
                          icon: Icons.timelapse_rounded,
                          label: 'Duration',
                          value: '${booking.durationMinutesSnapshot} min',
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    _SectionCard(
                      title: 'Appointment',
                      icon: Icons.event_outlined,
                      children: [
                        _InfoRow(
                          icon: Icons.calendar_today_outlined,
                          label: 'Date',
                          value: DateFormat('EEE, MMM dd yyyy')
                              .format(booking.startAt),
                        ),
                        const SizedBox(height: 12),
                        _InfoRow(
                          icon: Icons.schedule_rounded,
                          label: 'Time',
                          value:
                              '${DateFormat('HH:mm').format(booking.startAt)} – '
                              '${DateFormat('HH:mm').format(booking.endAt)}',
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    _SectionCard(
                      title: 'Price',
                      icon: Icons.payments_outlined,
                      children: [
                        _InfoRow(
                          icon: Icons.account_balance_wallet_outlined,
                          label: 'Amount',
                          value:
                              '${booking.currencySnapshot} ${booking.priceSnapshot.toStringAsFixed(0)}',
                          emphasize: true,
                        ),
                      ],
                    ),
                    if (booking.note != null &&
                        booking.note!.trim().isNotEmpty) ...[
                      const SizedBox(height: 16),
                      _SectionCard(
                        title: 'Note',
                        icon: Icons.sticky_note_2_outlined,
                        children: [
                          _MessageBox(text: booking.note!),
                        ],
                      ),
                    ],
                    if (booking.cancelReason != null &&
                        booking.cancelReason!.trim().isNotEmpty) ...[
                      const SizedBox(height: 16),
                      _SectionCard(
                        title: 'Cancel Reason',
                        icon: Icons.error_outline_rounded,
                        children: [
                          _MessageBox(
                              text: booking.cancelReason!, isDestructive: true),
                        ],
                      ),
                    ],
                  ],
                ),
              ),
            ),
            _ActionBar(booking: booking, loading: isLoading),
          ],
        ),
      ),
    );
  }
}

// ── Action bar ────────────────────────────────────────────────────────────────
class _ActionBar extends ConsumerWidget {
  final BookingModel booking;
  final bool loading;
  const _ActionBar({required this.booking, required this.loading});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final scheme = Theme.of(context).colorScheme;
    final vm = ref.read(customerBookingActionViewModelProvider.notifier);

    Widget? actions;

    switch (booking.status) {
      case 'pending':
      case 'confirmed':
        actions = Row(
          children: [
            Expanded(
              child: OutlinedButton.icon(
                onPressed: loading ? null : () => _showCancelDialog(context, vm, booking.id),
                icon: const Icon(Icons.cancel_outlined),
                label: const Text('Cancel'),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: FilledButton.icon(
                onPressed: loading
                    ? null
                    : () => _showRescheduleDialog(context, vm, booking),
                icon: const Icon(Icons.edit_calendar_rounded),
                label: const Text('Reschedule'),
              ),
            ),
          ],
        );
        break;
      case 'completed':
        actions = SizedBox(
          width: double.infinity,
          child: FilledButton.icon(
            onPressed: loading
                ? null
                : () => _showReviewDialog(context, vm, booking.id),
            icon: const Icon(Icons.star_outline_rounded),
            label: const Text('Leave a Review'),
          ),
        );
        break;
    }

    if (actions == null) return const SizedBox.shrink();

    return Container(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
      decoration: BoxDecoration(
        color: scheme.surface,
        border: Border(top: BorderSide(color: scheme.outlineVariant)),
      ),
      child: loading
          ? const Center(child: CircularProgressIndicator())
          : actions,
    );
  }

  void _showCancelDialog(
      BuildContext context,
      CustomerBookingActionViewModel vm,
      String bookingId) {
    final reasonCtrl = TextEditingController();
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Cancel Booking'),
        content: TextField(
          controller: reasonCtrl,
          decoration: const InputDecoration(
            labelText: 'Reason (optional)',
            border: OutlineInputBorder(),
          ),
          maxLines: 2,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Back'),
          ),
          FilledButton(
            onPressed: () {
              Navigator.pop(context);
              vm.cancel(bookingId, reason: reasonCtrl.text.trim());
            },
            child: const Text('Cancel Booking'),
          ),
        ],
      ),
    );
  }

  void _showRescheduleDialog(
      BuildContext context,
      CustomerBookingActionViewModel vm,
      BookingModel booking) async {
    final now = DateTime.now();
    final date = await showDatePicker(
      context: context,
      initialDate: booking.startAt.isAfter(now) ? booking.startAt : now,
      firstDate: now,
      lastDate: now.add(const Duration(days: 90)),
    );
    if (date == null || !context.mounted) return;

    final time = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(booking.startAt),
    );
    if (time == null) return;

    final newStart = DateTime(
      date.year, date.month, date.day, time.hour, time.minute,
    );
    vm.reschedule(booking.id, newStart);
  }

  void _showReviewDialog(
      BuildContext context,
      CustomerBookingActionViewModel vm,
      String bookingId) {
    int rating = 5;
    final commentCtrl = TextEditingController();

    showDialog(
      context: context,
      builder: (_) => StatefulBuilder(
        builder: (ctx, setState) => AlertDialog(
          title: const Text('Leave a Review'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(
                  5,
                  (i) => IconButton(
                    icon: Icon(
                      i < rating ? Icons.star_rounded : Icons.star_outline_rounded,
                      color: Colors.amber,
                    ),
                    onPressed: () => setState(() => rating = i + 1),
                  ),
                ),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: commentCtrl,
                decoration: const InputDecoration(
                  labelText: 'Comment (optional)',
                  border: OutlineInputBorder(),
                ),
                maxLines: 3,
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            FilledButton(
              onPressed: () {
                Navigator.pop(context);
                vm.review(
                  bookingId,
                  rating: rating,
                  comment: commentCtrl.text.trim(),
                );
              },
              child: const Text('Submit'),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Shared card widgets ───────────────────────────────────────────────────────
class _HeroCard extends StatelessWidget {
  final BookingModel booking;
  const _HeroCard({required this.booking});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final color = _statusColor(scheme, booking.status);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: scheme.surfaceContainerLow,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: scheme.outlineVariant),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            booking.serviceNameSnapshot,
            style: theme.textTheme.titleLarge
                ?.copyWith(fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(99),
                ),
                child: Text(
                  booking.status.toUpperCase(),
                  style: TextStyle(
                    color: color,
                    fontWeight: FontWeight.w700,
                    fontSize: 12,
                  ),
                ),
              ),
              const Spacer(),
              Text(
                '${booking.currencySnapshot} ${booking.priceSnapshot.toStringAsFixed(0)}',
                style: theme.textTheme.titleMedium
                    ?.copyWith(fontWeight: FontWeight.w800),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Color _statusColor(ColorScheme scheme, String status) {
    switch (status) {
      case 'pending':
        return Colors.orange;
      case 'confirmed':
        return Colors.blue;
      case 'completed':
        return Colors.green;
      default:
        return scheme.error;
    }
  }
}

class _SectionCard extends StatelessWidget {
  final String title;
  final IconData icon;
  final List<Widget> children;
  const _SectionCard(
      {required this.title, required this.icon, required this.children});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: scheme.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: scheme.outlineVariant),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(children: [
            Icon(icon, size: 18, color: scheme.primary),
            const SizedBox(width: 8),
            Text(title,
                style: theme.textTheme.titleSmall
                    ?.copyWith(fontWeight: FontWeight.w700)),
          ]),
          const SizedBox(height: 14),
          ...children,
        ],
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final bool emphasize;
  const _InfoRow(
      {required this.icon,
      required this.label,
      required this.value,
      this.emphasize = false});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    return Row(
      children: [
        Icon(icon, size: 18, color: scheme.onSurfaceVariant),
        const SizedBox(width: 10),
        Text(label,
            style: theme.textTheme.bodyMedium
                ?.copyWith(color: scheme.onSurfaceVariant)),
        const Spacer(),
        Text(
          value,
          style: theme.textTheme.bodyLarge?.copyWith(
            fontWeight: emphasize ? FontWeight.w800 : FontWeight.w600,
          ),
        ),
      ],
    );
  }
}

class _MessageBox extends StatelessWidget {
  final String text;
  final bool isDestructive;
  const _MessageBox({required this.text, this.isDestructive = false});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: isDestructive ? scheme.errorContainer : scheme.surfaceContainerHigh,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: isDestructive ? scheme.onErrorContainer : scheme.onSurface,
          height: 1.4,
        ),
      ),
    );
  }
}
