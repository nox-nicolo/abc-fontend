import 'dart:io';
import 'package:africa_beuty/feature/profile/view_model/salon.dart';
import 'package:africa_beuty/feature/profile/view_model/settings/profile_cover.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:cached_network_image/cached_network_image.dart';

class GalleryPage extends ConsumerStatefulWidget {
  const GalleryPage({super.key});

  @override
  ConsumerState<GalleryPage> createState() => _GalleryPageState();
}

class _GalleryPageState extends ConsumerState<GalleryPage> {
  final ImagePicker _picker = ImagePicker();

  // FIX: Initialize as empty lists immediately instead of using 'late'
  List<dynamic> _currentServerGallery = []; 
  final List<String> _idsToDelete = [];
  final List<File> _newFilesToUpload = [];

  @override
  void initState() {
    super.initState();
    // We use microtask to ensure the provider is read after the first frame
    Future.microtask(() {
      final salon = ref.read(salonProfileViewModelProvider).value;
      if (salon != null) {
        setState(() {
          _currentServerGallery = List.from(salon.gallery);
        });
      }
    });
  }

  Future<void> _pickAndCropImage(ImageSource source) async {
    final totalCount = _currentServerGallery.length + _newFilesToUpload.length;
    if (totalCount >= 10) {
      _showLimitReachedMessage();
      return;
    }

    final XFile? pickedFile = await _picker.pickImage(source: source);

    if (pickedFile != null && mounted) {
      final croppedFile = await ImageCropper().cropImage(
        sourcePath: pickedFile.path,
        aspectRatio: const CropAspectRatio(ratioX: 640, ratioY: 420),
        compressQuality: 90,
        uiSettings: [
          AndroidUiSettings(
            toolbarTitle: 'Crop Salon Image',
            toolbarColor: Theme.of(context).colorScheme.surface,
            toolbarWidgetColor: Colors.black,
            initAspectRatio: CropAspectRatioPreset.original,
            lockAspectRatio: true,
          ),
          IOSUiSettings(title: 'Crop Image', aspectRatioLockEnabled: true),
        ],
      );

      if (croppedFile != null) {
        setState(() {
          _newFilesToUpload.add(File(croppedFile.path));
        });
      }
    }
  }

  void _removeExistingImage(int index) {
    setState(() {
      final item = _currentServerGallery[index];
      // Assuming your gallery model has an 'id' field
      if (item.id != null) {
        _idsToDelete.add(item.id.toString());
      }
      _currentServerGallery.removeAt(index);
    });
  }

  void _removeNewFile(int index) {
    setState(() {
      _newFilesToUpload.removeAt(index);
    });
  }

  void _showPickerOptions() {
    showModalBottomSheet(
      context: context,
      builder: (context) => SafeArea(
        child: Wrap(
          children: [
            ListTile(
              leading: const Icon(Icons.photo_library),
              title: const Text('Gallery'),
              onTap: () {
                Navigator.pop(context);
                _pickAndCropImage(ImageSource.gallery);
              },
            ),
            ListTile(
              leading: const Icon(Icons.photo_camera),
              title: const Text('Camera'),
              onTap: () {
                Navigator.pop(context);
                _pickAndCropImage(ImageSource.camera);
              },
            ),
          ],
        ),
      ),
    );
  }

  void _showLimitReachedMessage() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Maximum of 10 images reached.')),
    );
  }

  Future<void> _handleSave() async {
    await ref.read(salonUpdateViewModelProvider.notifier).updateGallery(
          newFiles: _newFilesToUpload,
          deleteIds: _idsToDelete,
        );

    final state = ref.read(salonUpdateViewModelProvider);
    if (state is AsyncData && mounted) {
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Gallery updated successfully!'), backgroundColor: Colors.green),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final updateState = ref.watch(salonUpdateViewModelProvider);
    
    // Total count combines server images and new picks
    final totalCount = _currentServerGallery.length + _newFilesToUpload.length;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Salon Gallery'),
        actions: [
          updateState.isLoading
              ? const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  child: Center(child: SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2))),
                )
              : TextButton(
                  onPressed: _handleSave,
                  child: const Text('Save', style: TextStyle(fontWeight: FontWeight.bold)),
                ),
        ],
      ),
      floatingActionButton: totalCount < 10
          ? FloatingActionButton.extended(
              onPressed: _showPickerOptions,
              label: const Text("Add Image"),
              icon: const Icon(Icons.add_photo_alternate_outlined),
            )
          : null,
      body: totalCount == 0
      ? Center(
          child: Text(
            "No gallery images yet.\nTap 'Add Image' to start.",
            textAlign: TextAlign.center,
            style: theme.textTheme.bodyMedium,
          ),
        )
      : GridView.builder(
          padding: const EdgeInsets.all(12),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            childAspectRatio: 640 / 420,
          ),
          itemCount: totalCount,
          itemBuilder: (context, index) {
            // Determine if we are showing a server image or a new file
            final bool isServerImage = index < _currentServerGallery.length;

            if (isServerImage) {
              final item = _currentServerGallery[index];
              return _GalleryItemWidget(
                imageChild: CachedNetworkImage(
                  imageUrl: item.imageUrl, // Assuming your model uses .image for URL
                  fit: BoxFit.cover,
                  placeholder: (context, url) => Container(color: theme.colorScheme.surfaceContainerHighest),
                  errorWidget: (context, url, error) => const Icon(Icons.error),
                ),
                onDelete: () => _removeExistingImage(index),
                isNew: false,
              );
            } else {
              final fileIndex = index - _currentServerGallery.length;
              final file = _newFilesToUpload[fileIndex];
              return _GalleryItemWidget(
                imageChild: Image.file(file, fit: BoxFit.cover),
                onDelete: () => _removeNewFile(fileIndex),
                isNew: true,
              );
            }
          },
        ),
    );
  }
}

class _GalleryItemWidget extends StatelessWidget {
  final Widget imageChild;
  final VoidCallback onDelete;
  final bool isNew;

  const _GalleryItemWidget({
    required this.imageChild,
    required this.onDelete,
    required this.isNew,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Stack(
      fit: StackFit.expand,
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: imageChild,
        ),
        Positioned(
          top: 8,
          right: 8,
          child: GestureDetector(
            onTap: onDelete,
            child: Container(
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.7),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.close, size: 18, color: Colors.white),
            ),
          ),
        ),
        if (isNew)
          Positioned(
            bottom: 8,
            left: 8,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              decoration: BoxDecoration(
                color: theme.colorScheme.primary,
                borderRadius: BorderRadius.circular(4),
              ),
              child: const Text(
                "NEW",
                style: TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold),
              ),
            ),
          ),
      ],
    );
  }
}