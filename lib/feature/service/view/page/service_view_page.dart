import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:africa_beuty/core/constants/server_constants.dart';
import 'package:africa_beuty/core/failure/failure.dart';
import 'package:africa_beuty/core/http/api_client.dart';
import 'package:africa_beuty/feature/booking/provider/booking_draft.dart';
import 'package:africa_beuty/feature/booking/view/widgets/start_booking/select_time.dart';
import 'package:africa_beuty/feature/profile/view/page/view_profile.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'service_view_page.g.dart';

// ─────────────────────────────────────────────────────────────────────────────
// Models
// ─────────────────────────────────────────────────────────────────────────────

class MajorServiceModel {
  final String id;
  final String name;
  final String? image;
  final double? rating;

  const MajorServiceModel({
    required this.id,
    required this.name,
    this.image,
    this.rating,
  });

  factory MajorServiceModel.fromMap(Map<String, dynamic> m) => MajorServiceModel(
        id: m['id'] as String,
        name: m['name'] as String? ?? '',
        image: m['image'] as String?,
        rating: (m['rating'] as num?)?.toDouble(),
      );
}

class MinorServiceModel {
  final String id;
  final String serviceId;
  final String name;
  final String? image;
  final double? rating;
  final bool isEvent;

  const MinorServiceModel({
    required this.id,
    required this.serviceId,
    required this.name,
    this.image,
    this.rating,
    this.isEvent = false,
  });

  factory MinorServiceModel.fromMap(Map<String, dynamic> m) => MinorServiceModel(
        id: m['id'] as String,
        serviceId: m['service_id'] as String? ?? '',
        name: m['name'] as String? ?? '',
        image: m['image'] as String?,
        rating: (m['rating'] as num?)?.toDouble(),
        isEvent: m['is_event'] as bool? ?? false,
      );
}

class SalonServiceModel {
  final String salonId;
  final String name;
  final String? image;
  final String? city;
  final int? priceMin;
  final int? priceMax;
  final String? currency;
  final int? durationMinutes;
  final double? rating;
  // Present only in minor-service mode — used for direct booking
  final String? salonServicePriceId;

  const SalonServiceModel({
    required this.salonId,
    required this.name,
    this.image,
    this.city,
    this.priceMin,
    this.priceMax,
    this.currency,
    this.durationMinutes,
    this.rating,
    this.salonServicePriceId,
  });

  factory SalonServiceModel.fromMap(Map<String, dynamic> m) => SalonServiceModel(
        salonId: m['salon_id'] as String,
        name: m['salon_name'] as String? ?? '',
        image: m['salon_image'] as String?,
        city: m['salon_city'] as String?,
        priceMin: m['price_min'] as int?,
        priceMax: m['price_max'] as int?,
        currency: m['currency'] as String?,
        durationMinutes: m['duration_minutes'] as int?,
        rating: (m['rating'] as num?)?.toDouble(),
        salonServicePriceId: m['salon_service_price_id'] as String?,
      );
}

class ServiceDetailsData {
  final MajorServiceModel majorService;
  final MinorServiceModel? minorService;       // non-null → minor mode
  final List<MinorServiceModel>? minorServices; // non-null → major mode
  final List<SalonServiceModel> salonDetails;

  const ServiceDetailsData({
    required this.majorService,
    this.minorService,
    this.minorServices,
    required this.salonDetails,
  });

  bool get isMajorMode => minorServices != null && minorServices!.isNotEmpty;

  factory ServiceDetailsData.fromMap(Map<String, dynamic> m) => ServiceDetailsData(
        majorService: MajorServiceModel.fromMap(m['major_service'] as Map<String, dynamic>),
        minorService: m['minor_service'] != null
            ? MinorServiceModel.fromMap(m['minor_service'] as Map<String, dynamic>)
            : null,
        minorServices: (m['minor_services'] as List?)
            ?.map((e) => MinorServiceModel.fromMap(e as Map<String, dynamic>))
            .toList(),
        salonDetails: (m['salon_details'] as List?)
                ?.map((e) => SalonServiceModel.fromMap(e as Map<String, dynamic>))
                .toList() ??
            [],
      );
}

// ─────────────────────────────────────────────────────────────────────────────
// Repository
// ─────────────────────────────────────────────────────────────────────────────

class ServiceDetailsRepository {
  Future<Either<AppFailure, ServiceDetailsData>> fetch(String serviceId) async {
    try {
      final uri = Uri.parse(
          '${ServerConstants.serverUrl}/services/$serviceId/details');
      final response = await ApiClient.instance
          .get(uri)
          .timeout(const Duration(seconds: 15));

      if (response.statusCode == 200) {
        final map = jsonDecode(response.body) as Map<String, dynamic>;
        return Right(ServiceDetailsData.fromMap(map));
      }
      final body = _safeDecode(response.body);
      return Left(AppFailure(body?['detail'] ?? 'Failed to load service'));
    } on SocketException {
      return Left(AppFailure('No internet connection'));
    } on TimeoutException {
      return Left(AppFailure('Request timed out'));
    } on SessionExpiredException catch (e) {
      return Left(AppFailure(e.toString()));
    } catch (e) {
      return Left(AppFailure(e.toString()));
    }
  }

  Map<String, dynamic>? _safeDecode(String body) {
    try {
      return jsonDecode(body) as Map<String, dynamic>;
    } catch (_) {
      return null;
    }
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Provider
// ─────────────────────────────────────────────────────────────────────────────

@riverpod
Future<ServiceDetailsData> serviceDetails(
  Ref ref,
  String serviceId,
) async {
  final result = await ServiceDetailsRepository().fetch(serviceId);
  return result.fold((l) => throw l.message, (r) => r);
}

// ─────────────────────────────────────────────────────────────────────────────
// Page
// ─────────────────────────────────────────────────────────────────────────────

class ServiceDetailsPage extends ConsumerWidget {
  final String serviceId;

  const ServiceDetailsPage({super.key, required this.serviceId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final async = ref.watch(serviceDetailsProvider(serviceId));
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: false,
        title: Text(
          'Service Details',
          style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w700),
        ),
      ),
      body: async.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.error_outline, size: 48, color: Colors.grey),
                const SizedBox(height: 12),
                Text(e.toString(), textAlign: TextAlign.center),
                const SizedBox(height: 16),
                FilledButton(
                  onPressed: () => ref.invalidate(serviceDetailsProvider(serviceId)),
                  child: const Text('Retry'),
                ),
              ],
            ),
          ),
        ),
        data: (data) => _ServiceDetailsBody(data: data),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Body
// ─────────────────────────────────────────────────────────────────────────────

class _ServiceDetailsBody extends StatelessWidget {
  final ServiceDetailsData data;
  const _ServiceDetailsBody({required this.data});

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () async {},
      child: CustomScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        slivers: [
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  MajorServiceCard(service: data.majorService),
                  const SizedBox(height: 20),

                  // ── MAJOR mode: horizontal list of minor services ──────────
                  if (data.isMajorMode) ...[
                    SectionHeader(
                      title: 'Sub-services',
                      subtitle: '${data.minorServices!.length} styles available',
                    ),
                    const SizedBox(height: 12),
                    SizedBox(
                      height: 190,
                      child: ListView.separated(
                        scrollDirection: Axis.horizontal,
                        itemCount: data.minorServices!.length,
                        separatorBuilder: (_, _) => const SizedBox(width: 14),
                        itemBuilder: (context, i) {
                          final item = data.minorServices![i];
                          return MinorServiceHorizontalCard(
                            service: item,
                            onTap: () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) =>
                                    ServiceDetailsPage(serviceId: item.id),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    const SizedBox(height: 24),
                  ],

                  // ── MINOR mode: focused card ───────────────────────────────
                  if (data.minorService != null) ...[
                    const SectionHeader(
                      title: 'Selected service',
                      subtitle: 'Specific service selected',
                    ),
                    const SizedBox(height: 12),
                    MinorServiceFocusedCard(service: data.minorService!),
                    const SizedBox(height: 24),
                  ],

                  SectionHeader(
                    title: 'Salons',
                    subtitle:
                        '${data.salonDetails.length} salon${data.salonDetails.length == 1 ? '' : 's'} offering this',
                  ),
                  const SizedBox(height: 12),
                ],
              ),
            ),
          ),

          // ── Salon list ─────────────────────────────────────────────────────
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 28),
            sliver: SliverList.separated(
              itemCount: data.salonDetails.length,
              separatorBuilder: (_, _) => const SizedBox(height: 14),
              itemBuilder: (context, i) =>
                  SalonServiceCard(salon: data.salonDetails[i]),
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Widgets
// ─────────────────────────────────────────────────────────────────────────────

class MajorServiceCard extends StatelessWidget {
  final MajorServiceModel service;
  const MajorServiceCard({super.key, required this.service});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      height: 240,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(28),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: .08),
            blurRadius: 24,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Stack(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(28),
            child: service.image != null
                ? CachedNetworkImage(
                    imageUrl: service.image!,
                    width: double.infinity,
                    height: double.infinity,
                    fit: BoxFit.cover,
                    errorWidget: (ctx, url, err) => _imageFallback(),
                  )
                : _imageFallback(),
          ),
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(28),
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.black.withValues(alpha: .08),
                  Colors.black.withValues(alpha: .58),
                ],
              ),
            ),
          ),
          if (service.rating != null)
            Positioned(
              top: 16,
              right: 16,
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: .18),
                  borderRadius: BorderRadius.circular(999),
                  border:
                      Border.all(color: Colors.white.withValues(alpha: .18)),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.star_rounded,
                        size: 18, color: Colors.amber),
                    const SizedBox(width: 4),
                    Text(
                      service.rating!.toStringAsFixed(1),
                      style: theme.textTheme.labelLarge
                          ?.copyWith(fontWeight: FontWeight.w700),
                    ),
                  ],
                ),
              ),
            ),
          Positioned(
            left: 18,
            right: 18,
            bottom: 18,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Major Service',
                  style: theme.textTheme.labelLarge
                      ?.copyWith(fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 6),
                Text(
                  service.name,
                  style: theme.textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.w800,
                    height: 1.05,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _imageFallback() => Container(
        color: Colors.grey.shade300,
        child: const Center(child: Icon(Icons.design_services, size: 48)),
      );
}

class MinorServiceHorizontalCard extends StatelessWidget {
  final MinorServiceModel service;
  final VoidCallback? onTap;

  const MinorServiceHorizontalCard({
    super.key,
    required this.service,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      width: 150,
      decoration: BoxDecoration(
        color: theme.colorScheme.secondary.withValues(alpha: .2),
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: .05),
            blurRadius: 18,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(24),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(18),
                child: service.image != null
                    ? CachedNetworkImage(
                        imageUrl: service.image!,
                        height: 98,
                        width: double.infinity,
                        fit: BoxFit.cover,
                        errorWidget: (ctx, url, err) => _imgFallback(),
                      )
                    : _imgFallback(),
              ),
              const SizedBox(height: 10),
              Text(
                service.name,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: theme.textTheme.titleSmall
                    ?.copyWith(fontWeight: FontWeight.w700),
              ),
              const Spacer(),
              if (service.rating != null)
                Row(
                  children: [
                    const Icon(Icons.star_rounded,
                        size: 18, color: Colors.amber),
                    const SizedBox(width: 4),
                    Text(
                      service.rating!.toStringAsFixed(1),
                      style: theme.textTheme.bodyMedium
                          ?.copyWith(fontWeight: FontWeight.w600),
                    ),
                  ],
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _imgFallback() => Container(
        height: 98,
        color: Colors.grey.shade300,
        child: const Center(child: Icon(Icons.spa)),
      );
}

class MinorServiceFocusedCard extends StatelessWidget {
  final MinorServiceModel service;
  const MinorServiceFocusedCard({super.key, required this.service});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: theme.colorScheme.secondary.withValues(alpha: .2),
        borderRadius: BorderRadius.circular(26),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: .05),
            blurRadius: 18,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(18),
            child: service.image != null
                ? CachedNetworkImage(
                    imageUrl: service.image!,
                    width: 98,
                    height: 98,
                    fit: BoxFit.cover,
                    errorWidget: (ctx, url, err) => _imgFallback(),
                  )
                : _imgFallback(),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Minor Service',
                  style: theme.textTheme.labelLarge?.copyWith(
                    color: Colors.grey.shade500,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  service.name,
                  style: theme.textTheme.titleMedium
                      ?.copyWith(fontWeight: FontWeight.w800),
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    if (service.rating != null) ...[
                      const Icon(Icons.star_rounded,
                          size: 18, color: Colors.amber),
                      const SizedBox(width: 4),
                      Text(
                        service.rating!.toStringAsFixed(1),
                        style: theme.textTheme.bodyMedium
                            ?.copyWith(fontWeight: FontWeight.w700),
                      ),
                    ],
                    if (service.isEvent) ...[
                      const SizedBox(width: 10),
                      Text(
                        'Event',
                        style: theme.textTheme.labelMedium?.copyWith(
                          color: const Color(0xFF7C3AED),
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _imgFallback() => Container(
        width: 98,
        height: 98,
        color: Colors.grey.shade300,
        child: const Center(child: Icon(Icons.spa)),
      );
}

class SalonServiceCard extends ConsumerWidget {
  final SalonServiceModel salon;
  const SalonServiceCard({super.key, required this.salon});

  String get _priceText {
    if (salon.priceMax != null && salon.currency != null) {
      return '${salon.currency} ${salon.priceMax}';
    }
    if (salon.priceMin != null && salon.currency != null) {
      return 'From ${salon.currency} ${salon.priceMin}';
    }
    return 'Price on request';
  }

  String get _durationText =>
      salon.durationMinutes != null ? '${salon.durationMinutes} mins' : '–';

  void _book(BuildContext context, WidgetRef ref) {
    ref.read(bookingDraftProvider.notifier)
      ..reset()
      ..selectSalonOffer(
        salonServicePriceId: salon.salonServicePriceId!,
        salonName: salon.name,
        price: (salon.priceMin ?? 0).toDouble(),
        currency: salon.currency ?? '',
        durationMinutes: salon.durationMinutes ?? 60,
      );
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const PickDateTimePage()),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final canBook = salon.salonServicePriceId != null;

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: scheme.secondary.withValues(alpha: .1),
        borderRadius: BorderRadius.circular(26),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: .05),
            blurRadius: 18,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(18),
            child: salon.image != null
                ? CachedNetworkImage(
                    imageUrl: salon.image!,
                    width: 104,
                    height: 112,
                    fit: BoxFit.cover,
                    errorWidget: (ctx, url, err) => _imgFallback(),
                  )
                : _imgFallback(),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  salon.name,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: theme.textTheme.titleMedium
                      ?.copyWith(fontWeight: FontWeight.w800),
                ),
                const SizedBox(height: 8),
                if (salon.city != null)
                  Row(
                    children: [
                      Icon(Icons.location_on_rounded,
                          size: 18, color: Colors.grey.shade600),
                      const SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          salon.city!,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: theme.textTheme.bodyMedium
                              ?.copyWith(color: Colors.grey.shade500),
                        ),
                      ),
                    ],
                  ),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    if (salon.rating != null)
                      _MetaChip(
                          icon: Icons.star_rounded,
                          text: salon.rating!.toStringAsFixed(1)),
                    _MetaChip(
                        icon: Icons.payments_rounded, text: _priceText),
                    _MetaChip(
                        icon: Icons.schedule_rounded, text: _durationText),
                  ],
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    // View salon always available
                    Expanded(
                      child: SizedBox(
                        height: 40,
                        child: canBook
                            ? FilledButton.tonal(
                                onPressed: () => Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => ViewProfilePage(
                                      isServiceProfile: true,
                                      userId: salon.salonId,
                                    ),
                                  ),
                                ),
                                style: FilledButton.styleFrom(
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(14)),
                                ),
                                child: const Text('View salon'),
                              )
                            : FilledButton(
                                onPressed: () => Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => ViewProfilePage(
                                      isServiceProfile: true,
                                      userId: salon.salonId,
                                    ),
                                  ),
                                ),
                                style: FilledButton.styleFrom(
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(14)),
                                ),
                                child: const Text('View salon'),
                              ),
                      ),
                    ),
                    // Book button — only when salonServicePriceId is known
                    if (canBook) ...[
                      const SizedBox(width: 8),
                      SizedBox(
                        height: 40,
                        child: FilledButton(
                          onPressed: () => _book(context, ref),
                          style: FilledButton.styleFrom(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(14)),
                          ),
                          child: const Text('Book'),
                        ),
                      ),
                    ],
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _imgFallback() => Container(
        width: 104,
        height: 112,
        color: Colors.grey.shade300,
        child: const Center(child: Icon(Icons.store, size: 36)),
      );
}

class _MetaChip extends StatelessWidget {
  final IconData icon;
  final String text;
  const _MetaChip({required this.icon, required this.text});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      decoration: BoxDecoration(
        color: theme.colorScheme.primary.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16),
          const SizedBox(width: 6),
          Text(
            text,
            style: theme.textTheme.labelLarge
                ?.copyWith(fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );
  }
}

class SectionHeader extends StatelessWidget {
  final String title;
  final String subtitle;
  const SectionHeader({
    super.key,
    required this.title,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: theme.textTheme.titleLarge
              ?.copyWith(fontWeight: FontWeight.w800),
        ),
        const SizedBox(height: 4),
        Text(
          subtitle,
          style: theme.textTheme.bodyMedium
              ?.copyWith(color: Colors.grey.shade700),
        ),
      ],
    );
  }
}
