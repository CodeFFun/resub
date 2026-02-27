import 'package:flutter/material.dart';

class SubscriptionSelectAllWidget extends StatelessWidget {
  final bool selectAll;
  final VoidCallback onToggle;

  const SubscriptionSelectAllWidget({
    super.key,
    required this.selectAll,
    required this.onToggle,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        border: Border(bottom: BorderSide(color: Colors.grey[300]!)),
      ),
      child: Row(
        children: [
          Checkbox(value: selectAll, onChanged: (_) => onToggle()),
          const SizedBox(width: 12),
          const Text(
            'Select All Items',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Colors.black87,
            ),
          ),
        ],
      ),
    );
  }
}
