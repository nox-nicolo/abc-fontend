import 'package:flutter/material.dart';

class ConfigureServicePage extends StatefulWidget {
  final String serviceName; // Sub-service
  final String category;    // Service
  final String imageUrl;

  const ConfigureServicePage({
    super.key,
    required this.serviceName,
    required this.category,
    required this.imageUrl,
  });

  @override
  State<ConfigureServicePage> createState() => _ConfigureServicePageState();
}

class _ConfigureServicePageState extends State<ConfigureServicePage> {
  int duration = 60; // minutes
  double minPrice = 10;
  double maxPrice = 20;
  bool isActive = true;

  @override
  void initState() {
    super.initState();
    selectedCurrency = currencies.first; // default USD
  }

  final TextEditingController _stylistSearch = TextEditingController();

  final List<_Stylist> allStylists = const [
      _Stylist(
        id: "stylist_1",
        name: "Sarah M.",
        avatarUrl: "https://i.pravatar.cc/150?img=1",
      ),
      _Stylist(
        id: "stylist_2",
        name: "Michael K.",
        avatarUrl: "https://i.pravatar.cc/150?img=2",
      ),
      _Stylist(
        id: "stylist_3",
        name: "Aisha L.",
        avatarUrl: "https://i.pravatar.cc/150?img=3",
      ),
      _Stylist(
        id: "stylist_4",
        name: "John D.",
        avatarUrl: "https://i.pravatar.cc/150?img=4",
      ),
    ];


  final Set<_Stylist> selectedStylists = {};

  final List<_Currency> currencies = const [
    _Currency(code: "USD", symbol: "\$", name: "US Dollar"),
    _Currency(code: "TZS", symbol: "TSh", name: "Tanzanian Shilling"),
    _Currency(code: "KES", symbol: "KSh", name: "Kenyan Shilling"),
    _Currency(code: "UGX", symbol: "USh", name: "Ugandan Shilling"),
  ];

  late _Currency selectedCurrency;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final filteredStylists = allStylists.where((stylist) {
      return stylist.name
          .toLowerCase()
          .contains(_stylistSearch.text.toLowerCase());
    }).toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text("Configure Service"),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Service Header
          // 🧾 Service Preview Header
Container(
  padding: const EdgeInsets.all(16),
  decoration: BoxDecoration(
    color: theme.colorScheme.surfaceContainerHighest,
    borderRadius: BorderRadius.circular(20),
  ),
  child: Row(
    children: [
      // 🖼 Service Image
      ClipRRect(
        borderRadius: BorderRadius.circular(14),
        child: Image.network(
          widget.imageUrl,
          width: 72,
          height: 72,
          fit: BoxFit.cover,
        ),
      ),

      const SizedBox(width: 16),

      // 🏷 Names
      Expanded(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Sub-service name
            Text(
              widget.serviceName,
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 6),

            // Service / Category
            Text(
              widget.category,
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

          // ⏱ Duration
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
                  max: 600, // ⏱ 10 hours
                  divisions: 39,
                  label: "$duration min",
                  onChanged: (v) =>
                      setState(() => duration = v.toInt()),
                ),
              ],
            ),
          ),

          const SizedBox(height: 16),

          // 💰 Price
          _Card(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text("Price"),

                const SizedBox(height: 12),

                // Currency Selector
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
                    fillColor:
                        Theme.of(context).colorScheme.surfaceContainerLowest,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),

                const SizedBox(height: 16),

                // Min / Max Price
                Row(
                  children: [
                    Expanded(
                      child: _PriceField(
                        label: "Min Price (${selectedCurrency.symbol})",
                        value: minPrice,
                        onChanged: (v) =>
                            setState(() => minPrice = v),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _PriceField(
                        label: "Max Price (${selectedCurrency.symbol})",
                        value: maxPrice,
                        onChanged: (v) =>
                            setState(() => maxPrice = v),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),


          const SizedBox(height: 16),

          // 👥 Assign Stylists
          _Card(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text("Assign Stylists"),
                const SizedBox(height: 12),

                // 🔍 Search
                TextField(
                  controller: _stylistSearch,
                  decoration: InputDecoration(
                    hintText: "Search stylist",
                    prefixIcon: const Icon(Icons.search),
                    filled: true,
                    fillColor:
                        theme.colorScheme.surfaceContainerLowest,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14),
                      borderSide: BorderSide.none,
                    ),
                  ),
                  onChanged: (_) => setState(() {}),
                ),

                const SizedBox(height: 16),

                ...filteredStylists.map((stylist) {
                  final selected =
                      selectedStylists.contains(stylist);

                  return Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: InkWell(
                      borderRadius: BorderRadius.circular(16),
                      onTap: () {
                        setState(() {
                          if (selected) {
                            selectedStylists.remove(stylist);
                          } else {
                            selectedStylists.add(stylist);
                          }
                        });
                      },
                      child: Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: selected
                              ? theme.colorScheme.primaryContainer
                              : theme.colorScheme
                                  .surfaceContainerHighest,
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
                                style: theme.textTheme.bodyLarge
                                    ?.copyWith(
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                            if (selected)
                              Icon(
                                Icons.check_circle,
                                color:
                                    theme.colorScheme.primary,
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

          // 🔘 Active
          _Card(
            child: SwitchListTile(
              contentPadding: EdgeInsets.zero,
              title: const Text("Service Active"),
              subtitle: Text(
                isActive
                    ? "Visible to customers"
                    : "Hidden (draft)",
              ),
              value: isActive,
              onChanged: (v) => setState(() => isActive = v),
            ),
          ),

          const SizedBox(height: 32),

          // 💾 Save
          FilledButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text("Save Service"),
          ),
        ],
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
      color:
          Theme.of(context).colorScheme.surfaceContainerHighest,
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
        fillColor:
            Theme.of(context).colorScheme.surfaceContainerLowest,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide.none,
        ),
      ),
      onChanged: (v) =>
          onChanged(double.tryParse(v) ?? value),
    );
  }
}

/* ───────────────────────── Models ───────────────────────── */

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
      identical(this, other) ||
      other is _Stylist && other.id == id;

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