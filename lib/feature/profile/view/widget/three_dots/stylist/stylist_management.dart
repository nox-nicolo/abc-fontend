import 'package:africa_beuty/feature/profile/view/widget/three_dots/stylist/stylist_create.dart';
import 'package:africa_beuty/feature/profile/view/widget/three_dots/stylist/stylist_management_search.dart';
import 'package:africa_beuty/feature/profile/view/widget/three_dots/stylist/stylist_view.dart';
import 'package:flutter/material.dart';

class SalonStylistsPage extends StatefulWidget {
  const SalonStylistsPage({super.key});

  @override
  State<SalonStylistsPage> createState() => _SalonStylistsPageState();
}

class _SalonStylistsPageState extends State<SalonStylistsPage> {
  StylistSort _sort = StylistSort.recent;

  // Existing salon stylists list (UI mock)
  final List<SalonStylistUiModel> _allStylists = const [
    SalonStylistUiModel(id: "1", fullName: "Asha Mussa", username: "@asha.braids"),
    SalonStylistUiModel(id: "2", fullName: "Neema Joseph", username: "@neema.styles"),
  ];

  List<SalonStylistUiModel> get _visibleStylists {
    var items = [..._allStylists];
    switch (_sort) {
      case StylistSort.recent:
        break;
      case StylistSort.nameAsc:
        items.sort((a, b) => a.fullName.compareTo(b.fullName));
        break;
      case StylistSort.nameDesc:
        items.sort((a, b) => b.fullName.compareTo(a.fullName));
        break;
    }
    return items;
  }

  void _openSortSheet() {
    showModalBottomSheet(
      context: context,
      showDragHandle: true,
      builder: (_) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              title: const Text("Most recent"),
              trailing: _sort == StylistSort.recent ? const Icon(Icons.check) : null,
              onTap: () => _setSort(StylistSort.recent),
            ),
            ListTile(
              title: const Text("Name (A → Z)"),
              trailing: _sort == StylistSort.nameAsc ? const Icon(Icons.check) : null,
              onTap: () => _setSort(StylistSort.nameAsc),
            ),
            ListTile(
              title: const Text("Name (Z → A)"),
              trailing: _sort == StylistSort.nameDesc ? const Icon(Icons.check) : null,
              onTap: () => _setSort(StylistSort.nameDesc),
            ),
          ],
        ),
      ),
    );
  }

  void _setSort(StylistSort sort) {
    setState(() => _sort = sort);
    Navigator.pop(context);
  }

  // Mock search that matches your API response shape.
  // Later: replace body with your repository call.
  Future<StylistSearchResponse> _searchStylists(String query) async {
    await Future.delayed(const Duration(milliseconds: 250));

    final sample = <StylistSearchItem>[
      const StylistSearchItem(
        id: "u1",
        username: "johnnyfade",
        name: "John Mtei",
        profilePictureUrl: "",
      ),
      const StylistSearchItem(
        id: "u2",
        username: "zainab.glow",
        name: "Zainab Ally",
        profilePictureUrl: "",
      ),
    ];

    final q = query.toLowerCase();
    final items = sample
        .where((e) =>
            e.username.toLowerCase().contains(q) ||
            e.name.toLowerCase().contains(q))
        .toList();

    return StylistSearchResponse(items: items, query: query, count: items.length);
  }

  @override
  Widget build(BuildContext context) {
    final items = _visibleStylists;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Stylists"),
        actions: [
          IconButton(
            tooltip: "Sort",
            onPressed: _openSortSheet,
            icon: const Icon(Icons.sort),
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
              child: StylistSearchField(
                searchFn: _searchStylists,
                onPick: (picked) async {
                  await CreateSalonStylistSheet.open(
                    context,
                    user: SelectedStylistUser(
                      id: picked.id,
                      name: picked.name,
                      username: picked.username,
                      imageUrl: picked.profilePictureUrl,
                    ),
                    onSubmit: (req) async {
                      // Later: call your VM/repo:
                      // await ref.read(salonStylistsVMProvider.notifier).create(req.toMap());

                      // For now just print/preview:
                      debugPrint("CREATE STYLIST PAYLOAD => ${req.toMap()}");
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text("Payload ready (check logs)")),
                      );
                    },
                  );
                },
              ),
            ),
            const Divider(height: 1),
            Expanded(
              child: ListView.separated(
                padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
                itemCount: items.length,
                separatorBuilder: (_, __) => const SizedBox(height: 10),
                itemBuilder: (context, i) {
                  final s = items[i];
                  return _SalonStylistCard(stylist: s);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SalonStylistCard extends StatelessWidget {
  final SalonStylistUiModel stylist;
  const _SalonStylistCard({required this.stylist});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Material(
      color: cs.surfaceContainerLow,
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => StylistDetailPage(stylistId: '67757'),
            ),
          );
        }, // not implementing view/edit/delete yet
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            children: [
              CircleAvatar(
                radius: 20,
                child: Text(stylist.fullName.characters.take(1).toString()),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(stylist.fullName,
                        style: Theme.of(context).textTheme.titleMedium),
                    const SizedBox(height: 2),
                    Text(
                      stylist.username,
                      style: Theme.of(context)
                          .textTheme
                          .bodyMedium
                          ?.copyWith(color: cs.onSurfaceVariant),
                    ),
                  ],
                ),
              ),
              Icon(Icons.chevron_right, color: cs.onSurfaceVariant),
            ],
          ),
        ),
      ),
    );
  }
}

enum StylistSort { recent, nameAsc, nameDesc }

class SalonStylistUiModel {
  final String id;
  final String fullName;
  final String username;

  const SalonStylistUiModel({
    required this.id,
    required this.fullName,
    required this.username,
  });
}