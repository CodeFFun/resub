import 'package:flutter/material.dart';

class CategoryChipFilter extends StatelessWidget {
  final String categoryName;
  final bool isSelected;
  final ValueChanged<bool> onSelected;

  const CategoryChipFilter({
    super.key,
    required this.categoryName,
    required this.isSelected,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4.0),
      child: FilterChip(
        selected: isSelected,
        label: Text(categoryName),
        onSelected: onSelected,
        backgroundColor: Colors.white,
        selectedColor: Colors.orange,
        labelStyle: TextStyle(
          color: isSelected ? Colors.white : Colors.grey[700],
          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
        ),
        side: BorderSide(color: isSelected ? Colors.orange : Colors.grey[300]!),
      ),
    );
  }
}
