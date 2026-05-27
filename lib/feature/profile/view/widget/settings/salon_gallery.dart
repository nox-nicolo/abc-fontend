import 'dart:io';

import 'package:africa_beuty/feature/profile/model/salon.dart';
import 'package:africa_beuty/feature/profile/view_model/salon.dart';
import 'package:africa_beuty/feature/profile/view_model/settings/profile_cover.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';

class GalleryPage extends ConsumerStatefulWidget {
  const GalleryPage({super.key});

  @override
  ConsumerState<GalleryPage> createState() => _GalleryPageState();
}

class _GalleryPageState extends ConsumerState<GalleryPage> {
  static const _categories = ['general', 'hair', 'nails', 'makeup', 'braids'];

  final ImagePicker _picker = ImagePicker();
  final List<GalleryModel> _serverItems = [];
  final List<_PendingGalleryImage> _newItems = [];
  final List<String> _idsToDelete = [];

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      final salon = ref.read(salonProfileViewModelProvider).value;
      if (salon == null || !mounted) return;
      setState(() {
        _serverItems
          ..clear()
          ..addAll(salon.gallery);
      });
    });
  }

  int get _totalCount => _serverItems.length + _newItems.length;

  Future<void> _pickAndCropImage(ImageSource source) async {
    if (_totalCount >= 10) {
      _showMessage('Maximum of 10 images reached.');
      return;
    }

    final pickedFile = await _picker.pickImage(source: source);
    if (pickedFile == null || !mounted) return;

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

    if (croppedFile == null) return;
    setState(() {
      _newItems.add(
        _PendingGalleryImage(
          id: 'new-${DateTime.now().microsecondsSinceEpoch}',
          file: File(croppedFile.path),
        ),
      );
    });
  }

  Future<void> _confirmDeleteExisting(int index) async {
    final confirmed = await _confirmDelete();
    if (!confirmed || !mounted) return;

    setState(() {
      final item = _serverItems.removeAt(index);
      _idsToDelete.add(item.id);
    });
  }

  Future<void> _confirmDeleteNew(int index) async {
    final confirmed = await _confirmDelete();
    if (!confirmed || !mounted) return;
    setState(() => _newItems.removeAt(index));
  }

  Future<bool> _confirmDelete() async {
    return await showDialog<bool>(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Delete photo?'),
            content: const Text('This photo will be removed when you save.'),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context, false),
                child: const Text('Cancel'),
              ),
              FilledButton(
                onPressed: () => Navigator.pop(context, true),
                child: const Text('Delete'),
              ),
            ],
          ),
        ) ??
        false;
  }

  void _showPickerOptions() {
    showModalBottomSheet(
      context: context,
      showDragHandle: true,
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

  Future<void> _handleSave() async {
    await ref
        .read(salonUpdateViewModelProvider.notifier)
        .updateGallery(
          newFiles: _newItems.map((item) => item.file).toList(),
          deleteIds: _idsToDelete,
          galleryOrder: _serverItems.map((item) => item.id).toList(),
          galleryCategories: {
            for (final item in _serverItems) item.id: item.category,
          },
          newFileCategories: _newItems.map((item) => item.category).toList(),
        );

    if (!mounted) return;
    final state = ref.read(salonUpdateViewModelProvider);
    if (state is AsyncData) {
      Navigator.pop(context);
      _showMessage('Gallery updated successfully.');
    }
  }

  void _reorder(int oldIndex, int newIndex) {
    if (oldIndex < newIndex) newIndex -= 1;
    setState(() {
      final allItems = _combinedItems();
      final item = allItems.removeAt(oldIndex);
      allItems.insert(newIndex, item);
      _serverItems
        ..clear()
        ..addAll(allItems.whereType<GalleryModel>());
      _newItems
        ..clear()
        ..addAll(allItems.whereType<_PendingGalleryImage>());
    });
  }

  List<Object> _combinedItems() => [..._serverItems, ..._newItems];

  void _showMessage(String message) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final updateState = ref.watch(salonUpdateViewModelProvider);
    final allItems = _combinedItems();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Salon Gallery'),
        actions: [
          updateState.isLoading
              ? const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  child: Center(
                    child: SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    ),
                  ),
                )
              : TextButton(onPressed: _handleSave, child: const Text('Save')),
        ],
      ),
      floatingActionButton: _totalCount < 10
          ? FloatingActionButton.extended(
              onPressed: _showPickerOptions,
              label: const Text('Add Photo'),
              icon: const Icon(Icons.add_photo_alternate_outlined),
            )
          : null,
      body: allItems.isEmpty
          ? _EmptyGalleryState(onAdd: _showPickerOptions)
          : ReorderableListView.builder(
              padding: const EdgeInsets.fromLTRB(12, 12, 12, 96),
              itemCount: allItems.length,
              onReorder: _reorder,
              itemBuilder: (context, index) {
                final item = allItems[index];
                if (item is GalleryModel) {
                  return _GalleryRow(
                    key: ValueKey('server-${item.id}'),
                    image: CachedNetworkImage(
                      imageUrl: item.imageUrl,
                      fit: BoxFit.cover,
                      placeholder: (context, url) => Container(
                        color: theme.colorScheme.surfaceContainerHighest,
                      ),
                      errorWidget: (context, url, error) =>
                          const Icon(Icons.error),
                    ),
                    category: item.category,
                    isNew: false,
                    categories: _categories,
                    onCategoryChanged: (value) {
                      final serverIndex = _serverItems.indexWhere(
                        (existing) => existing.id == item.id,
                      );
                      if (serverIndex < 0) return;
                      setState(() {
                        _serverItems[serverIndex] = GalleryModel(
                          id: item.id,
                          imageUrl: item.imageUrl,
                          category: value,
                          position: item.position,
                        );
                      });
                    },
                    onDelete: () {
                      final serverIndex = _serverItems.indexWhere(
                        (existing) => existing.id == item.id,
                      );
                      if (serverIndex >= 0) _confirmDeleteExisting(serverIndex);
                    },
                  );
                }

                final newItem = item as _PendingGalleryImage;
                final newIndex = _newItems.indexWhere(
                  (x) => x.id == newItem.id,
                );
                return _GalleryRow(
                  key: ValueKey(newItem.id),
                  image: Image.file(newItem.file, fit: BoxFit.cover),
                  category: newItem.category,
                  isNew: true,
                  categories: _categories,
                  onCategoryChanged: (value) {
                    setState(() => newItem.category = value);
                  },
                  onDelete: () => _confirmDeleteNew(newIndex),
                );
              },
            ),
    );
  }
}

class _PendingGalleryImage {
  _PendingGalleryImage({required this.id, required this.file});

  final String id;
  final File file;
  String category = 'general';
}

class _GalleryRow extends StatelessWidget {
  const _GalleryRow({
    super.key,
    required this.image,
    required this.category,
    required this.isNew,
    required this.categories,
    required this.onCategoryChanged,
    required this.onDelete,
  });

  final Widget image;
  final String category;
  final bool isNew;
  final List<String> categories;
  final ValueChanged<String> onCategoryChanged;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;

    return Card(
      margin: const EdgeInsets.only(bottom: 10),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: SizedBox(width: 112, height: 78, child: image),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          isNew ? 'New photo' : 'Gallery photo',
                          style: theme.textTheme.titleSmall?.copyWith(
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ),
                      Icon(
                        Icons.drag_indicator_rounded,
                        color: scheme.onSurfaceVariant,
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  DropdownButtonFormField<String>(
                    initialValue: categories.contains(category)
                        ? category
                        : 'general',
                    decoration: const InputDecoration(
                      labelText: 'Category',
                      isDense: true,
                    ),
                    items: [
                      for (final item in categories)
                        DropdownMenuItem(
                          value: item,
                          child: Text(_categoryLabel(item)),
                        ),
                    ],
                    onChanged: (value) {
                      if (value != null) onCategoryChanged(value);
                    },
                  ),
                ],
              ),
            ),
            IconButton(
              tooltip: 'Delete',
              onPressed: onDelete,
              icon: const Icon(Icons.delete_outline_rounded),
            ),
          ],
        ),
      ),
    );
  }

  static String _categoryLabel(String value) {
    if (value.isEmpty) return 'General';
    return value[0].toUpperCase() + value.substring(1);
  }
}

class _EmptyGalleryState extends StatelessWidget {
  const _EmptyGalleryState({required this.onAdd});

  final VoidCallback onAdd;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CircleAvatar(
              radius: 30,
              backgroundColor: scheme.primary.withValues(alpha: 0.12),
              child: Icon(
                Icons.photo_library_outlined,
                color: scheme.primary,
                size: 30,
              ),
            ),
            const SizedBox(height: 14),
            Text(
              'No gallery photos yet',
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w800,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              'Add salon work, interiors, team photos, or style examples.',
              textAlign: TextAlign.center,
              style: theme.textTheme.bodySmall?.copyWith(
                color: scheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 16),
            FilledButton.icon(
              onPressed: onAdd,
              icon: const Icon(Icons.add_photo_alternate_outlined),
              label: const Text('Add Photo'),
            ),
          ],
        ),
      ),
    );
  }
}
