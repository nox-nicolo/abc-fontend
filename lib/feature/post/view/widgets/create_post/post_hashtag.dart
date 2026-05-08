import 'package:africa_beuty/feature/post/model/post_hashtags.dart';
import 'package:africa_beuty/feature/post/view_model/post_hashtags.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class PostHashTagPage extends ConsumerStatefulWidget {
  final List<String> initialSelectedHashtags;
  const PostHashTagPage({super.key, this.initialSelectedHashtags = const []});

  @override
  ConsumerState<PostHashTagPage> createState() => _PostHashTagPageState();
}

class _PostHashTagPageState extends ConsumerState<PostHashTagPage> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // load initial
    Future.microtask(() {
      final vm = ref.read(hashtagViewModelProvider.notifier);
      vm.loadInitial();

      // If UI provided initial selected hashtags, set them explicitly in the provider.
      // Use setSelected (not toggle) so we sync instead of flipping existing selections.
      if (widget.initialSelectedHashtags.isNotEmpty) {
        vm.setSelected(widget.initialSelectedHashtags);
      }
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final vmState = ref.watch(hashtagViewModelProvider);
    final vm = ref.read(hashtagViewModelProvider.notifier);
    final theme = Theme.of(context);

    return vmState.when(
      loading: () => const Scaffold(body: Center(child: CircularProgressIndicator())),
      error: (err, st) => Scaffold(body: Center(child: Text('Error: $err'))),
      data: (state) {
        final recent = state.recent;
        final results = state.results;
        final selected = state.selected;

        return Scaffold(
          appBar: AppBar(
            title: const Text('Add Hashtags'),
            leading: IconButton(
              icon: const Icon(Icons.close),
              onPressed: () => Navigator.of(context).pop(),
            ),
            actions: [
              TextButton(
                onPressed: () async {
                  // persist selected to recent and return selected
                  await vm.persistSelectedAsRecent();

                  // read latest provider selection and return that
                  final latestSelected = ref.read(hashtagViewModelProvider).value?.selected ?? [];
                  Navigator.of(context).pop(latestSelected);
                },
                child: Text('Done', style: TextStyle(color: theme.colorScheme.primary, fontWeight: FontWeight.bold)),
              )
            ],
          ),
          body: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                TextField(
                  controller: _searchController,
                  decoration: InputDecoration(
                    hintText: 'Search hashtags…',
                    prefixIcon: const Icon(Icons.search),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  onChanged: (q) => vm.search(q),
                ),
                const SizedBox(height: 12),

                if (selected.isNotEmpty)
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: theme.colorScheme.primaryContainer.withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Wrap(
                      spacing: 8,
                      runSpacing: 4,
                      children: selected.map((s) {
                        return Chip(
                          label: Text(s),
                          onDeleted: () => vm.toggleSelect(s),
                        );
                      }).toList(),
                    ),
                  ),

                const SizedBox(height: 12),

                Expanded(
                  child: results.isNotEmpty
                      ? _buildList('Search', results, selected, vm)
                      : _buildListSections(recent, vm, selected),
                ),

                const SizedBox(height: 12),

                // Allow adding new hashtag if search text present and not in selected
                Builder(builder: (ctx) {
                  final q = _searchController.text.trim();
                  final formatted = q.isEmpty ? '' : (q.startsWith('#') ? q : '#$q');
                  final canAdd = formatted.length > 1 && !selected.any((s) => s.toLowerCase() == formatted.toLowerCase());
                  if (!canAdd) return const SizedBox.shrink();
                  return SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: () {
                        vm.addNewHashtag(q);
                        _searchController.clear();
                      },
                      icon: const Icon(Icons.add),
                      label: Text('Add "$formatted"'),
                    ),
                  );
                }),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildListSections(List<PostHashtagsModel> recent, HashtagViewModel vm, List<String> selected) {
    return ListView(
      children: [
        if (recent.isNotEmpty) _buildList('Recent', recent, selected, vm),
      ],
    );
  }

  Widget _buildList(String title, List<PostHashtagsModel> items, List<String> selected, HashtagViewModel vm) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
        const SizedBox(height: 8),
        ...items.map((item) {
          final isSelected = selected.any((s) => s.toLowerCase() == item.name.toLowerCase());
          return Builder(builder: (context) {
            return ListTile(
              title: Text(item.name),
              trailing: Icon(isSelected ? Icons.check_circle : Icons.add_circle_outline, color: isSelected ? Theme.of(context).colorScheme.primary : null),
              onTap: () => vm.toggleSelect(item.name),
            );
          });
        }),
      ],
    );
  }
}
