import 'package:africa_beuty/core/widgets/app_state.dart';
import 'package:africa_beuty/core/widgets/skeleton.dart';
import 'package:africa_beuty/feature/search/model/search.dart';
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
      return const _IdleContent();
    }

    return searchAsync.when(
      loading: () => const _SearchResultsSkeleton(),
      error: (e, _) => AppErrorState(
        message: e,
        onRetry: () =>
            ref.read(searchViewModelProvider.notifier).onQueryChanged(query),
      ),
      data: (results) {
        if (results.isEmpty) {
          return const AppEmptyState(
            icon: Icons.search_off_rounded,
            title: 'No results found',
            message: 'Try a different name, salon, style, or hashtag.',
          );
        }
        return SearchResultList(results: results);
      },
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

class _IdleContent extends StatelessWidget {
  const _IdleContent();

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: const [
        NearbySalonsSection(),
        SizedBox(height: 28),
        TopSalonsSection(),
        SizedBox(height: 28),
        TrendingStylesSection(),
        SizedBox(height: 16),
      ],
    );
  }
}
