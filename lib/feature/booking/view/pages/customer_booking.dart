import 'package:africa_beuty/feature/booking/model/booking_status.dart';
import 'package:africa_beuty/feature/booking/view/pages/customer_booking_detail.dart';
import 'package:africa_beuty/feature/booking/view/widgets/start_booking/choose_style.dart';
import 'package:africa_beuty/feature/booking/view_modal/customer_booking.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

class CustomerBookingPage extends ConsumerStatefulWidget {
  const CustomerBookingPage({super.key});

  @override
  ConsumerState<CustomerBookingPage> createState() =>
      _CustomerBookingPageState();
}

class _CustomerBookingPageState extends ConsumerState<CustomerBookingPage> {
  @override
  void initState() {
    super.initState();
    ref.listenManual(
      customerBookingActionViewModelProvider,
      (_, next) {
        next.whenOrNull(
          error: (err, _) => ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(err.toString())),
          ),
          data: (_) => ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Done')),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 4,
      child: Scaffold(
        body: CustomScrollView(
          slivers: [
            SliverAppBar(
              automaticallyImplyLeading: false,
              pinned: true,
              title: const Text('My Bookings'),
              bottom: const TabBar(
                isScrollable: true,
                tabAlignment: TabAlignment.start,
                tabs: [
                  Tab(text: 'All'),
                  Tab(text: 'Pending'),
                  Tab(text: 'Confirmed'),
                  Tab(text: 'Completed'),
                ],
              ),
              actions: [
                IconButton(
                  tooltip: 'New Booking',
                  icon: const Icon(Icons.add),
                  onPressed: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const DiscoverStylePage(),
                    ),
                  ),
                ),
              ],
            ),
            SliverFillRemaining(
              child: TabBarView(
                children: [
                  _BookingTab(status: ''),
                  _BookingTab(status: 'pending'),
                  _BookingTab(status: 'confirmed'),
                  _BookingTab(status: 'completed'),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Per-tab list ──────────────────────────────────────────────────────────────
class _BookingTab extends ConsumerWidget {
  final String status;
  const _BookingTab({required this.status});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(myBookingsViewModelProvider(status));

    return state.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, _) => Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(e.toString()),
            const SizedBox(height: 12),
            FilledButton(
              onPressed: () =>
                  ref.invalidate(myBookingsViewModelProvider(status)),
              child: const Text('Retry'),
            ),
          ],
        ),
      ),
      data: (list) {
        if (list.isEmpty) {
          return Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.event_busy_rounded,
                    size: 56,
                    color: Theme.of(context).colorScheme.outline),
                const SizedBox(height: 12),
                Text(
                  status.isEmpty ? 'No bookings yet' : 'No $status bookings',
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
              ],
            ),
          );
        }

        final sorted = [...list]
          ..sort((a, b) => b.startAt.compareTo(a.startAt));

        return RefreshIndicator(
          onRefresh: () async =>
              ref.invalidate(myBookingsViewModelProvider(status)),
          child: ListView.separated(
            padding: const EdgeInsets.all(16),
            itemCount: sorted.length,
            separatorBuilder: (_, __) => const SizedBox(height: 12),
            itemBuilder: (_, i) => CustomerBookingCard(
              booking: sorted[i],
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) =>
                      CustomerBookingDetailPage(bookingId: sorted[i].id),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

// ── Booking card ──────────────────────────────────────────────────────────────
class CustomerBookingCard extends StatelessWidget {
  final BookingListItem booking;
  final VoidCallback? onTap;

  const CustomerBookingCard({super.key, required this.booking, this.onTap});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final color = _statusColor(scheme);

    return InkWell(
      borderRadius: BorderRadius.circular(16),
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: scheme.surfaceContainerLowest,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: scheme.outlineVariant),
        ),
        child: Row(
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: color.withOpacity(.15),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(_statusIcon(), color: color),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    booking.serviceName,
                    style: theme.textTheme.titleMedium
                        ?.copyWith(fontWeight: FontWeight.w700),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    DateFormat('EEE, MMM d • HH:mm').format(booking.startAt),
                    style: theme.textTheme.bodySmall
                        ?.copyWith(color: scheme.onSurfaceVariant),
                  ),
                  if (booking.cancelReason != null &&
                      booking.cancelReason!.isNotEmpty) ...[
                    const SizedBox(height: 4),
                    Text(
                      'Reason: ${booking.cancelReason}',
                      style: theme.textTheme.bodySmall
                          ?.copyWith(color: scheme.error),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ],
              ),
            ),
            const SizedBox(width: 8),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  '${booking.currency} ${booking.price.toStringAsFixed(0)}',
                  style: theme.textTheme.bodyMedium
                      ?.copyWith(fontWeight: FontWeight.w700),
                ),
                const SizedBox(height: 6),
                _StatusBadge(status: booking.status, color: color),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Color _statusColor(ColorScheme scheme) {
    switch (booking.status) {
      case 'pending':
        return Colors.orange;
      case 'confirmed':
        return Colors.blue;
      case 'completed':
        return Colors.green;
      case 'cancelled':
      case 'rejected':
        return scheme.error;
      default:
        return scheme.primary;
    }
  }

  IconData _statusIcon() {
    switch (booking.status) {
      case 'pending':
        return Icons.pending_actions_rounded;
      case 'confirmed':
        return Icons.check_circle_outline_rounded;
      case 'completed':
        return Icons.task_alt_rounded;
      case 'cancelled':
        return Icons.cancel_outlined;
      case 'rejected':
        return Icons.do_not_disturb_alt_rounded;
      default:
        return Icons.event_rounded;
    }
  }
}

class _StatusBadge extends StatelessWidget {
  final String status;
  final Color color;
  const _StatusBadge({required this.status, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: color.withOpacity(.12),
        borderRadius: BorderRadius.circular(99),
      ),
      child: Text(
        status.toUpperCase(),
        style: TextStyle(
          fontSize: 10,
          fontWeight: FontWeight.w700,
          color: color,
        ),
      ),
    );
  }
}
