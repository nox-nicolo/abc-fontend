import 'package:flutter/material.dart';

class ProfileToolPage extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final List<ProfileToolItem> items;

  const ProfileToolPage({
    super.key,
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.items,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;

    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 28),
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CircleAvatar(
                radius: 24,
                backgroundColor: scheme.primary.withValues(alpha: 0.12),
                child: Icon(icon, color: scheme.primary),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Text(
                  subtitle,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: scheme.onSurfaceVariant,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 22),
          DecoratedBox(
            decoration: BoxDecoration(
              color: scheme.surfaceContainerHighest.withValues(alpha: 0.55),
              borderRadius: BorderRadius.circular(18),
              border: Border.all(
                color: scheme.outlineVariant.withValues(alpha: 0.55),
              ),
            ),
            child: Column(
              children: [
                for (var i = 0; i < items.length; i++) ...[
                  _ToolRow(item: items[i]),
                  if (i != items.length - 1)
                    Divider(
                      height: 1,
                      indent: 60,
                      color: scheme.outlineVariant.withValues(alpha: 0.55),
                    ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class ProfileToolItem {
  final IconData icon;
  final String title;
  final String subtitle;
  final String badge;

  const ProfileToolItem({
    required this.icon,
    required this.title,
    required this.subtitle,
    this.badge = '',
  });
}

class _ToolRow extends StatelessWidget {
  final ProfileToolItem item;

  const _ToolRow({required this.item});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;

    return ListTile(
      leading: CircleAvatar(
        radius: 18,
        backgroundColor: scheme.primary.withValues(alpha: 0.1),
        child: Icon(item.icon, color: scheme.primary, size: 19),
      ),
      title: Text(
        item.title,
        style: theme.textTheme.bodyLarge?.copyWith(
          fontWeight: FontWeight.w700,
        ),
      ),
      subtitle: Text(item.subtitle),
      trailing: item.badge.isEmpty
          ? const Icon(Icons.chevron_right_rounded)
          : Text(
              item.badge,
              style: theme.textTheme.labelMedium?.copyWith(
                color: scheme.primary,
                fontWeight: FontWeight.w800,
              ),
            ),
    );
  }
}
