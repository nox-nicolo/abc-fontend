import 'package:africa_beuty/feature/booking/model/booking_status.dart';
import 'package:africa_beuty/feature/booking/view_modal/booking_action.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

class BookingDetailPage extends ConsumerStatefulWidget {
  final BookingListItem booking;

  const BookingDetailPage({super.key, required this.booking});

  @override
  ConsumerState<BookingDetailPage> createState() => _BookingDetailPageState();
}

class _BookingDetailPageState extends ConsumerState<BookingDetailPage> {
  @override
  void initState() {
    super.initState();

    ref.listenManual(bookingActionViewModelProvider, (prev, next) {
      next.whenOrNull(
        error: (err, _) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(err.toString())));
        },
        data: (_) {
          Navigator.pop(context);
        },
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final actionState = ref.watch(bookingActionViewModelProvider);
    final isLoading = actionState.isLoading;
    final booking = widget.booking;

    return Scaffold(
      backgroundColor: scheme.surface,
      appBar: AppBar(
        title: const Text('Booking Details'),
        centerTitle: true,
        elevation: 0,
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _BookingHeroCard(booking: booking),
                    const SizedBox(height: 20),

                    _ModernSectionCard(
                      title: 'Customer',
                      icon: Icons.person_outline_rounded,
                      children: [
                        _InfoRow(
                          icon: Icons.badge_outlined,
                          label: 'Name',
                          value: booking.customerName,
                        ),
                      ],
                    ),

                    const SizedBox(height: 16),

                    _ModernSectionCard(
                      title: 'Service',
                      icon: Icons.content_cut_rounded,
                      children: [
                        _InfoRow(
                          icon: Icons.spa_outlined,
                          label: 'Service',
                          value: booking.serviceName,
                        ),
                      ],
                    ),

                    const SizedBox(height: 16),

                    _ModernSectionCard(
                      title: 'Appointment',
                      icon: Icons.event_outlined,
                      children: [
                        _InfoRow(
                          icon: Icons.calendar_today_outlined,
                          label: 'Date',
                          value: DateFormat(
                            'EEEE, MMM dd yyyy',
                          ).format(booking.startAt),
                        ),
                        const SizedBox(height: 14),
                        _InfoRow(
                          icon: Icons.schedule_rounded,
                          label: 'Time',
                          value:
                              '${DateFormat('HH:mm').format(booking.startAt)} – '
                              '${DateFormat('HH:mm').format(booking.endAt)}',
                        ),
                        const SizedBox(height: 14),
                        _InfoRow(
                          icon: Icons.timelapse_rounded,
                          label: 'Duration',
                          value: '${booking.durationMinutes} mins',
                        ),
                      ],
                    ),

                    const SizedBox(height: 16),

                    _ModernSectionCard(
                      title: 'Price',
                      icon: Icons.payments_outlined,
                      children: [
                        _InfoRow(
                          icon: Icons.account_balance_wallet_outlined,
                          label: 'Amount',
                          value:
                              '${booking.currency} ${booking.price.toStringAsFixed(0)}',
                          emphasize: true,
                        ),
                      ],
                    ),

                    if (booking.note != null &&
                        booking.note!.trim().isNotEmpty) ...[
                      const SizedBox(height: 16),
                      _ModernSectionCard(
                        title: 'Note',
                        icon: Icons.sticky_note_2_outlined,
                        children: [_MessageBox(text: booking.note!)],
                      ),
                    ],

                    if (booking.status == 'cancelled' &&
                        booking.cancelReason != null &&
                        booking.cancelReason!.trim().isNotEmpty) ...[
                      const SizedBox(height: 16),
                      _ModernSectionCard(
                        title: 'Cancel Reason',
                        icon: Icons.error_outline_rounded,
                        children: [
                          _MessageBox(
                            text: booking.cancelReason!,
                            isDestructive: true,
                          ),
                        ],
                      ),
                    ],
                  ],
                ),
              ),
            ),

            Container(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
              decoration: BoxDecoration(
                color: scheme.surface,
                border: Border(top: BorderSide(color: scheme.outlineVariant)),
              ),
              child: _ActionButtons(booking: booking, loading: isLoading),
            ),
          ],
        ),
      ),
    );
  }
}

class _BookingHeroCard extends StatelessWidget {
  final BookingListItem booking;

  const _BookingHeroCard({required this.booking});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;

    final status = _statusMeta(context, _effectiveBookingStatus(booking));

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
          Wrap(
            spacing: 10,
            runSpacing: 10,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              Container(
                width: 52,
                height: 52,
                decoration: BoxDecoration(
                  color: scheme.primaryContainer,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Icon(
                  Icons.event_available_rounded,
                  color: scheme.onPrimaryContainer,
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    booking.serviceName,
                    style: theme.textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    booking.customerName,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: scheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              _StatusChip(
                label: status.label,
                background: status.bg,
                foreground: status.fg,
                icon: status.icon,
              ),
              const Spacer(),
              Text(
                '${booking.currency} ${booking.price.toStringAsFixed(0)}',
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w800,
                  color: scheme.primary,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _ModernSectionCard extends StatelessWidget {
  final String title;
  final IconData icon;
  final List<Widget> children;

  const _ModernSectionCard({
    required this.title,
    required this.icon,
    required this.children,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: scheme.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: scheme.outlineVariant),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 38,
                height: 38,
                decoration: BoxDecoration(
                  color: scheme.secondaryContainer,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(icon, size: 20, color: scheme.onSecondaryContainer),
              ),
              const SizedBox(width: 12),
              Text(
                title,
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
          const SizedBox(height: 18),
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

  const _InfoRow({
    required this.icon,
    required this.label,
    required this.value,
    this.emphasize = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 34,
          height: 34,
          decoration: BoxDecoration(
            color: scheme.surfaceContainerHigh,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(icon, size: 18, color: scheme.primary),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            label,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: scheme.onSurfaceVariant,
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          flex: 2,
          child: Text(
            value,
            textAlign: TextAlign.right,
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
            style: theme.textTheme.bodyLarge?.copyWith(
              fontWeight: emphasize ? FontWeight.w800 : FontWeight.w600,
              fontSize: emphasize ? 18 : null,
              color: scheme.onSurface,
            ),
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

    final bg = isDestructive
        ? scheme.errorContainer
        : scheme.surfaceContainerHigh;
    final fg = isDestructive ? scheme.onErrorContainer : scheme.onSurface;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Text(
        text,
        style: TextStyle(fontSize: 14, height: 1.45, color: fg),
      ),
    );
  }
}

class _StatusChip extends StatelessWidget {
  final String label;
  final Color background;
  final Color foreground;
  final IconData icon;

  const _StatusChip({
    required this.label,
    required this.background,
    required this.foreground,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(999),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: foreground),
          const SizedBox(width: 6),
          Text(
            label,
            style: TextStyle(
              color: foreground,
              fontWeight: FontWeight.w700,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }
}

class _StatusMeta {
  final String label;
  final Color bg;
  final Color fg;
  final IconData icon;

  const _StatusMeta({
    required this.label,
    required this.bg,
    required this.fg,
    required this.icon,
  });
}

_StatusMeta _statusMeta(BuildContext context, String status) {
  final scheme = Theme.of(context).colorScheme;

  switch (status) {
    case 'expired':
      return _StatusMeta(
        label: 'Expired',
        bg: scheme.surfaceContainerHighest,
        fg: scheme.onSurface,
        icon: Icons.hourglass_disabled_rounded,
      );
    case 'pending':
      return _StatusMeta(
        label: 'Pending',
        bg: scheme.secondaryContainer,
        fg: scheme.onSecondaryContainer,
        icon: Icons.schedule_rounded,
      );
    case 'confirmed':
      return _StatusMeta(
        label: 'Confirmed',
        bg: scheme.primaryContainer,
        fg: scheme.onPrimaryContainer,
        icon: Icons.check_circle_rounded,
      );
    case 'completed':
      return _StatusMeta(
        label: 'Completed',
        bg: scheme.tertiaryContainer,
        fg: scheme.onTertiaryContainer,
        icon: Icons.task_alt_rounded,
      );
    case 'cancelled':
      return _StatusMeta(
        label: 'Cancelled',
        bg: scheme.errorContainer,
        fg: scheme.onErrorContainer,
        icon: Icons.cancel_rounded,
      );
    default:
      return _StatusMeta(
        label: status,
        bg: scheme.surfaceContainerHighest,
        fg: scheme.onSurface,
        icon: Icons.info_outline_rounded,
      );
  }
}

class _ActionButtons extends ConsumerWidget {
  final BookingListItem booking;
  final bool loading;

  const _ActionButtons({required this.booking, required this.loading});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final vm = ref.read(bookingActionViewModelProvider.notifier);

    switch (_effectiveBookingStatus(booking)) {
      case 'expired':
        return const SizedBox.shrink();
      case 'pending':
        return Row(
          children: [
            Expanded(
              child: OutlinedButton.icon(
                onPressed: loading ? null : () => vm.reject(booking.id),
                icon: const Icon(Icons.close_rounded),
                label: const Text('Reject'),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: FilledButton.icon(
                onPressed: loading ? null : () => vm.accept(booking.id),
                icon: const Icon(Icons.check_rounded),
                label: const Text('Accept'),
              ),
            ),
          ],
        );

      case 'confirmed':
        return SizedBox(
          width: double.infinity,
          height: 52,
          child: FilledButton.icon(
            onPressed: loading ? null : () => vm.complete(booking.id),
            icon: const Icon(Icons.task_alt_rounded),
            label: const Text('Mark as Completed'),
          ),
        );

      default:
        return const SizedBox.shrink();
    }
  }
}

String _effectiveBookingStatus(BookingListItem booking) {
  if (booking.status == 'pending' && !booking.startAt.isAfter(DateTime.now())) {
    return 'expired';
  }
  return booking.status;
}
