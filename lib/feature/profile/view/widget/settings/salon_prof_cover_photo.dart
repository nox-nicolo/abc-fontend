import 'dart:io';
import 'package:africa_beuty/feature/profile/view_model/salon.dart';
import 'package:africa_beuty/feature/profile/view_model/settings/profile_cover.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image_cropper/image_cropper.dart';

class ProfileCoverPhoto extends ConsumerStatefulWidget {
  const ProfileCoverPhoto({super.key});

  @override
  ConsumerState<ProfileCoverPhoto> createState() => _ProfileCoverPhotoState();
}

class _ProfileCoverPhotoState extends ConsumerState<ProfileCoverPhoto> {
  final ImagePicker _picker = ImagePicker();
  File? _localProfileImage;
  File? _localCoverImage;

  Future<void> _pickAndCropImage(ImageSource source, bool isCover) async {
    final XFile? pickedFile = await _picker.pickImage(source: source);

    if (pickedFile != null) {
      final croppedFile = await ImageCropper().cropImage(
        sourcePath: pickedFile.path,
        aspectRatio: isCover 
            ? const CropAspectRatio(ratioX: 640, ratioY: 420) 
            : const CropAspectRatio(ratioX: 1, ratioY: 1),
        compressQuality: 100,
        uiSettings: [
          AndroidUiSettings(
            toolbarTitle: 'Crop ${isCover ? "Cover" : "Profile"} Photo',
            toolbarColor: Theme.of(context).colorScheme.surface,
            toolbarWidgetColor: Colors.black,
            initAspectRatio: isCover 
                ? CropAspectRatioPreset.original 
                : CropAspectRatioPreset.square,
            lockAspectRatio: true,
          ),
          IOSUiSettings(
            title: 'Crop Image',
            aspectRatioLockEnabled: true,
            resetAspectRatioEnabled: false,
          ),
        ],
      );

      if (croppedFile != null) {
        setState(() {
          if (isCover) {
            _localCoverImage = File(croppedFile.path);
          } else {
            _localProfileImage = File(croppedFile.path);
          }
        });
      }
    }
  }

  void _showPickerOptions(BuildContext context, bool isCover) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext bc) {
        return SafeArea(
          child: Wrap(
            children: <Widget>[
              ListTile(
                leading: const Icon(Icons.photo_library),
                title: const Text('Gallery'),
                onTap: () {
                  Navigator.of(context).pop();
                  _pickAndCropImage(ImageSource.gallery, isCover);
                },
              ),
              ListTile(
                leading: const Icon(Icons.photo_camera),
                title: const Text('Camera'),
                onTap: () {
                  Navigator.of(context).pop();
                  _pickAndCropImage(ImageSource.camera, isCover);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    // Listen to the main profile to get current URLs
    final salonData = ref.watch(salonProfileViewModelProvider);
    // Listen to the update state for loading/errors
    final updateState = ref.watch(salonUpdateViewModelProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Photos'),
        actions: [
          updateState.maybeWhen(
            loading: () => const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.0),
              child: Center(child: SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2))),
            ),
            orElse: () => TextButton(
              onPressed: (_localProfileImage == null && _localCoverImage == null)
                  ? null
                  : () async {
                      await ref.read(salonUpdateViewModelProvider.notifier).updateAccountMedia(
                            profileImage: _localProfileImage,
                            coverImage: _localCoverImage,
                          );
                      
                      // Check state again after async call
                      if (ref.read(salonUpdateViewModelProvider).hasValue && mounted) {
                        Navigator.of(context).pop();
                      }
                    },
              child: const Text('Save'),
            ),
          ),
        ],
      ),
      body: salonData.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) => Center(child: Text('Error: $error')),
        data: (salon) => SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(height: 20),
              const Text("Profile Photo (1:1)"),
              const SizedBox(height: 8),
              _ImagePickerBox(
                onTap: () => _showPickerOptions(context, false),
                localFile: _localProfileImage,
                networkUrl: salon.profilePicture,
                isSquare: true,
                outlineColor: theme.colorScheme.outlineVariant,
              ),
              const SizedBox(height: 32),
              const Text("Cover Photo (640 x 420)"),
              const SizedBox(height: 8),
              _ImagePickerBox(
                onTap: () => _showPickerOptions(context, true),
                localFile: _localCoverImage,
                networkUrl: salon.displayAds,
                isSquare: false,
                outlineColor: theme.colorScheme.outlineVariant,
                surfaceColor: theme.colorScheme.surfaceVariant,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ImagePickerBox extends StatelessWidget {
  final VoidCallback onTap;
  final File? localFile;
  final String networkUrl;
  final bool isSquare;
  final Color outlineColor;
  final Color? surfaceColor;

  const _ImagePickerBox({
    required this.onTap,
    this.localFile,
    required this.networkUrl,
    required this.isSquare,
    required this.outlineColor,
    this.surfaceColor,
  });

  @override
  Widget build(BuildContext context) {
    Widget content = Stack(
      fit: StackFit.expand,
      children: [
        if (localFile != null)
          Image.file(localFile!, fit: BoxFit.cover)
        else
          CachedNetworkImage(
            imageUrl: networkUrl,
            fit: BoxFit.cover,
            errorWidget: (context, url, error) => Icon(isSquare ? Icons.person : Icons.image, size: 50),
          ),
        Container(
          color: Colors.black.withOpacity(0.3),
          child: const Icon(Icons.camera_alt, color: Colors.white, size: 30),
        ),
      ],
    );

    return GestureDetector(
      onTap: onTap,
      child: isSquare
          ? Container(
              width: 150,
              height: 150,
              decoration: BoxDecoration(border: Border.all(color: outlineColor)),
              child: content,
            )
          : AspectRatio(
              aspectRatio: 640 / 420,
              child: Container(
                width: double.infinity,
                color: surfaceColor,
                child: content,
              ),
            ),
    );
  }
}