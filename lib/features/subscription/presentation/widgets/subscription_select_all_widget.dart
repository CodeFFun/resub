import 'package:flutter/material.dart';
import 'package:resub/app/theme/theme_data.dart';

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
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final appColors = theme.extension<AppThemeColors>();

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: appColors?.cardBackground ?? theme.cardColor,
        border: Border(
          bottom: BorderSide(color: appColors?.border ?? theme.dividerColor),
        ),
      ),
      child: Row(
        children: [
          Checkbox(value: selectAll, onChanged: (_) => onToggle()),
          const SizedBox(width: 12),
          Text(
            'Select All Items',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: colorScheme.onSurface,
            ),
          ),
        ],
      ),
    );
  }
}
