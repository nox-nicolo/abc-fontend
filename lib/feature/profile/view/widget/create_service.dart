import 'package:africa_beuty/feature/profile/view/widget/config_service.dart';
import 'package:flutter/material.dart';

class SelectServicePage extends StatefulWidget {
  const SelectServicePage({super.key});

  @override
  State<SelectServicePage> createState() => _SelectServicePageState();
}

class _SelectServicePageState extends State<SelectServicePage> {
  final TextEditingController _searchController = TextEditingController();

  final List<_ServiceItem> trendingServices = const [
    _ServiceItem("Haircut", "Hair"),
    _ServiceItem("Gel Manicure", "Nails"),
    _ServiceItem("Knotless Braids", "Braiding"),
    _ServiceItem("Beard Trim", "Barbering"),
  ];

  final List<_ServiceItem> mostUsedServices = const [
    _ServiceItem("Blow Dry", "Hair"),
    _ServiceItem("Acrylic Nails", "Nails"),
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Add Service"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // 🔍 Search
            TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: "Search service",
                prefixIcon: const Icon(Icons.search),
                filled: true,
                fillColor: theme.colorScheme.surfaceContainerHighest,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                  borderSide: BorderSide.none,
                ),
              ),
            ),

            const SizedBox(height: 24),

            // 🔥 Trending
            _SectionHeader(title: "Trending Services"),
            const SizedBox(height: 12),
            _ServiceList(
              services: trendingServices,
              onTap: _openConfiguration,
            ),

            const SizedBox(height: 24),

            // 📍 Most Used
            _SectionHeader(title: "Most Used by You"),
            const SizedBox(height: 12),
            _ServiceList(
              services: mostUsedServices,
              onTap: _openConfiguration,
            ),
          ],
        ),
      ),
    );
  }

  void _openConfiguration(_ServiceItem service) {
    Navigator.of(context).push(
  MaterialPageRoute(
    builder: (_) => ConfigureServicePage(
      serviceName: service.name,
      category: service.category,
      imageUrl: "https://images.unsplash.com/photo-1522335789203-aabd1fc54bc9",
    ),
  ),
);
  }
}

/* ───────────────────────── Widgets ───────────────────────── */

class _SectionHeader extends StatelessWidget {
  final String title;

  const _SectionHeader({required this.title});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Align(
      alignment: Alignment.centerLeft,
      child: Text(
        title,
        style: theme.textTheme.titleMedium?.copyWith(
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}

class _ServiceList extends StatelessWidget {
  final List<_ServiceItem> services;
  final Function(_ServiceItem) onTap;

  const _ServiceList({
    required this.services,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: services.map((service) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: Material(
            color: Theme.of(context).colorScheme.surfaceContainerHighest,
            borderRadius: BorderRadius.circular(16),
            child: InkWell(
              borderRadius: BorderRadius.circular(16),
              onTap: () => onTap(service),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    CircleAvatar(
                      backgroundColor:
                          Theme.of(context).colorScheme.primaryContainer,
                      child: Icon(
                        Icons.cut,
                        color: Theme.of(context).colorScheme.onPrimaryContainer,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            service.name,
                            style: Theme.of(context)
                                .textTheme
                                .titleSmall
                                ?.copyWith(fontWeight: FontWeight.w600),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            service.category,
                            style: Theme.of(context)
                                .textTheme
                                .bodySmall
                                ?.copyWith(
                                  color: Theme.of(context)
                                      .colorScheme
                                      .onSurfaceVariant,
                                ),
                          ),
                        ],
                      ),
                    ),
                    const Icon(Icons.chevron_right),
                  ],
                ),
              ),
            ),
          ),
        );
      }).toList(),
    );
  }
}

/* ───────────────────────── Models ───────────────────────── */

class _ServiceItem {
  final String name;
  final String category;

  const _ServiceItem(this.name, this.category);
}
