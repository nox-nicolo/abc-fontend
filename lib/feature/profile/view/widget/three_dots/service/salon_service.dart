
import 'package:africa_beuty/feature/profile/model/three_dots/services/service.dart';
import 'package:africa_beuty/feature/profile/view/widget/three_dots/service/salon_service_create.dart';
import 'package:africa_beuty/feature/profile/view_model/service/service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SelectServicePage extends ConsumerStatefulWidget {
  const SelectServicePage({super.key});

  @override
  ConsumerState<SelectServicePage> createState() =>
      _SelectServicePageState();
}

class _SelectServicePageState extends ConsumerState<SelectServicePage> {
  final TextEditingController _searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final state = ref.watch(salonServicesViewModelProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Salon Services"),
        elevation: 0,
      ),
      body: state.when(
        loading: () => const Center(
          child: CircularProgressIndicator(),
        ),
        error: (e, _) => Center(
          child: Text(e.toString()),
        ),
        data: (services) {
          // SAME UI LOGIC: split configured vs available
          final myServices =
            services.where((e) => e.salonServicePriceId != null).toList();

          final availableServices =
            services.where((e) => e.salonServicePriceId == null).toList();


          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              // 🔍 Search Field (BACKEND-DRIVEN)
              TextField(
                controller: _searchController,
                onChanged: (value) {
                  ref
                      .read(salonServicesViewModelProvider.notifier)
                      .search(value);
                },
                decoration: InputDecoration(
                  hintText: "Search your services...",
                  prefixIcon: const Icon(Icons.search),
                  filled: true,
                  fillColor: theme.colorScheme.surfaceContainerHighest,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),

              const SizedBox(height: 24),

              // ===============================
              // ACTIVE SERVICES
              // ===============================
              if (myServices.isNotEmpty) ...[
                _SectionHeader(
                  title: "My Active Services",
                  count: myServices.length,
                ),
                const SizedBox(height: 16),
                SizedBox(
                  height: 240,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: myServices.length,
                    itemBuilder: (context, index) {
                      return _ConfiguredServiceCard(
                        service: myServices[index],
                        onTap: () =>
                            _openConfiguration(myServices[index]),
                      );
                    },
                  ),
                ),
                const SizedBox(height: 32),
              ],

              // ===============================
              // AVAILABLE SERVICES
              // ===============================
              _SectionHeader(
                title: "Available to Configure",
                count: availableServices.length,
              ),
              const SizedBox(height: 12),
              _ServiceList(
                services: availableServices,
                onTap: _openConfiguration,
              ),
            ],
          );
        },
      ),
    );
  }

  void _openConfiguration(SalonServiceItemModel service) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => ConfigureServicePage(
          // SAME mapping as before, just correct fields
          serviceId: service.serviceId,
          subServiceId: service.subServiceId, 
          serviceName: service.serviceName, 
          serviceImage: service.serviceImage, 
          subServiceName: service.subServiceName, 
          subServiceImage: service.serviceImage,
        ),
      ),
    );
  }
}

/* ───────────────────────── Components ───────────────────────── */

class _SectionHeader extends StatelessWidget {
  final String title;
  final int count;

  const _SectionHeader({
    required this.title,
    required this.count,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: theme.textTheme.titleMedium
              ?.copyWith(fontWeight: FontWeight.bold),
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
          decoration: BoxDecoration(
            color: theme.colorScheme.primary.withOpacity(0.1),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Text(
            "$count",
            style: TextStyle(
              color: theme.colorScheme.primary,
              fontSize: 12,
            ),
          ),
        ),
      ],
    );
  }
}

class _ConfiguredServiceCard extends StatelessWidget {
  final SalonServiceItemModel service;
  final VoidCallback onTap;

  const _ConfiguredServiceCard({
    required this.service,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.only(right: 16),
      child: GestureDetector(
        onTap: onTap,
        child: SizedBox(
          width: 160,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Large Service Image
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      )
                    ],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: Stack(
                      children: [
                        Image.network(
                          service.serviceImage,
                          width: double.infinity,
                          height: double.infinity,
                          fit: BoxFit.cover,
                          errorBuilder: (_, __, ___) => Container(
                            color: theme.colorScheme.surfaceContainerHighest,
                            child: const Icon(Icons.broken_image),
                          ),
                        ),
                        // "Active" Badge Overlay
                        const Positioned(
                          top: 8,
                          right: 8,
                          child: CircleAvatar(
                            radius: 12,
                            backgroundColor: Colors.green,
                            child: Icon(Icons.check,
                                size: 14, color: Colors.white),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 10),

              // Names
              Text(
                service.subServiceName,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: theme.textTheme.titleSmall
                    ?.copyWith(fontWeight: FontWeight.bold),
              ),
              Text(
                service.serviceName,
                style: theme.textTheme.bodySmall
                    ?.copyWith(color: theme.colorScheme.secondary),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ServiceList extends StatelessWidget {
  final List<SalonServiceItemModel> services;
  final Function(SalonServiceItemModel) onTap;

  const _ServiceList({
    required this.services,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      children: services.map((service) {
        return Card(
          elevation: 0,
          margin: const EdgeInsets.only(bottom: 12),
          color: theme.colorScheme.surfaceContainerHighest.withOpacity(0.5),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
            side: service.isConfigured
                ? BorderSide(
                    color: theme.colorScheme.primary.withOpacity(0.2))
                : BorderSide.none,
          ),
          child: InkWell(
            borderRadius: BorderRadius.circular(16),
            onTap: () => onTap(service),
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Row(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.network(
                      service.serviceImage,
                      width: 56,
                      height: 56,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => Container(
                        width: 56,
                        height: 56,
                        color: Colors.grey[300],
                        child: const Icon(Icons.image_not_supported),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          service.subServiceName,
                          style: theme.textTheme.titleSmall
                              ?.copyWith(fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          service.serviceName,
                          style: theme.textTheme.bodySmall,
                        ),
                      ],
                    ),
                  ),
                  if (service.isConfigured)
                    const Icon(Icons.check_circle,
                        color: Colors.green, size: 20)
                  else
                    Icon(Icons.add_circle_outline,
                        color: theme.colorScheme.primary, size: 20),
                ],
              ),
            ),
          ),
        );
      }).toList(),
    );
  }
}