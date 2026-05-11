import 'package:africa_beuty/feature/post/view/page/view_post.dart';
import 'package:africa_beuty/feature/profile/view/page/view_profile.dart';
import 'package:africa_beuty/feature/saved/model/saved_item.dart';
import 'package:africa_beuty/feature/saved/provider/saved_provider.dart';
import 'package:africa_beuty/feature/service/view/page/service_view_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SavedPage extends ConsumerWidget {
  const SavedPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final saved = ref.watch(savedCollectionProvider);

    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Saved'),
          centerTitle: true,
          bottom: const TabBar(
            tabs: [
              Tab(text: 'Salons'),
              Tab(text: 'Services'),
              Tab(text: 'Styles'),
            ],
          ),
        ),
        body: saved.when(
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (error, _) => _SavedError(
            message: error.toString(),
            onRetry: () => ref.invalidate(savedCollectionProvider),
          ),
          data: (collection) => RefreshIndicator(
            onRefresh: () async => ref.invalidate(savedCollectionProvider),
            child: TabBarView(
              children: [
                _SavedSalonsList(items: collection.salons),
                _SavedServicesList(items: collection.services),
                _SavedStylesList(items: collection.styles),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _SavedSalonsList extends StatelessWidget {
  const _SavedSalonsList({required this.items});

  final List<SavedSalon> items;

  @override
  Widget build(BuildContext context) {
    if (items.isEmpty) {
      return const _EmptySavedList(
        icon: Icons.storefront_outlined,
        title: 'No saved salons yet',
      );
    }

    return ListView.separated(
      padding: const EdgeInsets.all(16),
      itemCount: items.length,
      separatorBuilder: (_, _) => const SizedBox(height: 8),
      itemBuilder: (context, index) {
        final salon = items[index];
        return ListTile(
          leading: _SavedThumb(
            imageUrl: salon.imageUrl,
            icon: Icons.storefront_rounded,
          ),
          title: Text(salon.name),
          subtitle: Text(
            [
              if (salon.username != null) '@${salon.username}',
              salon.subtitle,
            ].whereType<String>().join(' • '),
          ),
          trailing: const Icon(Icons.chevron_right),
          onTap: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (_) =>
                    ViewProfilePage(isServiceProfile: true, userId: salon.id),
              ),
            );
          },
        );
      },
    );
  }
}

class _SavedServicesList extends StatelessWidget {
  const _SavedServicesList({required this.items});

  final List<SavedService> items;

  @override
  Widget build(BuildContext context) {
    if (items.isEmpty) {
      return const _EmptySavedList(
        icon: Icons.design_services_outlined,
        title: 'No saved services yet',
      );
    }

    return ListView.separated(
      padding: const EdgeInsets.all(16),
      itemCount: items.length,
      separatorBuilder: (_, _) => const SizedBox(height: 8),
      itemBuilder: (context, index) {
        final service = items[index];
        final price = service.price == null
            ? null
            : '${service.currency ?? ''} ${service.price!.toStringAsFixed(0)}'
                  .trim();

        return ListTile(
          leading: _SavedThumb(
            imageUrl: service.imageUrl,
            icon: Icons.design_services_rounded,
          ),
          title: Text(service.name),
          subtitle: Text(
            [service.salonName, price].whereType<String>().join(' • '),
          ),
          trailing: const Icon(Icons.chevron_right),
          onTap: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (_) => ServiceDetailsPage(serviceId: service.id),
              ),
            );
          },
        );
      },
    );
  }
}

class _SavedStylesList extends StatelessWidget {
  const _SavedStylesList({required this.items});

  final List<SavedStyle> items;

  @override
  Widget build(BuildContext context) {
    if (items.isEmpty) {
      return const _EmptySavedList(
        icon: Icons.auto_awesome_outlined,
        title: 'No saved styles yet',
      );
    }

    return GridView.builder(
      padding: const EdgeInsets.all(16),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 12,
        crossAxisSpacing: 12,
        childAspectRatio: 0.78,
      ),
      itemCount: items.length,
      itemBuilder: (context, index) {
        final style = items[index];
        return InkWell(
          borderRadius: BorderRadius.circular(10),
          onTap: () {
            Navigator.of(context).push(
              MaterialPageRoute(builder: (_) => PostViewPage(postId: style.id)),
            );
          },
          child: Ink(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: Theme.of(context).colorScheme.surfaceContainerHighest,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: ClipRRect(
                    borderRadius: const BorderRadius.vertical(
                      top: Radius.circular(10),
                    ),
                    child: _SavedImageFill(
                      imageUrl: style.imageUrl,
                      icon: Icons.auto_awesome,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        style.title,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(fontWeight: FontWeight.w700),
                      ),
                      if (style.salonName != null) ...[
                        const SizedBox(height: 4),
                        Text(
                          style.salonName!,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                      ],
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _SavedThumb extends StatelessWidget {
  const _SavedThumb({this.imageUrl, required this.icon});

  final String? imageUrl;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: SizedBox(
        width: 52,
        height: 52,
        child: _SavedImageFill(imageUrl: imageUrl, icon: icon),
      ),
    );
  }
}

class _SavedImageFill extends StatelessWidget {
  const _SavedImageFill({this.imageUrl, required this.icon});

  final String? imageUrl;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    if (imageUrl != null && imageUrl!.isNotEmpty) {
      return Image.network(
        imageUrl!,
        fit: BoxFit.cover,
        width: double.infinity,
        height: double.infinity,
        errorBuilder: (_, _, _) => _fallback(context),
      );
    }
    return _fallback(context);
  }

  Widget _fallback(BuildContext context) {
    return Container(
      color: Theme.of(context).colorScheme.surfaceContainerHighest,
      child: Icon(icon),
    );
  }
}

class _EmptySavedList extends StatelessWidget {
  const _EmptySavedList({required this.icon, required this.title});

  final IconData icon;
  final String title;

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        SizedBox(height: MediaQuery.of(context).size.height * 0.22),
        Icon(icon, size: 64, color: Theme.of(context).colorScheme.outline),
        const SizedBox(height: 16),
        Center(
          child: Text(title, style: Theme.of(context).textTheme.titleMedium),
        ),
      ],
    );
  }
}

class _SavedError extends StatelessWidget {
  const _SavedError({required this.message, required this.onRetry});

  final String message;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(message, textAlign: TextAlign.center),
            const SizedBox(height: 12),
            FilledButton(onPressed: onRetry, child: const Text('Retry')),
          ],
        ),
      ),
    );
  }
}
