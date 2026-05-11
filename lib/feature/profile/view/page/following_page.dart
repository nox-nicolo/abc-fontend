import 'package:africa_beuty/feature/profile/model/following.dart';
import 'package:africa_beuty/feature/profile/view/widget/view_salon_profile.dart';
import 'package:africa_beuty/feature/profile/view_model/following.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class FollowingPage extends ConsumerWidget {
  const FollowingPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(myFollowingViewModelProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Following'), centerTitle: true),
      body: state.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text(e.toString())),
        data: (items) => items.isEmpty
            ? const _EmptyState()
            : RefreshIndicator(
                onRefresh: () =>
                    ref.read(myFollowingViewModelProvider.notifier).refresh(),
                child: ListView.separated(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  itemCount: items.length,
                  separatorBuilder: (context, i) => const Divider(height: 1),
                  itemBuilder: (context, i) => _SalonTile(
                    salon: items[i],
                    onUnfollow: () async {
                      final ok = await ref
                          .read(myFollowingViewModelProvider.notifier)
                          .unfollow(items[i].salonId);
                      if (!context.mounted) return;
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            ok
                                ? 'Unfollowed ${items[i].title}'
                                : 'Failed to unfollow',
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
      ),
    );
  }
}

// ── Salon tile ────────────────────────────────────────────────────────────────

class _SalonTile extends StatelessWidget {
  final FollowedSalonModel salon;
  final VoidCallback onUnfollow;

  const _SalonTile({required this.salon, required this.onUnfollow});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      leading: CircleAvatar(
        radius: 26,
        backgroundColor: scheme.surfaceContainerHighest,
        child: ClipOval(
          child: salon.profilePicture != null
              ? CachedNetworkImage(
                  imageUrl: salon.profilePicture!,
                  fit: BoxFit.cover,
                  width: 52,
                  height: 52,
                  errorWidget: (ctx, url, err) =>
                      const Icon(Icons.store_rounded),
                )
              : const Icon(Icons.store_rounded, size: 26),
        ),
      ),
      title: Text(
        salon.title,
        style: Theme.of(
          context,
        ).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w600),
      ),
      subtitle: Text(
        '@${salon.username}',
        style: Theme.of(
          context,
        ).textTheme.bodySmall?.copyWith(color: scheme.onSurfaceVariant),
      ),
      onTap: () => Navigator.of(context).push(
        MaterialPageRoute(
          builder: (_) => ViewServiceProfilePage(salonId: salon.salonId),
        ),
      ),
      trailing: OutlinedButton(
        onPressed: () => _confirmUnfollow(context),
        style: OutlinedButton.styleFrom(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
        ),
        child: const Text('Unfollow'),
      ),
    );
  }

  void _confirmUnfollow(BuildContext context) {
    showModalBottomSheet(
      context: context,
      showDragHandle: true,
      builder: (_) => Padding(
        padding: const EdgeInsets.fromLTRB(16, 0, 16, 32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CircleAvatar(
              radius: 34,
              backgroundColor: Theme.of(
                context,
              ).colorScheme.surfaceContainerHighest,
              child: ClipOval(
                child: salon.profilePicture != null
                    ? CachedNetworkImage(
                        imageUrl: salon.profilePicture!,
                        fit: BoxFit.cover,
                        width: 68,
                        height: 68,
                        errorWidget: (ctx, url, err) =>
                            const Icon(Icons.store_rounded),
                      )
                    : const Icon(Icons.store_rounded, size: 34),
              ),
            ),
            const SizedBox(height: 12),
            Text(
              'Unfollow ${salon.title}?',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Theme.of(context).colorScheme.error,
                  foregroundColor: Theme.of(context).colorScheme.onError,
                ),
                onPressed: () {
                  Navigator.pop(context);
                  onUnfollow();
                },
                child: const Text('Unfollow'),
              ),
            ),
            const SizedBox(height: 8),
            SizedBox(
              width: double.infinity,
              child: OutlinedButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Cancel'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Empty state ───────────────────────────────────────────────────────────────

class _EmptyState extends StatelessWidget {
  const _EmptyState();

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.store_outlined, size: 64, color: scheme.onSurfaceVariant),
          const SizedBox(height: 16),
          Text(
            'Not following anyone yet',
            style: Theme.of(
              context,
            ).textTheme.titleMedium?.copyWith(color: scheme.onSurfaceVariant),
          ),
          const SizedBox(height: 8),
          Text(
            'Salons you follow will appear here.',
            style: Theme.of(
              context,
            ).textTheme.bodySmall?.copyWith(color: scheme.onSurfaceVariant),
          ),
        ],
      ),
    );
  }
}
