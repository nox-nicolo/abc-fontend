import 'package:africa_beuty/core/model/services.dart';
import 'package:africa_beuty/core/widgets/skeleton.dart';
import 'package:africa_beuty/core/view_model/getminor_viewmodel.dart';
import 'package:africa_beuty/feature/booking/provider/booking_draft.dart';
import 'package:africa_beuty/feature/booking/view/widgets/start_booking/choose_salon.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class DiscoverStylePage extends ConsumerStatefulWidget {
  const DiscoverStylePage({super.key});

  @override
  ConsumerState<DiscoverStylePage> createState() => _DiscoverStylePageState();
}

class _DiscoverStylePageState extends ConsumerState<DiscoverStylePage> {
  String _query = '';

  @override
  Widget build(BuildContext context) {
    final stylesState = ref.watch(getMinorServiceViewModelProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Choose a Style')),
      body: Column(
        children: [
          // Search
          Padding(
            padding: const EdgeInsets.all(16),
            child: TextField(
              onChanged: (v) => setState(() => _query = v),
              decoration: InputDecoration(
                hintText: 'Search style (e.g. Curly, Braids)',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
            ),
          ),

          // Styles Grid
          Expanded(
            child: stylesState.when(
              loading: () => const _StyleGridSkeleton(),
              error: (err, _) => Center(child: Text(err.toString())),
              data: (styles) {
                final filtered = styles.where((s) {
                  return s.name.toLowerCase().contains(_query.toLowerCase());
                }).toList();

                return GridView.builder(
                  padding: const EdgeInsets.all(16),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    mainAxisSpacing: 12,
                    crossAxisSpacing: 12,
                    childAspectRatio: 0.9,
                  ),
                  itemCount: filtered.length,
                  itemBuilder: (_, index) {
                    final style = filtered[index];
                    return _StyleCard(
                      style: style,
                      onTap: () {
                        // Save selected style to draft
                        ref
                            .read(bookingDraftProvider.notifier)
                            .selectStyle(style);

                        //  Go to choose salon
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) =>
                                ChooseSalonPage(subServiceId: style.id),
                          ),
                        );
                      },
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _StyleGridSkeleton extends StatelessWidget {
  const _StyleGridSkeleton();

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      padding: const EdgeInsets.all(16),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 12,
        crossAxisSpacing: 12,
        childAspectRatio: 0.9,
      ),
      itemCount: 6,
      itemBuilder: (_, _) => const SkeletonCard(
        width: double.infinity,
        height: double.infinity,
        radius: 16,
      ),
    );
  }
}

class _StyleCard extends StatelessWidget {
  final PostMinorCategoriesModel style;
  final VoidCallback onTap;

  const _StyleCard({required this.style, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final hasImage = style.fileName.isNotEmpty;

    return InkWell(
      borderRadius: BorderRadius.circular(16),
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          color: Theme.of(context).colorScheme.surfaceContainerHighest,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // -----------------------
            // Image (optional)
            // -----------------------
            if (hasImage)
              Expanded(
                child: ClipRRect(
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(16),
                  ),
                  child: Image.network(
                    style.fileName,
                    fit: BoxFit.cover,
                    errorBuilder: (_, _, _) {
                      // Fail silently → show nothing
                      return const SizedBox.shrink();
                    },
                  ),
                ),
              ),

            // -----------------------
            // Name
            // -----------------------
            Padding(
              padding: const EdgeInsets.all(12),
              child: Text(
                style.name,
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
