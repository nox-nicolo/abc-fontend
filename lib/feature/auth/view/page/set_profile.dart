import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:africa_beuty/core/constants/server_constants.dart';
import 'package:africa_beuty/core/widgets/loader.dart';
import 'package:africa_beuty/feature/auth/view/page/select_service.dart';
import 'package:africa_beuty/feature/auth/view_model/setaccount_viewmodel.dart';
import 'package:africa_beuty/feature/auth/view_model/uploadaccount_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';

enum _UsernameStatus { idle, checking, available, taken, tooShort, invalidChars }

class SetProfile extends ConsumerStatefulWidget {
  const SetProfile({super.key});

  @override
  ConsumerState<SetProfile> createState() => _SetProfileState();
}

class _SetProfileState extends ConsumerState<SetProfile> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _usernameController = TextEditingController();
  File? _image;
  bool _useNetworkImage = true;

  _UsernameStatus _usernameStatus = _UsernameStatus.idle;
  Timer? _debounce;

  bool _profileLoaded = false;
  // The username that came from the API — treated as "available" so the
  // user doesn't need to wait for a round-trip just to keep their own name.
  String _serverUsername = '';

  @override
  void initState() {
    super.initState();
    _usernameController.addListener(_onUsernameChanged);
    Future.microtask(
        () => ref.read(setProfileViewModelProvider.notifier).getUserProfile());
  }

  @override
  void dispose() {
    _debounce?.cancel();
    _usernameController.removeListener(_onUsernameChanged);
    _usernameController.dispose();
    super.dispose();
  }

  // ── Username validation ─────────────────────────────────────────────────────

  void _onUsernameChanged() {
    final value = _usernameController.text.trim();

    // If the user kept / restored their own username — mark available instantly.
    if (value == _serverUsername && _serverUsername.isNotEmpty) {
      _debounce?.cancel();
      setState(() => _usernameStatus = _UsernameStatus.available);
      return;
    }

    if (value.length < 3) {
      _debounce?.cancel();
      setState(() => _usernameStatus =
          value.isEmpty ? _UsernameStatus.idle : _UsernameStatus.tooShort);
      return;
    }

    if (!_isValidChars(value)) {
      _debounce?.cancel();
      setState(() => _usernameStatus = _UsernameStatus.invalidChars);
      return;
    }

    setState(() => _usernameStatus = _UsernameStatus.checking);
    _debounce?.cancel();
    _debounce = Timer(
      const Duration(milliseconds: 600),
      () => _checkUsername(value),
    );
  }

  bool _isValidChars(String v) =>
      v.replaceAll('_', '').split('').every((c) => RegExp(r'[a-zA-Z0-9]').hasMatch(c));

  Future<void> _checkUsername(String username) async {
    try {
      final uri = Uri.parse(
        '${ServerConstants.serverUrl}/users/check-username'
        '?username=${Uri.encodeComponent(username)}',
      );
      final response = await http
          .get(uri)
          .timeout(const Duration(seconds: 8));

      if (!mounted) return;

      if (response.statusCode == 200) {
        final body = jsonDecode(response.body) as Map<String, dynamic>;
        setState(() {
          _usernameStatus = (body['available'] == true)
              ? _UsernameStatus.available
              : _UsernameStatus.taken;
        });
      } else {
        // Non-200 — treat as idle so the user can still proceed
        setState(() => _usernameStatus = _UsernameStatus.idle);
      }
    } on TimeoutException {
      if (mounted) {
        // Server too slow — let the user proceed (server will re-validate on save)
        setState(() => _usernameStatus = _UsernameStatus.idle);
      }
    } catch (_) {
      if (mounted) setState(() => _usernameStatus = _UsernameStatus.idle);
    }
  }

  // ── Image picker ────────────────────────────────────────────────────────────

  Future<void> _pickImage(ImageSource source) async {
    final pickedFile = await ImagePicker().pickImage(source: source);
    if (pickedFile == null) return;

    final croppedFile = await ImageCropper().cropImage(
      sourcePath: pickedFile.path,
      aspectRatio: const CropAspectRatio(ratioX: 1, ratioY: 1),
      compressQuality: 100,
      uiSettings: [
        AndroidUiSettings(
          toolbarTitle: 'Crop Image',
          toolbarWidgetColor: Colors.black,
          initAspectRatio: CropAspectRatioPreset.square,
          lockAspectRatio: true,
        ),
        IOSUiSettings(
          title: 'Crop Image',
          aspectRatioLockEnabled: true,
          aspectRatioPresets: [CropAspectRatioPreset.square],
        ),
      ],
    );

    if (croppedFile != null) {
      setState(() {
        _image = File(croppedFile.path);
        _useNetworkImage = false;
      });
    }
  }

  void _showImagePickerModal() {
    showModalBottomSheet(
      context: context,
      builder: (ctx) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(Icons.photo_library_outlined),
                title: const Text('Choose from Gallery'),
                onTap: () {
                  Navigator.pop(ctx);
                  _pickImage(ImageSource.gallery);
                },
              ),
              ListTile(
                leading: const Icon(Icons.camera_alt_outlined),
                title: const Text('Take a Photo'),
                onTap: () {
                  Navigator.pop(ctx);
                  _pickImage(ImageSource.camera);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ── Submit ──────────────────────────────────────────────────────────────────

  bool get _canSubmit =>
      _usernameStatus == _UsernameStatus.available ||
      _usernameStatus == _UsernameStatus.idle;

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    await ref.read(uploadAccountViewModelProvider.notifier).uploadAccount(
          username: _usernameController.text.trim(),
          profileFile: _image,
          useNetworkImage: _useNetworkImage,
        );
  }

  // ── Build ───────────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    final isUploading =
        ref.watch(uploadAccountViewModelProvider)?.isLoading == true;
    final profileState = ref.watch(setProfileViewModelProvider);
    final profileData = profileState?.value;

    // ── Load profile data once ──────────────────────────────────────────────
    if (!_profileLoaded && profileData != null) {
      _profileLoaded = true;
      _serverUsername = profileData.username;

      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted) return;
        // Remove listener so setting text doesn't trigger an unnecessary check
        _usernameController.removeListener(_onUsernameChanged);
        _usernameController.text = profileData.username;
        _usernameController.addListener(_onUsernameChanged);
        // Mark as available immediately — it's their current username
        if (profileData.username.isNotEmpty) {
          setState(() => _usernameStatus = _UsernameStatus.available);
        }
      });
    }

    // ── Upload result listener ──────────────────────────────────────────────
    ref.listen(uploadAccountViewModelProvider, (_, next) {
      next?.when(
        data: (data) {
          ScaffoldMessenger.of(context)
            ..hideCurrentMaterialBanner()
            ..showSnackBar(SnackBar(content: Text(data.message)));
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (_) => const SelectService()),
          );
        },
        error: (error, _) {
          ScaffoldMessenger.of(context)
            ..hideCurrentMaterialBanner()
            ..showSnackBar(SnackBar(content: Text(error.toString())));
        },
        loading: () {},
      );
    });

    // ── Image provider ──────────────────────────────────────────────────────
    ImageProvider? imageProvider;
    if (!_useNetworkImage && _image != null) {
      imageProvider = FileImage(_image!);
    } else if ((profileData?.pictureUrl ?? '').isNotEmpty) {
      imageProvider = NetworkImage(profileData!.pictureUrl);
    }

    final scheme = Theme.of(context).colorScheme;

    return Scaffold(
      body: isUploading
          ? const Loader()
          : SafeArea(
              child: SingleChildScrollView(
                padding:
                    const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Set up your profile',
                        style: Theme.of(context)
                            .textTheme
                            .headlineMedium
                            ?.copyWith(fontWeight: FontWeight.w800),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        'Choose a photo and username — you can change these later.',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: scheme.onSurfaceVariant),
                      ),
                      const SizedBox(height: 36),

                      // ── Avatar ─────────────────────────────────────────────
                      Center(
                        child: GestureDetector(
                          onTap: _showImagePickerModal,
                          child: Stack(
                            children: [
                              CircleAvatar(
                                radius: 64,
                                backgroundColor:
                                    scheme.surfaceContainerHighest,
                                backgroundImage: imageProvider,
                                child: imageProvider == null
                                    ? Icon(Icons.person_outline_rounded,
                                        size: 56,
                                        color: scheme.onSurfaceVariant)
                                    : null,
                              ),
                              Positioned(
                                bottom: 2,
                                right: 2,
                                child: Container(
                                  padding: const EdgeInsets.all(6),
                                  decoration: BoxDecoration(
                                    color: scheme.primary,
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                        color: scheme.surface, width: 2),
                                  ),
                                  child: Icon(Icons.camera_alt_rounded,
                                      size: 16, color: scheme.onPrimary),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 36),

                      // ── Loading skeleton while profile fetches ─────────────
                      if (profileState == null ||
                          profileState.isLoading)
                        const Padding(
                          padding: EdgeInsets.only(bottom: 16),
                          child: LinearProgressIndicator(),
                        ),

                      // ── Username field ─────────────────────────────────────
                      TextFormField(
                        controller: _usernameController,
                        style: const TextStyle(fontWeight: FontWeight.w600),
                        decoration: InputDecoration(
                          labelText: 'Username',
                          prefixText: '@',
                          prefixStyle: TextStyle(
                              color: scheme.primary,
                              fontWeight: FontWeight.w700),
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(14)),
                          filled: true,
                          fillColor: scheme.surfaceContainerHighest,
                          suffixIcon: _buildStatusIcon(scheme),
                          helperText: _helperText,
                          helperStyle:
                              TextStyle(color: _helperColor(scheme)),
                        ),
                        validator: (_) {
                          if (_usernameController.text.trim().length < 3) {
                            return 'Username must be at least 3 characters';
                          }
                          if (!_isValidChars(
                              _usernameController.text.trim())) {
                            return 'Only letters, numbers and underscores (_)';
                          }
                          if (_usernameStatus == _UsernameStatus.taken) {
                            return 'Username is already taken';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 48),

                      // ── Continue button ────────────────────────────────────
                      SizedBox(
                        width: double.infinity,
                        height: 52,
                        child: FilledButton(
                          onPressed: _canSubmit ? _submit : null,
                          child: const Text(
                            'Continue',
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.w700),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
    );
  }

  // ── Status icon & helpers ───────────────────────────────────────────────────

  Widget? _buildStatusIcon(ColorScheme scheme) {
    switch (_usernameStatus) {
      case _UsernameStatus.checking:
        return Padding(
          padding: const EdgeInsets.all(12),
          child: SizedBox(
            width: 20,
            height: 20,
            child: CircularProgressIndicator(
                strokeWidth: 2, color: scheme.primary),
          ),
        );
      case _UsernameStatus.available:
        return Icon(Icons.check_circle_rounded,
            color: Colors.green.shade600);
      case _UsernameStatus.taken:
        return Icon(Icons.cancel_rounded, color: scheme.error);
      case _UsernameStatus.tooShort:
      case _UsernameStatus.invalidChars:
        return Icon(Icons.info_outline_rounded,
            color: Colors.orange.shade600);
      case _UsernameStatus.idle:
        return null;
    }
  }

  String? get _helperText {
    switch (_usernameStatus) {
      case _UsernameStatus.available:
        return 'Username is available';
      case _UsernameStatus.taken:
        return 'Username is already taken';
      case _UsernameStatus.tooShort:
        return 'At least 3 characters required';
      case _UsernameStatus.invalidChars:
        return 'Only letters, numbers and underscores (_)';
      case _UsernameStatus.checking:
        return 'Checking availability...';
      case _UsernameStatus.idle:
        return null;
    }
  }

  Color _helperColor(ColorScheme scheme) {
    switch (_usernameStatus) {
      case _UsernameStatus.available:
        return Colors.green.shade600;
      case _UsernameStatus.taken:
        return scheme.error;
      case _UsernameStatus.tooShort:
      case _UsernameStatus.invalidChars:
        return Colors.orange.shade600;
      default:
        return scheme.onSurfaceVariant;
    }
  }
}
