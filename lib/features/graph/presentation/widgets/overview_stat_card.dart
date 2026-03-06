import 'package:flutter/material.dart';
import 'package:resub/app/theme/theme_data.dart';

class OverviewStatCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;

  const OverviewStatCard({
    required this.title,
    required this.value,
    required this.icon,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final appColors = theme.extension<AppThemeColors>();

    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: appColors?.cardBackground ?? theme.cardColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: appColors?.border ?? theme.dividerColor),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color:
                        appColors?.secondaryText ??
                        colorScheme.onSurface.withValues(alpha: 0.85),
                  ),
                ),
              ),
              Icon(
                icon,
                color: appColors?.deepBrand ?? colorScheme.primary,
                size: 20,
              ),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            value,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w700,
              color: colorScheme.onSurface,
              height: 1,
            ),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Icon(
                Icons.trending_up,
                size: 12,
                color: appColors?.deepBrand ?? colorScheme.primary,
              ),
              const SizedBox(width: 4),
              Expanded(
                child: Text(
                  '+0% from last month',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 10,
                    color:
                        appColors?.secondaryText ??
                        colorScheme.onSurface.withValues(alpha: 0.8),
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
