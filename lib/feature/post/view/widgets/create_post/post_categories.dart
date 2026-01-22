import 'package:africa_beuty/core/view_model/getminor_viewmodel.dart';
import 'package:africa_beuty/core/model/services.dart';
import 'package:africa_beuty/feature/post/providers/selected_category.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

class PostCategoriesPage extends ConsumerWidget {
  const PostCategoriesPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final categoryState = ref.watch(getMinorServiceViewModelProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Choose Category')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: categoryState.when(
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (err, stack) => Center(
            child: Text(err.toString(), style: const TextStyle(color: Colors.red)),
          ),
          data: (categories) => _CategoryContent(categories: categories),
        ),
      ),
    );
  }
}

// ✅ Convert to ConsumerStatefulWidget
class _CategoryContent extends ConsumerStatefulWidget {
  const _CategoryContent({required this.categories});

  final List<PostMinorCategoriesModel> categories;

  @override
  ConsumerState<_CategoryContent> createState() => _CategoryContentState();
}

class _CategoryContentState extends ConsumerState<_CategoryContent> {
  String _searchText = "";

  @override
  Widget build(BuildContext context) {
    final filteredCategories = widget.categories.where((cat) {
      return cat.name.toLowerCase().contains(_searchText.toLowerCase());
    }).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Select Category',
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
        ),
        const SizedBox(height: 32),
        TextField(
          onChanged: (val) => setState(() => _searchText = val),
          decoration: InputDecoration(
            hintText: 'Search categories...',
            prefixIcon: const Icon(Icons.search),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
          ),
        ),
        const SizedBox(height: 16),

        // Grid with tap support
        Expanded(
          child: MasonryGridView.count(
            crossAxisCount: 3,
            mainAxisSpacing: 12,
            crossAxisSpacing: 12,
            itemCount: filteredCategories.length,
            itemBuilder: (context, index) {
              final category = filteredCategories[index];
              return GestureDetector(
                onTap: () {
                  ref.read(selectedCategoryProvider.notifier).select(category);
                  Navigator.pop(context); // Back to CreatePostPage
                },
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: AspectRatio(
                        aspectRatio: 1,
                        child: Image.network(
                          category.fileName,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      category.name,
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
