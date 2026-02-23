import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:resub/core/api/api_endpoints.dart';
import 'package:resub/core/widgets/my_button.dart';
import 'package:resub/core/widgets/my_input_form_field.dart';
import 'package:resub/features/profile/presentation/widgets/media_picker_bottom_sheet.dart';
import 'package:resub/features/shop/domain/entities/shop_entity.dart';

class ShopForm extends StatefulWidget {
  final ShopEntity? initialShop;
  final List<String> categories;
  final List<String> addresses;
  final Function(ShopEntity)? onSubmit;
  final String submitButtonLabel;
  final bool showBackButton;

  const ShopForm({
    super.key,
    this.initialShop,
    required this.categories,
    required this.addresses,
    this.onSubmit,
    this.submitButtonLabel = 'Add Shop',
    this.showBackButton = false,
  });

  @override
  State<ShopForm> createState() => _ShopFormState();
}

class _ShopFormState extends State<ShopForm> {
  late TextEditingController _nameController;
  late TextEditingController _aboutController;
  late String _selectedCategory;
  late String _selectedAddress;
  late bool _acceptsSubscription;
  final List<XFile?> _shopImageUrl = [];
  String? _shopImage;
  final _formKey = GlobalKey<FormState>();
  final _imagePicker = ImagePicker();

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(
      text: widget.initialShop?.name ?? '',
    );
    _aboutController = TextEditingController(
      text: widget.initialShop?.about ?? '',
    );
    _selectedCategory =
        widget.initialShop?.category ??
        (widget.categories.isNotEmpty ? widget.categories[0] : '');
    _selectedAddress =
        widget.initialShop?.address ??
        (widget.addresses.isNotEmpty ? widget.addresses[0] : '');
    _acceptsSubscription = widget.initialShop?.acceptsSubscription ?? false;
    _shopImage = widget.initialShop?.image;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _aboutController.dispose();
    super.dispose();
  }

  Future<bool> _requestPermission(Permission permission) async {
    final status = await permission.status;
    if (status.isGranted) return true;

    if (status.isDenied) {
      final result = await permission.request();
      return result.isGranted;
    }

    if (status.isPermanentlyDenied) {
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
        _shopImageUrl.clear();
        _shopImageUrl.add(XFile(photo.path));
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
          _shopImageUrl.clear();
          _shopImageUrl.add(XFile(image.path));
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
      _shopImageUrl.clear();
      _shopImage = null;
    });
  }

  void _handleSubmit() {
    if (_formKey.currentState!.validate()) {
      final shop = ShopEntity(
        id: widget.initialShop?.id,
        name: _nameController.text.trim(),
        image: _shopImageUrl.isNotEmpty
            ? _shopImageUrl.first?.path
            : _shopImage,
        about: _aboutController.text.trim(),
        acceptsSubscription: _acceptsSubscription,
        category: _selectedCategory,
        address: _selectedAddress,
      );
      widget.onSubmit?.call(shop);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Text(
          widget.showBackButton ? 'Update Shop' : 'Add New Shop',
          style: const TextStyle(
            color: Colors.black87,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        leading: GestureDetector(
          onTap: () => Navigator.pop(context),
          child: const Icon(Icons.arrow_back, color: Colors.black87),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                const SizedBox(height: 20),
                // Shop Image Section
                if (_shopImageUrl.isNotEmpty)
                  GestureDetector(
                    onTap: _showMediaPicker,
                    child: Stack(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: Image.file(
                            File(_shopImageUrl.first!.path),
                            width: 150,
                            height: 150,
                            fit: BoxFit.cover,
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
                else if (_shopImage != null && _shopImage!.isNotEmpty)
                  GestureDetector(
                    onTap: _showMediaPicker,
                    child: Stack(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: Image.network(
                            '${ApiEndpoints.baseUrl}/$_shopImage',
                            width: 150,
                            height: 150,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) {
                              return Container(
                                width: 150,
                                height: 150,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(12),
                                  color: Colors.grey.shade300,
                                ),
                                child: Icon(
                                  Icons.image_not_supported,
                                  size: 40,
                                  color: Colors.grey.shade600,
                                ),
                              );
                            },
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
                    child: Container(
                      width: 150,
                      height: 150,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        color: Colors.grey.shade300,
                      ),
                      child: const Icon(
                        Icons.camera_alt,
                        size: 50,
                        color: Colors.white,
                      ),
                    ),
                  ),
                const SizedBox(height: 30),

                // Shop Name
                MyInputFormField(
                  controller: _nameController,
                  labelText: 'Shop Name',
                  icon: const Icon(Icons.store_outlined),
                 
                ),
                const SizedBox(height: 15),

                // About
                MyInputFormField(
                  controller: _aboutController,
                  labelText: 'About',
                  icon: const Icon(Icons.info_outlined),
                  
                ),
                const SizedBox(height: 15),

                // Category Dropdown
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: DropdownButton<String>(
                    value: _selectedCategory,
                    isExpanded: true,
                    underline: const SizedBox(),
                    icon: const Icon(Icons.arrow_drop_down),
                    items: widget.categories.map((String category) {
                      return DropdownMenuItem<String>(
                        value: category,
                        child: Text(category),
                      );
                    }).toList(),
                    onChanged: (String? newValue) {
                      if (newValue != null) {
                        setState(() {
                          _selectedCategory = newValue;
                        });
                      }
                    },
                  ),
                ),
                const SizedBox(height: 15),

                // Address Dropdown
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: DropdownButton<String>(
                    value: _selectedAddress,
                    isExpanded: true,
                    underline: const SizedBox(),
                    icon: const Icon(Icons.arrow_drop_down),
                    items: widget.addresses.map((String address) {
                      return DropdownMenuItem<String>(
                        value: address,
                        child: Text(address, overflow: TextOverflow.ellipsis),
                      );
                    }).toList(),
                    onChanged: (String? newValue) {
                      if (newValue != null) {
                        setState(() {
                          _selectedAddress = newValue;
                        });
                      }
                    },
                  ),
                ),
                const SizedBox(height: 20),

                // Accepts Subscription Toggle
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.1),
                        spreadRadius: 1,
                        blurRadius: 4,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Accepts Subscription',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: Colors.black87,
                        ),
                      ),
                      Switch(
                        value: _acceptsSubscription,
                        onChanged: (value) {
                          setState(() {
                            _acceptsSubscription = value;
                          });
                        },
                        activeThumbColor: const Color(0xFF92400E),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 30),

                // Buttons
                SizedBox(
                  width: double.infinity,
                  child: MyButton(
                    text: widget.submitButtonLabel,
                    onPressed: _handleSubmit,
                  ),
                ),
                if (widget.showBackButton) ...[
                  const SizedBox(height: 12),
                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton(
                      onPressed: () => Navigator.pop(context),
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(color: Color(0xFF92400E)),
                        padding: const EdgeInsets.symmetric(vertical: 12),
                      ),
                      child: const Text(
                        'Back',
                        style: TextStyle(
                          color: Color(0xFF92400E),
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}
