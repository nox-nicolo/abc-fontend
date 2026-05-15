import 'package:africa_beuty/core/view_model/getmajor_viewmodel.dart';
import 'package:africa_beuty/core/widgets/loader.dart';
import 'package:africa_beuty/feature/auth/view_model/uploadservice_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SelectService extends ConsumerStatefulWidget {
  const SelectService({super.key});

  @override
  ConsumerState<SelectService> createState() => _SelectServiceState();
}

class _SelectServiceState extends ConsumerState<SelectService> {
  final List<String> _selectedServiceIds = [];

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      ref.read(getMajorServiceViewModelProvider.notifier).getMajorService();
    });
  }

  @override
  Widget build(BuildContext context) {
    final isFetching =
        ref.watch(getMajorServiceViewModelProvider)?.isLoading == true;
    final isUploading =
        ref.watch(uploadServiceViewModelProvider)?.isLoading == true;
    final isLoading = isFetching || isUploading;
    final allMajorServices = ref.watch(getMajorServiceViewModelProvider);
    final scheme = Theme.of(context).colorScheme;

    if (isLoading) return const Scaffold(body: Loader());

    return Scaffold(
      body: allMajorServices?.when(
        data: (services) {
          if (services.isEmpty) {
            return const Center(child: Text('No services available'));
          }

          // Map id → name for chips
          final idToName = {for (final s in services) s.id: s.name};

          return SafeArea(
            child: CustomScrollView(
              slivers: [
                // ── Header ───────────────────────────────────────────────
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(24, 24, 24, 4),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'What are you into?',
                          style: Theme.of(context).textTheme.headlineMedium
                              ?.copyWith(fontWeight: FontWeight.w800),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          'Pick the services you love — we\'ll personalise your feed.',
                          style: Theme.of(context).textTheme.bodyMedium
                              ?.copyWith(color: scheme.onSurfaceVariant),
                        ),
                      ],
                    ),
                  ),
                ),

                // ── Selected chips ────────────────────────────────────────
                if (_selectedServiceIds.isNotEmpty)
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
                      child: Wrap(
                        spacing: 8,
                        runSpacing: 4,
                        children: _selectedServiceIds.map((id) {
                          return Chip(
                            label: Text(idToName[id] ?? id),
                            deleteIcon: const Icon(Icons.close, size: 16),
                            onDeleted: () =>
                                setState(() => _selectedServiceIds.remove(id)),
                            backgroundColor: scheme.primaryContainer,
                            labelStyle: TextStyle(
                              color: scheme.onPrimaryContainer,
                              fontWeight: FontWeight.w600,
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                  ),

                // ── Grid ──────────────────────────────────────────────────
                SliverPadding(
                  padding: const EdgeInsets.all(16),
                  sliver: SliverGrid(
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          mainAxisSpacing: 12,
                          crossAxisSpacing: 12,
                          childAspectRatio: 0.85,
                        ),
                    delegate: SliverChildBuilderDelegate((context, index) {
                      final svc = services[index];
                      final isSelected = _selectedServiceIds.contains(svc.id);

                      return GestureDetector(
                        onTap: () => setState(() {
                          isSelected
                              ? _selectedServiceIds.remove(svc.id)
                              : _selectedServiceIds.add(svc.id);
                        }),
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 180),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            border: isSelected
                                ? Border.all(color: scheme.primary, width: 3)
                                : null,
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(
                              isSelected ? 17 : 20,
                            ),
                            child: Stack(
                              fit: StackFit.expand,
                              children: [
                                // Image
                                Image.network(
                                  svc.fileName,
                                  fit: BoxFit.cover,
                                  errorBuilder: (ctx, err, st) => Container(
                                    color: scheme.surfaceContainerHighest,
                                    child: Icon(
                                      Icons.spa_outlined,
                                      size: 48,
                                      color: scheme.onSurfaceVariant,
                                    ),
                                  ),
                                ),

                                // Gradient overlay
                                DecoratedBox(
                                  decoration: BoxDecoration(
                                    gradient: LinearGradient(
                                      begin: Alignment.topCenter,
                                      end: Alignment.bottomCenter,
                                      colors: [
                                        Colors.transparent,
                                        Colors.black.withValues(alpha: 0.6),
                                      ],
                                      stops: const [0.5, 1.0],
                                    ),
                                  ),
                                ),

                                // Name label
                                Positioned(
                                  left: 12,
                                  right: 12,
                                  bottom: 12,
                                  child: Text(
                                    svc.name,
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w700,
                                      fontSize: 15,
                                      shadows: [
                                        Shadow(
                                          blurRadius: 4,
                                          color: Colors.black38,
                                        ),
                                      ],
                                    ),
                                  ),
                                ),

                                // Checkmark badge
                                if (isSelected)
                                  Positioned(
                                    top: 10,
                                    right: 10,
                                    child: Container(
                                      padding: const EdgeInsets.all(4),
                                      decoration: BoxDecoration(
                                        color: scheme.primary,
                                        shape: BoxShape.circle,
                                      ),
                                      child: Icon(
                                        Icons.check_rounded,
                                        color: scheme.onPrimary,
                                        size: 16,
                                      ),
                                    ),
                                  ),
                              ],
                            ),
                          ),
                        ),
                      );
                    }, childCount: services.length),
                  ),
                ),

                // ── Finish button ─────────────────────────────────────────
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(24, 8, 24, 32),
                    child: Column(
                      children: [
                        if (_selectedServiceIds.isEmpty)
                          Padding(
                            padding: const EdgeInsets.only(bottom: 12),
                            child: Text(
                              'Select at least one service to continue',
                              style: TextStyle(
                                color: scheme.onSurfaceVariant,
                                fontSize: 13,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        SizedBox(
                          width: double.infinity,
                          height: 52,
                          child: FilledButton(
                            onPressed: _selectedServiceIds.isEmpty
                                ? null
                                : () async {
                                    final nav = Navigator.of(context);
                                    final messenger = ScaffoldMessenger.of(
                                      context,
                                    );
                                    try {
                                      await ref
                                          .read(
                                            uploadServiceViewModelProvider
                                                .notifier,
                                          )
                                          .uploadService(
                                            selectedServices:
                                                _selectedServiceIds,
                                          );
                                      if (mounted) {
                                        nav.pushNamedAndRemoveUntil(
                                          '/page0',
                                          (_) => false,
                                        );
                                      }
                                    } catch (e) {
                                      if (mounted) {
                                        messenger.showSnackBar(
                                          SnackBar(content: Text(e.toString())),
                                        );
                                      }
                                    }
                                  },
                            child: Text(
                              _selectedServiceIds.isEmpty
                                  ? 'Continue'
                                  : 'Continue with ${_selectedServiceIds.length} service${_selectedServiceIds.length == 1 ? '' : 's'}',
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        },
        error: (error, _) => Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.error_outline, size: 64, color: scheme.error),
              const SizedBox(height: 16),
              const Text('Failed to load services'),
              const SizedBox(height: 8),
              FilledButton.tonal(
                onPressed: () => ref.refresh(getMajorServiceViewModelProvider),
                child: const Text('Retry'),
              ),
            ],
          ),
        ),
        loading: () => null,
      ),
    );
  }
}
