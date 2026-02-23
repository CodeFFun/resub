import 'package:flutter/material.dart';
import 'package:resub/features/category/domain/entities/category_entity.dart';

class CategoryCard extends StatelessWidget {
  final CategoryEntity category;
  final List<String> allShops; // List of shop names for display
  final VoidCallback onLeftIconTap;
  final VoidCallback onDelete;

  const CategoryCard({
    super.key,
    required this.category,
    required this.allShops,
    required this.onLeftIconTap,
    required this.onDelete,
  });

  String _getShopsDisplay() {
    if (category.shopIds.isEmpty) {
      return 'No shops';
    }
    // Get shop names - in this simple implementation using indices
    List<String> selectedShops = [];
    for (int i = 0; i < allShops.length; i++) {
      if (category.shopIds.contains(i.toString())) {
        selectedShops.add(allShops[i]);
      }
    }
    return selectedShops.isNotEmpty ? selectedShops.join(', ') : 'No shops';
  }

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: Key(category.id ?? category.name),
      onDismissed: (direction) {
        onDelete();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Category deleted'),
            duration: const Duration(seconds: 2),
          ),
        );
      },
      background: Container(
        color: Colors.red,
        alignment: Alignment.center,
        child: const Icon(Icons.delete, color: Colors.white),
      ),
      secondaryBackground: Container(
        color: Colors.red,
        alignment: Alignment.center,
        child: const Icon(Icons.delete, color: Colors.white),
      ),
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
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
        child: ListTile(
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 12,
          ),
          leading: GestureDetector(
            onTap: onLeftIconTap,
            child: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(Icons.edit, size: 24, color: Color(0xFF92400E)),
            ),
          ),
          title: Text(
            category.name,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 6),
              Text(
                category.description,
                style: TextStyle(fontSize: 14, color: Colors.grey.shade700),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 4),
              Text(
                _getShopsDisplay(),
                style: TextStyle(fontSize: 13, color: Colors.grey.shade600),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
