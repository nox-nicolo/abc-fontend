import 'package:africa_beuty/feature/search/model/search.dart';
import 'package:africa_beuty/feature/search/view/widgets/results/search_result_item.dart';
import 'package:flutter/material.dart';

class SearchResultList extends StatelessWidget {
  final List<SearchResult> results;
  final VoidCallback? onLoadMore;
  final ValueChanged<SearchResult>? onResultSelected;
  final bool isLoadingMore;

  const SearchResultList({
    super.key,
    required this.results,
    this.onLoadMore,
    this.onResultSelected,
    this.isLoadingMore = false,
  });

  @override
  Widget build(BuildContext context) {
    final visibleResults = _dedupe(results);

    return NotificationListener<ScrollNotification>(
      onNotification: (notification) {
        final loadMore = onLoadMore;
        if (loadMore == null || isLoadingMore) return false;
        final metrics = notification.metrics;
        if (metrics.pixels >= metrics.maxScrollExtent - 240) {
          loadMore();
        }
        return false;
      },
      child: ListView.builder(
        itemCount: visibleResults.length + (isLoadingMore ? 1 : 0),
        itemBuilder: (context, index) {
          if (index >= visibleResults.length) {
            return const Padding(
              padding: EdgeInsets.symmetric(vertical: 16),
              child: Center(child: CircularProgressIndicator.adaptive()),
            );
          }
          final result = visibleResults[index];
          return SearchResultItem(
            result: result,
            onSelected: () => onResultSelected?.call(result),
          );
        },
      ),
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
