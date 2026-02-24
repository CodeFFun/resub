import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:resub/app/routes/app_routes.dart';
import 'package:resub/core/services/storage/user_session_service.dart';
import 'package:resub/features/address/domain/entities/address_entity.dart';
import 'package:resub/features/address/presentation/pages/create_adress_screen.dart';
import 'package:resub/features/address/presentation/pages/update_address_screen.dart';
import 'package:resub/features/address/presentation/state/address_state.dart';
import 'package:resub/features/address/presentation/view_models/address_view_model.dart';
import 'package:resub/features/address/presentation/widgets/address_card.dart';

class AddressPageScreen extends ConsumerStatefulWidget {
  const AddressPageScreen({super.key});

  @override
  ConsumerState<AddressPageScreen> createState() => _AddressPageScreenState();
}

class _AddressPageScreenState extends ConsumerState<AddressPageScreen> {
  late List<AddressEntity> _addresses = [];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadUserData();
    });
  }

  void _loadUserData() async {
    final userSession = ref.read(userSessionServiceProvider);
    final userId = userSession.getCurrentUserId();

    if (userId != null) {
      await ref.read(addressViewModelProvider.notifier).getAddressesOfUser();
    }
  }

  void _handleAddAddress(AddressEntity address) async {
    await ref
        .read(addressViewModelProvider.notifier)
        .createAddress(addressEntity: address);
    if (mounted) {
      Navigator.pop(context);
    }
  }

  void _handleUpdateAddress(AddressEntity address) async {
    await ref
        .read(addressViewModelProvider.notifier)
        .updateAddress(addressEntity: address, addressId: address.id!);
    if (mounted) {
      Navigator.pop(context);
    }
  }

  void _handleDeleteAddress(String id) async {
    await ref
        .read(addressViewModelProvider.notifier)
        .deleteAddress(addressId: id);
  }

  void _openCreateAddressScreen() {
    AppRoutes.push(
      context,
      CreateAddressScreen(onAddressCreated: _handleAddAddress),
    );
  }

  void _openUpdateAddressScreen(AddressEntity address) {
    AppRoutes.push(
      context,
      UpdateAddressScreen(
        address: address,
        onAddressUpdated: _handleUpdateAddress,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    ref.listen<AddressState>(addressViewModelProvider, (previous, next) {
      if (next.status == AddressStatus.created) {
        ref.read(addressViewModelProvider.notifier).getAddressesOfUser();
      }
      if (next.status == AddressStatus.deleted) {
        ref.read(addressViewModelProvider.notifier).getAddressesOfUser();
      }
      if (next.status == AddressStatus.updated) {
        ref.read(addressViewModelProvider.notifier).getAddressesOfUser();
      }
      if (next.status == AddressStatus.loaded && next.addresses != null) {
        setState(() {
          _addresses = next.addresses!;
        });
      }
    });
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          'My Addresses',
          style: TextStyle(
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
      body: Column(
        children: [
          Expanded(
            child: _addresses.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.location_off_outlined,
                          size: 64,
                          color: Colors.grey.shade400,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'No addresses yet',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.grey.shade600,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Add a new address to get started',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey.shade500,
                          ),
                        ),
                      ],
                    ),
                  )
                : ListView.builder(
                    itemCount: _addresses.length,
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    itemBuilder: (context, index) {
                      final address = _addresses[index];
                      return AddressCard(
                        address: address,
                        onLeftIconTap: () => _openUpdateAddressScreen(address),
                        onDelete: () => _handleDeleteAddress(address.id ?? ''),
                      );
                    },
                  ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: _openCreateAddressScreen,
                icon: const Icon(Icons.add),
                label: const Text('Add New Address'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF92400E),
                  padding: const EdgeInsets.symmetric(vertical: 12),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
