import 'dart:io';

import 'package:africa_beuty/core/widgets/loader.dart';
import 'package:africa_beuty/feature/auth/view/page/select_service.dart';
import 'package:africa_beuty/feature/auth/view_model/setaccount_viewmodel.dart';
import 'package:africa_beuty/feature/auth/view_model/uploadaccount_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';

class SetProfile extends ConsumerStatefulWidget {
  const SetProfile({super.key});

  @override
  ConsumerState<SetProfile> createState() => _SetProfileState();
}


class _SetProfileState extends ConsumerState<SetProfile> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _usernameController = TextEditingController();
  File? _image;
  bool _useNetworkImage = true; // Track which image source to use
  

  @override
  void initState() {
    super.initState();

    Future.microtask(() {
      ref.read(setProfileViewModelProvider.notifier).getUserProfile();
    });
  }

  Future<void> _pickImage(ImageSource source ) async {
      final pickedFile = await ImagePicker().pickImage(source: source);

      if ( pickedFile != null ) {
        final croppedFile = await ImageCropper().cropImage(
          sourcePath: pickedFile.path, 
          aspectRatio: const CropAspectRatio(ratioX: 1, ratioY: 1), 
          compressQuality: 100, 
          uiSettings: [
            AndroidUiSettings(
              toolbarTitle: 'Crop Image', 
              toolbarWidgetColor: Colors.black, 
              initAspectRatio: CropAspectRatioPreset.square, 
              lockAspectRatio: true
            ),
            IOSUiSettings(
              title: 'Crop Image', 
              aspectRatioLockEnabled: true, 
              aspectRatioPresets: [
                CropAspectRatioPreset.square, 
              ]
            )
          ]
        );

        if ( croppedFile != null ) {
          setState(() {
            _image = File(croppedFile.path);
            _useNetworkImage = false;
          });
        }
      }
  }

  void _showImagePickerModal() {
    showModalBottomSheet(
      context: context, 
      builder: (context) {
        return SafeArea(
          child: Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ListTile(
                  leading: Icon(Icons.photo_library),
                  title: Text('Choose from Gallery'),
                  onTap: () {
                    _pickImage(ImageSource.gallery);
                    Navigator.pop(context);
                  },
                ),
                ListTile(
                  leading: Icon(Icons.camera_alt),
                  title: Text('Take a Picture'),
                  onTap: () {
                    _pickImage(ImageSource.camera);
                    Navigator.pop(context);
                  },
                )
              ],
            ),
          )
        );
      }
    );
  }
  
  @override
  Widget build(BuildContext context) {
    final isLoading = ref.watch(uploadAccountViewModelProvider)?.isLoading == true;
    final profileState = ref.watch(setProfileViewModelProvider);
    final profileData = profileState?.value;
    final profilePictureUrl = profileData?.pictureUrl ?? '';
    final profileUsername = profileData?.username ?? '';

    _usernameController.text = profileUsername;

    // Data and error wathcing
    ref.listen(
      uploadAccountViewModelProvider, 
      (_, next) {
        next?.when(
          data: (data) {
              ScaffoldMessenger.of(context)..hideCurrentMaterialBanner()
              ..showSnackBar(
                SnackBar(
                  content: Text(data.message),
                )
              );
              Navigator.pushReplacement(
                context, 
                MaterialPageRoute(
                  builder: (context) => 
                    const SelectService()
                )
              );
          }, 
          error: (error, st) {
            ScaffoldMessenger.of(context)
            ..hideCurrentMaterialBanner()
            ..showSnackBar(
              SnackBar(
                content: Text(error.toString())
              )
            );
          }, 
          loading: () {} // if handeling loading here will not able to return a widget
        );
      }
    );

    // Determine which image to display
    ImageProvider? imageProvider;
    if (!_useNetworkImage && _image != null ) {
      imageProvider = FileImage(_image!);
    } else if (profilePictureUrl.isNotEmpty) {
      imageProvider = NetworkImage(profilePictureUrl);
    }

    return Scaffold(
      body: isLoading ? const Loader()

       : 

      SafeArea(
        child: Padding( // Add padding to the main content area
          padding: const EdgeInsets.all(16.0), // Adjust padding as needed
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Set Profile', 
                  style: Theme.of(context).textTheme.titleLarge,
                ), 
                Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Stack(
                        children: [
                          CircleAvatar(
                            radius: 80,
                            backgroundImage: imageProvider, // Use the determined image provider
                            
                            // child: _image == null ? Icon(Icons.person, size: 80,) : null,
                            backgroundColor: Colors.transparent,
                          
                          ),
                          Positioned(
                            bottom: 0, 
                            right: 0, 
                            child: GestureDetector(
                              onTap: _showImagePickerModal,
                              child: Container(
                                padding: EdgeInsets.all(8), 
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                ),
                                child: Icon(
                                  Icons.camera_alt_outlined, 
                                  size: 24,
                                ),
                              ),
                            )
                          ),
                        ], 
                      ), 
                      
                  
                      Padding(
                        padding: EdgeInsets.all(24), 
                        child: TextFormField(
                          controller: _usernameController,
                          style: TextStyle(
                            fontWeight: FontWeight.w800, 
                          ),
                          decoration: InputDecoration(
                            icon: Icon(FontAwesome.dollar_sign_solid), 
                            hintText: 'username', 
                          ),
                          
                          // Working here letter ?? Suggestion for usernames..
                          validator: (value) {
                            if ( value == null || value.isEmpty ) {
                              return 'Please \nEnter \nusername';
                            } else {
                              return null;
                            }
                          },
                          // ... here here .. 
                        )
                      )
                    ],
                  ),
                ), 
                const SizedBox(height: 20,), 
                SizedBox(
                  width: double.infinity,
                  child: TextButton(
                    onPressed: () async {
                      if (_formKey.currentState!.validate() ) {

                        File? fileToUpload = _image??_image;

                        await ref.read(uploadAccountViewModelProvider.notifier).uploadAccount(
                          username: _usernameController.text.trim(),
                          profileFile: fileToUpload, 
                          useNetworkImage: _useNetworkImage
                        );
                      }
                    }, 
                    child: Text('Next')
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}