import 'package:africa_beuty/feature/profile/model/three_dots/stylists/search_stylists.dart';
import 'package:africa_beuty/feature/profile/model/three_dots/stylists/view_stylists.dart';
import 'package:africa_beuty/feature/profile/view/widget/three_dots/stylist/stylist_create.dart';
import 'package:africa_beuty/feature/profile/view/widget/three_dots/stylist/stylist_management_search.dart';
import 'package:africa_beuty/feature/profile/view/widget/three_dots/stylist/stylist_view.dart';
import 'package:africa_beuty/feature/profile/view_model/stylist/create_stylists.dart';
import 'package:africa_beuty/feature/profile/view_model/stylist/search_stylists.dart';
import 'package:africa_beuty/feature/profile/view_model/stylist/view_stylists.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SalonStylistsPage extends ConsumerStatefulWidget {
  const SalonStylistsPage({super.key});

  @override
  ConsumerState<SalonStylistsPage> createState() => _SalonStylistsPageState();
}

class _SalonStylistsPageState extends ConsumerState<SalonStylistsPage> {
  StylistSort _sort = StylistSort.recent;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(salonStylistViewModelProvider.notifier).getSalonStylists();
    });
  }

  Future<void> _refresh() async {
    await ref.read(salonStylistViewModelProvider.notifier).getSalonStylists();
  }

  Future<StylistSearchResponse> _searchStylists(String query) {
    return ref
        .read(stylistSearchViewModelProvider.notifier)
        .searchStylists(query);
  }

  Future<void> _openCreateSheet(StylistSearchItem picked) async {
    await CreateSalonStylistSheet.open(
      context,
      user: SelectedStylistUser(
        id: picked.id,
        name: picked.name,
        username: picked.username,
        imageUrl: picked.profilePictureUrl,
      ),
      onSubmit: (req) async {
        final result = await ref
            .read(createStylistViewModelProvider.notifier)
            .createStylist(request: req);

        if (!mounted) return;

        await ref.read(salonStylistViewModelProvider.notifier).getSalonStylists();

        if (!mounted) return;

        await showDialog<void>(
          context: context,
          builder: (dialogContext) {
            return AlertDialog(
              title: const Text('Success'),
              content: Text(
                result.message.isNotEmpty
                    ? result.message
                    : '${picked.name} was created as a stylist.',
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(dialogContext).pop(),
                  child: const Text('OK'),
                ),
              ],
            );
          },
        );
      },
    );
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
              trailing:
                  _sort == StylistSort.recent ? const Icon(Icons.check) : null,
              onTap: () => _setSort(StylistSort.recent),
            ),
            ListTile(
              title: const Text("Name (A → Z)"),
              trailing:
                  _sort == StylistSort.nameAsc ? const Icon(Icons.check) : null,
              onTap: () => _setSort(StylistSort.nameAsc),
            ),
            ListTile(
              title: const Text("Name (Z → A)"),
              trailing:
                  _sort == StylistSort.nameDesc ? const Icon(Icons.check) : null,
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

  List<StylistItem> _sortedStylists(List<StylistItem> items) {
    final sorted = [...items];

    switch (_sort) {
      case StylistSort.recent:
        sorted.sort((a, b) {
          final aTime = a.createdAt ?? DateTime.fromMillisecondsSinceEpoch(0);
          final bTime = b.createdAt ?? DateTime.fromMillisecondsSinceEpoch(0);
          return bTime.compareTo(aTime);
        });
        break;
      case StylistSort.nameAsc:
        sorted.sort((a, b) {
          final aName = (a.user?.name ?? '').toLowerCase();
          final bName = (b.user?.name ?? '').toLowerCase();
          return aName.compareTo(bName);
        });
        break;
      case StylistSort.nameDesc:
        sorted.sort((a, b) {
          final aName = (a.user?.name ?? '').toLowerCase();
          final bName = (b.user?.name ?? '').toLowerCase();
          return bName.compareTo(aName);
        });
        break;
    }

    return sorted;
  }

  @override
  Widget build(BuildContext context) {
    final stylistState = ref.watch(salonStylistViewModelProvider);

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
        child: stylistState.when(
          loading: () => const _SalonStylistsLoadingView(),
          error: (error, _) => RefreshIndicator(
            onRefresh: _refresh,
            child: ListView(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
              children: [
                StylistSearchField(
                  searchFn: _searchStylists,
                  onPick: _openCreateSheet,
                ),
                const SizedBox(height: 24),
                _ErrorStateView(
                  message: error.toString(),
                  onRetry: _refresh,
                ),
              ],
            ),
          ),
          data: (data) {
            final items = _sortedStylists(data.items);

            return RefreshIndicator(
              onRefresh: _refresh,
              child: ListView(
                physics: const AlwaysScrollableScrollPhysics(),
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
                    child: StylistSearchField(
                      searchFn: _searchStylists,
                      onPick: _openCreateSheet,
                    ),
                  ),
                  const Divider(height: 1),
                  if (items.isEmpty)
                    const Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 32,
                      ),
                      child: _EmptyStateView(),
                    )
                  else
                    Padding(
                      padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
                      child: Column(
                        children: [
                          _StylistsSummaryRow(
                            total: data.total,
                            shown: items.length,
                          ),
                          const SizedBox(height: 12),
                          ListView.separated(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: items.length,
                            separatorBuilder: (_, _) =>
                                const SizedBox(height: 10),
                            itemBuilder: (context, i) {
                              final stylist = items[i];
                              return _SalonStylistCard(stylist: stylist);
                            },
                          ),
                        ],
                      ),
                    ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}

class _SalonStylistCard extends StatelessWidget {
  final StylistItem stylist;

  const _SalonStylistCard({
    required this.stylist,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;

    final fullName = stylist.user?.name.trim().isNotEmpty == true
        ? stylist.user!.name.trim()
        : 'Unknown stylist';

    final username = stylist.user?.username.trim().isNotEmpty == true
        ? '@${stylist.user!.username.trim()}'
        : 'No username';

    final imageUrl = stylist.user?.profilePictureUrl ?? '';
    final title = stylist.title.trim();
    final bio = stylist.bio.trim();

    return Material(
      color: cs.surfaceContainerLow,
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => StylistDetailPage(stylistId: stylist.id),
            ),
          );
        },
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _StylistAvatar(
                imageUrl: imageUrl,
                fallbackText: fullName,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            fullName,
                            style: theme.textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                        if (stylist.isOwner)
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: cs.primaryContainer,
                              borderRadius: BorderRadius.circular(999),
                            ),
                            child: Text(
                              'Owner',
                              style: theme.textTheme.labelSmall?.copyWith(
                                color: cs.onPrimaryContainer,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      username,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: cs.onSurfaceVariant,
                      ),
                    ),
                    if (title.isNotEmpty) ...[
                      const SizedBox(height: 8),
                      Text(
                        title,
                        style: theme.textTheme.bodyMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                    if (bio.isNotEmpty) ...[
                      const SizedBox(height: 6),
                      Text(
                        bio,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: cs.onSurfaceVariant,
                        ),
                      ),
                    ],
                    const SizedBox(height: 10),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: [
                        _StatusChip(
                          label: stylist.isActive ? 'Active' : 'Inactive',
                          icon: stylist.isActive
                              ? Icons.verified_outlined
                              : Icons.pause_circle_outline,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              Icon(
                Icons.chevron_right,
                color: cs.onSurfaceVariant,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _StylistAvatar extends StatelessWidget {
  final String imageUrl;
  final String fallbackText;

  const _StylistAvatar({
    required this.imageUrl,
    required this.fallbackText,
  });

  @override
  Widget build(BuildContext context) {
    final initials = fallbackText.characters.take(1).toString().toUpperCase();

    if (imageUrl.trim().isEmpty) {
      return CircleAvatar(
        radius: 24,
        child: Text(initials),
      );
    }

    return CircleAvatar(
      radius: 24,
      backgroundImage: NetworkImage(imageUrl),
      onBackgroundImageError: (_, _) {},
      child: null,
    );
  }
}

class _StatusChip extends StatelessWidget {
  final String label;
  final IconData icon;

  const _StatusChip({
    required this.label,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: cs.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(999),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: cs.onSurfaceVariant),
          const SizedBox(width: 6),
          Text(
            label,
            style: theme.textTheme.labelMedium?.copyWith(
              color: cs.onSurfaceVariant,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

class _StylistsSummaryRow extends StatelessWidget {
  final int total;
  final int shown;

  const _StylistsSummaryRow({
    required this.total,
    required this.shown,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;

    return Row(
      children: [
        Expanded(
          child: Text(
            shown == total
                ? '$total stylists'
                : '$shown of $total stylists',
            style: theme.textTheme.titleSmall?.copyWith(
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
        Text(
          'Pull down to refresh',
          style: theme.textTheme.bodySmall?.copyWith(
            color: cs.onSurfaceVariant,
          ),
        ),
      ],
    );
  }
}

class _SalonStylistsLoadingView extends StatelessWidget {
  const _SalonStylistsLoadingView();

  @override
  Widget build(BuildContext context) {
    return ListView(
      physics: const AlwaysScrollableScrollPhysics(),
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
      children: const [
        _LoadingCard(height: 64),
        SizedBox(height: 16),
        _LoadingCard(height: 96),
        SizedBox(height: 10),
        _LoadingCard(height: 96),
        SizedBox(height: 10),
        _LoadingCard(height: 96),
      ],
    );
  }
}

class _LoadingCard extends StatelessWidget {
  final double height;

  const _LoadingCard({
    required this.height,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Container(
      height: height,
      decoration: BoxDecoration(
        color: cs.surfaceContainerLow,
        borderRadius: BorderRadius.circular(16),
      ),
    );
  }
}

class _ErrorStateView extends StatelessWidget {
  final String message;
  final Future<void> Function() onRetry;

  const _ErrorStateView({
    required this.message,
    required this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;

    return Center(
      child: Column(
        children: [
          Icon(
            Icons.error_outline,
            size: 48,
            color: cs.error,
          ),
          const SizedBox(height: 12),
          Text(
            'Failed to load stylists',
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            message,
            textAlign: TextAlign.center,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: cs.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 16),
          FilledButton(
            onPressed: () => onRetry(),
            child: const Text('Try again'),
          ),
        ],
      ),
    );
  }
}

class _EmptyStateView extends StatelessWidget {
  const _EmptyStateView();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;

    return Center(
      child: Column(
        children: [
          Icon(
            Icons.content_cut_outlined,
            size: 48,
            color: cs.onSurfaceVariant,
          ),
          const SizedBox(height: 12),
          Text(
            'No stylists yet',
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Your salon stylists will appear here once they are added.',
            textAlign: TextAlign.center,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: cs.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }
}

enum StylistSort {
  recent,
  nameAsc,
  nameDesc,
}