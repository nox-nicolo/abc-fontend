import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'image_edit_data.dart';

class ImageEditorPage extends StatefulWidget {
  final List<XFile> initialImages;
  final double initialAspectRatio;

  const ImageEditorPage({
    super.key,
    required this.initialImages,
    this.initialAspectRatio = 1.0,
  });

  @override
  State<ImageEditorPage> createState() => _ImageEditorPageState();
}

class _ImageEditorPageState extends State<ImageEditorPage> {
  List<ImageEditData> _imageEditDataList = [];
  int _currentImageIndex = 0;
  late double _globalAspectRatio;
  late final PageController _pageController;

  @override
  void initState() {
    super.initState();
    _globalAspectRatio = widget.initialAspectRatio;
    _pageController = PageController(initialPage: _currentImageIndex);
    _imageEditDataList = widget.initialImages.map(
      (xfile) => ImageEditData(image: File(xfile.path), aspectRatio: _globalAspectRatio, type: 'image'),
    ).toList();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _showCropAspectRatioSelector() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(18)),
      ),
      builder: (context) {
        return Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.only(topRight: Radius.circular(18), topLeft: Radius.circular(18))
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Select Aspect Ratio', style: Theme.of(context).textTheme.titleMedium),
              const SizedBox(height: 12),
              Wrap(
                spacing: 8,
                children: AspectRatioOption.predefinedRatios.map((option) {
                  final isSelected = _globalAspectRatio == option.ratio;
                  return ChoiceChip(
                    label: Text(option.label),
                    selected: isSelected,
                    onSelected: (_) {
                      Navigator.of(context).pop();
                      setState(() {
                        _globalAspectRatio = option.ratio;
                        _imageEditDataList = _imageEditDataList.map(
                          (img) => img.copyWith(aspectRatio: _globalAspectRatio),
                        ).toList();
                      });
                    },
                  );
                }).toList(),
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> _cropImage(int index) async {
    final imageData = _imageEditDataList[index];
    final aspectRatio = _globalAspectRatio;

    final croppedFile = await ImageCropper().cropImage(
      sourcePath: imageData.image.path,
      compressQuality: 90,
      aspectRatio: aspectRatio == -1
          ? null
          : CropAspectRatio(
              ratioX: aspectRatio,
              ratioY: 1,
            ),
      uiSettings: [
        AndroidUiSettings(
          toolbarTitle: 'Crop Image',
          toolbarColor: Theme.of(context).primaryColor,
          toolbarWidgetColor: Colors.white,
          initAspectRatio: CropAspectRatioPreset.original,
          lockAspectRatio: aspectRatio != -1,
        ),
        IOSUiSettings(
          title: 'Crop Image',
          aspectRatioLockEnabled: aspectRatio != -1,
        ),
      ],
    );

    if (croppedFile != null) {
      final croppedImageFile = File(croppedFile.path);
      setState(() {
        _imageEditDataList[index] = imageData.copyWith(
          image: croppedImageFile,
          isCropped: true,
        );
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Image cropped successfully')),
        );
      }
    }
  }

  Widget _buildEditButton({required IconData icon, required String label, required VoidCallback onPressed}) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        IconButton(onPressed: onPressed, icon: Icon(icon)),
        Text(label),
      ],
    );
  }

  Widget _buildThumbnail(int index) {
    final isSelected = index == _currentImageIndex;
    return GestureDetector(
      onTap: () {
        setState(() {
          _currentImageIndex = index;
          _pageController.animateToPage(
            index,
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOut,
          );
        });
      },
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 4),
        padding: isSelected ? const EdgeInsets.all(2) : EdgeInsets.zero,
        decoration: BoxDecoration(
          border: isSelected ? Border.all(color: Theme.of(context).colorScheme.primary, width: 2) : null,
        ),
        child: Image.file(
          _imageEditDataList[index].image,
          width: 60,
          height: 60,
          fit: BoxFit.cover,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Image Editor')),
      body: Column(
        children: [
          Expanded(
            child: PageView.builder(
              itemCount: _imageEditDataList.length,
              controller: _pageController,
              onPageChanged: (index) {
                setState(() {
                  _currentImageIndex = index;
                });
              },
              itemBuilder: (_, index) => Image.file(
                _imageEditDataList[index].image,
                fit: BoxFit.contain,
              ),
            ),
          ),
          const SizedBox(height: 8),
          SizedBox(
            height: 70,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: _imageEditDataList.length,
              itemBuilder: (_, index) => _buildThumbnail(index),
            ),
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildEditButton(
                icon: Icons.crop,
                label: 'Crop',
                onPressed: () => _cropImage(_currentImageIndex),
              ),
              _buildEditButton(
                icon: Icons.aspect_ratio,
                label: 'Aspect Ratio',
                onPressed: _showCropAspectRatioSelector,
              ),
            ],
          ),
          const SizedBox(height: 16),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          Navigator.of(context).pop(_imageEditDataList);
        },
        child: const Icon(Icons.check),
      ),
    );
  }
}
