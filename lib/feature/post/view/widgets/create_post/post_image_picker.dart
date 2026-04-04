import 'dart:io';
import 'package:africa_beuty/feature/post/view/widgets/create_post/image_edit_data.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class PostImagePicker extends StatelessWidget {
  final List<XFile> selectedImages;
  final VoidCallback onPickFromCamera;
  final VoidCallback onPickFromGallery;
  final Function(int) onEditImage;
  final Function(int) onRemoveImage;
  final bool canAddMore;
  final double aspectRatio;
  final ValueChanged<double> onAspectRatioChanged;

  const PostImagePicker({
    super.key,
    required this.selectedImages,
    required this.onPickFromCamera,
    required this.onPickFromGallery,
    required this.onEditImage,
    required this.onRemoveImage,
    required this.canAddMore,
    required this.aspectRatio,
    required this.onAspectRatioChanged,
  });

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    if (selectedImages.isEmpty) return const SizedBox();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // ── Aspect ratio chips ──────────────────────────────────
        SizedBox(
          height: 36,
          child: ListView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.only(bottom: 4),
            children: AspectRatioOption.predefinedRatios.map((opt) {
              final selected = aspectRatio == opt.ratio;
              return Padding(
                padding: const EdgeInsets.only(right: 8),
                child: ChoiceChip(
                  label: Text(opt.label),
                  selected: selected,
                  onSelected: (_) => onAspectRatioChanged(opt.ratio),
                  visualDensity: VisualDensity.compact,
                  labelStyle: TextStyle(
                    fontSize: 12,
                    color: selected
                        ? scheme.onPrimary
                        : scheme.onSurfaceVariant,
                  ),
                ),
              );
            }).toList(),
          ),
        ),

        const SizedBox(height: 8),

        // ── Image previews ──────────────────────────────────────
        Expanded(
          child: ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: List.generate(selectedImages.length, (index) {
                  return _ImageTile(
                    file: File(selectedImages[index].path),
                    onRemove: () => onRemoveImage(index),
                    onEdit: () => onEditImage(index),
                    aspectRatio: aspectRatio == -1 ? 1.0 : aspectRatio,
                  );
                }),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _ImageTile extends StatelessWidget {
  final File file;
  final VoidCallback onRemove;
  final VoidCallback onEdit;
  final double aspectRatio;

  const _ImageTile({
    required this.file,
    required this.onRemove,
    required this.onEdit,
    required this.aspectRatio,
  });

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width * 0.75;
    final height = width / aspectRatio;

    return Container(
      margin: const EdgeInsets.only(right: 8),
      width: width,
      height: height.clamp(160.0, 500.0),
      child: Stack(
        fit: StackFit.expand,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Image.file(file, fit: BoxFit.cover),
          ),

          // Remove button (top-left)
          Positioned(
            top: 8,
            left: 8,
            child: GestureDetector(
              onTap: onRemove,
              child: Container(
                padding: const EdgeInsets.all(4),
                decoration: const BoxDecoration(
                  color: Colors.black54,
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.close, color: Colors.white, size: 18),
              ),
            ),
          ),

          // Edit/crop button (top-right)
          Positioned(
            top: 8,
            right: 8,
            child: GestureDetector(
              onTap: onEdit,
              child: Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: Colors.black54,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Icon(Icons.crop, color: Colors.white, size: 18),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
