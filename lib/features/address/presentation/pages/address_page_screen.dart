import 'package:flutter/material.dart';
import 'package:resub/app/routes/app_routes.dart';
import 'package:resub/features/address/domain/entities/address_entity.dart';
import 'package:resub/features/address/presentation/pages/create_adress_screen.dart';
import 'package:resub/features/address/presentation/pages/update_address_screen.dart';
import 'package:resub/features/address/presentation/widgets/address_card.dart';

class AddressPageScreen extends StatefulWidget {
  const AddressPageScreen({super.key});

  @override
  State<AddressPageScreen> createState() => _AddressPageScreenState();
}

class _AddressPageScreenState extends State<AddressPageScreen> {
  late List<AddressEntity> _addresses;

  @override
  void initState() {
    super.initState();
    // Initialize with dummy data
    _addresses = [
      const AddressEntity(
        id: '1',
        label: 'Home',
        line1: '123 Main Street, Apartment 4B',
        city: 'San Francisco',
        state: 'California',
        country: 'United States',
      ),
    ];
  }

  void _handleAddAddress(AddressEntity address) {
    setState(() {
      _addresses.add(
        address.copyWith(id: DateTime.now().millisecondsSinceEpoch.toString()),
      );
    });
    if (mounted) {
      Navigator.pop(context);
    }
  }

  void _handleUpdateAddress(AddressEntity address) {
    setState(() {
      final index = _addresses.indexWhere((addr) => addr.id == address.id);
      if (index != -1) {
        _addresses[index] = address;
      }
    });
    if (mounted) {
      Navigator.pop(context);
    }
  }

  void _handleDeleteAddress(String id) {
    setState(() {
      _addresses.removeWhere((addr) => addr.id == id);
    });
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
