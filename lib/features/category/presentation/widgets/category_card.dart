import 'package:flutter/material.dart';
import 'package:resub/app/theme/theme_data.dart';
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
    if (category.shopName != null && category.shopName!.isNotEmpty) {
      return category.shopName!;
    }
    if (category.shopId == null || category.shopId!.isEmpty) {
      return 'No shops';
    }
    if (allShops.contains(category.shopId)) {
      return category.shopId!;
    }
    return 'No shops';
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final appColors = theme.extension<AppThemeColors>();

    return Dismissible(
      key: Key(category.id ?? category.name!),
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
          color: appColors?.cardBackground ?? theme.cardColor,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: appColors?.border ?? theme.dividerColor),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.08),
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
                color: colorScheme.surface,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                Icons.edit,
                size: 24,
                color: appColors?.deepBrand ?? colorScheme.primary,
              ),
            ),
          ),
          title: Text(
            category.name!,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: colorScheme.onSurface,
            ),
          ),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 6),
              Text(
                category.description!,
                style: TextStyle(
                  fontSize: 14,
                  color:
                      appColors?.secondaryText ??
                      colorScheme.onSurface.withValues(alpha: 0.8),
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 4),
              Text(
                _getShopsDisplay(),
                style: TextStyle(
                  fontSize: 13,
                  color:
                      appColors?.mutedText ??
                      colorScheme.onSurface.withValues(alpha: 0.65),
                ),
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
