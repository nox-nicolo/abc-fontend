import 'package:africa_beuty/feature/profile/model/config_service_salon.dart';
import 'package:africa_beuty/feature/profile/model/config_service_update_create.dart';
import 'package:africa_beuty/feature/profile/view_model/config_service_salon.dart';
import 'package:africa_beuty/feature/profile/view_model/config_service_update_create.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ConfigureServicePage extends ConsumerStatefulWidget {
  final String serviceId;
  final String subServiceId;

  const ConfigureServicePage({
    super.key,
    required this.serviceId,
    required this.subServiceId,
  });

  @override
  ConsumerState<ConfigureServicePage> createState() =>
      _ConfigureServicePageState();
}

class _ConfigureServicePageState extends ConsumerState<ConfigureServicePage> {
  // Form state (filled from API)
  int duration = 60; // minutes
  double minPrice = 0;
  double maxPrice = 0;
  bool isActive = true;

  // Currency (UI only; backend value maps to this)
  final List<_Currency> currencies = const [
    _Currency(code: "TZS", symbol: "TSh", name: "Tanzanian Shilling"),
    _Currency(code: "KES", symbol: "KSh", name: "Kenyan Shilling"),
    _Currency(code: "UGX", symbol: "USh", name: "Ugandan Shilling"),
    _Currency(code: "USD", symbol: "\$", name: "US Dollar"),
  ];

  late _Currency selectedCurrency;

  // Benefits / Products (prefill from config, then editable locally)
  List<ServiceProduct> selectedProducts = [];
  List<ServiceBenefit> selectedBenefits = [];

  // Stylists mock UI (IDs are real)
  final TextEditingController _stylistSearch = TextEditingController();

  late final List<_Stylist> allStylists = const [
    _Stylist(
      id: "44075850-3047-4efa-9750-6df79a823939",
      name: "Sarah M.",
      avatarUrl: "https://i.pravatar.cc/150?img=1",
    ),
    _Stylist(
      id: "62b7b46e-61bc-498c-8e23-5683dff54f5b",
      name: "Michael K.",
      avatarUrl: "https://i.pravatar.cc/150?img=2",
    ),
    _Stylist(
      id: "27e25454-1430-437c-b6d4-2ecb16f180a7",
      name: "Aisha L.",
      avatarUrl: "https://i.pravatar.cc/150?img=3",
    ),
    _Stylist(
      id: "8dbdba9f-3a7f-4bad-80ac-da07357f4c0c",
      name: "John D.",
      avatarUrl: "https://i.pravatar.cc/150?img=4",
    ),
  ];

  final Set<_Stylist> selectedStylists = {};

  bool _didInitFromApi = false;


  @override
  void initState() {
    super.initState();
    selectedCurrency = currencies.first;

    ref.listen(
      configServiceUpdateCreateViewModelProvider,
      (previous, next) {
        next.whenOrNull(
          data: (_) {
            
            _didInitFromApi = false;

            // Force re-fetch of fresh backend data
            ref.invalidate(
              salonServiceConfigDetailViewModelProvider(
                serviceId: widget.serviceId,
                subServiceId: widget.subServiceId,
              ),
            );

            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text("Service saved successfully")),
            );
          },
          error: (e, _) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(e.toString())),
            );
          },
        );
      },
    );
  }


  @override
  void dispose() {
    _stylistSearch.dispose();
    super.dispose();
  }

  // ----------------------------------------------------------
  // Prefill form from API once
  // ----------------------------------------------------------
  void _initFromApiOnce(SalonServiceConfigModel model) {
    if (_didInitFromApi) return;
    _didInitFromApi = true;

    final cfg = model.config;

    setState(() {
      // If configured, prefill from config; else keep defaults
      duration = cfg?.durationMinutes ?? 60;

      minPrice = (cfg?.priceMin ?? 0).toDouble();
      maxPrice = (cfg?.priceMax ?? 0).toDouble();

      final currencyCode = cfg?.currency;
      selectedCurrency = currencies.firstWhere(
        (c) => c.code == currencyCode,
        orElse: () => currencies.first,
      );

      isActive = (cfg?.status ?? "active") == "active";

      // Benefits
      selectedBenefits = (cfg?.benefits ?? [])
          .map(
            (b) => ServiceBenefit(
              text: b.benefit,
              position: b.position,
            ),
          )
          .toList()
        ..sort((a, b) => a.position.compareTo(b.position));

      // Products
      selectedProducts = (cfg?.products ?? [])
          .map(
            (p) => ServiceProduct(
              name: p.productName,
              brand: p.brand,
            ),
          )
          .toList();

      // Stylists selected (mock list → only select those IDs that exist in mock)
      selectedStylists.clear();
      final ids = cfg?.stylistIds ?? const <String>[];
      for (final s in allStylists) {
        if (ids.contains(s.id)) selectedStylists.add(s);
      }
    });
  }

  // ----------------------------------------------------------
  // Benefits Bottom Sheet
  // ----------------------------------------------------------
  void _showAddBenefitBottomSheet() {
    final TextEditingController benefitController = TextEditingController();
    final TextEditingController positionController = TextEditingController();
    final theme = Theme.of(context);

    positionController.text = (selectedBenefits.length + 1).toString();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: theme.colorScheme.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
      ),
      builder: (context) => Padding(
        padding: EdgeInsets.only(
          left: 20,
          right: 20,
          top: 10,
          bottom: MediaQuery.of(context).viewInsets.bottom + 20,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 40,
                height: 4,
                margin: const EdgeInsets.only(bottom: 20),
                decoration: BoxDecoration(
                  color: theme.colorScheme.outlineVariant,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            Text("Add Service Benefit", style: theme.textTheme.headlineSmall),
            const SizedBox(height: 20),
            TextField(
              controller: benefitController,
              autofocus: true,
              maxLines: 2,
              decoration: InputDecoration(
                labelText: "Benefit Description",
                hintText: "e.g. Promotes natural hair growth",
                filled: true,
                fillColor: theme.colorScheme.surfaceContainerHighest,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: positionController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: "Display Position",
                prefixIcon: const Icon(Icons.format_list_numbered),
                filled: true,
                fillColor: theme.colorScheme.surfaceContainerHighest,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: FilledButton(
                onPressed: () {
                  if (benefitController.text.trim().isNotEmpty) {
                    setState(() {
                      selectedBenefits.add(
                        ServiceBenefit(
                          text: benefitController.text.trim(),
                          position: int.tryParse(positionController.text) ?? 1,
                        ),
                      );
                      selectedBenefits.sort(
                        (a, b) => a.position.compareTo(b.position),
                      );
                    });
                    Navigator.pop(context);
                  }
                },
                child: const Text("Add Benefit"),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ----------------------------------------------------------
  // Product Bottom Sheet
  // ----------------------------------------------------------
  void _showAddProductBottomSheet() {
    final TextEditingController nameController = TextEditingController();
    final TextEditingController brandController = TextEditingController();
    final theme = Theme.of(context);

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: theme.colorScheme.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
      ),
      builder: (context) => Padding(
        padding: EdgeInsets.only(
          left: 20,
          right: 20,
          top: 10,
          bottom: MediaQuery.of(context).viewInsets.bottom + 20,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 40,
                height: 4,
                margin: const EdgeInsets.only(bottom: 20),
                decoration: BoxDecoration(
                  color: theme.colorScheme.outlineVariant,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            Text("Add Product", style: theme.textTheme.headlineSmall),
            const SizedBox(height: 20),
            TextField(
              controller: nameController,
              autofocus: true,
              decoration: InputDecoration(
                labelText: "Product Name",
                prefixIcon: const Icon(Icons.inventory_2_outlined),
                filled: true,
                fillColor: theme.colorScheme.surfaceContainerHighest,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: brandController,
              decoration: InputDecoration(
                labelText: "Brand / Manufacturer",
                prefixIcon: const Icon(Icons.branding_watermark_outlined),
                filled: true,
                fillColor: theme.colorScheme.surfaceContainerHighest,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: FilledButton(
                onPressed: () {
                  if (nameController.text.trim().isNotEmpty &&
                      brandController.text.trim().isNotEmpty) {
                    setState(() {
                      selectedProducts.add(
                        ServiceProduct(
                          name: nameController.text.trim(),
                          brand: brandController.text.trim(),
                        ),
                      );
                    });
                    Navigator.pop(context);
                  }
                },
                child: const Text("Add to Service"),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ----------------------------------------------------------
  // Stylists: Bottom sheet "Add" flow (requested)
  // ----------------------------------------------------------
  void _openStylistModal(_Stylist stylist) {
    final theme = Theme.of(context);
    final alreadySelected = selectedStylists.contains(stylist);

    showModalBottomSheet(
      context: context,
      backgroundColor: theme.colorScheme.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(22)),
      ),
      builder: (_) => Padding(
        padding: const EdgeInsets.fromLTRB(20, 12, 20, 20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Center(
              child: Container(
                width: 40,
                height: 4,
                margin: const EdgeInsets.only(bottom: 16),
                decoration: BoxDecoration(
                  color: theme.colorScheme.outlineVariant,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            Row(
              children: [
                CircleAvatar(
                  radius: 26,
                  backgroundImage: NetworkImage(stylist.avatarUrl),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        stylist.name,
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        "ID: ${stylist.id}",
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 18),
            SizedBox(
              width: double.infinity,
              height: 48,
              child: FilledButton.icon(
                onPressed: () {
                  setState(() {
                    if (alreadySelected) {
                      selectedStylists.remove(stylist);
                    } else {
                      selectedStylists.add(stylist);
                    }
                  });
                  Navigator.pop(context);
                },
                icon: Icon(alreadySelected ? Icons.remove : Icons.add),
                label: Text(alreadySelected ? "Remove Stylist" : "Add Stylist"),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ----------------------------------------------------------
  // Build
  // ----------------------------------------------------------
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    // IMPORTANT: this provider should be your detail view-model provider
    // that calls GET /salon/services/{service_id}/sub/{sub_service_id}/configure
    final state = ref.watch(
      salonServiceConfigDetailViewModelProvider(
        serviceId: widget.serviceId,
        subServiceId: widget.subServiceId,
      ),
    );

    final actionState = ref.watch(configServiceUpdateCreateViewModelProvider);


    return Scaffold(
      appBar: AppBar(
        title: const Text("Configure Service"),
        actions: [
          IconButton(
            onPressed: () => ref
                .read(
                  salonServiceConfigDetailViewModelProvider(
                    serviceId: widget.serviceId,
                    subServiceId: widget.subServiceId,
                  ).notifier,
                )
                .refresh(serviceId: widget.serviceId, subServiceId: widget.subServiceId),
            icon: const Icon(Icons.refresh),
          ),
        ],
      ),
      body: state.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text(e.toString())),
        data: (model) {
          // One-time prefill from API
          _initFromApiOnce(model);

          final headerImage = (model.subServiceImage.isNotEmpty)
              ? model.subServiceImage
              : model.serviceImage;

          final filteredStylists = allStylists.where((stylist) {
            return stylist.name
                .toLowerCase()
                .contains(_stylistSearch.text.toLowerCase());
          }).toList();

          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              // Service Preview Header (SAME UI)
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: theme.colorScheme.surfaceContainerHighest,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  children: [
                    // Image (sub_service first, service fallback)
                    ClipRRect(
                      borderRadius: BorderRadius.circular(14),
                      child: Image.network(
                        headerImage,
                        width: 72,
                        height: 72,
                        fit: BoxFit.cover,
                        errorBuilder: (_, _, _) => Container(
                          width: 72,
                          height: 72,
                          color: theme.colorScheme.surfaceContainerLowest,
                          child: const Icon(Icons.image_not_supported),
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    // Names from API (NO constructor strings)
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            model.subServiceName,
                            style: theme.textTheme.titleLarge?.copyWith(
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            model.serviceName,
                            style: theme.textTheme.bodyMedium?.copyWith(
                              color: theme.colorScheme.onSurfaceVariant,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 32),

              // Duration (SAME UI)
              _Card(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text("Duration"),
                    const SizedBox(height: 8),
                    Text("$duration minutes"),
                    Slider(
                      value: duration.toDouble(),
                      min: 15,
                      max: 600,
                      divisions: 39,
                      label: "$duration min",
                      onChanged: (v) => setState(() => duration = v.toInt()),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 16),

              // Price (SAME UI)
              _Card(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text("Price"),
                    const SizedBox(height: 12),
                    DropdownButtonFormField<_Currency>(
                      value: selectedCurrency,
                      items: currencies.map((currency) {
                        return DropdownMenuItem(
                          value: currency,
                          child: Text(
                            "${currency.symbol}  ${currency.code} — ${currency.name}",
                          ),
                        );
                      }).toList(),
                      onChanged: (value) {
                        if (value != null) {
                          setState(() => selectedCurrency = value);
                        }
                      },
                      decoration: InputDecoration(
                        labelText: "Currency",
                        filled: true,
                        fillColor: theme.colorScheme.surfaceContainerLowest,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(14),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(
                          child: _PriceField(
                            label: "Min Price (${selectedCurrency.symbol})",
                            value: minPrice,
                            onChanged: (v) => setState(() => minPrice = v),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: _PriceField(
                            label: "Max Price (${selectedCurrency.symbol})",
                            value: maxPrice,
                            onChanged: (v) => setState(() => maxPrice = v),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 16),

              // Assign Stylists (SAME UI look, but click opens modal to add/remove)
              _Card(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text("Assign Stylists"),
                    const SizedBox(height: 12),
                    TextField(
                      controller: _stylistSearch,
                      decoration: InputDecoration(
                        hintText: "Search stylist",
                        prefixIcon: const Icon(Icons.search),
                        filled: true,
                        fillColor: theme.colorScheme.surfaceContainerLowest,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(14),
                          borderSide: BorderSide.none,
                        ),
                      ),
                      onChanged: (_) => setState(() {}),
                    ),
                    const SizedBox(height: 16),
                    ...filteredStylists.map((stylist) {
                      final selected = selectedStylists.contains(stylist);

                      return Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: InkWell(
                          borderRadius: BorderRadius.circular(16),
                          onTap: () => _openStylistModal(stylist),
                          child: Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: selected
                                  ? theme.colorScheme.primaryContainer
                                  : theme.colorScheme.surfaceContainerHighest,
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: Row(
                              children: [
                                CircleAvatar(
                                  radius: 22,
                                  backgroundImage:
                                      NetworkImage(stylist.avatarUrl),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Text(
                                    stylist.name,
                                    style: theme.textTheme.bodyLarge?.copyWith(
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                                if (selected)
                                  Icon(
                                    Icons.check_circle,
                                    color: theme.colorScheme.primary,
                                  )
                                else
                                  Icon(
                                    Icons.add_circle_outline,
                                    color: theme.colorScheme.primary,
                                  ),
                              ],
                            ),
                          ),
                        ),
                      );
                    }),
                  ],
                ),
              ),

              const SizedBox(height: 16),

              // Benefits (SAME UI)
              _Card(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text("Service Benefits",
                        style: TextStyle(fontWeight: FontWeight.bold)),
                    const SizedBox(height: 12),
                    if (selectedBenefits.isEmpty)
                      Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: Text(
                          "No benefits added yet.",
                          style: theme.textTheme.labelMedium
                              ?.copyWith(fontStyle: FontStyle.italic),
                        ),
                      ),
                    if (selectedBenefits.isNotEmpty)
                      Column(
                        children: selectedBenefits
                            .map(
                              (benefit) => Padding(
                                padding: const EdgeInsets.only(bottom: 8.0),
                                child: Container(
                                  padding: const EdgeInsets.all(12),
                                  decoration: BoxDecoration(
                                    color: theme
                                        .colorScheme.surfaceContainerLowest,
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Row(
                                    children: [
                                      CircleAvatar(
                                        radius: 12,
                                        backgroundColor: theme.colorScheme
                                            .secondaryContainer,
                                        child: Text(
                                          "${benefit.position}",
                                          style: TextStyle(
                                            fontSize: 12,
                                            color: theme.colorScheme
                                                .onSecondaryContainer,
                                          ),
                                        ),
                                      ),
                                      const SizedBox(width: 12),
                                      Expanded(
                                        child: Text(
                                          benefit.text,
                                          style: theme.textTheme.bodyMedium,
                                        ),
                                      ),
                                      IconButton(
                                        icon: const Icon(
                                          Icons.remove_circle_outline,
                                          size: 20,
                                        ),
                                        onPressed: () => setState(() =>
                                            selectedBenefits.remove(benefit)),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            )
                            .toList(),
                      ),
                    ActionChip(
                      avatar: const Icon(Icons.stars, size: 16),
                      label: const Text("Add Benefit"),
                      onPressed: _showAddBenefitBottomSheet,
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 16),

              // Products (SAME UI)
              _Card(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text("Products Used",
                        style: TextStyle(fontWeight: FontWeight.bold)),
                    const SizedBox(height: 12),
                    if (selectedProducts.isEmpty)
                      Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: Text(
                          "No products added yet.",
                          style: theme.textTheme.labelMedium
                              ?.copyWith(fontStyle: FontStyle.italic),
                        ),
                      ),
                    if (selectedProducts.isNotEmpty)
                      Column(
                        children: selectedProducts
                            .map(
                              (product) => Padding(
                                padding: const EdgeInsets.only(bottom: 8.0),
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 12,
                                    vertical: 8,
                                  ),
                                  decoration: BoxDecoration(
                                    color: theme
                                        .colorScheme.surfaceContainerLowest,
                                    borderRadius: BorderRadius.circular(12),
                                    border: Border.all(
                                      color: theme.colorScheme.outlineVariant,
                                    ),
                                  ),
                                  child: Row(
                                    children: [
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              product.name,
                                              style: const TextStyle(
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                            Text(
                                              product.brand,
                                              style: theme.textTheme.labelSmall,
                                            ),
                                          ],
                                        ),
                                      ),
                                      IconButton(
                                        icon: const Icon(Icons.close, size: 18),
                                        onPressed: () => setState(() =>
                                            selectedProducts.remove(product)),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            )
                            .toList(),
                      ),
                    ActionChip(
                      avatar: const Icon(Icons.add, size: 16),
                      label: const Text("Add Product"),
                      onPressed: _showAddProductBottomSheet,
                    ),
                  ],
                ),
              ),

              // Active (SAME UI)
              _Card(
                child: SwitchListTile(
                  contentPadding: EdgeInsets.zero,
                  title: const Text("Service Active"),
                  subtitle: Text(
                    isActive ? "Visible to customers" : "Hidden (draft)",
                  ),
                  value: isActive,
                  onChanged: (v) => setState(() => isActive = v),
                ),
              ),

              const SizedBox(height: 32),

              // Save (same UI, for now just pop like yours)
              FilledButton(
                onPressed: actionState.isLoading
                    ? null
                    : () async {
                        final payload = SalonServiceConfigRequestModel(
                          serviceId: widget.serviceId,
                          subServiceId: widget.subServiceId,
                          priceMin: minPrice.toInt(),
                          priceMax: maxPrice.toInt(),
                          currency: selectedCurrency.code,
                          durationMinutes: duration,
                          status: isActive ? "active" : "draft",
                          stylistIds: selectedStylists.map((e) => e.id).toList(),
                          benefits: selectedBenefits
                              .map(
                                (b) => ServiceConfigBenefit(
                                  benefit: b.text,
                                  position: b.position,
                                ),
                              )
                              .toList(),
                          products: selectedProducts
                              .map(
                                (p) => ServiceConfigProduct(
                                  productName: p.name,
                                  brand: p.brand,
                                ),
                              )
                              .toList(),
                        );

                        await ref
                            .read(
                              configServiceUpdateCreateViewModelProvider.notifier,
                            )
                            .save(
                              isConfigured: model.isConfigured,
                              salonServicePriceId:
                                  model.config?.salonServicePriceId,
                              payload: payload,
                            );
                      },
                child: Text(
                  actionState.isLoading
                      ? "Saving..."
                      : model.isConfigured
                          ? "Update Service"
                          : "Save Service",
                ),
              ),

            ],
          );
        },
      ),
    );
  }
}

/* ───────────────────────── Widgets ───────────────────────── */

class _Card extends StatelessWidget {
  final Widget child;

  const _Card({required this.child});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Theme.of(context).colorScheme.surfaceContainerHighest,
      borderRadius: BorderRadius.circular(20),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: child,
      ),
    );
  }
}

class _PriceField extends StatelessWidget {
  final String label;
  final double value;
  final ValueChanged<double> onChanged;

  const _PriceField({
    required this.label,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      initialValue: value.toStringAsFixed(0),
      keyboardType: TextInputType.number,
      decoration: InputDecoration(
        labelText: label,
        filled: true,
        fillColor: Theme.of(context).colorScheme.surfaceContainerLowest,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide.none,
        ),
      ),
      onChanged: (v) => onChanged(double.tryParse(v) ?? value),
    );
  }
}

/* ───────────────────────── Local UI models ───────────────────────── */

class _Stylist {
  final String id;
  final String name;
  final String avatarUrl;

  const _Stylist({
    required this.id,
    required this.name,
    required this.avatarUrl,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) || other is _Stylist && other.id == id;

  @override
  int get hashCode => id.hashCode;
}

class _Currency {
  final String code;
  final String symbol;
  final String name;

  const _Currency({
    required this.code,
    required this.symbol,
    required this.name,
  });
}

class ServiceProduct {
  final String name;
  final String brand;

  const ServiceProduct({required this.name, required this.brand});
}

class ServiceBenefit {
  final String text;
  final int position;

  const ServiceBenefit({required this.text, required this.position});
}



// import 'package:flutter/material.dart';

// // add another widget for salon to write the benefit of that services sort off.
// // Also add service products used to prepare that service

// class ConfigureServicePage extends StatefulWidget {
//   final String serviceName; // Sub-service
//   final String category;    // Service
//   final String imageUrl;

//   const ConfigureServicePage({
//     super.key,
//     required this.serviceName,
//     required this.category,
//     required this.imageUrl,
//   });

//   @override
//   State<ConfigureServicePage> createState() => _ConfigureServicePageState();
// }

// class _ConfigureServicePageState extends State<ConfigureServicePage> {
//   int duration = 60; // minutes
//   double minPrice = 10;
//   double maxPrice = 20;
//   bool isActive = true;

//   @override
//   void initState() {
//     super.initState();
//     selectedCurrency = currencies.first; // default USD
//   }

//   final TextEditingController _stylistSearch = TextEditingController();

//   final List<_Stylist> allStylists = const [
//       _Stylist(
//         id: "stylist_1",
//         name: "Sarah M.",
//         avatarUrl: "https://i.pravatar.cc/150?img=1",
//       ),
//       _Stylist(
//         id: "stylist_2",
//         name: "Michael K.",
//         avatarUrl: "https://i.pravatar.cc/150?img=2",
//       ),
//       _Stylist(
//         id: "stylist_3",
//         name: "Aisha L.",
//         avatarUrl: "https://i.pravatar.cc/150?img=3",
//       ),
//       _Stylist(
//         id: "stylist_4",
//         name: "John D.",
//         avatarUrl: "https://i.pravatar.cc/150?img=4",
//       ),
//     ];


//   final Set<_Stylist> selectedStylists = {};

//   final List<_Currency> currencies = const [
//     _Currency(code: "TZS", symbol: "TSh", name: "Tanzanian Shilling"),
//     _Currency(code: "KES", symbol: "KSh", name: "Kenyan Shilling"),
//     _Currency(code: "UGX", symbol: "USh", name: "Ugandan Shilling"),
//      _Currency(code: "USD", symbol: "\$", name: "US Dollar"),
//   ];


//   List<ServiceProduct> selectedProducts = [];

//   List<ServiceBenefit> selectedBenefits = [];

//   late _Currency selectedCurrency;

//   void _showAddBenefitBottomSheet() {
//     final TextEditingController benefitController = TextEditingController();
//     final TextEditingController positionController = TextEditingController();
//     final theme = Theme.of(context);

//     // Default the position to the next number in the list
//     positionController.text = (selectedBenefits.length + 1).toString();

//     showModalBottomSheet(
//       context: context,
//       isScrollControlled: true,
//       backgroundColor: theme.colorScheme.surface,
//       shape: const RoundedRectangleBorder(
//         borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
//       ),
//       builder: (context) => Padding(
//         padding: EdgeInsets.only(
//           left: 20,
//           right: 20,
//           top: 10,
//           bottom: MediaQuery.of(context).viewInsets.bottom + 20,
//         ),
//         child: Column(
//           mainAxisSize: MainAxisSize.min,
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Center(
//               child: Container(
//                 width: 40, height: 4,
//                 margin: const EdgeInsets.only(bottom: 20),
//                 decoration: BoxDecoration(
//                   color: theme.colorScheme.outlineVariant,
//                   borderRadius: BorderRadius.circular(2),
//                 ),
//               ),
//             ),
//             Text("Add Service Benefit", style: theme.textTheme.headlineSmall),
//             const SizedBox(height: 20),

//             TextField(
//               controller: benefitController,
//               autofocus: true,
//               maxLines: 2, // Benefits might be a bit longer
//               decoration: InputDecoration(
//                 labelText: "Benefit Description",
//                 hintText: "e.g. Promotes natural hair growth",
//                 filled: true,
//                 fillColor: theme.colorScheme.surfaceContainerHighest,
//                 border: OutlineInputBorder(
//                   borderRadius: BorderRadius.circular(14),
//                   borderSide: BorderSide.none,
//                 ),
//               ),
//             ),
//             const SizedBox(height: 16),

//             TextField(
//               controller: positionController,
//               keyboardType: TextInputType.number,
//               decoration: InputDecoration(
//                 labelText: "Display Position",
//                 prefixIcon: const Icon(Icons.format_list_numbered),
//                 filled: true,
//                 fillColor: theme.colorScheme.surfaceContainerHighest,
//                 border: OutlineInputBorder(
//                   borderRadius: BorderRadius.circular(14),
//                   borderSide: BorderSide.none,
//                 ),
//               ),
//             ),
//             const SizedBox(height: 24),

//             SizedBox(
//               width: double.infinity,
//               height: 50,
//               child: FilledButton(
//                 onPressed: () {
//                   if (benefitController.text.isNotEmpty) {
//                     setState(() {
//                       selectedBenefits.add(
//                         ServiceBenefit(
//                           text: benefitController.text,
//                           position: int.tryParse(positionController.text) ?? 1,
//                         ),
//                       );
//                       // Sort the list automatically by position
//                       selectedBenefits.sort((a, b) => a.position.compareTo(b.position));
//                     });
//                     Navigator.pop(context);
//                   }
//                 },
//                 child: const Text("Add Benefit"),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   void _showAddProductBottomSheet() {
//     final TextEditingController nameController = TextEditingController();
//     final TextEditingController brandController = TextEditingController();
//     final theme = Theme.of(context);

//     showModalBottomSheet(
//       context: context,
//       isScrollControlled: true, // Allows sheet to move up with the keyboard
//       backgroundColor: theme.colorScheme.surface,
//       shape: const RoundedRectangleBorder(
//         borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
//       ),
//       builder: (context) => Padding(
//         // Padding adjusts based on the keyboard's height
//         padding: EdgeInsets.only(
//           left: 20,
//           right: 20,
//           top: 10,
//           bottom: MediaQuery.of(context).viewInsets.bottom + 20,
//         ),
//         child: Column(
//           mainAxisSize: MainAxisSize.min,
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             // Drag handle for a native feel
//             Center(
//               child: Container(
//                 width: 40,
//                 height: 4,
//                 margin: const EdgeInsets.only(bottom: 20),
//                 decoration: BoxDecoration(
//                   color: theme.colorScheme.outlineVariant,
//                   borderRadius: BorderRadius.circular(2),
//                 ),
//               ),
//             ),
            
//             Text("Add Product", style: theme.textTheme.headlineSmall),
//             const SizedBox(height: 20),

//             TextField(
//               controller: nameController,
//               autofocus: true, // Focus automatically when opened
//               decoration: InputDecoration(
//                 labelText: "Product Name",
//                 prefixIcon: const Icon(Icons.inventory_2_outlined),
//                 filled: true,
//                 fillColor: theme.colorScheme.surfaceContainerHighest,
//                 border: OutlineInputBorder(
//                   borderRadius: BorderRadius.circular(14),
//                   borderSide: BorderSide.none,
//                 ),
//               ),
//             ),
//             const SizedBox(height: 16),

//             TextField(
//               controller: brandController,
//               decoration: InputDecoration(
//                 labelText: "Brand / Manufacturer",
//                 prefixIcon: const Icon(Icons.branding_watermark_outlined),
//                 filled: true,
//                 fillColor: theme.colorScheme.surfaceContainerHighest,
//                 border: OutlineInputBorder(
//                   borderRadius: BorderRadius.circular(14),
//                   borderSide: BorderSide.none,
//                 ),
//               ),
//             ),
//             const SizedBox(height: 24),

//             SizedBox(
//               width: double.infinity,
//               height: 50,
//               child: FilledButton(
//                 onPressed: () {
//                   if (nameController.text.isNotEmpty && brandController.text.isNotEmpty) {
//                     setState(() {
//                       selectedProducts.add(
//                         ServiceProduct(
//                           name: nameController.text,
//                           brand: brandController.text,
//                         ),
//                       );
//                     });
//                     Navigator.pop(context);
//                   }
//                 },
//                 child: const Text("Add to Service"),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     final theme = Theme.of(context);

//     final filteredStylists = allStylists.where((stylist) {
//       return stylist.name
//           .toLowerCase()
//           .contains(_stylistSearch.text.toLowerCase());
//     }).toList();

//     return Scaffold(
//       appBar: AppBar(
//         title: const Text("Configure Service"),
//       ),
//       body: ListView(
//         padding: const EdgeInsets.all(16),
//         children: [
//           // Service Header
//           // 🧾 Service Preview Header
//           Container(
//             padding: const EdgeInsets.all(16),
//             decoration: BoxDecoration(
//               color: theme.colorScheme.surfaceContainerHighest,
//               borderRadius: BorderRadius.circular(20),
//             ),
//             child: Row(
//               children: [
//                 // 🖼 Service Image
//                 ClipRRect(
//                   borderRadius: BorderRadius.circular(14),
//                   child: Image.network(
//                     widget.imageUrl,
//                     width: 72,
//                     height: 72,
//                     fit: BoxFit.cover,
//                   ),
//                 ),

//                 const SizedBox(width: 16),

//                 // 🏷 Names
//                 Expanded(
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       // Sub-service name
//                       Text(
//                         widget.serviceName,
//                         style: theme.textTheme.titleLarge?.copyWith(
//                           fontWeight: FontWeight.w700,
//                         ),
//                       ),
//                       const SizedBox(height: 6),

//                       // Service / Category
//                       Text(
//                         widget.category,
//                         style: theme.textTheme.bodyMedium?.copyWith(
//                           color: theme.colorScheme.onSurfaceVariant,
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               ],
//             ),
//           ),

//           const SizedBox(height: 32),

//           // ⏱ Duration
//           _Card(
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 const Text("Duration"),
//                 const SizedBox(height: 8),
//                 Text("$duration minutes"),
//                 Slider(
//                   value: duration.toDouble(),
//                   min: 15,
//                   max: 600, // ⏱ 10 hours
//                   divisions: 39,
//                   label: "$duration min",
//                   onChanged: (v) =>
//                       setState(() => duration = v.toInt()),
//                 ),
//               ],
//             ),
//           ),

//           const SizedBox(height: 16),

//           // 💰 Price
//           _Card(
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 const Text("Price"),

//                 const SizedBox(height: 12),

//                 // Currency Selector
//                 DropdownButtonFormField<_Currency>(
//                   value: selectedCurrency,
//                   items: currencies.map((currency) {
//                     return DropdownMenuItem(
//                       value: currency,
//                       child: Text(
//                         "${currency.symbol}  ${currency.code} — ${currency.name}",
//                       ),
//                     );
//                   }).toList(),
//                   onChanged: (value) {
//                     if (value != null) {
//                       setState(() => selectedCurrency = value);
//                     }
//                   },
//                   decoration: InputDecoration(
//                     labelText: "Currency",
//                     filled: true,
//                     fillColor:
//                         Theme.of(context).colorScheme.surfaceContainerLowest,
//                     border: OutlineInputBorder(
//                       borderRadius: BorderRadius.circular(14),
//                       borderSide: BorderSide.none,
//                     ),
//                   ),
//                 ),

//                 const SizedBox(height: 16),

//                 // Min / Max Price
//                 Row(
//                   children: [
//                     Expanded(
//                       child: _PriceField(
//                         label: "Min Price (${selectedCurrency.symbol})",
//                         value: minPrice,
//                         onChanged: (v) =>
//                             setState(() => minPrice = v),
//                       ),
//                     ),
//                     const SizedBox(width: 12),
//                     Expanded(
//                       child: _PriceField(
//                         label: "Max Price (${selectedCurrency.symbol})",
//                         value: maxPrice,
//                         onChanged: (v) =>
//                             setState(() => maxPrice = v),
//                       ),
//                     ),
//                   ],
//                 ),
//               ],
//             ),
//           ),


//           const SizedBox(height: 16),

//           // 👥 Assign Stylists
//           _Card(
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 const Text("Assign Stylists"),
//                 const SizedBox(height: 12),

//                 // 🔍 Search
//                 TextField(
//                   controller: _stylistSearch,
//                   decoration: InputDecoration(
//                     hintText: "Search stylist",
//                     prefixIcon: const Icon(Icons.search),
//                     filled: true,
//                     fillColor:
//                         theme.colorScheme.surfaceContainerLowest,
//                     border: OutlineInputBorder(
//                       borderRadius: BorderRadius.circular(14),
//                       borderSide: BorderSide.none,
//                     ),
//                   ),
//                   onChanged: (_) => setState(() {}),
//                 ),

//                 const SizedBox(height: 16),

//                 ...filteredStylists.map((stylist) {
//                   final selected =
//                       selectedStylists.contains(stylist);

//                   return Padding(
//                     padding: const EdgeInsets.only(bottom: 12),
//                     child: InkWell(
//                       borderRadius: BorderRadius.circular(16),
//                       onTap: () {
//                         setState(() {
//                           if (selected) {
//                             selectedStylists.remove(stylist);
//                           } else {
//                             selectedStylists.add(stylist);
//                           }
//                         });
//                       },
//                       child: Container(
//                         padding: const EdgeInsets.all(12),
//                         decoration: BoxDecoration(
//                           color: selected
//                               ? theme.colorScheme.primaryContainer
//                               : theme.colorScheme
//                                   .surfaceContainerHighest,
//                           borderRadius: BorderRadius.circular(16),
//                         ),
//                         child: Row(
//                           children: [
//                             CircleAvatar(
//                               radius: 22,
//                               backgroundImage:
//                                   NetworkImage(stylist.avatarUrl),
//                             ),
//                             const SizedBox(width: 12),
//                             Expanded(
//                               child: Text(
//                                 stylist.name,
//                                 style: theme.textTheme.bodyLarge
//                                     ?.copyWith(
//                                   fontWeight: FontWeight.w600,
//                                 ),
//                               ),
//                             ),
//                             if (selected)
//                               Icon(
//                                 Icons.check_circle,
//                                 color:
//                                     theme.colorScheme.primary,
//                               ),
//                           ],
//                         ),
//                       ),
//                     ),
//                   );
//                 }),
//               ],
//             ),
//           ),

//           const SizedBox(height: 16),

//           _Card(
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 const Text("Service Benefits", style: TextStyle(fontWeight: FontWeight.bold)),
//                 const SizedBox(height: 12),

//                 if (selectedBenefits.isEmpty)
//                   Padding(
//                     padding: const EdgeInsets.only(bottom: 12),
//                     child: Text("No benefits added yet.", 
//                       style: theme.textTheme.labelMedium?.copyWith(fontStyle: FontStyle.italic)),
//                   ),
                
//                 if (selectedBenefits.isNotEmpty)
//                   Column(
//                     children: selectedBenefits.map((benefit) => Padding(
//                       padding: const EdgeInsets.only(bottom: 8.0),
//                       child: Container(
//                         padding: const EdgeInsets.all(12),
//                         decoration: BoxDecoration(
//                           color: theme.colorScheme.surfaceContainerLowest,
//                           borderRadius: BorderRadius.circular(12),
//                         ),
//                         child: Row(
//                           children: [
//                             // Position Circle
//                             CircleAvatar(
//                               radius: 12,
//                               backgroundColor: theme.colorScheme.secondaryContainer,
//                               child: Text(
//                                 "${benefit.position}",
//                                 style: TextStyle(fontSize: 12, color: theme.colorScheme.onSecondaryContainer),
//                               ),
//                             ),
//                             const SizedBox(width: 12),
//                             Expanded(
//                               child: Text(benefit.text, style: theme.textTheme.bodyMedium),
//                             ),
//                             IconButton(
//                               icon: const Icon(Icons.remove_circle_outline, size: 20),
//                               onPressed: () => setState(() => selectedBenefits.remove(benefit)),
//                             ),
//                           ],
//                         ),
//                       ),
//                     )).toList(),
//                   ),

//                 ActionChip(
//                   avatar: const Icon(Icons.stars, size: 16),
//                   label: const Text("Add Benefit"),
//                   onPressed: _showAddBenefitBottomSheet,
//                 ),
//               ],
//             ),
//           ),

//           const SizedBox(height: 16),

//           _Card(
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 const Text("Products Used", style: TextStyle(fontWeight: FontWeight.bold)),
//                 const SizedBox(height: 12),

//                 if (selectedProducts.isEmpty)
//                   Padding(
//                     padding: const EdgeInsets.only(bottom: 12),
//                     child: Text("No products added yet.", 
//                       style: theme.textTheme.labelMedium?.copyWith(fontStyle: FontStyle.italic)),
//                   ),
                
//                 // List of Added Products
//                 if (selectedProducts.isNotEmpty)
//                   Column(
//                     children: selectedProducts.map((product) => Padding(
//                       padding: const EdgeInsets.only(bottom: 8.0),
//                       child: Container(
//                         padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
//                         decoration: BoxDecoration(
//                           color: Theme.of(context).colorScheme.surfaceContainerLowest,
//                           borderRadius: BorderRadius.circular(12),
//                           border: Border.all(color: Theme.of(context).colorScheme.outlineVariant),
//                         ),
//                         child: Row(
//                           children: [
//                             Expanded(
//                               child: Column(
//                                 crossAxisAlignment: CrossAxisAlignment.start,
//                                 children: [
//                                   Text(product.name, style: const TextStyle(fontWeight: FontWeight.w600)),
//                                   Text(product.brand, style: Theme.of(context).textTheme.labelSmall),
//                                 ],
//                               ),
//                             ),
//                             IconButton(
//                               icon: const Icon(Icons.close, size: 18),
//                               onPressed: () => setState(() => selectedProducts.remove(product)),
//                             ),
//                           ],
//                         ),
//                       ),
//                     )).toList(),
//                   ),

//                 // ➕ Button to Add New
//                 ActionChip(
//                   avatar: const Icon(Icons.add, size: 16),
//                   label: const Text("Add Product"),
//                   onPressed: () {
//                     // You could show a dialog or bottom sheet here to input both strings
//                     _showAddProductBottomSheet();
//                   },
//                 ),
//               ],
//             ),
//           ),

//           // 🔘 Active
//           _Card(
//             child: SwitchListTile(
//               contentPadding: EdgeInsets.zero,
//               title: const Text("Service Active"),
//               subtitle: Text(
//                 isActive
//                     ? "Visible to customers"
//                     : "Hidden (draft)",
//               ),
//               value: isActive,
//               onChanged: (v) => setState(() => isActive = v),
//             ),
//           ),

//           const SizedBox(height: 32),

//           // 💾 Save
//           FilledButton(
//             onPressed: () {
//               Navigator.pop(context);
//             },
//             child: const Text("Save Service"),
//           ),
//         ],
//       ),
//     );
//   }
// }

// /* ───────────────────────── Widgets ───────────────────────── */

// class _Card extends StatelessWidget {
//   final Widget child;

//   const _Card({required this.child});

//   @override
//   Widget build(BuildContext context) {
//     return Material(
//       color:
//           Theme.of(context).colorScheme.surfaceContainerHighest,
//       borderRadius: BorderRadius.circular(20),
//       child: Padding(
//         padding: const EdgeInsets.all(16),
//         child: child,
//       ),
//     );
//   }
// }

// class _PriceField extends StatelessWidget {
//   final String label;
//   final double value;
//   final ValueChanged<double> onChanged;

//   const _PriceField({
//     required this.label,
//     required this.value,
//     required this.onChanged,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return TextFormField(
//       initialValue: value.toStringAsFixed(0),
//       keyboardType: TextInputType.number,
//       decoration: InputDecoration(
//         labelText: label,
//         filled: true,
//         fillColor:
//             Theme.of(context).colorScheme.surfaceContainerLowest,
//         border: OutlineInputBorder(
//           borderRadius: BorderRadius.circular(14),
//           borderSide: BorderSide.none,
//         ),
//       ),
//       onChanged: (v) =>
//           onChanged(double.tryParse(v) ?? value),
//     );
//   }
// }

// /* ───────────────────────── Models ───────────────────────── */

// class _Stylist {
//   final String id;
//   final String name;
//   final String avatarUrl;

//   const _Stylist({
//     required this.id,
//     required this.name,
//     required this.avatarUrl,
//   });

//   @override
//   bool operator ==(Object other) =>
//       identical(this, other) ||
//       other is _Stylist && other.id == id;

//   @override
//   int get hashCode => id.hashCode;
// }

// class _Currency {
//   final String code;
//   final String symbol;
//   final String name;

//   const _Currency({
//     required this.code,
//     required this.symbol,
//     required this.name,
//   });
// }

// class ServiceProduct {
//   final String name;
//   final String brand;

//   const ServiceProduct({required this.name, required this.brand});
// }

// class ServiceBenefit {
//   final String text;
//   final int position;

//   const ServiceBenefit({required this.text, required this.position});
// }