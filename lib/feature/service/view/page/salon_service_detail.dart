import 'package:africa_beuty/feature/booking/provider/booking_draft.dart';
import 'package:africa_beuty/feature/booking/view/widgets/start_booking/select_time.dart';
import 'package:africa_beuty/feature/profile/model/salon_view_profile.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Salon-scoped service detail. Shown when a user taps a service card on a
/// salon profile — keeps the viewer locked to this salon's offering rather
/// than scattering them to the marketplace-wide list.
class SalonServiceDetailPage extends ConsumerWidget {
  final SalonViewProfileModel salon;
  final SalonServiceItemModel service;

  const SalonServiceDetailPage({
    super.key,
    required this.salon,
    required this.service,
  });

  String get _priceText {
    if (service.priceMin == null) return 'Price on request';
    final min = service.priceMin!;
    final max = service.priceMax;
    final currency = service.currency;
    if (max != null && max != min) return '$currency $min – $max';
    return '$currency $min';
  }

  String get _durationText => service.durationMinutes != null
      ? '${service.durationMinutes} min'
      : '—';

  void _startBooking(BuildContext context, WidgetRef ref) {
    ref.read(bookingDraftProvider.notifier)
      ..reset()
      ..selectSalonOffer(
        salonServicePriceId: service.id,
        salonName: salon.salon.name,
        serviceName: service.name,
        price: (service.priceMin ?? 0).toDouble(),
        currency: service.currency,
        durationMinutes: service.durationMinutes ?? 60,
      );
    Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => const PickDateTimePage()),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: Text(service.name,
            style: theme.textTheme.titleLarge
                ?.copyWith(fontWeight: FontWeight.w700)),
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 120),
        children: [
          // Salon banner — keeps user anchored to the salon
          _SalonBanner(salon: salon),
          const SizedBox(height: 20),

          // Service title
          Text(service.name,
              style: theme.textTheme.headlineSmall
                  ?.copyWith(fontWeight: FontWeight.w800)),
          const SizedBox(height: 8),

          // Price + duration chips
          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: [
              _MetaChip(
                icon: Icons.payments_rounded,
                text: _priceText,
                color: scheme.primary,
              ),
              _MetaChip(
                icon: Icons.schedule_rounded,
                text: _durationText,
                color: scheme.secondary,
              ),
            ],
          ),
          const SizedBox(height: 24),

          if (service.stylists.isNotEmpty) ...[
            Text('Stylists',
                style: theme.textTheme.titleMedium
                    ?.copyWith(fontWeight: FontWeight.w800)),
            const SizedBox(height: 12),
            SizedBox(
              height: 110,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: service.stylists.length,
                separatorBuilder: (_, _) => const SizedBox(width: 12),
                itemBuilder: (_, i) => _StylistAvatar(
                  stylist: service.stylists[i],
                ),
              ),
            ),
            const SizedBox(height: 24),
          ],

          Text('About this service',
              style: theme.textTheme.titleMedium
                  ?.copyWith(fontWeight: FontWeight.w800)),
          const SizedBox(height: 8),
          Text(
            salon.salon.description.isNotEmpty
                ? salon.salon.description
                : 'No description provided by the salon.',
            style: theme.textTheme.bodyMedium
                ?.copyWith(color: scheme.onSurfaceVariant),
          ),
        ],
      ),
      bottomNavigationBar: SafeArea(
        minimum: const EdgeInsets.fromLTRB(16, 8, 16, 16),
        child: SizedBox(
          height: 54,
          child: FilledButton.icon(
            onPressed: () => _startBooking(context, ref),
            icon: const Icon(Icons.calendar_month_rounded),
            label: const Text(
              'Book Now',
              style: TextStyle(fontWeight: FontWeight.w800, fontSize: 16),
            ),
            style: FilledButton.styleFrom(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(999)),
            ),
          ),
        ),
      ),
    );
  }
}

class _SalonBanner extends StatelessWidget {
  final SalonViewProfileModel salon;
  const _SalonBanner({required this.salon});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: scheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 26,
            backgroundColor: scheme.surface,
            child: ClipOval(
              child: CachedNetworkImage(
                imageUrl: salon.salon.profilePicture,
                width: 52,
                height: 52,
                fit: BoxFit.cover,
                errorWidget: (_, _, _) => const Icon(Icons.store),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  salon.salon.name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w800,
                      ),
                ),
                if (salon.salon.slogan.isNotEmpty)
                  Text(
                    salon.salon.slogan,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: scheme.onSurfaceVariant,
                        ),
                  ),
              ],
            ),
          ),
          if (salon.salon.isVerified)
            const Icon(Icons.verified, color: Colors.blue, size: 22),
        ],
      ),
    );
  }
}

class _StylistAvatar extends StatelessWidget {
  final SalonServiceStylistModel stylist;
  const _StylistAvatar({required this.stylist});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 76,
      child: Column(
        children: [
          CircleAvatar(
            radius: 32,
            backgroundColor: Colors.grey.shade200,
            backgroundImage: stylist.avatar != null
                ? CachedNetworkImageProvider(stylist.avatar!)
                : null,
            child: stylist.avatar == null
                ? const Icon(Icons.person, size: 28)
                : null,
          ),
          const SizedBox(height: 6),
          Text(
            stylist.name,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.labelSmall,
          ),
        ],
      ),
    );
  }
}

class _MetaChip extends StatelessWidget {
  final IconData icon;
  final String text;
  final Color color;

  const _MetaChip({
    required this.icon,
    required this.text,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: color),
          const SizedBox(width: 6),
          Text(text,
              style: Theme.of(context).textTheme.labelMedium?.copyWith(
                    fontWeight: FontWeight.w700,
                  )),
        ],
      ),
    );
  }
}
