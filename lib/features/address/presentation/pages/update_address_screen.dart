import 'package:flutter/material.dart';
import 'package:resub/features/address/domain/entities/address_entity.dart';
import 'package:resub/features/address/presentation/widgets/address_form.dart';

class UpdateAddressScreen extends StatelessWidget {
  final AddressEntity address;
  final Function(AddressEntity) onAddressUpdated;

  const UpdateAddressScreen({
    super.key,
    required this.address,
    required this.onAddressUpdated,
  });

  @override
  Widget build(BuildContext context) {
    return AddressForm(
      initialAddress: address,
      submitButtonLabel: 'Update',
      showBackButton: true,
      onSubmit: onAddressUpdated,
    );
  }
}
