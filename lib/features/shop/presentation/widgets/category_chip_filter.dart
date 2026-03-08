import 'package:flutter/material.dart';
import 'package:resub/app/theme/theme_data.dart';

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
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final appColors = theme.extension<AppThemeColors>();

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4.0),
      child: FilterChip(
        selected: isSelected,
        label: Text(categoryName),
        onSelected: onSelected,
        backgroundColor: appColors?.cardBackground ?? theme.cardColor,
        selectedColor: appColors?.deepBrand ?? colorScheme.primary,
        labelStyle: TextStyle(
          color: isSelected
              ? colorScheme.onPrimary
              : (appColors?.secondaryText ??
                    colorScheme.onSurface.withValues(alpha: 0.8)),
          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
        ),
        side: BorderSide(
          color: isSelected
              ? (appColors?.deepBrand ?? colorScheme.primary)
              : (appColors?.border ?? theme.dividerColor),
        ),
      ),
    );
  }
}
