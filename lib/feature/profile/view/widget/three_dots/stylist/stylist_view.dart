import 'package:africa_beuty/feature/profile/view/widget/three_dots/stylist/stylist_edit.dart';
import 'package:flutter/material.dart';
import 'package:icons_plus/icons_plus.dart';

class StylistDetailPage extends StatefulWidget {
  const StylistDetailPage({
    super.key,
    required this.stylistId,
  });

  final String stylistId;

  @override
  State<StylistDetailPage> createState() => _StylistDetailPageState();
}

class _StylistDetailPageState extends State<StylistDetailPage> {
  late Future<SalonStylist> _future;

  @override
  void initState() {
    super.initState();
    _future = _fetchStylist(widget.stylistId);
  }

  Future<SalonStylist> _fetchStylist(String stylistId) async {
    // TODO: Replace with your real API call:
    // final json = await api.get("/salon/stylists/$stylistId");
    // return SalonStylist.fromMap(json);

    await Future.delayed(const Duration(milliseconds: 420));

    final mock = <String, dynamic>{
      "id": stylistId,
      "salon_id": "ddb4bb51-2dd2-4d59-bf44-7959ad07f46b",
      "user_id": "27e25454-1430-437c-b6d4-2ecb16f180a7",
      "title": "Senior Stylist",
      "bio": "Specialized in braids, natural hair care & bridal looks.",
      "is_owner": false,
      "is_active": false,
      "created_at": "2026-02-25T18:32:21.102236",
      "user": {
        "id": "27e25454-1430-437c-b6d4-2ecb16f180a7",
        "username": "custom_pka0xu",
        "name": "Customer",
        "profile_picture_url":
            "http://192.168.43.160:8000/assets/images/user_profile_picture//user.png"
      }
    };

    return SalonStylist.fromMap(mock);
  }

  void _refresh() {
    setState(() {
      _future = _fetchStylist(widget.stylistId);
    });
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return FutureBuilder<SalonStylist>(
      future: _future,
      builder: (context, snap) {
        final isLoading = snap.connectionState == ConnectionState.waiting;

        return Scaffold(
          extendBodyBehindAppBar: true,
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            title: const Text("Stylist"),
            actions: [
              TextButton.icon(
                onPressed: () async {

                  final result = await EditSalonStylistSheet.open(
                    context,
                    name: "customer",
                    username: "custom_pka0xu",
                    imageUrl: "http://192.168.43.160:8000/assets/images/user_profile_picture//user.png",
                    title: "Senior Stylist",
                    bio: "Braids specialist",
                    isOwner: true,
                    isActive: true
                  );

                  if (result != null) {

                    /// later call API
                    print(result);

                  }
                },
                icon: const Icon(Icons.edit_outlined),
                label: const Text("Edit   "),
              ),
              PopupMenuButton<_MenuAction>(
                tooltip: "More",
                enabled: !isLoading,
                onSelected: (action) async {
                  if (action == _MenuAction.refresh) {
                    _refresh();
                  }
                  if (action == _MenuAction.delete) {
                    final ok = await _confirmDelete(context);
                    if (!context.mounted) return;
                    if (ok == true) {
                      // TODO: delete
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text("Delete (not implemented)")),
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
                        Text("Delete stylist"),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
          body: _buildBody(context, snap),
        );
      },
    );
  }

  Widget _buildBody(BuildContext context, AsyncSnapshot<SalonStylist> snap) {
    final cs = Theme.of(context).colorScheme;

    if (snap.connectionState == ConnectionState.waiting) {
      return const Center(child: CircularProgressIndicator());
    }

    if (snap.hasError) {
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
              const SizedBox(height: 12),
              FilledButton.tonalIcon(
                onPressed: _refresh,
                icon: const Icon(Icons.refresh),
                label: const Text("Try again"),
              )
            ],
          ),
        ),
      );
    }

    final stylist = snap.data!;
    final user = stylist.user;

    return Stack(
      children: [
        // Gradient backdrop (modern feel)
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

        // Content
        SafeArea(
          child: CustomScrollView(
            slivers: [
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
                  child: Column(
                    children: [
                      const SizedBox(height: 42), // space under transparent appbar

                      // Hero header card
                      _HeroHeaderCard(stylist: stylist),

                      const SizedBox(height: 14),

                      // Quick stats / status row (compact & modern)
                      _PillsRow(stylist: stylist),

                      const SizedBox(height: 18),

                      // Details Cards
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
                              icon: Icons.alternate_email,
                              label: "Username",
                              value: user.username.startsWith("@")
                                  ? user.username
                                  : "@${user.username}",
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

  String _formatDateTime(DateTime dt) {
    if (dt.millisecondsSinceEpoch == 0) return "—";
    final y = dt.year.toString().padLeft(4, "0");
    final m = dt.month.toString().padLeft(2, "0");
    final d = dt.day.toString().padLeft(2, "0");
    final hh = dt.hour.toString().padLeft(2, "0");
    final mm = dt.minute.toString().padLeft(2, "0");
    return "$y-$m-$d  $hh:$mm";
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

/// ---------------------------
/// DATA MODELS
/// ---------------------------

class SalonStylist {
  final String id;
  final String salonId;
  final String userId;
  final String title;
  final String bio;
  final bool isOwner;
  final bool isActive;
  final DateTime createdAt;
  final StylistUser user;

  const SalonStylist({
    required this.id,
    required this.salonId,
    required this.userId,
    required this.title,
    required this.bio,
    required this.isOwner,
    required this.isActive,
    required this.createdAt,
    required this.user,
  });

  factory SalonStylist.fromMap(Map<String, dynamic> json) {
    return SalonStylist(
      id: (json["id"] ?? "").toString(),
      salonId: (json["salon_id"] ?? "").toString(),
      userId: (json["user_id"] ?? "").toString(),
      title: (json["title"] ?? "").toString(),
      bio: (json["bio"] ?? "").toString(),
      isOwner: (json["is_owner"] ?? false) == true,
      isActive: (json["is_active"] ?? true) == true,
      createdAt: DateTime.tryParse((json["created_at"] ?? "").toString()) ??
          DateTime.fromMillisecondsSinceEpoch(0),
      user:
          StylistUser.fromMap((json["user"] ?? const {}) as Map<String, dynamic>),
    );
  }
}

class StylistUser {
  final String id;
  final String username;
  final String name;
  final String? profilePictureUrl;

  const StylistUser({
    required this.id,
    required this.username,
    required this.name,
    required this.profilePictureUrl,
  });

  factory StylistUser.fromMap(Map<String, dynamic> json) {
    return StylistUser(
      id: (json["id"] ?? "").toString(),
      username: (json["username"] ?? "").toString(),
      name: (json["name"] ?? "").toString(),
      profilePictureUrl: (json["profile_picture_url"] as String?),
    );
  }
}

/// ---------------------------
/// MODERN UI WIDGETS
/// ---------------------------

class _HeroHeaderCard extends StatelessWidget {
  const _HeroHeaderCard({required this.stylist});
  final SalonStylist stylist;

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
              name: u.name,
              imageUrl: u.profilePictureUrl,
              radius: 30,
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    u.name,
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.w800,
                        ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    u.username.startsWith("@") ? u.username : "@${u.username}",
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
  final SalonStylist stylist;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Wrap(
      spacing: 10,
      runSpacing: 10,
      children: [
        _Pill(
          icon: stylist.isActive ? Icons.check_circle_outline : Icons.pause_circle_outline,
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
        _Pill(
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
    if (parts.length == 1) return parts.first.characters.take(2).toString().toUpperCase();
    final a = parts[0].characters.take(1).toString();
    final b = parts[1].characters.take(1).toString();
    return (a + b).toUpperCase();
  }
}