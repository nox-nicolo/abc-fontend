import 'package:africa_beuty/feature/search/model/search.dart';
import 'package:africa_beuty/feature/search/view/widgets/results/search_result_item.dart';
import 'package:flutter/material.dart';

class SearchResultList extends StatelessWidget {
  final List<SearchResult> results;

  const SearchResultList({
    super.key,
    required this.results,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: results.length,
      itemBuilder: (context, index) {
        final result = results[index];
        return SearchResultItem(result: result);
      }
    );
  }
}
