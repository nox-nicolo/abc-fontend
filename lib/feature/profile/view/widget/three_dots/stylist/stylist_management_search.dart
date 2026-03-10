import 'dart:async';
import 'package:flutter/material.dart';

/// Matches your API response shape:
/// {
///   "items": [ { id, username, name, profile_picture_url, ... } ],
///   "query": "string",
///   "count": 0
/// }
class StylistSearchResponse {
  final List<StylistSearchItem> items;
  final String query;
  final int count;

  const StylistSearchResponse({
    required this.items,
    required this.query,
    required this.count,
  });
}

class StylistSearchItem {
  final String id;
  final String username;
  final String name;
  final String? profilePictureUrl;

  const StylistSearchItem({
    required this.id,
    required this.username,
    required this.name,
    required this.profilePictureUrl,
  });

  // Optional: if later you want json parsing quickly
  factory StylistSearchItem.fromMap(Map<String, dynamic> json) {
    return StylistSearchItem(
      id: (json["id"] ?? "").toString(),
      username: (json["username"] ?? "").toString(),
      name: (json["name"] ?? "").toString(),
      profilePictureUrl: (json["profile_picture_url"] as String?),
    );
  }
}

/// Signature your page/provider will implement later.
typedef SearchStylistsFn = Future<StylistSearchResponse> Function(String query);

class StylistSearchField extends StatefulWidget {
  const StylistSearchField({
    super.key,
    required this.searchFn,
    this.onPick,
    this.hintText = "Search by username or name",
    this.debounceMs = 350,
    this.minChars = 2,
  });

  final SearchStylistsFn searchFn;
  final ValueChanged<StylistSearchItem>? onPick;
  final String hintText;
  final int debounceMs;
  final int minChars;

  @override
  State<StylistSearchField> createState() => _StylistSearchFieldState();
}

class _StylistSearchFieldState extends State<StylistSearchField> {
  final _ctrl = TextEditingController();
  final _focusNode = FocusNode();

  Timer? _debounce;
  bool _loading = false;
  String _lastQuery = "";
  StylistSearchResponse? _resp;
  Object? _error;

  @override
  void initState() {
    super.initState();
    _focusNode.addListener(() {
      // when user taps out, close dropdown
      if (!_focusNode.hasFocus) {
        setState(() {
          _resp = null;
          _error = null;
          _loading = false;
        });
      } else {
        // if focused and already has query, keep dropdown behavior
        if (_ctrl.text.trim().length >= widget.minChars) {
          _triggerSearch(_ctrl.text.trim());
        }
      }
    });
  }

  @override
  void dispose() {
    _debounce?.cancel();
    _ctrl.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _onChanged(String value) {
    final q = value.trim();
    _debounce?.cancel();

    if (q.length < widget.minChars) {
      setState(() {
        _loading = false;
        _error = null;
        _resp = null;
        _lastQuery = q;
      });
      return;
    }

    _debounce = Timer(Duration(milliseconds: widget.debounceMs), () {
      _triggerSearch(q);
    });
  }

  Future<void> _triggerSearch(String q) async {
    _lastQuery = q;
    setState(() {
      _loading = true;
      _error = null;
    });

    try {
      final res = await widget.searchFn(q);

      // avoid showing stale results if user typed quickly
      if (!mounted) return;
      if (_lastQuery != q) return;

      setState(() {
        _resp = res;
        _loading = false;
      });
    } catch (e) {
      if (!mounted) return;
      if (_lastQuery != q) return;

      setState(() {
        _error = e;
        _resp = null;
        _loading = false;
      });
    }
  }

  void _clear() {
    _ctrl.clear();
    setState(() {
      _resp = null;
      _error = null;
      _loading = false;
      _lastQuery = "";
    });
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    final showDropdown = _focusNode.hasFocus &&
        (_loading || _error != null || (_resp?.items.isNotEmpty ?? false));

    return Column(
      children: [
        TextField(
          controller: _ctrl,
          focusNode: _focusNode,
          onChanged: _onChanged,
          textInputAction: TextInputAction.search,
          decoration: InputDecoration(
            hintText: widget.hintText,
            prefixIcon: const Icon(Icons.search),
            suffixIcon: _ctrl.text.isEmpty
                ? null
                : IconButton(
                    tooltip: "Clear",
                    onPressed: _clear,
                    icon: const Icon(Icons.close),
                  ),
            filled: true,
            fillColor: cs.surfaceContainerHighest,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: BorderSide.none,
            ),
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
          ),
        ),

        // Dropdown results (below input)
        if (showDropdown) ...[
          const SizedBox(height: 8),
          Material(
            color: cs.surfaceContainerLow,
            elevation: 1,
            borderRadius: BorderRadius.circular(14),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(14),
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxHeight: 280),
                child: _buildDropdownBody(context),
              ),
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildDropdownBody(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    if (_loading) {
      return const Padding(
        padding: EdgeInsets.all(12),
        child: Row(
          children: [
            SizedBox(
              width: 18,
              height: 18,
              child: CircularProgressIndicator(strokeWidth: 2),
            ),
            SizedBox(width: 10),
            Text("Searching..."),
          ],
        ),
      );
    }

    if (_error != null) {
      return Padding(
        padding: const EdgeInsets.all(12),
        child: Text(
          "Failed to search. Try again.",
          style: Theme.of(context)
              .textTheme
              .bodyMedium
              ?.copyWith(color: cs.error),
        ),
      );
    }

    final items = _resp?.items ?? const <StylistSearchItem>[];
    if (items.isEmpty) {
      return const Padding(
        padding: EdgeInsets.all(12),
        child: Text("No results"),
      );
    }

    return ListView.separated(
      padding: EdgeInsets.zero,
      itemCount: items.length,
      separatorBuilder: (_, __) => Divider(
        height: 1,
        thickness: 1,
        color: cs.surfaceContainerHighest,
      ),
      itemBuilder: (context, i) {
        final it = items[i];
        return InkWell(
          onTap: () {
            // you can choose behavior:
            // 1) Keep query in field (current behavior)
            // 2) Replace text with picked username/name
            // _ctrl.text = it.username;

            widget.onPick?.call(it);

            // close dropdown after pick
            FocusScope.of(context).unfocus();
          },
          
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            child: Row(
              children: [
                _NetworkAvatar(
                  url: it.profilePictureUrl,
                  fallbackText: it.name,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        it.name,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: Theme.of(context).textTheme.titleSmall,
                      ),
                      const SizedBox(height: 2),
                      Text(
                        "@${it.username.replaceAll("@", "")}",
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: Theme.of(context)
                            .textTheme
                            .bodyMedium
                            ?.copyWith(color: cs.onSurfaceVariant),
                      ),
                    ],
                  ),
                ),
                Icon(Icons.add, color: cs.primary),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _NetworkAvatar extends StatelessWidget {
  const _NetworkAvatar({
    required this.url,
    required this.fallbackText,
  });

  final String? url;
  final String fallbackText;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    final initials = _initials(fallbackText);

    return CircleAvatar(
      radius: 20,
      backgroundColor: cs.primaryContainer,
      foregroundColor: cs.onPrimaryContainer,
      child: (url == null || url!.isEmpty)
          ? Text(
              initials,
              style: const TextStyle(fontWeight: FontWeight.w700),
            )
          : ClipOval(
              child: Image.network(
                url!,
                width: 40,
                height: 40,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => Center(
                  child: Text(
                    initials,
                    style: const TextStyle(fontWeight: FontWeight.w700),
                  ),
                ),
              ),
            ),
    );
  }

  String _initials(String name) {
    final parts = name.trim().split(RegExp(r"\s+"));
    if (parts.isEmpty) return "";
    if (parts.length == 1) return parts.first.characters.take(2).toString();
    return (parts[0].characters.take(1).toString() +
            parts[1].characters.take(1).toString())
        .toUpperCase();
  }
}