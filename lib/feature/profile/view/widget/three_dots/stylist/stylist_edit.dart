import 'package:flutter/material.dart';

class EditSalonStylistRequest {
  final String title;
  final String bio;
  final bool isOwner;
  final bool isActive;

  const EditSalonStylistRequest({
    required this.title,
    required this.bio,
    required this.isOwner,
    required this.isActive,
  });

  Map<String, dynamic> toMap() => {
        "title": title.trim(),
        "bio": bio.trim(),
        "is_owner": isOwner,
        "is_active": isActive,
      };
}

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
  });

  final String name;
  final String username;
  final String? imageUrl;

  final String title;
  final String bio;
  final bool isOwner;
  final bool isActive;

  static Future<Map<String, dynamic>?> open(
    BuildContext context, {
    required String name,
    required String username,
    required String? imageUrl,
    required String title,
    required String bio,
    required bool isOwner,
    required bool isActive,
  }) {
    return showModalBottomSheet<Map<String, dynamic>>(
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

  void _save() {
    if (!(_formKey.currentState?.validate() ?? false)) return;

    final req = EditSalonStylistRequest(
      title: _titleCtrl.text,
      bio: _bioCtrl.text,
      isOwner: _isOwner,
      isActive: _isActive,
    );

    Navigator.pop(context, req.toMap());
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

              /// USER PREVIEW
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
                      backgroundImage: widget.imageUrl != null
                          ? NetworkImage(widget.imageUrl!)
                          : null,
                      child: widget.imageUrl == null
                          ? Text(widget.name.characters.first)
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
                            "@${widget.username}",
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

              /// FORM
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
                          "Inactive stylists won't appear for booking"),
                    ),

                    const SizedBox(height: 16),

                    SizedBox(
                      width: double.infinity,
                      child: FilledButton.icon(
                        onPressed: _save,
                        icon: const Icon(Icons.save),
                        label: const Text("Save changes"),
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