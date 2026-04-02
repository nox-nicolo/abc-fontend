import 'package:africa_beuty/feature/profile/model/three_dots/services/create.dart';
import 'package:africa_beuty/feature/profile/repositories/three_dots/services/stylist.dart';
import 'package:africa_beuty/feature/profile/view_model/service/config_service_salon.dart';
import 'package:africa_beuty/feature/profile/view_model/service/create.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ConfigureServicePage extends ConsumerStatefulWidget {
  final String serviceId;
  final String serviceName;
  final String serviceImage;

  final String subServiceId;
  final String subServiceName;
  final String subServiceImage;

  const ConfigureServicePage({
    super.key,
    required this.serviceId,
    required this.serviceName,
    required this.serviceImage,
    required this.subServiceId,
    required this.subServiceName,
    required this.subServiceImage,
  });

  @override
  ConsumerState<ConfigureServicePage> createState() =>
      _ConfigureServicePageState();
}

class _ConfigureServicePageState extends ConsumerState<ConfigureServicePage> {
  int duration = 60;
  double minPrice = 0;
  double maxPrice = 0;
  bool isActive = true;

  final List<_Currency> currencies = const [
    _Currency(code: "TZS", symbol: "TSh", name: "Tanzanian Shilling"),
    _Currency(code: "KES", symbol: "KSh", name: "Kenyan Shilling"),
    _Currency(code: "UGX", symbol: "USh", name: "Ugandan Shilling"),
    _Currency(code: "USD", symbol: "\$", name: "US Dollar"),
  ];

  late _Currency selectedCurrency;

  List<ServiceProduct> selectedProducts = [];
  List<ServiceBenefit> selectedBenefits = [];
  List<String> selectedStylistIds = [];
  List<SalonServiceConfigStylistModel> selectedStylists = [];

  bool _didInitFromApi = false;

  @override
  void initState() {
    super.initState();
    selectedCurrency = currencies.first;

    ref.listenManual(
      createServiceProvider,
      (previous, next) {
        next.whenOrNull(
          data: (message) {
            if (message == null) return;

            _didInitFromApi = false;

            ref.invalidate(
              salonServiceConfigDetailViewModelProvider(
                serviceId: widget.serviceId,
                subServiceId: widget.subServiceId,
              ),
            );

            if (!mounted) return;

            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(message)),
            );

            ref.read(createServiceProvider.notifier).reset();
          },
          error: (e, _) {
            if (!mounted) return;

            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(e.toString())),
            );
          },
        );
      },
    );
  }

  Future<void> _onRefresh() async {
    _didInitFromApi = false;

    await ref
        .read(
          salonServiceConfigDetailViewModelProvider(
            serviceId: widget.serviceId,
            subServiceId: widget.subServiceId,
          ).notifier,
        )
        .refresh(
          serviceId: widget.serviceId,
          subServiceId: widget.subServiceId,
        );
  }

  void _initFromApiOnce(SalonServiceSelectableItemModel model) {
    if (_didInitFromApi) return;
    _didInitFromApi = true;

    final cfg = model.config;

    setState(() {
      duration = cfg?.durationMinutes ?? 60;
      minPrice = (cfg?.priceMin ?? 0).toDouble();
      maxPrice = (cfg?.priceMax ?? 0).toDouble();

      final currencyCode = cfg?.currency;
      selectedCurrency = currencies.firstWhere(
        (c) => c.code == currencyCode,
        orElse: () => currencies.first,
      );

      isActive = cfg?.status == SalonServiceStatus.active;

      selectedBenefits = (cfg?.benefits ?? [])
          .map(
            (b) => ServiceBenefit(
              text: b.benefit,
              position: b.position,
            ),
          )
          .toList()
        ..sort((a, b) => a.position.compareTo(b.position));

      selectedProducts = (cfg?.products ?? [])
          .map(
            (p) => ServiceProduct(
              name: p.productName,
              brand: p.brand ?? '',
            ),
          )
          .toList();

      selectedStylists = List<SalonServiceConfigStylistModel>.from(
        cfg?.stylists ?? const [],
      );

      selectedStylistIds = selectedStylists.map((s) => s.id).toList();
    });
  }

  void _showAddBenefitBottomSheet() {
    final benefitController = TextEditingController();
    final positionController = TextEditingController();
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
                  if (benefitController.text.trim().isEmpty) return;

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
                },
                child: const Text("Add Benefit"),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showAddProductBottomSheet() {
    final nameController = TextEditingController();
    final brandController = TextEditingController();
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
                  if (nameController.text.trim().isEmpty ||
                      brandController.text.trim().isEmpty) {
                    return;
                  }

                  setState(() {
                    selectedProducts.add(
                      ServiceProduct(
                        name: nameController.text.trim(),
                        brand: brandController.text.trim(),
                      ),
                    );
                  });

                  Navigator.pop(context);
                },
                child: const Text("Add to Service"),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showSelectStylistsBottomSheet() {
    final theme = Theme.of(context);
    final currentSelected = {...selectedStylistIds};

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: theme.colorScheme.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
      ),
      builder: (context) {
        return Consumer(
          builder: (context, ref, _) {
            final stylistsState = ref.watch(salonStylistsProvider);

            return StatefulBuilder(
              builder: (context, setModalState) {
                return SafeArea(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(20, 10, 20, 20),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          width: 40,
                          height: 4,
                          margin: const EdgeInsets.only(bottom: 20),
                          decoration: BoxDecoration(
                            color: theme.colorScheme.outlineVariant,
                            borderRadius: BorderRadius.circular(2),
                          ),
                        ),
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            'Select Stylists',
                            style: theme.textTheme.headlineSmall,
                          ),
                        ),
                        const SizedBox(height: 16),
                        Flexible(
                          child: stylistsState.when(
                            loading: () => const Center(
                              child: Padding(
                                padding: EdgeInsets.all(24),
                                child: CircularProgressIndicator(),
                              ),
                            ),
                            error: (e, _) => Padding(
                              padding: const EdgeInsets.all(16),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(e.toString()),
                                  const SizedBox(height: 12),
                                  FilledButton(
                                    onPressed: () {
                                      ref
                                          .read(salonStylistsProvider.notifier)
                                          .refresh();
                                    },
                                    child: const Text('Retry'),
                                  ),
                                ],
                              ),
                            ),
                            data: (stylists) {
                              if (stylists.isEmpty) {
                                return const Padding(
                                  padding: EdgeInsets.all(16),
                                  child: Text('No stylists found.'),
                                );
                              }

                              return ListView.separated(
                                shrinkWrap: true,
                                itemCount: stylists.length,
                                separatorBuilder: (_, __) =>
                                    const SizedBox(height: 8),
                                itemBuilder: (context, index) {
                                  final stylist = stylists[index];
                                  final isSelected =
                                      currentSelected.contains(stylist.id);

                                  return InkWell(
                                    borderRadius: BorderRadius.circular(16),
                                    onTap: () {
                                      setModalState(() {
                                        if (isSelected) {
                                          currentSelected.remove(stylist.id);
                                        } else {
                                          currentSelected.add(stylist.id);
                                        }
                                      });
                                    },
                                    child: Container(
                                      padding: const EdgeInsets.all(12),
                                      decoration: BoxDecoration(
                                        color: theme.colorScheme
                                            .surfaceContainerHighest,
                                        borderRadius: BorderRadius.circular(16),
                                        border: Border.all(
                                          color: isSelected
                                              ? theme.colorScheme.primary
                                              : theme.colorScheme.outlineVariant,
                                        ),
                                      ),
                                      child: Row(
                                        children: [
                                          CircleAvatar(
                                            radius: 22,
                                            backgroundImage:
                                                (stylist.imageUrl != null &&
                                                        stylist
                                                            .imageUrl!
                                                            .isNotEmpty)
                                                    ? NetworkImage(
                                                        stylist.imageUrl!,
                                                      )
                                                    : null,
                                            child: (stylist.imageUrl == null ||
                                                    stylist.imageUrl!.isEmpty)
                                                ? const Icon(
                                                    Icons.person_outline,
                                                  )
                                                : null,
                                          ),
                                          const SizedBox(width: 12),
                                          Expanded(
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  stylist.displayName,
                                                  style:
                                                      theme.textTheme.titleMedium,
                                                ),
                                                if ((stylist.title ?? '')
                                                    .trim()
                                                    .isNotEmpty)
                                                  Text(
                                                    stylist.title!,
                                                    style: theme
                                                        .textTheme.bodySmall
                                                        ?.copyWith(
                                                      color: theme
                                                          .colorScheme
                                                          .onSurfaceVariant,
                                                    ),
                                                  ),
                                              ],
                                            ),
                                          ),
                                          Icon(
                                            isSelected
                                                ? Icons.check_circle
                                                : Icons.radio_button_unchecked,
                                            color: isSelected
                                                ? theme.colorScheme.primary
                                                : theme.colorScheme.outline,
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                },
                              );
                            },
                          ),
                        ),
                        const SizedBox(height: 16),
                        SizedBox(
                          width: double.infinity,
                          height: 50,
                          child: FilledButton(
                            onPressed: () {
                              final stylists = ref.read(
                                salonStylistsProvider,
                              );

                              stylists.whenData((items) {
                                setState(() {
                                  selectedStylistIds = currentSelected.toList();

                                  selectedStylists = items
                                      .where(
                                        (stylist) =>
                                            currentSelected.contains(stylist.id),
                                      )
                                      .map(
                                        (stylist) =>
                                            SalonServiceConfigStylistModel(
                                          id: stylist.id,
                                          name: stylist.displayName,
                                          image: stylist.imageUrl,
                                        ),
                                      )
                                      .toList();
                                });
                              });

                              Navigator.pop(context);
                            },
                            child: const Text('Done'),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final detailState = ref.watch(
      salonServiceConfigDetailViewModelProvider(
        serviceId: widget.serviceId,
        subServiceId: widget.subServiceId,
      ),
    );

    final actionState = ref.watch(createServiceProvider);

    final headerImage = widget.subServiceImage.isNotEmpty
        ? widget.subServiceImage
        : widget.serviceImage;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Configure Service"),
        automaticallyImplyLeading: true,
      ),
      body: detailState.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text(e.toString())),
        data: (response) {
          final model = response.item;

          if (!_didInitFromApi) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              if (!mounted) return;
              _initFromApiOnce(model);
            });
          }

          return RefreshIndicator(
            onRefresh: _onRefresh,
            child: ListView(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.all(16),
              children: [
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.surfaceContainerHighest,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    children: [
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
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              widget.subServiceName,
                              style: theme.textTheme.titleLarge?.copyWith(
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            const SizedBox(height: 6),
                            Text(
                              widget.serviceName,
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
                const SizedBox(height: 24),
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
                        onChanged: (v) {
                          setState(() => duration = v.toInt());
                        },
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                _Card(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text("Price"),
                      const SizedBox(height: 12),
                      DropdownButtonFormField<_Currency>(
                        value: selectedCurrency,
                        items: currencies.map((currency) {
                          return DropdownMenuItem<_Currency>(
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
                _Card(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Assigned Stylists",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 12),
                      if (selectedStylists.isEmpty)
                        Text(
                          "No stylists assigned yet.",
                          style: theme.textTheme.labelMedium?.copyWith(
                            fontStyle: FontStyle.italic,
                          ),
                        )
                      else
                        Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          children: selectedStylists.map((stylist) {
                            return Chip(
                              avatar: (stylist.image != null &&
                                      stylist.image!.isNotEmpty)
                                  ? CircleAvatar(
                                      backgroundImage:
                                          NetworkImage(stylist.image!),
                                    )
                                  : const CircleAvatar(
                                      child: Icon(
                                        Icons.person_outline,
                                        size: 16,
                                      ),
                                    ),
                              label: Text(stylist.name),
                              onDeleted: () {
                                setState(() {
                                  selectedStylists
                                      .removeWhere((s) => s.id == stylist.id);
                                  selectedStylistIds.remove(stylist.id);
                                });
                              },
                            );
                          }).toList(),
                        ),
                      const SizedBox(height: 10),
                      ActionChip(
                        avatar: const Icon(Icons.people_outline, size: 16),
                        label: const Text('Select Stylists'),
                        onPressed: _showSelectStylistsBottomSheet,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                _Card(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Service Benefits",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 12),
                      if (selectedBenefits.isEmpty)
                        Padding(
                          padding: const EdgeInsets.only(bottom: 12),
                          child: Text(
                            "No benefits added yet.",
                            style: theme.textTheme.labelMedium?.copyWith(
                              fontStyle: FontStyle.italic,
                            ),
                          ),
                        ),
                      if (selectedBenefits.isNotEmpty)
                        Column(
                          children: selectedBenefits.map((benefit) {
                            return Padding(
                              padding: const EdgeInsets.only(bottom: 8),
                              child: Container(
                                padding: const EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  color:
                                      theme.colorScheme.surfaceContainerLowest,
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Row(
                                  children: [
                                    CircleAvatar(
                                      radius: 12,
                                      backgroundColor: theme
                                          .colorScheme.secondaryContainer,
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
                                      onPressed: () {
                                        setState(() {
                                          selectedBenefits.remove(benefit);
                                        });
                                      },
                                    ),
                                  ],
                                ),
                              ),
                            );
                          }).toList(),
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
                _Card(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Products Used",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 12),
                      if (selectedProducts.isEmpty)
                        Padding(
                          padding: const EdgeInsets.only(bottom: 12),
                          child: Text(
                            "No products added yet.",
                            style: theme.textTheme.labelMedium?.copyWith(
                              fontStyle: FontStyle.italic,
                            ),
                          ),
                        ),
                      if (selectedProducts.isNotEmpty)
                        Column(
                          children: selectedProducts.map((product) {
                            return Padding(
                              padding: const EdgeInsets.only(bottom: 8),
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 8,
                                ),
                                decoration: BoxDecoration(
                                  color:
                                      theme.colorScheme.surfaceContainerLowest,
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
                                      onPressed: () {
                                        setState(() {
                                          selectedProducts.remove(product);
                                        });
                                      },
                                    ),
                                  ],
                                ),
                              ),
                            );
                          }).toList(),
                        ),
                      ActionChip(
                        avatar: const Icon(Icons.add, size: 16),
                        label: const Text("Add Product"),
                        onPressed: _showAddProductBottomSheet,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
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
                            status: isActive
                                ? SalonServiceStatus.active
                                : SalonServiceStatus.inactive,
                            stylistIds: selectedStylistIds,
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

                          await ref.read(createServiceProvider.notifier).save(
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
            ),
          );
        },
      ),
    );
  }
}

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

  const ServiceProduct({
    required this.name,
    required this.brand,
  });
}

class ServiceBenefit {
  final String text;
  final int position;

  const ServiceBenefit({
    required this.text,
    required this.position,
  });
}