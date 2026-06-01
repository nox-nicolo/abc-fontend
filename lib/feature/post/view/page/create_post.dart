import 'dart:io';
import 'package:africa_beuty/feature/post/model/post_tag_people.dart';
import 'package:africa_beuty/feature/post/providers/selected_category.dart';
import 'package:africa_beuty/feature/post/state/post_media.dart';
import 'package:africa_beuty/feature/post/state/post_setting.dart';
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
import 'package:africa_beuty/feature/post/view/widgets/post_share_sheet.dart';
import 'package:africa_beuty/feature/post/view_model/create_post.dart';
import 'package:africa_beuty/feature/post/view_model/post_settings.dart';
import 'package:africa_beuty/feature/profile/view/page/salon_event_campaign.dart';
import 'package:africa_beuty/feature/profile/view_model/salon.dart';
import 'package:africa_beuty/feature/profile/view_model/salon_profile_post.dart';
import 'package:africa_beuty/feature/post/view/page/view_post.dart';
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
    return _validationMessage(hasServiceCategory) == null;
  }

  String? _validationMessage(bool hasServiceCategory) {
    final hasText = captionController.text.trim().isNotEmpty;
    if (_postType == 'announcement') {
      return hasText || selectedImages.isNotEmpty
          ? null
          : 'Add text or at least one image for an announcement.';
    }
    if (!hasServiceCategory) {
      return 'Choose the service this post is showing.';
    }
    if (selectedImages.isEmpty) {
      return 'Add at least one image for a service post.';
    }
    if (selectedImages.length != editedImages.length) {
      return 'One image is still processing. Please try again.';
    }
    return null;
  }

  Future<String?> _validateMediaFiles() async {
    if (editedImages.length > 4) return 'You can add up to 4 images.';
    for (final image in editedImages) {
      if (image.type != 'image') {
        return 'Only image posts are supported right now.';
      }
      if (image.aspectRatio <= 0) {
        return 'One image has invalid dimensions. Please edit it again.';
      }
      if (!await image.image.exists()) {
        return 'Cannot access one selected image. Please remove and add it again.';
      }
    }
    return null;
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Theme.of(context).colorScheme.error,
      ),
    );
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
      if (!mounted) return;

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

      if (!mounted) return;

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
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Unable to access gallery: $e')));
    }
  }

  Future<void> pickFromCamera() async {
    if (selectedImages.length >= 4) return;

    try {
      final image = await picker.pickImage(source: ImageSource.camera);
      if (!mounted) return;

      if (image == null) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('No image captured.')));
        return;
      }

      final file = File(image.path);
      if (!await file.exists()) {
        if (!mounted) return;
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
      if (!mounted) return;
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

      if (!mounted) return;
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

      if (!mounted) return;

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
      if (!mounted) return;
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
    final viewState = ref.read(createPostViewModelProvider);
    if (viewState.isSubmitting) return;

    final selectedCategory = ref.read(selectedCategoryProvider);
    final validationMessage = _validationMessage(selectedCategory != null);
    if (validationMessage != null) {
      _showError(validationMessage);
      return;
    }

    final mediaError = await _validateMediaFiles();
    if (!mounted) return;
    if (mediaError != null) {
      _showError(mediaError);
      return;
    }

    final settings = ref.read(postSettingsViewModelProvider).value;
    if (settings != null) {
      viewModel.setSettings(
        PostSettingsState(
          visibility: settings.visibility,
          showLikes: settings.showLikes,
          enableComments: settings.enableComments,
          allowSharing: settings.allowSharing,
          showLocation: settings.showLocation,
          pinned: settings.pinned,
          ageRestriction: settings.ageRestriction,
          disableReactions: settings.disableReactions,
        ),
      );
    }

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

    viewModel.setTaggedUsers(taggedPeople.map((e) => e.username).toList());

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
      final postId = postState.createdPostId;
      final salonId = ref.read(salonProfileViewModelProvider).value?.id;
      if (salonId != null) {
        ref
            .read(profilePostsViewModelProvider(salonId).notifier)
            .getInitialPosts();
      }
      _clearForm();
      if (widget.onPostSubmit != null) {
        widget.onPostSubmit!();
      } else {
        showPostSuccessDialog(
          context,
          onDone: () => Navigator.of(context).pop(),
          onCreateAnother: () {},
          onViewPost: postId == null || postId.isEmpty
              ? null
              : () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => PostViewPage(postId: postId),
                    ),
                  );
                },
          onShare: postId == null || postId.isEmpty
              ? null
              : () {
                  showPostShareSheet(context, ref, postId);
                },
          onBoostLater: () {
            Navigator.of(context).push(
              MaterialPageRoute(builder: (_) => const SalonEventCampaignPage()),
            );
          },
        );
      }
    } else if (postState.error != null) {
      _showError(postState.error!);
    }
  }

  Future<void> openPreview() async {
    final selectedCategory = ref.read(selectedCategoryProvider);
    final captionText = captionController.text.trim();
    final viewState = ref.read(createPostViewModelProvider);

    if (captionText.isEmpty && editedImages.isEmpty) {
      _showError('Add a caption or image before previewing.');
      return;
    }

    final shouldPublish = await Navigator.of(context).push<bool>(
      MaterialPageRoute(
        builder: (_) => _DraftPostPreviewPage(
          authorName: viewState.author.isNotEmpty
              ? viewState.author
              : 'username',
          profileImagePath: viewState.picture.isNotEmpty
              ? viewState.picture
              : null,
          postType: _postType,
          serviceName: selectedCategory?.name,
          caption: captionText,
          hashtags: {
            ..._extractHashtags(captionText),
            ...selectedHashtags,
          }.toList(),
          taggedPeople: taggedPeople.map((person) => person.username).toList(),
          images: editedImages.map((image) => image.image).toList(),
          aspectRatio: _aspectRatio,
        ),
      ),
    );

    if (!mounted || shouldPublish != true) return;
    await submit();
  }

  @override
  Widget build(BuildContext context) {
    final category = ref.watch(selectedCategoryProvider);
    final viewState = ref.watch(createPostViewModelProvider);
    final scheme = Theme.of(context).colorScheme;

    final isValid = _isValidPost(category != null);
    final canTapPost = !viewState.isSubmitting;
    final captionText = captionController.text.trim();
    final inlineHashtags = _extractHashtags(captionText);
    final qualityChecks = <_PostQualityCheck>[
      _PostQualityCheck(
        label: 'Clear service photo',
        done: selectedImages.isNotEmpty,
        hint: 'Add at least one bright, clear image.',
      ),
      if (_postType == 'service')
        _PostQualityCheck(
          label: 'Service selected',
          done: category != null,
          hint: 'Choose the service shown in this post.',
        ),
      _PostQualityCheck(
        label: 'Useful caption',
        done: captionText.length >= 24,
        hint: 'Mention style, result, care tip, or who it suits.',
      ),
      _PostQualityCheck(
        label: 'Hashtags',
        done: selectedHashtags.isNotEmpty || inlineHashtags.isNotEmpty,
        hint: 'Add searchable tags like #braids or #nails.',
      ),
      _PostQualityCheck(
        label: 'Tag stylist/client',
        done: taggedPeople.isNotEmpty,
        hint: 'Tag the stylist or client when it helps trust.',
      ),
    ];

    return Scaffold(
      appBar: AppBar(
        actions: [
          TextButton.icon(
            onPressed: openPreview,
            icon: const Icon(Icons.visibility_outlined, size: 18),
            label: const Text('Preview'),
          ),
          TextButton(
            onPressed: canTapPost ? submit : null,
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
                      color: isValid
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

            _PostQualityGuide(checks: qualityChecks),

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

class _DraftPostPreviewPage extends StatefulWidget {
  const _DraftPostPreviewPage({
    required this.authorName,
    required this.profileImagePath,
    required this.postType,
    required this.serviceName,
    required this.caption,
    required this.hashtags,
    required this.taggedPeople,
    required this.images,
    required this.aspectRatio,
  });

  final String authorName;
  final String? profileImagePath;
  final String postType;
  final String? serviceName;
  final String caption;
  final List<String> hashtags;
  final List<String> taggedPeople;
  final List<File> images;
  final double aspectRatio;

  @override
  State<_DraftPostPreviewPage> createState() => _DraftPostPreviewPageState();
}

class _DraftPostPreviewPageState extends State<_DraftPostPreviewPage> {
  final PageController _pageController = PageController();
  int _page = 0;

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final aspectRatio = widget.aspectRatio <= 0 ? 1.0 : widget.aspectRatio;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Post preview'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Edit'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('Publish'),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.only(bottom: 92),
        children: [
          Container(
            margin: const EdgeInsets.fromLTRB(16, 8, 16, 12),
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: scheme.primaryContainer.withValues(alpha: 0.45),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: scheme.outlineVariant),
            ),
            child: Row(
              children: [
                Icon(Icons.visibility_outlined, color: scheme.primary),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    'Preview only. This shows how customers may see the post in feed and profile before you publish.',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: scheme.onSurfaceVariant,
                      height: 1.35,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Card(
            margin: const EdgeInsets.symmetric(horizontal: 16),
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
              side: BorderSide(color: scheme.outlineVariant),
            ),
            clipBehavior: Clip.antiAlias,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.all(12),
                  child: Row(
                    children: [
                      _PreviewAvatar(imagePath: widget.profileImagePath),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Flexible(
                                  child: Text(
                                    widget.authorName,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: theme.textTheme.titleSmall?.copyWith(
                                      fontWeight: FontWeight.w800,
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 5),
                                Icon(
                                  Icons.verified_rounded,
                                  size: 15,
                                  color: scheme.primary,
                                ),
                              ],
                            ),
                            Text(
                              widget.serviceName ??
                                  (widget.postType == 'announcement'
                                      ? 'Announcement'
                                      : 'Service post'),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: theme.textTheme.labelSmall?.copyWith(
                                color: scheme.onSurfaceVariant,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 5,
                        ),
                        decoration: BoxDecoration(
                          color: scheme.surfaceContainerHighest,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          'Draft',
                          style: theme.textTheme.labelSmall?.copyWith(
                            fontWeight: FontWeight.w800,
                            color: scheme.primary,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                if (widget.images.isNotEmpty)
                  Stack(
                    alignment: Alignment.bottomCenter,
                    children: [
                      AspectRatio(
                        aspectRatio: aspectRatio,
                        child: PageView.builder(
                          controller: _pageController,
                          itemCount: widget.images.length,
                          onPageChanged: (value) => setState(() {
                            _page = value;
                          }),
                          itemBuilder: (context, index) {
                            return Image.file(
                              widget.images[index],
                              fit: BoxFit.cover,
                              width: double.infinity,
                            );
                          },
                        ),
                      ),
                      if (widget.images.length > 1)
                        Positioned(
                          bottom: 10,
                          child: Row(
                            children: List.generate(widget.images.length, (
                              index,
                            ) {
                              final active = index == _page;
                              return AnimatedContainer(
                                duration: const Duration(milliseconds: 200),
                                margin: const EdgeInsets.symmetric(
                                  horizontal: 3,
                                ),
                                width: active ? 14 : 6,
                                height: 6,
                                decoration: BoxDecoration(
                                  color: Colors.white.withValues(
                                    alpha: active ? 0.95 : 0.55,
                                  ),
                                  borderRadius: BorderRadius.circular(99),
                                ),
                              );
                            }),
                          ),
                        ),
                    ],
                  )
                else
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(18),
                    color: scheme.surfaceContainerHighest,
                    child: Text(
                      widget.caption.isEmpty
                          ? 'Announcement preview'
                          : widget.caption,
                      style: theme.textTheme.titleMedium?.copyWith(
                        height: 1.35,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(12, 12, 12, 6),
                  child: Row(
                    children: [
                      _PreviewMetric(
                        icon: Icons.favorite_border_rounded,
                        label: '0',
                      ),
                      const SizedBox(width: 18),
                      _PreviewMetric(
                        icon: Icons.mode_comment_outlined,
                        label: '0',
                      ),
                      const SizedBox(width: 18),
                      _PreviewMetric(icon: Icons.send_outlined, label: '0'),
                      const Spacer(),
                      Icon(
                        Icons.bookmark_border_rounded,
                        color: scheme.primary,
                      ),
                    ],
                  ),
                ),
                if (widget.caption.isNotEmpty && widget.images.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.fromLTRB(12, 4, 12, 0),
                    child: Text(
                      widget.caption,
                      style: theme.textTheme.bodyMedium?.copyWith(height: 1.4),
                    ),
                  ),
                if (widget.hashtags.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.fromLTRB(12, 8, 12, 0),
                    child: Wrap(
                      spacing: 6,
                      runSpacing: 6,
                      children: widget.hashtags
                          .map(
                            (tag) => Text(
                              tag,
                              style: theme.textTheme.bodySmall?.copyWith(
                                color: scheme.primary,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          )
                          .toList(),
                    ),
                  ),
                if (widget.taggedPeople.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.fromLTRB(12, 8, 12, 0),
                    child: Wrap(
                      spacing: 6,
                      runSpacing: 6,
                      children: widget.taggedPeople
                          .map(
                            (person) => Chip(
                              label: Text('@$person'),
                              visualDensity: VisualDensity.compact,
                              materialTapTargetSize:
                                  MaterialTapTargetSize.shrinkWrap,
                            ),
                          )
                          .toList(),
                    ),
                  ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(12, 8, 12, 14),
                  child: Text(
                    'Just now',
                    style: theme.textTheme.labelSmall?.copyWith(
                      color: scheme.onSurfaceVariant,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: SafeArea(
        minimum: const EdgeInsets.fromLTRB(16, 8, 16, 16),
        child: Row(
          children: [
            Expanded(
              child: OutlinedButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('Keep editing'),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: FilledButton(
                onPressed: () => Navigator.of(context).pop(true),
                child: const Text('Publish post'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _PreviewAvatar extends StatelessWidget {
  const _PreviewAvatar({this.imagePath});

  final String? imagePath;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final path = imagePath;

    return CircleAvatar(
      radius: 20,
      backgroundColor: scheme.surfaceContainerHighest,
      child: ClipOval(
        child: path == null || path.isEmpty
            ? Icon(Icons.storefront_rounded, color: scheme.primary)
            : Image.network(
                path,
                width: 40,
                height: 40,
                fit: BoxFit.cover,
                errorBuilder: (_, _, _) =>
                    Icon(Icons.storefront_rounded, color: scheme.primary),
              ),
      ),
    );
  }
}

class _PreviewMetric extends StatelessWidget {
  const _PreviewMetric({required this.icon, required this.label});

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 22, color: scheme.primary),
        const SizedBox(width: 5),
        Text(
          label,
          style: Theme.of(
            context,
          ).textTheme.labelMedium?.copyWith(fontWeight: FontWeight.w800),
        ),
      ],
    );
  }
}

class _PostQualityGuide extends StatelessWidget {
  const _PostQualityGuide({required this.checks});

  final List<_PostQualityCheck> checks;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final completed = checks.where((check) => check.done).length;
    final ready = completed == checks.length;

    return Container(
      margin: const EdgeInsets.fromLTRB(16, 8, 16, 0),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: scheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: scheme.outlineVariant),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                ready ? Icons.verified_rounded : Icons.lightbulb_outline,
                size: 18,
                color: ready ? scheme.secondary : scheme.primary,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  ready ? 'Post quality looks strong' : 'Post quality guide',
                  style: theme.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
              Text(
                '$completed/${checks.length}',
                style: theme.textTheme.labelMedium?.copyWith(
                  color: ready ? scheme.secondary : scheme.onSurfaceVariant,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            ready
                ? 'This post has the basics customers need before they trust, save, or book.'
                : checks.firstWhere((check) => !check.done).hint,
            style: theme.textTheme.bodySmall?.copyWith(
              color: scheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 10),
          Wrap(
            spacing: 6,
            runSpacing: 6,
            children: checks.map((check) {
              return _PostQualityChip(check: check);
            }).toList(),
          ),
        ],
      ),
    );
  }
}

class _PostQualityChip extends StatelessWidget {
  const _PostQualityChip({required this.check});

  final _PostQualityCheck check;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final color = check.done ? scheme.secondary : scheme.onSurfaceVariant;
    final background = check.done ? scheme.secondaryContainer : scheme.surface;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 7),
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: check.done ? scheme.secondary : scheme.outlineVariant,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            check.done
                ? Icons.check_circle_rounded
                : Icons.radio_button_unchecked,
            size: 15,
            color: color,
          ),
          const SizedBox(width: 5),
          Text(
            check.label,
            style: theme.textTheme.labelSmall?.copyWith(
              color: check.done ? scheme.onSecondaryContainer : color,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}

class _PostQualityCheck {
  const _PostQualityCheck({
    required this.label,
    required this.done,
    required this.hint,
  });

  final String label;
  final bool done;
  final String hint;
}

void showPostSuccessDialog(
  BuildContext context, {
  required VoidCallback onDone,
  VoidCallback? onCreateAnother,
  VoidCallback? onViewPost,
  VoidCallback? onShare,
  VoidCallback? onBoostLater,
}) {
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (dialogContext) => Dialog(
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
              'Post published',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 8),
            Text(
              'Keep the momentum going while the post is fresh.',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 24),
            if (onViewPost != null) ...[
              SizedBox(
                width: double.infinity,
                child: FilledButton.icon(
                  onPressed: () {
                    Navigator.pop(dialogContext);
                    onViewPost();
                  },
                  icon: const Icon(Icons.open_in_new_rounded),
                  label: const Text('View post'),
                ),
              ),
              const SizedBox(height: 8),
            ],
            if (onShare != null)
              SizedBox(
                width: double.infinity,
                child: OutlinedButton.icon(
                  onPressed: () {
                    Navigator.pop(dialogContext);
                    onShare();
                  },
                  icon: const Icon(Icons.send_outlined),
                  label: const Text('Share'),
                ),
              ),
            if (onShare != null) const SizedBox(height: 8),
            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                onPressed: () {
                  Navigator.pop(dialogContext);
                  onCreateAnother?.call();
                },
                icon: const Icon(Icons.add_photo_alternate_outlined),
                label: const Text('Create another'),
              ),
            ),
            const SizedBox(height: 8),
            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                onPressed: () {
                  Navigator.pop(dialogContext);
                  onBoostLater?.call();
                },
                icon: const Icon(Icons.campaign_outlined),
                label: const Text('Boost later'),
              ),
            ),
            const SizedBox(height: 8),
            SizedBox(
              width: double.infinity,
              child: TextButton(
                onPressed: () {
                  Navigator.pop(dialogContext);
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
