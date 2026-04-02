import 'package:africa_beuty/feature/profile/model/three_dots/stylists/edit_stylist.dart';
import 'package:flutter/material.dart';

class EditSalonStylistSheet extends StatefulWidget {
  const EditSalonStylistSheet({
    super.key,
    required this.name,
    required this.username,
    required this.imageUrl,
    required this.title,
    required this.bio,
    required this.isOwner,
    required this.isActive,
    this.onSubmit,
  });

  final String name;
  final String username;
  final String? imageUrl;

  final String title;
  final String bio;
  final bool isOwner;
  final bool isActive;

  final Future<void> Function(EditSalonStylistRequest req)? onSubmit;

  static Future<void> open(
    BuildContext context, {
    required String name,
    required String username,
    required String? imageUrl,
    required String title,
    required String bio,
    required bool isOwner,
    required bool isActive,
    Future<void> Function(EditSalonStylistRequest req)? onSubmit,
  }) {
    return showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      showDragHandle: true,
      builder: (_) => EditSalonStylistSheet(
        name: name,
        username: username,
        imageUrl: imageUrl,
        title: title,
        bio: bio,
        isOwner: isOwner,
        isActive: isActive,
        onSubmit: onSubmit,
      ),
    );
  }

  @override
  State<EditSalonStylistSheet> createState() => _EditSalonStylistSheetState();
}

class _EditSalonStylistSheetState extends State<EditSalonStylistSheet> {
  final _formKey = GlobalKey<FormState>();

  late TextEditingController _titleCtrl;
  late TextEditingController _bioCtrl;

  late bool _isOwner;
  late bool _isActive;
  bool _submitting = false;

  @override
  void initState() {
    super.initState();

    _titleCtrl = TextEditingController(text: widget.title);
    _bioCtrl = TextEditingController(text: widget.bio);

    _isOwner = widget.isOwner;
    _isActive = widget.isActive;
  }

  @override
  void dispose() {
    _titleCtrl.dispose();
    _bioCtrl.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    if (_submitting) return;
    if (!(_formKey.currentState?.validate() ?? false)) return;

    final req = EditSalonStylistRequest(
      title: _titleCtrl.text,
      bio: _bioCtrl.text,
      isOwner: _isOwner,
      isActive: _isActive,
    );

    setState(() => _submitting = true);

    try {
      if (widget.onSubmit != null) {
        await widget.onSubmit!(req);
        if (!mounted) return;
        Navigator.pop(context);
      } else {
        if (!mounted) return;
        Navigator.pop(context);
      }
    } catch (_) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Failed to update stylist")),
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
    final bottom = MediaQuery.of(context).viewInsets.bottom;

    return Padding(
      padding: EdgeInsets.only(bottom: bottom),
      child: SafeArea(
        top: false,
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Edit Stylist",
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              const SizedBox(height: 16),
              Container(
                decoration: BoxDecoration(
                  color: cs.surfaceContainerLow,
                  borderRadius: BorderRadius.circular(16),
                ),
                padding: const EdgeInsets.all(12),
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: 24,
                      backgroundColor: cs.primaryContainer,
                      backgroundImage: widget.imageUrl != null &&
                              widget.imageUrl!.trim().isNotEmpty
                          ? NetworkImage(widget.imageUrl!)
                          : null,
                      child: widget.imageUrl == null ||
                              widget.imageUrl!.trim().isEmpty
                          ? Text(widget.name.characters.take(1).toString())
                          : null,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.name,
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
                          Text(
                            widget.username.startsWith("@")
                                ? widget.username
                                : "@${widget.username}",
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium
                                ?.copyWith(color: cs.onSurfaceVariant),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              Form(
                key: _formKey,
                child: Column(
                  children: [
                    TextFormField(
                      controller: _titleCtrl,
                      decoration: const InputDecoration(
                        labelText: "Title",
                        prefixIcon: Icon(Icons.badge_outlined),
                      ),
                      validator: (v) {
                        if ((v ?? "").trim().isEmpty) {
                          return "Title is required";
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 12),
                    TextFormField(
                      controller: _bioCtrl,
                      minLines: 3,
                      maxLines: 5,
                      decoration: const InputDecoration(
                        labelText: "Bio",
                        prefixIcon: Icon(Icons.notes_outlined),
                      ),
                    ),
                    const SizedBox(height: 14),
                    SwitchListTile(
                      value: _isOwner,
                      onChanged: (v) => setState(() => _isOwner = v),
                      title: const Text("Owner"),
                      subtitle: const Text("Mark stylist as salon owner"),
                    ),
                    SwitchListTile(
                      value: _isActive,
                      onChanged: (v) => setState(() => _isActive = v),
                      title: const Text("Active"),
                      subtitle: const Text(
                        "Inactive stylists won't appear for booking",
                      ),
                    ),
                    const SizedBox(height: 16),
                    SizedBox(
                      width: double.infinity,
                      child: FilledButton.icon(
                        onPressed: _submitting ? null : _save,
                        icon: _submitting
                            ? const SizedBox(
                                width: 18,
                                height: 18,
                                child: CircularProgressIndicator(strokeWidth: 2),
                              )
                            : const Icon(Icons.save),
                        label: Text(
                          _submitting ? "Saving..." : "Save changes",
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}