import 'package:flutter/material.dart';
import 'package:resub/features/address/domain/entities/address_entity.dart';
import 'package:resub/features/address/presentation/widgets/address_form.dart';

class CreateAddressScreen extends StatelessWidget {
  final Function(AddressEntity) onAddressCreated;

  const CreateAddressScreen({super.key, required this.onAddressCreated});

  @override
  Widget build(BuildContext context) {
    return AddressForm(
      submitButtonLabel: 'Create',
      showBackButton: false,
      onSubmit: onAddressCreated,
    );
  }
}
