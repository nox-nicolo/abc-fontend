import 'dart:async';

import 'package:africa_beuty/feature/post/providers/post_repository_provider.dart';
import 'package:africa_beuty/feature/post/repositories/recent_share_users.dart';
import 'package:africa_beuty/feature/search/model/search.dart';
import 'package:africa_beuty/feature/search/repository/search.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

Future<int?> showPostShareSheet(
  BuildContext context,
  WidgetRef ref,
  String postId,
) async {
  final sharedCount = await showModalBottomSheet<int>(
    context: context,
    isScrollControlled: true,
    useSafeArea: true,
    builder: (_) => _PostShareSheet(parentRef: ref, postId: postId),
  );

  if (!context.mounted || sharedCount == null) return null;

  await showDialog<void>(
    context: context,
    builder: (_) => _PostSharedDialog(sharedCount: sharedCount),
  );

  return sharedCount;
}

class _PostShareSheet extends StatefulWidget {
  const _PostShareSheet({required this.parentRef, required this.postId});

  final WidgetRef parentRef;
  final String postId;

  @override
  State<_PostShareSheet> createState() => _PostShareSheetState();
}

class _PostShareSheetState extends State<_PostShareSheet> {
  final _search = TextEditingController();
  final _message = TextEditingController();
  final _repo = SearchRepositoryImpl();
  final _recentRepo = RecentShareUsersRepository();
  final Set<String> _selected = {};
  final Map<String, SearchUserResult> _selectedUsers = {};
  List<SearchUserResult> _recentUsers = const [];
  List<SearchUserResult> _users = const [];
  Timer? _debounce;
  bool _loading = false;
  bool _sending = false;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadRecent();
  }

  @override
  void dispose() {
    _debounce?.cancel();
    _search.dispose();
    _message.dispose();
    super.dispose();
  }

  Future<void> _loadRecent() async {
    final recent = await _recentRepo.load();
    if (!mounted) return;
    setState(() => _recentUsers = recent);
  }

  void _onSearchChanged(String value) {
    setState(() {});
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 300), () {
      _runSearch(value);
    });
  }

  Future<void> _runSearch(String value) async {
    final query = value.trim();
    if (query.isEmpty) {
      setState(() {
        _users = const [];
        _loading = false;
        _error = null;
      });
      return;
    }

    setState(() {
      _loading = true;
      _error = null;
    });

    final result = await _repo.searchUsers(query: query, limit: 20);
    if (!mounted) return;

    result.match(
      (failure) => setState(() {
        _loading = false;
        _users = const [];
        _error = failure.message;
      }),
      (items) => setState(() {
        _loading = false;
        _users = items;
      }),
    );
  }

  void _toggleUser(SearchUserResult user, bool? selected) {
    setState(() {
      if (selected == true) {
        _selected.add(user.id);
        _selectedUsers[user.id] = user;
      } else {
        _selected.remove(user.id);
        _selectedUsers.remove(user.id);
      }
    });
  }

  Future<void> _share() async {
    if (_selected.isEmpty || _sending) return;
    setState(() => _sending = true);
    final usersToRemember = _selected
        .map((id) => _selectedUsers[id])
        .whereType<SearchUserResult>()
        .toList();

    final result = await widget.parentRef
        .read(postRemoteRepoProviderProvider)
        .sharePost(
          postId: widget.postId,
          userIds: _selected.toList(),
          message: _message.text,
        );

    if (!mounted) return;
    setState(() => _sending = false);
    result.match(
      (failure) => ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(failure.message))),
      (count) async {
        if (count > 0) {
          await _recentRepo.saveUsed(usersToRemember);
        }
        if (mounted) Navigator.pop(context, count);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isSearching = _search.text.trim().isNotEmpty;
    final visibleUsers = isSearching ? _users : _recentUsers;

    return FractionallySizedBox(
      heightFactor: 0.86,
      child: Padding(
        padding: EdgeInsets.fromLTRB(
          16,
          16,
          16,
          MediaQuery.of(context).viewInsets.bottom + 16,
        ),
        child: Column(
          children: [
            Row(
              children: [
                Text(
                  'Share post',
                  style: theme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const Spacer(),
                IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(Icons.close_rounded),
                ),
              ],
            ),
            TextField(
              controller: _search,
              onChanged: _onSearchChanged,
              decoration: InputDecoration(
                prefixIcon: const Icon(Icons.search),
                hintText: 'Search people',
                suffixIcon: _search.text.isEmpty
                    ? null
                    : IconButton(
                        onPressed: () {
                          _search.clear();
                          _onSearchChanged('');
                          setState(() {});
                        },
                        icon: const Icon(Icons.close_rounded),
                      ),
              ),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _message,
              maxLines: 2,
              decoration: const InputDecoration(hintText: 'Add a message...'),
            ),
            const SizedBox(height: 10),
            Expanded(child: _buildPeopleList(isSearching, visibleUsers)),
            SizedBox(
              width: double.infinity,
              child: FilledButton.icon(
                onPressed: _selected.isEmpty || _sending ? null : _share,
                icon: _sending
                    ? const SizedBox(
                        width: 18,
                        height: 18,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Icon(Icons.send_rounded),
                label: Text(
                  _selected.isEmpty
                      ? 'Select people'
                      : 'Send to ${_selected.length}',
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPeopleList(bool isSearching, List<SearchUserResult> users) {
    if (_loading) return const Center(child: CircularProgressIndicator());

    if (_error != null) {
      return Center(child: Text(_error!));
    }

    if (users.isEmpty) {
      return Center(
        child: Text(
          isSearching
              ? 'No people found'
              : 'Search for people to share this post with.',
          textAlign: TextAlign.center,
        ),
      );
    }

    return ListView.builder(
      itemCount: users.length + 1,
      itemBuilder: (_, index) {
        if (index == 0) {
          return Padding(
            padding: const EdgeInsets.fromLTRB(4, 4, 4, 8),
            child: Text(
              isSearching ? 'Results' : 'Recent',
              style: Theme.of(context).textTheme.labelLarge,
            ),
          );
        }

        final user = users[index - 1];
        final selected = _selected.contains(user.id);
        return CheckboxListTile(
          value: selected,
          onChanged: (value) => _toggleUser(user, value),
          secondary: CircleAvatar(
            backgroundImage:
                user.avatarUrl != null && user.avatarUrl!.isNotEmpty
                ? NetworkImage(user.avatarUrl!)
                : null,
            child: user.avatarUrl == null || user.avatarUrl!.isEmpty
                ? const Icon(Icons.person)
                : null,
          ),
          title: Text(user.fullName ?? user.username),
          subtitle: Text('@${user.username}'),
        );
      },
    );
  }
}

class _PostSharedDialog extends StatelessWidget {
  const _PostSharedDialog({required this.sharedCount});

  final int sharedCount;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final alreadyShared = sharedCount == 0;

    return AlertDialog(
      icon: CircleAvatar(
        radius: 28,
        backgroundColor: alreadyShared
            ? colorScheme.surfaceContainerHighest
            : colorScheme.primaryContainer,
        child: Icon(
          alreadyShared ? Icons.check_circle_outline : Icons.send_rounded,
          color: alreadyShared
              ? colorScheme.onSurfaceVariant
              : colorScheme.onPrimaryContainer,
        ),
      ),
      title: Text(alreadyShared ? 'Already shared' : 'Post shared'),
      content: Text(
        alreadyShared
            ? 'You already shared this post with the selected people.'
            : sharedCount == 1
            ? 'Your post was sent to 1 person.'
            : 'Your post was sent to $sharedCount people.',
        textAlign: TextAlign.center,
      ),
      actionsAlignment: MainAxisAlignment.center,
      actions: [
        FilledButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Done'),
        ),
      ],
    );
  }
}
