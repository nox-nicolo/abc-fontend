import 'package:flutter/material.dart';

class ServiceDetailsPage extends StatefulWidget {
  const ServiceDetailsPage({super.key});

  @override
  State<ServiceDetailsPage> createState() => _ServiceDetailsPageState();
}

class _ServiceDetailsPageState extends State<ServiceDetailsPage> {
  /// change this to test the two cases
  late ServiceDetailsModel data;

  /// keep track of current mode so refresh reloads same type
  bool _isMajorModeMock = true;

  @override
  void initState() {
    super.initState();

    /// major mode
    data = MockServiceDetails.majorMode();
    _isMajorModeMock = true;

    /// minor mode
    // data = MockServiceDetails.minorMode();
    // _isMajorModeMock = false;
  }

  Future<void> _onRefresh() async {
    await Future.delayed(const Duration(milliseconds: 700));

    setState(() {
      data = _isMajorModeMock
          ? MockServiceDetails.majorMode()
          : MockServiceDetails.minorMode();
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isMajorMode =
        data.minorServices != null && data.minorServices!.isNotEmpty;
    final isMinorMode = data.minorService != null;

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: false,
        title: Text(
          "Service Details",
          style: theme.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
      body: RefreshIndicator(
        onRefresh: _onRefresh,
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

                    if (isMajorMode) ...[
                      SectionHeader(
                        title: "Sub-services",
                        subtitle:
                            "${data.minorServices!.length} styles available",
                      ),
                      const SizedBox(height: 12),
                      SizedBox(
                        height: 190,
                        child: ListView.separated(
                          scrollDirection: Axis.horizontal,
                          itemCount: data.minorServices!.length,
                          separatorBuilder: (_, __) => const SizedBox(width: 14),
                          itemBuilder: (context, index) {
                            final item = data.minorServices![index];
                            return MinorServiceHorizontalCard(service: item);
                          },
                        ),
                      ),
                      const SizedBox(height: 24),
                    ],

                    if (isMinorMode) ...[
                      const SectionHeader(
                        title: "Selected service",
                        subtitle: "Specific service selected",
                      ),
                      const SizedBox(height: 12),
                      MinorServiceFocusedCard(service: data.minorService!),
                      const SizedBox(height: 24),
                    ],

                    SectionHeader(
                      title: "Salons",
                      subtitle:
                          "${data.salonDetails.length} salon${data.salonDetails.length == 1 ? '' : 's'} offering this service",
                    ),
                    const SizedBox(height: 12),
                  ],
                ),
              ),
            ),

            SliverPadding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 28),
              sliver: SliverList.separated(
                itemCount: data.salonDetails.length,
                separatorBuilder: (_, __) => const SizedBox(height: 14),
                itemBuilder: (context, index) {
                  final salon = data.salonDetails[index];
                  return SalonServiceCard(salon: salon);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class MajorServiceCard extends StatelessWidget {
  final MajorServiceModel service;

  const MajorServiceCard({
    super.key,
    required this.service,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      height: 240,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(28),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(.08),
            blurRadius: 24,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Stack(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(28),
            child: Image.network(
              service.image,
              width: double.infinity,
              height: double.infinity,
              fit: BoxFit.cover,
            ),
          ),
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(28),
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.black.withOpacity(.08),
                  Colors.black.withOpacity(.18),
                  Colors.black.withOpacity(.58),
                ],
              ),
            ),
          ),
          Positioned(
            top: 16,
            right: 16,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(.18),
                borderRadius: BorderRadius.circular(999),
                border: Border.all(color: Colors.white.withOpacity(.18)),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.star_rounded, size: 18, color: Colors.amber),
                  const SizedBox(width: 4),
                  Text(
                    service.rating.toStringAsFixed(1),
                    style: theme.textTheme.labelLarge?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
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
                  "Major Service",
                  style: theme.textTheme.labelLarge?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
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
}

class MinorServiceHorizontalCard extends StatelessWidget {
  final MinorServiceModel service;

  const MinorServiceHorizontalCard({
    super.key,
    required this.service,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      width: 150,
      decoration: BoxDecoration(
        color: theme.colorScheme.secondary.withOpacity(.2),
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(.05),
            blurRadius: 18,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(24),
        onTap: () {},
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(18),
                child: Image.network(
                  service.image,
                  height: 98,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                service.name,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: theme.textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
              ),
              const Spacer(),
              Row(
                children: [
                  const Icon(Icons.star_rounded, size: 18, color: Colors.amber),
                  const SizedBox(width: 4),
                  Text(
                    service.rating.toStringAsFixed(1),
                    style: theme.textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class MinorServiceFocusedCard extends StatelessWidget {
  final MinorServiceModel service;

  const MinorServiceFocusedCard({
    super.key,
    required this.service,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: theme.colorScheme.secondary.withOpacity(.2),
        borderRadius: BorderRadius.circular(26),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(.05),
            blurRadius: 18,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(18),
            child: Image.network(
              service.image,
              width: 98,
              height: 98,
              fit: BoxFit.cover,
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Minor Service",
                  style: theme.textTheme.labelLarge?.copyWith(
                    color: Colors.grey.shade500,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  service.name,
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    const Icon(Icons.star_rounded, size: 18, color: Colors.amber),
                    const SizedBox(width: 4),
                    Text(
                      service.rating.toStringAsFixed(1),
                      style: theme.textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    if (service.isEvent) ...[
                      const SizedBox(width: 10),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(999),
                        ),
                        child: Text(
                          "Event",
                          style: theme.textTheme.labelMedium?.copyWith(
                            color: const Color(0xFF7C3AED),
                            fontWeight: FontWeight.w700,
                          ),
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
}

class SalonServiceCard extends StatelessWidget {
  final SalonServiceModel salon;

  const SalonServiceCard({
    super.key,
    required this.salon,
  });

  String _formatPriceRange() {
    return "${salon.currency} ${salon.priceMax}";
  }

  String _formatDuration() {
    return "${salon.durationMinutes} mins";
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: theme.colorScheme.secondary.withOpacity(.1),
        borderRadius: BorderRadius.circular(26),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(.05),
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
            child: Image.network(
              salon.image,
              width: 104,
              height: 112,
              fit: BoxFit.cover,
            ),
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
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Icon(
                      Icons.location_on_rounded,
                      size: 18,
                      color: Colors.grey.shade600,
                    ),
                    const SizedBox(width: 4),
                    Expanded(
                      child: Text(
                        salon.city,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: Colors.grey.shade500,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    _MetaChip(
                      icon: Icons.star_rounded,
                      text: salon.rating.toStringAsFixed(1),
                    ),
                    _MetaChip(
                      icon: Icons.payments_rounded,
                      text: _formatPriceRange(),
                    ),
                    _MetaChip(
                      icon: Icons.schedule_rounded,
                      text: _formatDuration(),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                SizedBox(
                  height: 40,
                  child: FilledButton(
                    onPressed: () {},
                    style: FilledButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),
                    child: const Text("View salon"),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _MetaChip extends StatelessWidget {
  final IconData icon;
  final String text;

  const _MetaChip({
    required this.icon,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      decoration: BoxDecoration(
        color: theme.colorScheme.primary.withOpacity(0.1),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16),
          const SizedBox(width: 6),
          Text(
            text,
            style: theme.textTheme.labelLarge?.copyWith(
              fontWeight: FontWeight.w600,
            ),
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
          style: theme.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.w800,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          subtitle,
          style: theme.textTheme.bodyMedium?.copyWith(
            color: Colors.grey.shade700,
          ),
        ),
      ],
    );
  }
}

/* -------------------------------------------------------------------------- */
/*                                   MODELS                                   */
/* -------------------------------------------------------------------------- */

class ServiceDetailsModel {
  final MajorServiceModel majorService;
  final MinorServiceModel? minorService;
  final List<MinorServiceModel>? minorServices;
  final List<SalonServiceModel> salonDetails;

  const ServiceDetailsModel({
    required this.majorService,
    this.minorService,
    this.minorServices,
    required this.salonDetails,
  });
}

class MajorServiceModel {
  final String id;
  final String name;
  final String image;
  final double rating;

  const MajorServiceModel({
    required this.id,
    required this.name,
    required this.image,
    required this.rating,
  });
}

class MinorServiceModel {
  final String id;
  final String serviceId;
  final String name;
  final String image;
  final double rating;
  final bool isEvent;

  const MinorServiceModel({
    required this.id,
    required this.serviceId,
    required this.name,
    required this.image,
    required this.rating,
    required this.isEvent,
  });
}

class SalonServiceModel {
  final String salonId;
  final String name;
  final String image;
  final String city;
  final int priceMin;
  final int priceMax;
  final String currency;
  final int durationMinutes;
  final double rating;

  const SalonServiceModel({
    required this.salonId,
    required this.name,
    required this.image,
    required this.city,
    required this.priceMin,
    required this.priceMax,
    required this.currency,
    required this.durationMinutes,
    required this.rating,
  });
}

/* -------------------------------------------------------------------------- */
/*                                  MOCK DATA                                 */
/* -------------------------------------------------------------------------- */

class MockServiceDetails {
  static ServiceDetailsModel majorMode() {
    return ServiceDetailsModel(
      majorService: const MajorServiceModel(
        id: "major_1",
        name: "Braids",
        image:
            "https://images.unsplash.com/photo-1517841905240-472988babdf9?q=80&w=1200&auto=format&fit=crop",
        rating: 4.8,
      ),
      minorService: null,
      minorServices: const [
        MinorServiceModel(
          id: "minor_1",
          serviceId: "major_1",
          name: "Knotless Braids",
          image:
              "https://images.unsplash.com/photo-1524504388940-b1c1722653e1?q=80&w=1200&auto=format&fit=crop",
          rating: 4.7,
          isEvent: false,
        ),
        MinorServiceModel(
          id: "minor_2",
          serviceId: "major_1",
          name: "Box Braids",
          image:
              "https://images.unsplash.com/photo-1487412720507-e7ab37603c6f?q=80&w=1200&auto=format&fit=crop",
          rating: 4.6,
          isEvent: false,
        ),
        MinorServiceModel(
          id: "minor_3",
          serviceId: "major_1",
          name: "Cornrows",
          image:
              "https://images.unsplash.com/photo-1494790108377-be9c29b29330?q=80&w=1200&auto=format&fit=crop",
          rating: 4.5,
          isEvent: true,
        ),
      ],
      salonDetails: const [
        SalonServiceModel(
          salonId: "salon_1",
          name: "Nuru Beauty Lounge",
          image:
              "https://images.unsplash.com/photo-1521590832167-7bcbfaa6381f?q=80&w=1200&auto=format&fit=crop",
          city: "Dar es Salaam",
          priceMin: 25000,
          priceMax: 60000,
          currency: "TZS",
          durationMinutes: 180,
          rating: 4.7,
        ),
        SalonServiceModel(
          salonId: "salon_2",
          name: "Glow House Salon",
          image:
              "https://images.unsplash.com/photo-1560066984-138dadb4c035?q=80&w=1200&auto=format&fit=crop",
          city: "Arusha",
          priceMin: 30000,
          priceMax: 55000,
          currency: "TZS",
          durationMinutes: 150,
          rating: 4.6,
        ),
        SalonServiceModel(
          salonId: "salon_3",
          name: "Royal Touch Studio",
          image:
              "https://images.unsplash.com/photo-1522337360788-8b13dee7a37e?q=80&w=1200&auto=format&fit=crop",
          city: "Mwanza",
          priceMin: 20000,
          priceMax: 45000,
          currency: "TZS",
          durationMinutes: 120,
          rating: 4.5,
        ),
      ],
    );
  }

  static ServiceDetailsModel minorMode() {
    return ServiceDetailsModel(
      majorService: const MajorServiceModel(
        id: "major_1",
        name: "Braids",
        image:
            "https://images.unsplash.com/photo-1517841905240-472988babdf9?q=80&w=1200&auto=format&fit=crop",
        rating: 4.8,
      ),
      minorService: const MinorServiceModel(
        id: "minor_1",
        serviceId: "major_1",
        name: "Knotless Braids",
        image:
            "https://images.unsplash.com/photo-1524504388940-b1c1722653e1?q=80&w=1200&auto=format&fit=crop",
        rating: 4.7,
        isEvent: false,
      ),
      minorServices: null,
      salonDetails: const [
        SalonServiceModel(
          salonId: "salon_1",
          name: "Nuru Beauty Lounge",
          image:
              "https://images.unsplash.com/photo-1521590832167-7bcbfaa6381f?q=80&w=1200&auto=format&fit=crop",
          city: "Dar es Salaam",
          priceMin: 35000,
          priceMax: 60000,
          currency: "TZS",
          durationMinutes: 180,
          rating: 4.8,
        ),
        SalonServiceModel(
          salonId: "salon_2",
          name: "Glow House Salon",
          image:
              "https://images.unsplash.com/photo-1560066984-138dadb4c035?q=80&w=1200&auto=format&fit=crop",
          city: "Dodoma",
          priceMin: 32000,
          priceMax: 52000,
          currency: "TZS",
          durationMinutes: 170,
          rating: 4.6,
        ),
      ],
    );
  }
}