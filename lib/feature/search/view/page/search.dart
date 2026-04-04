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
              Text(
                'Search',
                style: Theme.of(context).textTheme.headlineLarge,
              ),
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
              Expanded(
                child: _buildBody(context, searchAsync, searchVm.query),
              ),
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
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, _) => Center(
        child: Text(e.toString(), style: Theme.of(context).textTheme.bodyMedium),
      ),
      data: (results) {
        if (results.isEmpty) {
          return const Center(child: Text('No results found'));
        }
        return SearchResultList(results: results);
      },
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
