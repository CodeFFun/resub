import 'package:flutter/material.dart';
import 'package:resub/core/widgets/my_button.dart';
import 'package:resub/core/widgets/my_input_form_field.dart';
import 'package:resub/features/address/domain/entities/address_entity.dart';

class AddressForm extends StatefulWidget {
  final AddressEntity? initialAddress;
  final Function(AddressEntity)? onSubmit;
  final String submitButtonLabel;
  final bool showBackButton;

  const AddressForm({
    super.key,
    this.initialAddress,
    this.onSubmit,
    this.submitButtonLabel = 'Create',
    this.showBackButton = false,
  });

  @override
  State<AddressForm> createState() => _AddressFormState();
}

class _AddressFormState extends State<AddressForm> {
  late TextEditingController _labelController;
  late TextEditingController _line1Controller;
  late TextEditingController _cityController;
  late TextEditingController _stateController;
  late TextEditingController _countryController;
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _labelController = TextEditingController(
      text: widget.initialAddress?.label ?? '',
    );
    _line1Controller = TextEditingController(
      text: widget.initialAddress?.line1 ?? '',
    );
    _cityController = TextEditingController(
      text: widget.initialAddress?.city ?? '',
    );
    _stateController = TextEditingController(
      text: widget.initialAddress?.state ?? '',
    );
    _countryController = TextEditingController(
      text: widget.initialAddress?.country ?? '',
    );
  }

  @override
  void dispose() {
    _labelController.dispose();
    _line1Controller.dispose();
    _cityController.dispose();
    _stateController.dispose();
    _countryController.dispose();
    super.dispose();
  }

  void _handleSubmit() {
    final label = _labelController.text.trim();
    final line1 = _line1Controller.text.trim();
    final city = _cityController.text.trim();
    final state = _stateController.text.trim();
    final country = _countryController.text.trim();

    if (label.isEmpty ||
        line1.isEmpty ||
        city.isEmpty ||
        state.isEmpty ||
        country.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill in all fields.')),
      );
      return;
    }

    if (_formKey.currentState!.validate()) {
      final address = AddressEntity(
        id: widget.initialAddress?.id,
        label: label,
        line1: line1,
        city: city,
        state: state,
        country: country,
      );
      widget.onSubmit?.call(address);
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
          widget.showBackButton ? 'Update Address' : 'Add New Address',
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
                MyInputFormField(
                  controller: _labelController,
                  labelText: 'Label',
                  icon: const Icon(Icons.label_outline),
                ),
                const SizedBox(height: 15),
                MyInputFormField(
                  controller: _line1Controller,
                  labelText: 'Address Line 1',
                  icon: const Icon(Icons.home_outlined),
                ),
                const SizedBox(height: 15),
                MyInputFormField(
                  controller: _cityController,
                  labelText: 'City',
                  icon: const Icon(Icons.location_city_outlined),
                ),
                const SizedBox(height: 15),
                MyInputFormField(
                  controller: _stateController,
                  labelText: 'State',
                  icon: const Icon(Icons.location_on_outlined),
                ),
                const SizedBox(height: 15),
                MyInputFormField(
                  controller: _countryController,
                  labelText: 'Country',
                  icon: const Icon(Icons.public_outlined),
                ),
                const SizedBox(height: 30),
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
