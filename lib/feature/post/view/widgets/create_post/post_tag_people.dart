import 'package:africa_beuty/feature/post/view_model/post_tag_people.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:africa_beuty/feature/post/model/post_tag_people.dart';

class PostTagPeople extends ConsumerStatefulWidget {
  final List<PostTagPeopleModel> initialSelected;

  const PostTagPeople(
    {
      super.key, 
      required this.initialSelected
    }
  );

  @override
  ConsumerState<PostTagPeople> createState() => _PostTagPeopleState();
}

class _PostTagPeopleState extends ConsumerState<PostTagPeople> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();

    Future.microtask(() {
      final vm = ref.read(tagPeopleViewModelProvider.notifier);

      vm.restoreSelected(widget.initialSelected);
      
      vm.loadRecommended();
      vm.loadRecent();
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final state = ref.watch(tagPeopleViewModelProvider);
    final vm = ref.read(tagPeopleViewModelProvider.notifier);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Tag People"),
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context, state.value?.selected ?? []);
            },
            child: Text(
              "Done",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: theme.colorScheme.primary,
              ),
            ),
          ),
        ],
      ),

      body: state.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, _) => Center(child: Text(err.toString())),

        data: (data) {
          final selected = data.selected;
          final recommended = data.recommended;
          final recent = data.recent;
          final searchResults = data.search;

          return Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                TextField(
                  controller: _searchController,
                  decoration: InputDecoration(
                    hintText: "Search people…",
                    prefixIcon: const Icon(Icons.search),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  onChanged: vm.search,
                ),

                const SizedBox(height: 16),

                if (selected.isNotEmpty)
                  buildSelectedSection(theme, selected, vm),

                const SizedBox(height: 16),

                Expanded(
                  child: searchResults.isNotEmpty
                      ? buildUserList(searchResults, selected, vm)
                      : buildDefaultLists(
                          recommended,
                          recent,
                          selected,
                          vm,
                        ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget buildSelectedSection(
    ThemeData theme,
    List<PostTagPeopleModel> selected,
    TagPeopleViewModel vm,
  ) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: theme.colorScheme.primaryContainer.withOpacity(0.3),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Wrap(
        spacing: 8,
        runSpacing: 8,
        children: selected.map((user) {
          return Chip(
            avatar: CircleAvatar(
              backgroundImage: NetworkImage(user.profilePicture),
            ),
            label: Text(user.username),
            deleteIcon: const Icon(Icons.close),
            onDeleted: () => vm.toggleSelect(user),
          );
        }).toList(),
      ),
    );
  }

  Widget buildDefaultLists(
    List<PostTagPeopleModel> recommended,
    List<PostTagPeopleModel> recent,
    List<PostTagPeopleModel> selected,
    TagPeopleViewModel vm,
  ) {
    return ListView(
      children: [
        if (recommended.isNotEmpty)
          buildUserSection("Recommended", recommended, selected, vm),

        if (recent.isNotEmpty)
          buildUserSection("Recent", recent, selected, vm),
      ],
    );
  }

  Widget buildUserList(
    List<PostTagPeopleModel> users,
    List<PostTagPeopleModel> selected,
    TagPeopleViewModel vm,
  ) {
    return ListView.builder(
      itemCount: users.length,
      itemBuilder: (_, index) {
        return buildUserTile(users[index], selected, vm);
      },
    );
  }

  Widget buildUserSection(
    String title,
    List<PostTagPeopleModel> users,
    List<PostTagPeopleModel> selected,
    TagPeopleViewModel vm,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 12),
        Text(
          title,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        const SizedBox(height: 8),

        ...users.map((u) => buildUserTile(u, selected, vm)),
      ],
    );
  }

  Widget buildUserTile(
    PostTagPeopleModel user,
    List<PostTagPeopleModel> selected,
    TagPeopleViewModel vm,
  ) {
    final isSelected = selected.any((u) => u.id == user.id);

    return ListTile(
      leading: CircleAvatar(
        backgroundImage: NetworkImage(user.profilePicture),
      ),
      title: Text(user.username),
      subtitle: Text(user.name),
      trailing: Icon(
        isSelected ? Icons.check_circle : Icons.circle_outlined,
        color: isSelected ? Colors.green : Colors.grey,
      ),
      onTap: () => vm.toggleSelect(user),
    );
  }
}
