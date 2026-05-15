import 'package:africa_beuty/core/theme/colors_pallete.dart';
import 'package:africa_beuty/feature/booking/model/booking_status.dart';
import 'package:africa_beuty/feature/booking/view/widgets/start_booking/choose_style.dart';
import 'package:africa_beuty/feature/booking/view/widgets/view_booking.dart';
import 'package:africa_beuty/feature/booking/view_modal/booking_action.dart';
import 'package:africa_beuty/feature/booking/view_modal/booking_status.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:intl/intl.dart';

class SalonBookingPage extends ConsumerStatefulWidget {
  const SalonBookingPage({super.key});

  @override
  ConsumerState<SalonBookingPage> createState() => _SalonBookingPageState();
}

class _SalonBookingPageState extends ConsumerState<SalonBookingPage> {
  void _invalidateAll() {
    ref.invalidate(bookingListViewModelProvider('confirmed'));
    ref.invalidate(bookingListViewModelProvider('pending'));
    ref.invalidate(bookingListViewModelProvider('completed'));
    ref.invalidate(bookingListViewModelProvider('cancelled'));
    ref.invalidate(bookingListViewModelProvider('expired'));
  }

  @override
  void initState() {
    super.initState();

    // Refresh data every time this page is (re)shown
    WidgetsBinding.instance.addPostFrameCallback((_) => _invalidateAll());

    // Listen to accept/reject/complete results and refresh lists
    ref.listenManual(bookingActionViewModelProvider, (prev, next) {
      next.whenOrNull(
        error: (err, _) {
          if (!mounted) return;
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(err.toString())));
        },
        data: (_) {
          _invalidateAll();
          if (!mounted) return;
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(const SnackBar(content: Text('Updated')));
        },
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final confirmed = ref.watch(bookingListViewModelProvider('confirmed'));
    final pending = ref.watch(bookingListViewModelProvider('pending'));
    final completed = ref.watch(bookingListViewModelProvider('completed'));
    final cancelled = ref.watch(bookingListViewModelProvider('cancelled'));
    final expired = ref.watch(bookingListViewModelProvider('expired'));

    final actionState = ref.watch(bookingActionViewModelProvider);
    final actionLoading = actionState.isLoading;

    final screenWidth = MediaQuery.of(context).size.width;

    return DefaultTabController(
      length: 5,
      child: Scaffold(
        body: Stack(
          children: [
            CustomScrollView(
              slivers: [
                const SliverAppBar(
                  automaticallyImplyLeading: false,
                  pinned: true,
                  title: Text('Bookings'),
                ),

                // ---------------- Next Appointment ----------------
                const SliverToBoxAdapter(
                  child: Padding(
                    padding: EdgeInsets.all(16),
                    child: Text(
                      'Next Appointment',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),

                SliverToBoxAdapter(
                  child: confirmed.when(
                    loading: () => const SizedBox(
                      height: 140,
                      child: Center(child: CircularProgressIndicator()),
                    ),
                    error: (e, _) => const Padding(
                      padding: EdgeInsets.all(16),
                      child: Text('Failed to load upcoming appointments'),
                    ),
                    data: (list) {
                      final now = DateTime.now();
                      final upcoming =
                          list.where((b) => b.startAt.isAfter(now)).toList()
                            ..sort((a, b) => a.startAt.compareTo(b.startAt));

                      if (upcoming.isEmpty) {
                        return const Padding(
                          padding: EdgeInsets.all(16),
                          child: Text('No upcoming appointments'),
                        );
                      }

                      return SizedBox(
                        height: 140,
                        child: ListView.separated(
                          scrollDirection: Axis.horizontal,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 8,
                          ),
                          itemCount: upcoming.length,
                          separatorBuilder: (_, _) => const SizedBox(width: 16),
                          itemBuilder: (_, i) => SizedBox(
                            width: screenWidth * .9,
                            child: NextBookingCard(
                              booking: upcoming[i],
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) =>
                                        BookingDetailPage(booking: upcoming[i]),
                                  ),
                                );
                              },
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),

                // ---------------- Start Booking ----------------
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const DiscoverStylePage(),
                          ),
                        );
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        child: const Text('Start New Booking'),
                      ),
                    ),
                  ),
                ),

                // ---------------- Tabs ----------------
                const SliverToBoxAdapter(
                  child: TabBar(
                    tabs: [
                      Tab(text: 'Pending'),
                      Tab(text: 'Confirmed'),
                      Tab(text: 'Completed'),
                      Tab(text: 'Cancelled'),
                      Tab(text: 'Expired'),
                    ],
                  ),
                ),

                SliverFillRemaining(
                  child: TabBarView(
                    children: [
                      BookingTab(
                        state: pending,
                        empty: 'No pending bookings',
                        actionLoading: actionLoading,
                      ),
                      BookingTab(
                        state: confirmed,
                        empty: 'No confirmed bookings',
                        actionLoading: actionLoading,
                      ),
                      BookingTab(
                        state: completed,
                        empty: 'No completed bookings',
                        actionLoading: actionLoading,
                      ),
                      BookingTab(
                        state: cancelled,
                        empty: 'No cancelled bookings',
                        actionLoading: actionLoading,
                      ),
                      BookingTab(
                        state: expired,
                        empty: 'No expired bookings',
                        actionLoading: actionLoading,
                      ),
                    ],
                  ),
                ),
              ],
            ),

            // Global action blocker (optional but clean UX)
            if (actionLoading)
              Positioned.fill(
                child: IgnorePointer(
                  ignoring: false,
                  child: Container(
                    color: Colors.black.withValues(alpha: 0.05),
                    alignment: Alignment.center,
                    child: const SizedBox(
                      width: 28,
                      height: 28,
                      child: CircularProgressIndicator(strokeWidth: 3),
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class NextBookingCard extends StatelessWidget {
  final BookingListItem booking;
  final VoidCallback? onTap;

  const NextBookingCard({super.key, required this.booking, this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(16),
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Theme.of(
            context,
          ).colorScheme.primaryContainer.withValues(alpha: .4),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          children: [
            const Icon(Icons.event, size: 28),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    booking.customerName,
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    booking.serviceName,
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${DateFormat('MMM dd • HH:mm').format(booking.startAt)}'
                    ' • ${booking.durationMinutes} mins',
                    style: const TextStyle(fontSize: 12),
                  ),
                ],
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  '${booking.currency} ${booking.price.toStringAsFixed(0)}',
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 6),
                const Chip(
                  label: Text('CONFIRMED'),
                  visualDensity: VisualDensity.compact,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class BookingTab extends ConsumerWidget {
  final AsyncValue<List<BookingListItem>> state;
  final String empty;
  final bool actionLoading;

  const BookingTab({
    super.key,
    required this.state,
    required this.empty,
    required this.actionLoading,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return state.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, _) => Center(child: Text(empty)),
      data: (list) {
        if (list.isEmpty) {
          return Center(child: Text(empty));
        }

        // sort by date ascending
        final sorted = [...list]
          ..sort((a, b) => a.startAt.compareTo(b.startAt));

        return ListView.separated(
          padding: const EdgeInsets.all(16),
          itemCount: sorted.length,
          separatorBuilder: (_, _) => const SizedBox(height: 12),
          itemBuilder: (_, i) {
            final booking = sorted[i];
            final effectiveStatus = _effectiveBookingStatus(booking);

            return BookingCard(
              booking: booking,
              disabled: actionLoading,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => BookingDetailPage(booking: booking),
                  ),
                );
              },
              onAccept: effectiveStatus == 'pending' && !actionLoading
                  ? () => ref
                        .read(bookingActionViewModelProvider.notifier)
                        .accept(booking.id)
                  : null,
              onReject: effectiveStatus == 'pending' && !actionLoading
                  ? () => ref
                        .read(bookingActionViewModelProvider.notifier)
                        .reject(booking.id)
                  : null,
            );
          },
        );
      },
    );
  }
}

class BookingCard extends StatelessWidget {
  final BookingListItem booking;
  final VoidCallback? onTap;
  final VoidCallback? onAccept;
  final VoidCallback? onReject;
  final bool disabled;

  const BookingCard({
    super.key,
    required this.booking,
    this.onTap,
    this.onAccept,
    this.onReject,
    this.disabled = false,
  });

  @override
  Widget build(BuildContext context) {
    final status = _effectiveBookingStatus(booking);
    final isPending = status == 'pending';

    return Slidable(
      enabled: isPending && !disabled,
      key: ValueKey(booking.id),
      endActionPane: isPending && !disabled
          ? ActionPane(
              motion: const StretchMotion(),
              extentRatio: 0.42,
              children: [
                SlidableAction(
                  onPressed: (_) => onAccept?.call(),
                  backgroundColor: AppColors.successLight,
                  foregroundColor: AppColors.lightOnSecondary,
                  icon: Icons.check,
                  label: 'Accept',
                  borderRadius: BorderRadius.circular(12),
                  autoClose: true,
                ),
                SlidableAction(
                  onPressed: (_) => onReject?.call(),
                  backgroundColor: AppColors.errorLight,
                  foregroundColor: AppColors.lightOnPrimary,
                  icon: Icons.close,
                  label: 'Reject',
                  borderRadius: BorderRadius.circular(12),
                  autoClose: true,
                ),
              ],
            )
          : null,
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: disabled ? null : onTap,
        child: _card(context),
      ),
    );
  }

  Widget _card(BuildContext context) {
    final status = _effectiveBookingStatus(booking);
    final isCancelled = status == 'cancelled';

    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Opacity(
        opacity: disabled ? 0.7 : 1.0,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: _statusColor(context).withValues(alpha: .15),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(_statusIcon(), color: _statusColor(context)),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      booking.customerName,
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: 2),
                    Text(
                      booking.serviceName,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${DateFormat('MMM dd • HH:mm').format(booking.startAt)}'
                      ' • ${booking.durationMinutes} mins',
                      style: const TextStyle(fontSize: 13),
                    ),
                    if (isCancelled && booking.cancelReason != null) ...[
                      const SizedBox(height: 6),
                      Text(
                        'Reason: ${booking.cancelReason}',
                        style: TextStyle(
                          fontSize: 12,
                          color: Theme.of(context).colorScheme.error,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    '${booking.currency} ${booking.price.toStringAsFixed(0)}',
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 6),
                  Chip(
                    label: Text(
                      status.toUpperCase(),
                      style: const TextStyle(fontSize: 11),
                    ),
                    visualDensity: VisualDensity.compact,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  IconData _statusIcon() {
    switch (_effectiveBookingStatus(booking)) {
      case 'expired':
        return Icons.hourglass_disabled_outlined;
      case 'pending':
        return Icons.pending_actions;
      case 'confirmed':
        return Icons.check_circle_outline;
      case 'completed':
        return Icons.check_circle_outline;
      case 'cancelled':
        return Icons.cancel_outlined;
      default:
        return Icons.event;
    }
  }

  Color _statusColor(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final isLight = scheme.brightness == Brightness.light;
    switch (_effectiveBookingStatus(booking)) {
      case 'expired':
        return scheme.outline;
      case 'pending':
        return isLight ? AppColors.warningLight : AppColors.warningDark;
      case 'confirmed':
        return scheme.primary;
      case 'completed':
        return isLight ? AppColors.successLight : AppColors.successDark;
      case 'cancelled':
        return scheme.error;
      default:
        return scheme.primary;
    }
  }
}

String _effectiveBookingStatus(BookingListItem booking) {
  if (booking.status == 'pending' && !booking.startAt.isAfter(DateTime.now())) {
    return 'expired';
  }
  return booking.status;
}
