import 'package:africa_beuty/feature/search/model/search.dart';
import 'package:africa_beuty/feature/search/view/widgets/results/search_result_item.dart';
import 'package:flutter/material.dart';

class SearchResultList extends StatelessWidget {
  final List<SearchResult> results;

  const SearchResultList({super.key, required this.results});

  @override
  Widget build(BuildContext context) {
    final visibleResults = _dedupe(results);

    return ListView.builder(
      itemCount: visibleResults.length,
      itemBuilder: (context, index) {
        final result = visibleResults[index];
        return SearchResultItem(result: result);
      },
    );
  }

  List<SearchResult> _dedupe(List<SearchResult> source) {
    final seen = <String>{};
    final deduped = <SearchResult>[];

    for (final result in source) {
      final key = switch (result) {
        SearchHashtagResult(:final tag) => 'hashtag:${tag.toLowerCase()}',
        _ => '${result.entity.name}:${result.id}',
      };

      if (seen.add(key)) deduped.add(result);
    }

    return deduped;
  }
}
