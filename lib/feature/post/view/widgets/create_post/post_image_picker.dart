import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class PostImagePicker extends StatelessWidget {
  final List<XFile> selectedImages;
  final VoidCallback onPickFromCamera;
  final VoidCallback onPickFromGallery;
  final Function(int) onEditImage;
  final Function(int) onRemoveImage;
  final bool canAddMore;

  const PostImagePicker({
    super.key,
    required this.selectedImages,
    required this.onPickFromCamera,
    required this.onPickFromGallery,
    required this.onEditImage,
    required this.onRemoveImage,
    required this.canAddMore,
  });

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    if (selectedImages.isEmpty) return const SizedBox();

    return Stack(
      children: [
        // Image preview scrollable container
        SizedBox(
          height: 500,
          width: double.infinity,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: List.generate(selectedImages.length, (index) {
                  return Container(
                    margin: const EdgeInsets.only(right: 12),
                    width: size.width * .8,
                    height: 500,
                    child: Image.file(
                      File(selectedImages[index].path),
                      fit: BoxFit.cover,
                    ),
                  );
                }),
              ),
            ),
          ),
        ),

        // Edit button (shared for now)
        Positioned(
          top: 12,
          right: 12,
          child: GestureDetector(
            onTap: () {
              // This is just a placeholder for now
              onEditImage(0); // Later you might want to pass selected index
            },
            child: Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: Colors.black54,
                borderRadius: BorderRadius.circular(20),
              ),
              child: const Icon(
                Icons.edit,
                color: Colors.white,
                size: 20,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
