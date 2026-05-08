import 'package:africa_beuty/feature/profile/model/three_dots/stylists/create_stylist.dart';
import 'package:flutter/material.dart';
import 'package:icons_plus/icons_plus.dart';

class SelectedStylistUser {
  final String id;
  final String name;
  final String username;
  final String? imageUrl;

  const SelectedStylistUser({
    required this.id,
    required this.name,
    required this.username,
    required this.imageUrl,
  });
}

class CreateSalonStylistSheet extends StatefulWidget {
  const CreateSalonStylistSheet({
    super.key,
    required this.user,
    this.onSubmit,
  });

  final SelectedStylistUser user;
  final Future<void> Function(CreateSalonStylistRequest req)? onSubmit;

  static Future<void> open(
    BuildContext context, {
    required SelectedStylistUser user,
    Future<void> Function(CreateSalonStylistRequest req)? onSubmit,
  }) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      showDragHandle: true,
      builder: (_) => CreateSalonStylistSheet(
        user: user,
        onSubmit: onSubmit,
      ),
    );
  }

  @override
  State<CreateSalonStylistSheet> createState() =>
      _CreateSalonStylistSheetState();
}

class _CreateSalonStylistSheetState extends State<CreateSalonStylistSheet> {
  final _formKey = GlobalKey<FormState>();

  final _titleCtrl = TextEditingController();
  final _bioCtrl = TextEditingController();

  bool _isOwner = false;
  bool _isActive = true;
  bool _submitting = false;

  @override
  void initState() {
    super.initState();
    _titleCtrl.text = "Stylist";
  }

  @override
  void dispose() {
    _titleCtrl.dispose();
    _bioCtrl.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (_submitting) return;

    final valid = _formKey.currentState?.validate() ?? false;
    if (!valid) return;

    final req = CreateSalonStylistRequest(
      title: _titleCtrl.text,
      bio: _bioCtrl.text,
      isOwner: _isOwner,
      isActive: _isActive,
      userId: widget.user.id,
    );

    setState(() => _submitting = true);

    try {
      if (widget.onSubmit != null) {
        await widget.onSubmit!(req);
        if (!mounted) return;
        Navigator.pop(context);
      } else {
        if (!mounted) return;
        Navigator.pop(context, req.toJson());
      }
    } catch (_) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Failed to create stylist")),
      );
    } finally {
      if (mounted) {
        setState(() => _submitting = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final bottomInset = MediaQuery.of(context).viewInsets.bottom;

    return Padding(
      padding: EdgeInsets.only(bottom: bottomInset),
      child: SafeArea(
        top: false,
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Create Stylist",
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              const SizedBox(height: 12),
              Material(
                color: cs.surfaceContainerLow,
                borderRadius: BorderRadius.circular(16),
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Row(
                    children: [
                      _UserAvatar(
                        name: widget.user.name,
                        imageUrl: widget.user.imageUrl,
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              widget.user.name,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: Theme.of(context).textTheme.titleMedium,
                            ),
                            const SizedBox(height: 2),
                            Text(
                              "@${widget.user.username.replaceAll("@", "")}",
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
                      const SizedBox(width: 8),
                      Icon(
                        Icons.verified_user_outlined,
                        color: cs.onSurfaceVariant,
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Form(
                key: _formKey,
                child: Column(
                  children: [
                    TextFormField(
                      controller: _titleCtrl,
                      textInputAction: TextInputAction.next,
                      decoration: const InputDecoration(
                        labelText: "Title",
                        hintText: "e.g. Senior Stylist, Barber, Nail Tech",
                        prefixIcon: Icon(Icons.badge_outlined),
                      ),
                      validator: (v) {
                        final value = (v ?? "").trim();
                        if (value.isEmpty) return "Title is required";
                        if (value.length < 2) return "Title is too short";
                        return null;
                      },
                    ),
                    const SizedBox(height: 12),
                    TextFormField(
                      controller: _bioCtrl,
                      minLines: 3,
                      maxLines: 6,
                      decoration: const InputDecoration(
                        labelText: "Bio",
                        hintText:
                            "Short description: specialties, experience, style…",
                        prefixIcon: Icon(Icons.notes_outlined),
                      ),
                      validator: (v) {
                        if (v != null && v.trim().length > 280) {
                          return "Bio is too long (max 280 characters)";
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 14),
                    _SwitchTile(
                      title: "Owner",
                      subtitle: "Mark this stylist as salon owner",
                      value: _isOwner,
                      onChanged: (v) => setState(() => _isOwner = v),
                      icon: Bootstrap.person_badge,
                    ),
                    const SizedBox(height: 8),
                    _SwitchTile(
                      title: "Active",
                      subtitle: "Inactive stylists won’t appear for booking",
                      value: _isActive,
                      onChanged: (v) => setState(() => _isActive = v),
                      icon: Icons.toggle_on_outlined,
                    ),
                    const SizedBox(height: 16),
                    SizedBox(
                      width: double.infinity,
                      child: FilledButton.icon(
                        onPressed: _submitting ? null : _submit,
                        icon: _submitting
                            ? const SizedBox(
                                width: 18,
                                height: 18,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                ),
                              )
                            : const Icon(Icons.person_add_alt_1),
                        label: Text(
                          _submitting ? "Creating..." : "Create Stylist",
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 8),
              Text(
                "user_id will be: ${widget.user.id}",
                style: Theme.of(context)
                    .textTheme
                    .bodySmall
                    ?.copyWith(color: cs.onSurfaceVariant),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _UserAvatar extends StatelessWidget {
  final String name;
  final String? imageUrl;

  const _UserAvatar({
    required this.name,
    required this.imageUrl,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final initials = _initials(name);

    return CircleAvatar(
      radius: 22,
      backgroundColor: cs.primaryContainer,
      foregroundColor: cs.onPrimaryContainer,
      child: (imageUrl == null || imageUrl!.isEmpty)
          ? Text(
              initials,
              style: const TextStyle(fontWeight: FontWeight.w700),
            )
          : ClipOval(
              child: Image.network(
                imageUrl!,
                width: 44,
                height: 44,
                fit: BoxFit.cover,
                errorBuilder: (_, _, _) => Center(
                  child: Text(
                    initials,
                    style: const TextStyle(fontWeight: FontWeight.w700),
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
      return parts.first.characters.take(2).toString();
    }
    return (parts[0].characters.take(1).toString() +
            parts[1].characters.take(1).toString())
        .toUpperCase();
  }
}

class _SwitchTile extends StatelessWidget {
  final String title;
  final String subtitle;
  final bool value;
  final ValueChanged<bool> onChanged;
  final IconData icon;

  const _SwitchTile({
    required this.title,
    required this.subtitle,
    required this.value,
    required this.onChanged,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Material(
      color: cs.surfaceContainerLow,
      borderRadius: BorderRadius.circular(14),
      child: SwitchListTile(
        value: value,
        onChanged: onChanged,
        title: Row(
          children: [
            Icon(icon, size: 18),
            const SizedBox(width: 8),
            Text(title),
          ],
        ),
        subtitle: Text(subtitle),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(14),
        ),
      ),
    );
  }
}