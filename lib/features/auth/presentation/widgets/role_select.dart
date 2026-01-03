import 'package:flutter/material.dart';

class RoleSelect extends StatelessWidget {
  final String role;
  final String title;
  final IconData icon;
  final VoidCallback onTap;
  final String? selectedRole;
  const RoleSelect({
    super.key,
    required this.role,
    required this.title,
    required this.icon,
    required this.onTap,
    this.selectedRole,
  });
  @override
  Widget build(BuildContext context) {
    final bool isSelected = selectedRole == role;
    return InkWell(
      onTap: onTap,
      child: Card(
        color: isSelected ? Colors.lightGreen.shade100 : Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: BorderSide(
            color: isSelected ? Colors.green : Colors.transparent,
            width: 2,
          ),
        ),
        elevation: 4,
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            children: [
              Icon(icon, size: 120, color: Colors.brown[800]),
              SizedBox(height: 8),
              Text(
                title,
                style: TextStyle(fontSize: 16, color: Colors.brown[800]),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
