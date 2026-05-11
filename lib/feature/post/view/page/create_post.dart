import 'dart:io';
import 'package:africa_beuty/feature/post/model/post_tag_people.dart';
import 'package:africa_beuty/feature/post/providers/selected_category.dart';
import 'package:africa_beuty/feature/post/state/post_media.dart';
import 'package:africa_beuty/feature/post/view/widgets/create_post/image_edit_data.dart';
import 'package:africa_beuty/feature/post/view/widgets/create_post/post_action_buttons.dart';
import 'package:africa_beuty/feature/post/view/widgets/create_post/post_categories.dart';
import 'package:africa_beuty/feature/post/view/widgets/create_post/post_hashtag.dart';
import 'package:africa_beuty/feature/post/view/widgets/create_post/post_image_editor.dart';
import 'package:africa_beuty/feature/post/view/widgets/create_post/post_image_picker.dart';
import 'package:africa_beuty/feature/post/view/widgets/create_post/post_settings.dart';
import 'package:africa_beuty/feature/post/view/widgets/create_post/post_tag_people.dart';
import 'package:africa_beuty/feature/post/view/widgets/create_post/post_text_input.dart';
import 'package:africa_beuty/feature/post/view/widgets/create_post/user_info_header.dart';
import 'package:africa_beuty/feature/post/view_model/create_post.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';

class CreatePostPage extends ConsumerStatefulWidget {
  final VoidCallback? onPostSubmit;

  const CreatePostPage({super.key, this.onPostSubmit});

  @override
  ConsumerState<CreatePostPage> createState() => _CreatePostPageState();
}

class _CreatePostPageState extends ConsumerState<CreatePostPage> {
  final ImagePicker picker = ImagePicker();
  final List<XFile> selectedImages = [];
  List<ImageEditData> editedImages = [];

  final captionController = TextEditingController();

  List<String> selectedHashtags = [];
  List<PostTagPeopleModel> taggedPeople = [];
  String _postType = 'service';

  // Global aspect ratio for all images (shown in the picker chips)
  double _aspectRatio = 1.0;

  @override
  void dispose() {
    captionController.dispose();
    super.dispose();
  }

  List<String> _extractHashtags(String text) {
    return RegExp(r'#\w+').allMatches(text).map((e) => e.group(0)!).toList();
  }

  bool _isValidPost(bool hasServiceCategory) {
    final hasText = captionController.text.trim().isNotEmpty;
    if (_postType == 'announcement') {
      return hasText || selectedImages.isNotEmpty;
    }
    return hasServiceCategory && selectedImages.isNotEmpty;
  }

  // ── Aspect ratio ────────────────────────────────────────────
  void _onAspectRatioChanged(double ratio) {
    setState(() {
      _aspectRatio = ratio;
      editedImages = editedImages
          .map((e) => e.copyWith(aspectRatio: ratio))
          .toList();
    });
  }

  // ── Image handling ───────────────────────────────────────────
  Future<void> pickImages() async {
    try {
      final images = await picker.pickMultiImage();
      if (images.isEmpty) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('No images selected.')));
        return;
      }

      final remaining = 4 - selectedImages.length;
      final take = images.take(remaining).toList();

      final newSelected = <XFile>[];
      final newEdited = <ImageEditData>[];
      final missingFiles = <String>[];

      for (final xfile in take) {
        final file = File(xfile.path);
        if (await file.exists()) {
          newSelected.add(xfile);
          newEdited.add(
            ImageEditData(
              image: file,
              aspectRatio: _aspectRatio,
              type: 'image',
            ),
          );
        } else {
          missingFiles.add(xfile.name);
        }
      }

      if (missingFiles.isNotEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Cannot access files: ${missingFiles.join(', ')}'),
          ),
        );
      }

      if (newSelected.isEmpty) return;

      setState(() {
        selectedImages.addAll(newSelected);
        editedImages.addAll(newEdited);
      });
    } on Exception catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Unable to access gallery: $e')));
    }
  }

  Future<void> pickFromCamera() async {
    if (selectedImages.length >= 4) return;

    try {
      final image = await picker.pickImage(source: ImageSource.camera);
      if (image == null) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('No image captured.')));
        return;
      }

      final file = File(image.path);
      if (!await file.exists()) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Cannot access captured image.')),
        );
        return;
      }

      setState(() {
        selectedImages.add(image);
        editedImages.add(
          ImageEditData(image: file, aspectRatio: _aspectRatio, type: 'image'),
        );
      });
    } on Exception catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Unable to access camera: $e')));
    }
  }

  void removeImage(int index) {
    if (index < 0 || index >= selectedImages.length) return;
    setState(() {
      selectedImages.removeAt(index);
      editedImages.removeAt(index);
    });
  }

  Future<void> editImage(int index) async {
    try {
      final result = await Navigator.push<List<ImageEditData>>(
        context,
        MaterialPageRoute(
          builder: (_) => ImageEditorPage(
            initialImages: editedImages
                .map((e) => XFile(e.image.path))
                .toList(),
            initialAspectRatio: _aspectRatio,
          ),
        ),
      );

      if (result == null || result.isEmpty) return;

      final newSelected = <XFile>[];
      final newEdited = <ImageEditData>[];
      final missingFiles = <String>[];

      for (final editData in result) {
        final file = editData.image;
        if (await file.exists()) {
          newEdited.add(editData);
          newSelected.add(XFile(file.path));
        } else {
          missingFiles.add(file.path);
        }
      }

      if (missingFiles.isNotEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Cannot access edited files: ${missingFiles.join(', ')}',
            ),
          ),
        );
      }

      if (newEdited.isEmpty) return;

      setState(() {
        editedImages = newEdited;
        // Also update aspect ratio from editor result
        if (newEdited.isNotEmpty) _aspectRatio = newEdited.first.aspectRatio;
        selectedImages
          ..clear()
          ..addAll(newSelected);
      });
    } on Exception catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Failed to edit image: $e')));
    }
  }

  // ── Modals ───────────────────────────────────────────────────
  void openSettings() {
    showModalBottomSheet(
      context: context,
      showDragHandle: true,
      isScrollControlled: true,
      builder: (_) => const PostSettingsPage(),
    );
  }

  void openCategories() {
    showModalBottomSheet(
      context: context,
      showDragHandle: true,
      builder: (_) => const PostCategoriesPage(),
    );
  }

  void openHashtags() async {
    final res = await showModalBottomSheet<List<String>>(
      context: context,
      isScrollControlled: true,
      showDragHandle: true,
      builder: (_) =>
          PostHashTagPage(initialSelectedHashtags: selectedHashtags),
    );

    if (res != null) setState(() => selectedHashtags = res);
  }

  void openTagging() async {
    final res = await showModalBottomSheet<List<PostTagPeopleModel>>(
      context: context,
      isScrollControlled: true,
      showDragHandle: true,
      builder: (_) => PostTagPeople(initialSelected: taggedPeople),
    );

    if (res != null) setState(() => taggedPeople = res);
  }

  void _clearForm() {
    setState(() {
      selectedImages.clear();
      editedImages.clear();
      selectedHashtags.clear();
      taggedPeople.clear();
      _aspectRatio = 1.0;
      _postType = 'service';
    });
    captionController.clear();
    ref.read(selectedCategoryProvider.notifier).clear();
  }

  // ── Submit ───────────────────────────────────────────────────
  Future<void> submit() async {
    final viewModel = ref.read(createPostViewModelProvider.notifier);
    final selectedCategory = ref.read(selectedCategoryProvider);
    if (!_isValidPost(selectedCategory != null)) return;

    viewModel.setPostType(_postType);
    viewModel.setCategory(
      _postType == 'service' ? selectedCategory?.id ?? '' : '',
    );
    viewModel.setCaption(captionController.text);

    // Merge inline hashtags from caption with those picked from the picker
    viewModel.setHashtags(
      {
        ..._extractHashtags(captionController.text),
        ...selectedHashtags,
      }.toList(),
    );

    viewModel.setTaggedUsers(taggedPeople.map((e) => e.id).toList());

    viewModel.setMedia(
      editedImages
          .map(
            (e) => PostMediaState(
              path: e.image.path,
              aspectRatio: e.aspectRatio,
              type: e.type,
            ),
          )
          .toList(),
    );

    await viewModel.submit();
    if (!mounted) return;

    final postState = ref.read(createPostViewModelProvider);

    if (postState.isSuccess) {
      _clearForm();
      if (widget.onPostSubmit != null) {
        widget.onPostSubmit!();
      } else {
        showPostSuccessDialog(context, () => Navigator.of(context).pop());
      }
    } else if (postState.error != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(postState.error!),
          backgroundColor: Theme.of(context).colorScheme.error,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final category = ref.watch(selectedCategoryProvider);
    final viewState = ref.watch(createPostViewModelProvider);
    final scheme = Theme.of(context).colorScheme;

    final canSubmit = _isValidPost(category != null) && !viewState.isSubmitting;

    return Scaffold(
      appBar: AppBar(
        actions: [
          TextButton(
            onPressed: canSubmit ? submit : null,
            child: viewState.isSubmitting
                ? const SizedBox(
                    width: 18,
                    height: 18,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : Text(
                    'Post',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: canSubmit
                          ? scheme.primary
                          : scheme.onSurface.withValues(alpha: 0.38),
                    ),
                  ),
          ),
          const SizedBox(width: 16),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.only(bottom: 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            UserInfoHeader(
              username: viewState.author.isNotEmpty
                  ? viewState.author
                  : 'username',
              profileImagePath: viewState.picture.isNotEmpty
                  ? viewState.picture
                  : 'assets/images/dp.jpg',
              onSettingPressed: openSettings,
            ),

            Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
              child: SizedBox(
                width: double.infinity,
                child: SegmentedButton<String>(
                  segments: const [
                    ButtonSegment(
                      value: 'service',
                      icon: Icon(Icons.spa_outlined),
                      label: Text('Service'),
                    ),
                    ButtonSegment(
                      value: 'announcement',
                      icon: Icon(Icons.campaign_outlined),
                      label: Text('Announcement'),
                    ),
                  ],
                  selected: {_postType},
                  onSelectionChanged: (selection) {
                    setState(() {
                      _postType = selection.first;
                      if (_postType == 'announcement') {
                        ref.read(selectedCategoryProvider.notifier).clear();
                      }
                    });
                  },
                ),
              ),
            ),

            if (_postType == 'service')
              GestureDetector(
                onTap: openCategories,
                child: Container(
                  margin: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: scheme.primaryContainer,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Row(
                    children: [
                      category?.fileName != null &&
                              category!.fileName.isNotEmpty
                          ? ClipRRect(
                              borderRadius: BorderRadius.circular(4),
                              child: Image.network(
                                category.fileName,
                                width: 42,
                                height: 42,
                                fit: BoxFit.cover,
                                errorBuilder: (_, _, _) =>
                                    const Icon(Icons.category, size: 28),
                              ),
                            )
                          : const Icon(Icons.spa_outlined, size: 28),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          category?.name ?? 'Select service',
                          style: Theme.of(context).textTheme.titleMedium
                              ?.copyWith(
                                color: category == null
                                    ? scheme.onSurfaceVariant
                                    : null,
                              ),
                        ),
                      ),
                      if (category != null)
                        GestureDetector(
                          onTap: () => ref
                              .read(selectedCategoryProvider.notifier)
                              .clear(),
                          child: const Icon(Icons.close, size: 20),
                        )
                      else
                        const Icon(Icons.arrow_drop_down),
                    ],
                  ),
                ),
              ),

            // ── Main text + media box ──────────────────────────
            AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              margin: const EdgeInsets.all(16),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: scheme.surface,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: scheme.outlineVariant),
              ),
              child: LayoutBuilder(
                builder: (context, constraints) {
                  final screenHeight = MediaQuery.of(context).size.height;
                  final containerHeight = selectedImages.isNotEmpty
                      ? screenHeight * 0.65
                      : screenHeight * 0.35;

                  return SizedBox(
                    height: containerHeight,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        PostTextInput(
                          controller: captionController,
                          onChanged: () => setState(() {}),
                          hasImages: selectedImages.isNotEmpty,
                        ),
                        const SizedBox(height: 8),

                        // Selected hashtag chips (separate from caption)
                        if (selectedHashtags.isNotEmpty)
                          Wrap(
                            spacing: 6,
                            runSpacing: 4,
                            children: selectedHashtags.map((tag) {
                              return Chip(
                                label: Text(
                                  tag,
                                  style: const TextStyle(fontSize: 12),
                                ),
                                padding: EdgeInsets.zero,
                                materialTapTargetSize:
                                    MaterialTapTargetSize.shrinkWrap,
                                onDeleted: () => setState(
                                  () => selectedHashtags.remove(tag),
                                ),
                              );
                            }).toList(),
                          ),

                        if (selectedHashtags.isNotEmpty)
                          const SizedBox(height: 8),

                        if (selectedImages.isNotEmpty)
                          Expanded(
                            child: PostImagePicker(
                              selectedImages: selectedImages,
                              onPickFromCamera: pickFromCamera,
                              onPickFromGallery: pickImages,
                              onRemoveImage: removeImage,
                              onEditImage: editImage,
                              canAddMore: selectedImages.length < 4,
                              aspectRatio: _aspectRatio,
                              onAspectRatioChanged: _onAspectRatioChanged,
                            ),
                          ),

                        const SizedBox(height: 10),
                        PostActionButtons(
                          onCameraPressed: pickFromCamera,
                          onGalleryPressed: pickImages,
                          onHashTagPressed: openHashtags,
                          onTagPressed: openTagging,
                          imageCount: selectedImages.length,
                          maxImages: 4,
                          taggedPeopleCount: taggedPeople.length,
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

void showPostSuccessDialog(BuildContext context, VoidCallback onDone) {
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (_) => Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.check_circle,
              size: 60,
              color: Theme.of(context).colorScheme.primary,
            ),
            const SizedBox(height: 16),
            Text(
              'Post Submitted',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                  onDone();
                },
                child: const Text('Done'),
              ),
            ),
          ],
        ),
      ),
    ),
  );
}
