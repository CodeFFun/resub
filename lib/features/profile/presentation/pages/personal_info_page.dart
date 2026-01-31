import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:resub/core/api/api_endpoints.dart';
import 'package:resub/core/services/storage/user_session_service.dart';
import 'package:resub/core/utils/snackbar_utils.dart';
import 'package:resub/core/widgets/my_button.dart';
import 'package:resub/core/widgets/my_input_form_field.dart';
import 'package:resub/features/dashboard/presentation/pages/home_screen.dart';
import 'package:resub/features/profile/presentation/state/profile_state.dart';
import 'package:resub/features/profile/presentation/view_models/profile_view_model.dart';
import 'package:resub/features/profile/presentation/widgets/media_picker_bottom_sheet.dart';

class PersonalInfoPage extends ConsumerStatefulWidget {
  const PersonalInfoPage({super.key});

  @override
  ConsumerState<PersonalInfoPage> createState() => _PersonalInfoPageState();
}

class _PersonalInfoPageState extends ConsumerState<PersonalInfoPage> {
  final _formKey = GlobalKey<FormState>();
  final _fullNameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _emailController = TextEditingController();
  final List<XFile?> _profilePictureUrl = [];
  String? _profilePicture;
  String _userName = '';
  final _imagePicker = ImagePicker();
  bool _isDataLoaded = false; // Track if data has been loaded

  @override
  void dispose() {
    _fullNameController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadUserData();
    });
  }

  Future<void> _loadUserData() async {
    final userSession = ref.read(userSessionServiceProvider);
    final userId = userSession.getCurrentUserId();

    if (userId != null) {
      await ref
          .read(profileViewModelProvider.notifier)
          .getProfileById(userId: userId);
    }
  }

  Future<bool> _requestPermission(Permission permission) async {
    final status = await permission.status;
    if (status.isGranted) return true;

    if (status.isDenied) {
      final result = await permission.request();
      return result.isGranted;
    }

    if (status.isPermanentlyDenied) {
      // _showPermissionDeniedDialog();
      return false;
    }

    return false;
  }

  Future<void> _pickFromCamera() async {
    final hasPermission = await _requestPermission(Permission.camera);
    if (!hasPermission) return;

    final XFile? photo = await _imagePicker.pickImage(
      source: ImageSource.camera,
      imageQuality: 80,
    );

    if (photo != null) {
      setState(() {
        _profilePictureUrl.clear();
        _profilePictureUrl.add(XFile(photo.path));
      });
    }
  }

  Future<void> _pickFromGallery() async {
    try {
      final XFile? image = await _imagePicker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 80,
      );

      if (image != null) {
        setState(() {
          _profilePictureUrl.clear();
          _profilePictureUrl.add(XFile(image.path));
        });
      }
    } catch (e) {
      debugPrint('Image picker error: $e');
    }
  }

  void _showMediaPicker() {
    MediaPickerBottomSheet.show(
      context,
      onCameraTap: _pickFromCamera,
      onGalleryTap: _pickFromGallery,
    );
  }

  void _clearImage() {
    setState(() {
      _profilePictureUrl.clear();
    });
  }

  void _handleSubmit() async {
    if (_formKey.currentState!.validate()) {
      // Process data
      await ref
          .read(profileViewModelProvider.notifier)
          .updateProfile(
            fullName: _fullNameController.text.trim(),
            phoneNumber: _phoneController.text.trim(),
            alternateEmail: _emailController.text.trim(),
            profilePictureUrl: _profilePictureUrl.isNotEmpty
                ? File(_profilePictureUrl.first!.path)
                : null,
          );
    }
  }

  @override
  Widget build(BuildContext context) {
    ref.listen<ProfileState>(profileViewModelProvider, (previous, next) {
      if (next.status == ProfileStatus.loaded &&
          !_isDataLoaded &&
          next.user != null) {
        _isDataLoaded = true;
        _fullNameController.text = next.user!.fullName ?? '';
        _phoneController.text = next.user!.phoneNumber ?? '';
        _emailController.text = next.user!.alternateEmail ?? '';
        _profilePicture = next.user!.profilePicture;
        _userName = next.user!.userName ?? '';
      } else if (next.status == ProfileStatus.updated) {
        SnackbarUtils.showSuccess(context, 'Profile updated successfully!');
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const HomeScreen()),
        );
      } else if (next.status == ProfileStatus.error &&
          next.errorMessage != null) {
        SnackbarUtils.showError(context, next.errorMessage!);
      }
    });

    final profileState = ref.watch(profileViewModelProvider);

    return Scaffold(
      body: profileState.status == ProfileStatus.loading && !_isDataLoaded
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.only(
                  top: 60,
                  left: 20,
                  right: 20,
                  bottom: 20,
                ),
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      const SizedBox(height: 20),
                      // Profile Picture Section
                      if (_profilePictureUrl.isNotEmpty)
                        GestureDetector(
                          onTap: _showMediaPicker,
                          child: Stack(
                            children: [
                              CircleAvatar(
                                radius: 60,
                                backgroundColor: Colors.pink.shade300,
                                backgroundImage:
                                    FileImage(
                                          File(_profilePictureUrl.first!.path),
                                        )
                                        as ImageProvider?,
                                child: null,
                              ),
                              Positioned(
                                top: 10,
                                right: 10,
                                child: Container(
                                  padding: const EdgeInsets.all(8),
                                  decoration: const BoxDecoration(
                                    color: Colors.white,
                                    shape: BoxShape.circle,
                                  ),
                                  child: GestureDetector(
                                    onTap: _clearImage,
                                    child: const Text(
                                      'x',
                                      style: TextStyle(
                                        color: Colors.red,
                                        fontSize: 20,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        )
                      else if (_profilePicture != null &&
                          _profilePicture!.isNotEmpty)
                        GestureDetector(
                          onTap: _showMediaPicker,
                          child: Stack(
                            children: [
                              CircleAvatar(
                                radius: 60,
                                backgroundImage: NetworkImage(
                                  '${ApiEndpoints.baseUrl}$_profilePicture',
                                ),
                              ),
                              Positioned(
                                top: 10,
                                right: 10,
                                child: Container(
                                  padding: const EdgeInsets.all(8),
                                  decoration: const BoxDecoration(
                                    color: Colors.white,
                                    shape: BoxShape.circle,
                                  ),
                                  child: GestureDetector(
                                    onTap: _clearImage,
                                    child: const Text(
                                      'x',
                                      style: TextStyle(
                                        color: Colors.red,
                                        fontSize: 20,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        )
                      else
                        GestureDetector(
                          onTap: _showMediaPicker,
                          child: CircleAvatar(
                            radius: 60,
                            backgroundColor: Colors.pink.shade300,
                            child: const Icon(
                              Icons.camera_alt,
                              size: 40,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      const SizedBox(height: 20),
                      Text(
                        _userName,
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 30),

                      // Full Name
                      MyInputFormField(
                        controller: _fullNameController,
                        labelText: 'Full name',
                        hintText: 'Enter your full name',
                        icon: const Icon(Icons.person_outline),
                        inputType: TextInputType.text,
                      ),
                      const SizedBox(height: 25),

                      // Phone Number
                      MyInputFormField(
                        controller: _phoneController,
                        labelText: 'Phone number',
                        hintText: 'Enter your phone number',
                        icon: const Icon(Icons.phone_outlined),
                        inputType: TextInputType.phone,
                      ),
                      const SizedBox(height: 25),

                      // Alternate Email
                      MyInputFormField(
                        controller: _emailController,
                        labelText: 'Alternate email',
                        hintText: 'Enter your email',
                        icon: const Icon(Icons.email_outlined),
                        inputType: TextInputType.emailAddress,
                      ),
                      const SizedBox(height: 45),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          // Back Button
                          SizedBox(
                            width: 180,
                            height: 56,
                            child: MyButton(
                              text: "Back",
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              color: Colors.red,
                            ),
                          ),
                          SizedBox(width: 20),
                          // Next Button
                          Expanded(
                            child: SizedBox(
                              height: 56,
                              child: MyButton(
                                text: "Update",
                                onPressed: _handleSubmit,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
    );
  }
}
