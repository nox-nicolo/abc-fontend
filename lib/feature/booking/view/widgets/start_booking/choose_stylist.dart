import 'package:africa_beuty/core/widgets/app_state.dart';
import 'package:africa_beuty/feature/booking/model/booking_stylist.dart';
import 'package:africa_beuty/feature/booking/provider/booking_draft.dart';
import 'package:africa_beuty/feature/booking/provider/salon_offer.dart';
import 'package:africa_beuty/feature/booking/view/widgets/start_booking/confirm.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ChooseStylistPage extends ConsumerWidget {
  const ChooseStylistPage({super.key, required this.salonServicePriceId});

  final String salonServicePriceId;

  void _continueWithStylist(
    BuildContext context,
    WidgetRef ref,
    String? stylistId,
  ) {
    ref.read(bookingDraftProvider.notifier).setStylist(stylistId);
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const ConfirmBookingPage()),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final draft = ref.watch(bookingDraftProvider);
    final startAt = draft.startAt;
    if (startAt == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Choose a Stylist')),
        body: const AppEmptyState(
          icon: Icons.schedule_rounded,
          title: 'Select a time first',
          message: 'Choose an appointment time before selecting a stylist.',
        ),
      );
    }

    final request = BookingStylistsRequest(
      salonServicePriceId: salonServicePriceId,
      startAt: startAt,
    );
    final stylists = ref.watch(bookingStylistsProvider(request));

    return Scaffold(
      appBar: AppBar(title: const Text('Choose a Stylist')),
      body: stylists.when(
        loading: () => const AppLoadingState(),
        error: (error, _) => AppErrorState(
          message: error,
          onRetry: () => ref.invalidate(bookingStylistsProvider(request)),
        ),
        data: (items) {
          final recommended = _recommendedFrom(items);
          final manualItems = items
              .where((item) => !item.isRecommended)
              .toList();
          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              if (recommended != null)
                _RecommendedAction(
                  stylist: recommended,
                  onTap: () =>
                      _continueWithStylist(context, ref, recommended.stylistId),
                )
              else
                _AnyStylistAction(
                  filled: true,
                  onTap: () => _continueWithStylist(context, ref, null),
                ),
              const SizedBox(height: 12),
              if (recommended != null)
                _AnyStylistAction(
                  filled: false,
                  onTap: () => _continueWithStylist(context, ref, null),
                ),
              if (manualItems.isNotEmpty) ...[
                const SizedBox(height: 24),
                Text(
                  'Choose someone specific',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 12),
                for (final stylist in manualItems) ...[
                  _StylistTile(
                    stylist: stylist,
                    onTap: () =>
                        _continueWithStylist(context, ref, stylist.stylistId),
                  ),
                  const SizedBox(height: 12),
                ],
              ],
            ],
          );
        },
      ),
    );
  }

  BookingStylistModel? _recommendedFrom(List<BookingStylistModel> items) {
    for (final item in items) {
      if (item.isRecommended) return item;
    }
    return null;
  }
}

class _RecommendedAction extends StatelessWidget {
  const _RecommendedAction({required this.stylist, required this.onTap});

  final BookingStylistModel stylist;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final reason =
        stylist.recommendationReason ?? 'Best match for this booking';
    return SizedBox(
      width: double.infinity,
      child: FilledButton.icon(
        onPressed: onTap,
        icon: const Icon(Icons.auto_awesome_rounded),
        label: Padding(
          padding: const EdgeInsets.symmetric(vertical: 12),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Help me choose: ${stylist.name}'),
              const SizedBox(height: 2),
              Text(
                reason,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.labelSmall?.copyWith(
                  color: Theme.of(context).colorScheme.onPrimary,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _AnyStylistAction extends StatelessWidget {
  const _AnyStylistAction({required this.onTap, required this.filled});

  final VoidCallback onTap;
  final bool filled;

  @override
  Widget build(BuildContext context) {
    final child = Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: const [
          Icon(Icons.groups_rounded),
          SizedBox(width: 8),
          Flexible(child: Text('Let salon assign stylist')),
        ],
      ),
    );
    if (filled) {
      return SizedBox(
        width: double.infinity,
        child: FilledButton(onPressed: onTap, child: child),
      );
    }
    return SizedBox(
      width: double.infinity,
      child: OutlinedButton(onPressed: onTap, child: child),
    );
  }
}

class _StylistTile extends StatelessWidget {
  const _StylistTile({required this.stylist, required this.onTap});

  final BookingStylistModel stylist;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.zero,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      child: ListTile(
        onTap: onTap,
        leading: ClipOval(
          child: stylist.image.isNotEmpty
              ? CachedNetworkImage(
                  imageUrl: stylist.image,
                  width: 48,
                  height: 48,
                  fit: BoxFit.cover,
                  errorWidget: (_, _, _) => const _StylistFallback(),
                )
              : const _StylistFallback(),
        ),
        title: Text(stylist.name),
        subtitle: Text(_subtitle),
        trailing: const Icon(Icons.arrow_forward_ios_rounded, size: 16),
      ),
    );
  }

  String get _subtitle {
    final parts = <String>[];
    final title = stylist.title?.trim();
    if (title != null && title.isNotEmpty) parts.add(title);
    if (stylist.reviewsCount > 0) {
      parts.add('${stylist.rating.toStringAsFixed(1)} rating');
    }
    return parts.isEmpty ? 'Available for this service' : parts.join(' · ');
  }
}

class _StylistFallback extends StatelessWidget {
  const _StylistFallback();

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      radius: 24,
      backgroundColor: Theme.of(context).colorScheme.surfaceContainerHighest,
      child: Icon(
        Icons.person_rounded,
        color: Theme.of(context).colorScheme.onSurfaceVariant,
      ),
    );
  }
}
