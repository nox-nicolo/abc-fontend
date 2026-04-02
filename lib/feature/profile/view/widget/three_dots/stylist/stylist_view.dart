
import 'package:africa_beuty/feature/profile/model/three_dots/stylists/view_single_stylists.dart';
import 'package:africa_beuty/feature/profile/view/widget/three_dots/stylist/stylist_edit.dart';
import 'package:africa_beuty/feature/profile/view_model/stylist/edit_stylist.dart';
import 'package:africa_beuty/feature/profile/view_model/stylist/view_single_stylist.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:icons_plus/icons_plus.dart';

class StylistDetailPage extends ConsumerWidget {
  const StylistDetailPage({
    super.key,
    required this.stylistId,
  });

  final String stylistId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cs = Theme.of(context).colorScheme;
    final stylistState = ref.watch(salonStylistDetailViewModelProvider(stylistId));

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text("Stylist"),
        actions: [
          stylistState.maybeWhen(
            data: (stylist) => TextButton.icon(
              onPressed: () async {
                // final user = stylist.user;

                final result = await EditSalonStylistSheet.open(
                  context,
                  name: stylist.user?.name ?? '',
                  username: stylist.user?.username ?? '',
                  imageUrl: stylist.user?.profilePictureUrl ?? '',
                  title: stylist.title,
                  bio: stylist.bio,
                  isOwner: stylist.isOwner,
                  isActive: stylist.isActive,
                  onSubmit: (req) async {
                    final updated = await ref
                        .read(editStylistViewModelProvider.notifier)
                        .editStylist(
                          stylistId: stylist.id,
                          request: req,
                        );

                    if (!context.mounted) return;

                    ref
                        .read(salonStylistDetailViewModelProvider(stylist.id).notifier)
                        .getSalonStylistDetail(stylist.id);

                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Row(
                          children: [
                            // Modern success icon with a soft background
                            Container(
                              padding: const EdgeInsets.all(6),
                              decoration: BoxDecoration(
                                color: Colors.green.withOpacity(0.1),
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(
                                Icons.check_rounded,
                                color: Colors.green,
                                size: 18,
                              ),
                            ),
                            const SizedBox(width: 12),
                            // Flexible to prevent text overflow
                            Expanded(
                              child: Text(
                                updated.user?.name.isNotEmpty == true
                                    ? '${updated.user!.name} updated successfully'
                                    : 'Stylist updated successfully',
                                style: const TextStyle(
                                  color: Colors.black87,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ],
                        ),
                        backgroundColor: Colors.white,
                        behavior: SnackBarBehavior.floating,
                        elevation: 8,
                        // shadowColor: Colors.black.withOpacity(0.2),
                        margin: const EdgeInsets.fromLTRB(20, 0, 20, 40), // Floats above the bottom
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                          side: BorderSide(color: Colors.grey.withOpacity(0.1), width: 1),
                        ),
                        duration: const Duration(seconds: 3),
                      ),
                    );
                  },
                );
              },
              icon: const Icon(Icons.edit_outlined),
              label: const Text("Edit   "),
            ),
            orElse: () => const SizedBox.shrink(),
          ),
          PopupMenuButton<_MenuAction>(
            tooltip: "More",
            onSelected: (action) async {
              if (action == _MenuAction.refresh) {
                await ref
                    .read(salonStylistDetailViewModelProvider(stylistId).notifier)
                    .getSalonStylistDetail(stylistId);
              }

              if (action == _MenuAction.delete) {
                final ok = await _confirmDelete(context);
                if (!context.mounted) return;

                if (ok == true) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Row(
                        children: [
                          const Icon(Icons.info_outline, color: Colors.orangeAccent, size: 20),
                          const SizedBox(width: 12),
                          const Text(
                            "Delete not implemented",
                            style: TextStyle(
                              color: Colors.black87,
                              fontWeight: FontWeight.w500,
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                      backgroundColor: Colors.white,
                      behavior: SnackBarBehavior.floating,
                      elevation: 4,
                      margin: const EdgeInsets.all(20),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                        side: BorderSide(color: Colors.grey.shade200, width: 1),
                      ),
                      duration: const Duration(seconds: 2),
                    ),
                  );
                }
              }
            },
            itemBuilder: (_) => [
              const PopupMenuItem(
                value: _MenuAction.refresh,
                child: Row(
                  children: [
                    Icon(Icons.refresh),
                    SizedBox(width: 10),
                    Text("Refresh"),
                  ],
                ),
              ),
              PopupMenuItem(
                value: _MenuAction.delete,
                child: Row(
                  children: [
                    Icon(Icons.delete_outline, color: cs.error),
                    const SizedBox(width: 10),
                    const Text("Delete stylist"),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
      body: stylistState.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) => _DetailErrorView(
          message: error.toString(),
          onRetry: () {
            ref
                .read(salonStylistDetailViewModelProvider(stylistId).notifier)
                .getSalonStylistDetail(stylistId);
          },
        ),
        data: (stylist) => _DetailBody(stylist: stylist),
      ),
    );
  }

  Future<bool?> _confirmDelete(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Delete stylist?"),
        content: const Text(
          "This will remove the stylist from your salon. You can add them again later.",
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text("Cancel"),
          ),
          FilledButton(
            style: FilledButton.styleFrom(backgroundColor: cs.error),
            onPressed: () => Navigator.pop(context, true),
            child: const Text("Delete"),
          ),
        ],
      ),
    );
  }
}

enum _MenuAction { refresh, delete }

class _DetailBody extends StatelessWidget {
  const _DetailBody({required this.stylist});

  final SalonStylistDetail stylist;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final user = stylist.user;

    return Stack(
      children: [
        Positioned.fill(
          child: DecoratedBox(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  cs.primaryContainer.withOpacity(0.95),
                  cs.surface.withOpacity(0.2),
                  cs.secondaryContainer.withOpacity(0.55),
                ],
              ),
            ),
          ),
        ),
        SafeArea(
          child: CustomScrollView(
            slivers: [
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
                  child: Column(
                    children: [
                      const SizedBox(height: 42),
                      _HeroHeaderCard(stylist: stylist),
                      const SizedBox(height: 14),
                      _PillsRow(stylist: stylist),
                      const SizedBox(height: 18),
                      _GlassSection(
                        title: "About",
                        child: Column(
                          children: [
                            _InfoRow(
                              icon: Icons.badge_outlined,
                              label: "Title",
                              value: _dashIfEmpty(stylist.title),
                            ),
                            const SizedBox(height: 10),
                            _InfoRow(
                              icon: Icons.notes_outlined,
                              label: "Bio",
                              value: _dashIfEmpty(stylist.bio),
                              maxLines: 4,
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 14),
                      _GlassSection(
                        title: "Account",
                        child: Column(
                          children: [
                            _InfoRow(
                              icon: Icons.person_outline,
                              label: "Name",
                              value: _dashIfEmpty(user?.name ?? ''),
                            ),
                            const SizedBox(height: 10),
                            _InfoRow(
                              icon: Icons.alternate_email,
                              label: "Username",
                              value: _dashIfEmpty(
                                (user?.username ?? '').startsWith("@")
                                    ? (user?.username ?? '')
                                    : "@${user?.username ?? ''}",
                              ),
                            ),
                            const SizedBox(height: 10),
                            _InfoRow(
                              icon: Icons.schedule_outlined,
                              label: "Created",
                              value: _formatDateTime(stylist.createdAt),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 20),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  String _dashIfEmpty(String v) => v.trim().isEmpty ? "—" : v.trim();

  String _formatDateTime(DateTime? dt) {
    if (dt == null) return "—";
    final y = dt.year.toString().padLeft(4, "0");
    final m = dt.month.toString().padLeft(2, "0");
    final d = dt.day.toString().padLeft(2, "0");
    final hh = dt.hour.toString().padLeft(2, "0");
    final mm = dt.minute.toString().padLeft(2, "0");
    return "$y-$m-$d  $hh:$mm";
  }
}

class _DetailErrorView extends StatelessWidget {
  const _DetailErrorView({
    required this.message,
    required this.onRetry,
  });

  final String message;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.error_outline, size: 44, color: cs.error),
            const SizedBox(height: 10),
            Text(
              "Failed to load stylist",
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 8),
            Text(
              message,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 12),
            FilledButton.tonalIcon(
              onPressed: onRetry,
              icon: const Icon(Icons.refresh),
              label: const Text("Try again"),
            ),
          ],
        ),
      ),
    );
  }
}

/// ---------------------------
/// UI WIDGETS
/// ---------------------------

class _HeroHeaderCard extends StatelessWidget {
  const _HeroHeaderCard({required this.stylist});
  final SalonStylistDetail stylist;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final u = stylist.user;

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(22),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            cs.surface.withOpacity(0.40),
            cs.surface.withOpacity(0.18),
          ],
        ),
        border: Border.all(color: cs.onSurface.withOpacity(0.06)),
        boxShadow: [
          BoxShadow(
            blurRadius: 24,
            spreadRadius: -10,
            color: Colors.black.withOpacity(0.18),
            offset: const Offset(0, 14),
          )
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(14, 14, 14, 14),
        child: Row(
          children: [
            _UserAvatar(
              name: u?.name ?? '',
              imageUrl: u?.profilePictureUrl,
              radius: 30,
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    u?.name.isNotEmpty == true ? u!.name : 'Unknown stylist',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.w800,
                        ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    (u?.username ?? '').startsWith("@")
                        ? (u?.username ?? '')
                        : "@${u?.username ?? ''}",
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          color: cs.onSurfaceVariant,
                        ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 10),
                  Text(
                    stylist.title.trim().isEmpty ? "Stylist" : stylist.title.trim(),
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: cs.onSurfaceVariant,
                        ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _PillsRow extends StatelessWidget {
  const _PillsRow({required this.stylist});
  final SalonStylistDetail stylist;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 10,
      runSpacing: 10,
      children: [
        _Pill(
          icon: stylist.isActive
              ? Icons.check_circle_outline
              : Icons.pause_circle_outline,
          text: stylist.isActive ? "Active" : "Inactive",
        ),
        if (stylist.isOwner)
          const _Pill(
            icon: FontAwesome.crown_solid,
            text: "Owner",
          ),
        _Pill(
          icon: Icons.badge_outlined,
          text: stylist.title.trim().isEmpty ? "Stylist" : stylist.title.trim(),
        ),
        const _Pill(
          icon: Icons.person_outline,
          text: "User linked",
        ),
      ],
    );
  }
}

class _Pill extends StatelessWidget {
  const _Pill({required this.icon, required this.text});
  final IconData icon;
  final String text;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 9),
      decoration: BoxDecoration(
        color: cs.surface.withOpacity(0.22),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: cs.onSurface.withOpacity(0.06)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 18, color: cs.onSurface),
          const SizedBox(width: 8),
          Text(
            text,
            style: Theme.of(context).textTheme.labelLarge?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
          ),
        ],
      ),
    );
  }
}

class _GlassSection extends StatelessWidget {
  const _GlassSection({
    required this.title,
    required this.child,
  });

  final String title;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: cs.surface.withOpacity(0.20),
        border: Border.all(color: cs.onSurface.withOpacity(0.06)),
      ),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(14, 14, 14, 14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 12),
            child,
          ],
        ),
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  const _InfoRow({
    required this.icon,
    required this.label,
    required this.value,
    this.maxLines = 2,
  });

  final IconData icon;
  final String label;
  final String value;
  final int maxLines;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 36,
          height: 36,
          decoration: BoxDecoration(
            color: cs.surfaceContainerHighest.withOpacity(0.55),
            borderRadius: BorderRadius.circular(12),
          ),
          alignment: Alignment.center,
          child: Icon(icon, size: 18),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: Theme.of(context).textTheme.labelLarge?.copyWith(
                      color: cs.onSurfaceVariant,
                    ),
              ),
              const SizedBox(height: 2),
              Text(
                value,
                maxLines: maxLines,
                overflow: TextOverflow.ellipsis,
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _UserAvatar extends StatelessWidget {
  const _UserAvatar({
    required this.name,
    required this.imageUrl,
    required this.radius,
  });

  final String name;
  final String? imageUrl;
  final double radius;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final initials = _initials(name);

    return Container(
      width: radius * 2,
      height: radius * 2,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: cs.primaryContainer,
        boxShadow: [
          BoxShadow(
            blurRadius: 18,
            spreadRadius: -10,
            color: Colors.black.withOpacity(0.25),
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: ClipOval(
        child: (imageUrl == null || imageUrl!.isEmpty)
            ? Center(
                child: Text(
                  initials,
                  style: TextStyle(
                    fontWeight: FontWeight.w900,
                    fontSize: radius * 0.7,
                    color: cs.onPrimaryContainer,
                  ),
                ),
              )
            : Image.network(
                imageUrl!,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => Center(
                  child: Text(
                    initials,
                    style: TextStyle(
                      fontWeight: FontWeight.w900,
                      fontSize: radius * 0.7,
                      color: cs.onPrimaryContainer,
                    ),
                  ),
                ),
              ),
      ),
    );
  }

  String _initials(String v) {
    final parts = v.trim().split(RegExp(r"\s+"));
    if (parts.isEmpty) return "";
    if (parts.length == 1) {
      return parts.first.characters.take(2).toString().toUpperCase();
    }
    final a = parts[0].characters.take(1).toString();
    final b = parts[1].characters.take(1).toString();
    return (a + b).toUpperCase();
  }
}