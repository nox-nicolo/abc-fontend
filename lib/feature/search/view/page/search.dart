import 'dart:async';

import 'package:africa_beuty/core/widgets/app_state.dart';
import 'package:africa_beuty/core/widgets/skeleton.dart';
import 'package:africa_beuty/feature/ads/provider/ad_provider.dart';
import 'package:africa_beuty/feature/ads/view/sponsored_ad_post.dart';
import 'package:africa_beuty/feature/search/model/search.dart';
import 'package:africa_beuty/feature/search/repository/search_history.dart';
import 'package:africa_beuty/feature/search/view/widgets/nearby_salons_section.dart';
import 'package:africa_beuty/feature/search/view/widgets/results/search_result_list.dart';
import 'package:africa_beuty/feature/search/view/widgets/search_input.dart';
import 'package:africa_beuty/feature/search/view/widgets/top_salons_section.dart';
import 'package:africa_beuty/feature/search/view/widgets/trending_styles_section.dart';
import 'package:africa_beuty/feature/search/view_model/search.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SearchPage extends ConsumerStatefulWidget {
  const SearchPage({super.key});

  @override
  ConsumerState<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends ConsumerState<SearchPage> {
  final TextEditingController _searchController = TextEditingController();
  final SearchHistoryRepository _historyRepository = SearchHistoryRepository();
  late Future<List<SearchHistoryItem>> _historyFuture;

  @override
  void initState() {
    super.initState();
    _historyFuture = _loadHistory();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final searchAsync = ref.watch(searchViewModelProvider);
    final searchVm = ref.read(searchViewModelProvider.notifier);

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 12),
              Text('Search', style: Theme.of(context).textTheme.headlineLarge),
              const SizedBox(height: 16),
              SearchInput(
                controller: _searchController,
                onChanged: searchVm.onQueryChanged,
                onClear: () {
                  _searchController.clear();
                  searchVm.clear();
                },
              ),
              const SizedBox(height: 16),
              Expanded(child: _buildBody(context, searchAsync, searchVm.query)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBody(
    BuildContext context,
    AsyncValue<List<SearchResult>> searchAsync,
    String query,
  ) {
    if (query.isEmpty) {
      return _IdleContent(
        historyFuture: _historyFuture,
        onHistoryTap: _runHistorySearch,
        onRemoveHistory: _removeHistory,
        onClearHistory: _clearHistory,
      );
    }

    return searchAsync.when(
      loading: () => const _SearchResultsSkeleton(),
      error: (e, _) => AppErrorState(
        message: e,
        onRetry: () =>
            ref.read(searchViewModelProvider.notifier).onQueryChanged(query),
      ),
      data: (results) {
        final vm = ref.read(searchViewModelProvider.notifier);
        if (results.isEmpty) {
          return const AppEmptyState(
            icon: Icons.search_off_rounded,
            title: 'No results found',
            message: 'Try a different name, salon, style, or hashtag.',
          );
        }
        return SearchResultList(
          results: results,
          onResultSelected: (result) => _saveSearchClick(query, result),
          isLoadingMore: vm.isLoadingMore,
          onLoadMore: vm.canLoadMore ? vm.loadMore : null,
        );
      },
    );
  }

  Future<List<SearchHistoryItem>> _loadHistory() async {
    final result = await _historyRepository.list(limit: 10);
    return result.fold((_) => const <SearchHistoryItem>[], (items) => items);
  }

  void _refreshHistory() {
    setState(() {
      _historyFuture = _loadHistory();
    });
  }

  void _runHistorySearch(SearchHistoryItem item) {
    _searchController.text = item.query;
    ref.read(searchViewModelProvider.notifier).onQueryChanged(item.query);
  }

  void _saveSearchClick(String query, SearchResult result) {
    unawaited(
      _historyRepository
          .saveResult(query: query, result: result)
          .then((_) => mounted ? _refreshHistory() : null),
    );
  }

  void _removeHistory(SearchHistoryItem item) {
    unawaited(
      _historyRepository
          .deleteItem(item.id)
          .then((_) => mounted ? _refreshHistory() : null),
    );
  }

  void _clearHistory() {
    unawaited(
      _historyRepository.clear().then(
        (_) => mounted ? _refreshHistory() : null,
      ),
    );
  }
}

class _SearchResultsSkeleton extends StatelessWidget {
  const _SearchResultsSkeleton();

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      itemCount: 8,
      separatorBuilder: (_, _) => const SizedBox(height: 4),
      itemBuilder: (_, _) => const SkeletonListTile(
        roundLeading: false,
        trailingWidth: 42,
        padding: EdgeInsets.symmetric(vertical: 10),
      ),
    );
  }
}

// ── Idle content (no query typed) ─────────────────────────────────────────────

class _IdleContent extends ConsumerWidget {
  const _IdleContent({
    required this.historyFuture,
    required this.onHistoryTap,
    required this.onRemoveHistory,
    required this.onClearHistory,
  });

  final Future<List<SearchHistoryItem>> historyFuture;
  final ValueChanged<SearchHistoryItem> onHistoryTap;
  final ValueChanged<SearchHistoryItem> onRemoveHistory;
  final VoidCallback onClearHistory;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ads = ref.watch(adsByPlacementProvider(adPlacementSearch));

    return ListView(
      children: [
        _RecentSearchesSection(
          future: historyFuture,
          onTap: onHistoryTap,
          onRemove: onRemoveHistory,
          onClear: onClearHistory,
        ),
        const NearbySalonsSection(),
        const SizedBox(height: 28),
        ads.maybeWhen(
          data: (items) => items.isEmpty
              ? const SizedBox.shrink()
              : SponsoredAdPost(ad: items.first),
          orElse: () => const SizedBox.shrink(),
        ),
        const TopSalonsSection(),
        const SizedBox(height: 28),
        const TrendingStylesSection(),
        const SizedBox(height: 16),
      ],
    );
  }
}

class _RecentSearchesSection extends StatelessWidget {
  const _RecentSearchesSection({
    required this.future,
    required this.onTap,
    required this.onRemove,
    required this.onClear,
  });

  final Future<List<SearchHistoryItem>> future;
  final ValueChanged<SearchHistoryItem> onTap;
  final ValueChanged<SearchHistoryItem> onRemove;
  final VoidCallback onClear;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<SearchHistoryItem>>(
      future: future,
      builder: (context, snapshot) {
        final items = snapshot.data ?? const <SearchHistoryItem>[];
        if (items.isEmpty) return const SizedBox.shrink();

        return Padding(
          padding: const EdgeInsets.only(bottom: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(
                    'Recent searches',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const Spacer(),
                  TextButton(onPressed: onClear, child: const Text('Clear')),
                ],
              ),
              const SizedBox(height: 4),
              ...items.map(
                (item) => ListTile(
                  dense: true,
                  contentPadding: EdgeInsets.zero,
                  leading: const Icon(Icons.history_rounded),
                  title: Text(
                    item.query,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  subtitle: Text(_historyLabel(item)),
                  trailing: IconButton(
                    tooltip: 'Remove',
                    icon: const Icon(Icons.close_rounded),
                    onPressed: () => onRemove(item),
                  ),
                  onTap: () => onTap(item),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  String _historyLabel(SearchHistoryItem item) {
    return switch (item.entity) {
      'salon' => 'Salon',
      'service' => 'Service',
      'hashtag' => 'Hashtag',
      'user' => 'User',
      _ => 'Search',
    };
  }
}
