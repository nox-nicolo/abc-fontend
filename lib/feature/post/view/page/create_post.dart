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
  final VoidCallback? onPostSubmit; // callback to switch pages

  const CreatePostPage({super.key, this.onPostSubmit});

  @override
  ConsumerState<CreatePostPage> createState() => _CreatePostPageState();
}

class _CreatePostPageState extends ConsumerState<CreatePostPage> {
  final ImagePicker picker = ImagePicker();
  final List<XFile> selectedImages = [];
  List<ImageEditData> editedImages = [];

  final captionController = TextEditingController();
  final displayController = TextEditingController();

  String originalCaption = "";
  List<String> selectedHashtags = [];
  List<PostTagPeopleModel> taggedPeople = [];

  @override
  void initState() {
    super.initState();

    captionController.addListener(_onCaptionChanged);
    displayController.addListener(_onDisplayChanged);
  }

  @override
  void dispose() {
    captionController.dispose();
    displayController.dispose();
    super.dispose();
  }

  // --- TEXT INPUT HANDLING ---

  void _onCaptionChanged() {
    originalCaption = captionController.text;
    _updateDisplayText();
    setState(() {});
  }

  void _onDisplayChanged() {
    captionController
      ..removeListener(_onCaptionChanged)
      ..text = displayController.text
      ..addListener(_onCaptionChanged);

    originalCaption = displayController.text;
    setState(() {});
  }

  List<String> _extractHashtags(String text) {
    return RegExp(r"#\w+").allMatches(text).map((e) => e.group(0)!).toList();
  }

  void _updateDisplayText() {
    final hashtagsInCaption = _extractHashtags(originalCaption);
    final missing = selectedHashtags.where((h) => !hashtagsInCaption.contains(h));

    final sep = originalCaption.trim().isEmpty ? "" : " ";
    final newText = "$originalCaption$sep${missing.join(" ")}".trim();

    displayController
      ..removeListener(_onDisplayChanged)
      ..text = newText
      ..addListener(_onDisplayChanged);
  }

  bool get isValidPost =>
      originalCaption.trim().isNotEmpty || selectedImages.isNotEmpty;

  // --- IMAGE HANDLING ---
// --- PICK MULTIPLE IMAGES ---
Future<void> pickImages() async {
  try {
    final images = await picker.pickMultiImage();
    if (images.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("No images selected.")),
      );
      return;
    }

    final remaining = 4 - selectedImages.length;
    final take = images.take(remaining).toList();

    final newSelected = <XFile>[];
    final newEdited = <ImageEditData>[];
    final missingFiles = <String>[];

    for (var xfile in take) {
      final file = File(xfile.path);
      if (await file.exists()) {
        newSelected.add(xfile);
        newEdited.add(ImageEditData(image: file, aspectRatio: 1, type: "image"));
      } else {
        missingFiles.add(xfile.name);
      }
    }

    if (missingFiles.isNotEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Cannot access files: ${missingFiles.join(', ')}")),
      );
    }

    if (newSelected.isEmpty) return;

    setState(() {
      selectedImages.addAll(newSelected);
      editedImages.addAll(newEdited);
    });
  } on Exception catch (e) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Unable to access gallery: $e")),
    );
  }
}

// --- PICK IMAGE FROM CAMERA ---
Future<void> pickFromCamera() async {
  if (selectedImages.length >= 4) return;

  try {
    final image = await picker.pickImage(source: ImageSource.camera);
    if (image == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("No image captured.")),
      );
      return;
    }

    final file = File(image.path);
    if (!await file.exists()) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Cannot access captured image.")),
      );
      return;
    }

    setState(() {
      selectedImages.add(image);
      editedImages.add(ImageEditData(image: file, aspectRatio: 1, type: "image"));
    });
  } on Exception catch (e) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Unable to access camera: $e")),
    );
  }
}

// --- REMOVE IMAGE ---
void removeImage(int index) {
  if (index < 0 || index >= selectedImages.length) return;

  setState(() {
    selectedImages.removeAt(index);
    editedImages.removeAt(index);
  });
}

// --- EDIT IMAGE ---
Future<void> editImage(int index) async {
  try {
    // Pass editedImages to preserve current edits
    final result = await Navigator.push<List<ImageEditData>>(
      context,
      MaterialPageRoute(
        builder: (_) => ImageEditorPage(initialImages: editedImages.map((e) => XFile(e.image.path)).toList()),
      ),
    );

    if (result == null || result.isEmpty) return;

    final newSelected = <XFile>[];
    final newEdited = <ImageEditData>[];
    final missingFiles = <String>[];

    for (var editData in result) {
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
        SnackBar(content: Text("Cannot access edited files: ${missingFiles.join(', ')}")),
      );
    }

    if (newEdited.isEmpty) return;

    setState(() {
      editedImages = newEdited;
      selectedImages
        ..clear()
        ..addAll(newSelected);
    });
  } on Exception catch (e) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Failed to edit image: $e")),
    );
  }
}


  // --- MODALS ---

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
      builder: (_) => PostHashTagPage(initialSelectedHashtags: selectedHashtags),
    );

    if (res != null) {
      setState(() {
        selectedHashtags = res;
        _updateDisplayText();
      });
    }
  }

  void openTagging() async {
    final res = await showModalBottomSheet<List<PostTagPeopleModel>>(
      context: context,
      isScrollControlled: true,
      showDragHandle: true,
      builder: (_) => PostTagPeople(initialSelected: taggedPeople),
    );

    if (res != null) {
      setState(() => taggedPeople = res);
    }
  }

  // --- SUBMIT POST ---
  Future<void> submit() async {
    if (!isValidPost) return;

    final viewModel = ref.read(createPostViewModelProvider.notifier);
    final selectedCategory = ref.read(selectedCategoryProvider);

    viewModel.setCategory(selectedCategory?.id ?? "");
    viewModel.setCaption(originalCaption);

    viewModel.setHashtags({
      ..._extractHashtags(originalCaption),
      ...selectedHashtags,
    }.toList());

    viewModel.setTaggedUsers(taggedPeople.map((e) => e.id).toList());

    viewModel.setMedia(
      editedImages
          .map((e) => PostMediaState(path: e.image.path, aspectRatio: e.aspectRatio, type: e.type))
          .toList(),
    );

    // Submit to backend
    await viewModel.submit();

    final state = ref.read(createPostViewModelProvider);

    if (state.isSuccess) {
      if (!mounted) return;
      // Use a callback to the parent instead of navigating here
      if (widget.onPostSubmit != null) {
        widget.onPostSubmit!();
      } else {
        // fallback: show success dialog and pop the post page when done
        showPostSuccessDialog(context, () {
          Navigator.of(context).pop();
        });
      }
    } else if (state.error != null) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(state.error!), backgroundColor: Colors.red),
      );
    }
  }


  @override
  Widget build(BuildContext context) {
    final category = ref.watch(selectedCategoryProvider);
    final viewState = ref.watch(createPostViewModelProvider);

    return Scaffold(
      appBar: AppBar(
        actions: [
          TextButton(
            onPressed: isValidPost ? submit : null,
            child: Text(
              "Post",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: isValidPost
                    ? Theme.of(context).colorScheme.primary
                    : Colors.grey,
              ),
            ),
          ),
          const SizedBox(width: 16),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.only(bottom: 24),
        child: Column(
          children: [
            UserInfoHeader(
              username: viewState.author.isNotEmpty ? viewState.author : "username",
              profileImagePath: viewState.picture.isNotEmpty ? viewState.picture : "assets/images/dp.jpg",
              onSettingPressed: openSettings,
            ),

            // --- CATEGORY PICKER ---
            GestureDetector(
              onTap: openCategories,
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.primaryContainer,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Row(
                  children: [
                    category?.fileName != null && category!.fileName.isNotEmpty
                        ? ClipRRect(
                            borderRadius: BorderRadius.circular(4), // small rounding if needed
                            child: Image.network(
                              category.fileName,
                              width: 42,
                              height: 42,
                              fit: BoxFit.cover,
                              loadingBuilder: (context, child, loadingProgress) {
                                if (loadingProgress == null) return child;
                                return SizedBox(
                                  width: 32,
                                  height: 32,
                                  child: Center(
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                      value: loadingProgress.expectedTotalBytes != null
                                          ? loadingProgress.cumulativeBytesLoaded /
                                            (loadingProgress.expectedTotalBytes ?? 1)
                                          : null,
                                    ),
                                  ),
                                );
                              },
                              errorBuilder: (context, error, stackTrace) {
                                return Icon(Icons.category, size: 28);
                              },
                            ),
                          )
                        : Icon(Icons.category, size: 28),
                    const SizedBox(width: 12),
                    Text(
                      category?.name ?? "Select Category",
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const Spacer(),
                    Icon(Icons.arrow_drop_down),
                  ],
                ),

              ),
            ),

            // --- MAIN BOX ---
            AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              margin: const EdgeInsets.all(16),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surface,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.grey.shade300),
              ),
              child: LayoutBuilder(
                builder: (context, constraints) {
                  final screenHeight = MediaQuery.of(context).size.height;
                  final containerHeight = selectedImages.isNotEmpty
                      ? screenHeight * 0.6 // 60% of screen height when images exist
                      : screenHeight * 0.35; // 35% if no images

                  return SizedBox(
                    height: containerHeight,
                    child: Column(
                      children: [
                        PostTextInput(
                          controller: displayController,
                          onChanged: () => setState(() {}),
                          hasImages: selectedImages.isNotEmpty,
                        ),
                        const SizedBox(height: 8),
                        if (selectedImages.isNotEmpty)
                          SizedBox(
                            height: containerHeight * 0.55, // leave space for text & buttons
                            child: PostImagePicker(
                              selectedImages: selectedImages,
                              onPickFromCamera: pickFromCamera,
                              onPickFromGallery: pickImages,
                              onRemoveImage: removeImage,
                              onEditImage: editImage,
                              canAddMore: selectedImages.length < 4,
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
            )

          ],
        ),
      ),
    );
  }
}


// Success Model
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
            Icon(Icons.check_circle, size: 60, color: Colors.green),
            const SizedBox(height: 16),
            Text("Post Submitted", style: Theme.of(context).textTheme.headlineSmall),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pop(context); // close dialog
                  onDone();               // tell parent to switch page
                },
                child: const Text("Done"),
              ),
            ),
          ],
        ),
      ),
    ),
  );
}
