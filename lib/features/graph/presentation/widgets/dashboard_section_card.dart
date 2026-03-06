import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:resub/app/theme/theme_data.dart';

class DashboardSectionCard extends StatelessWidget {
  final String title;
  final Widget child;
  final double minHeight;

  const DashboardSectionCard({
    required this.title,
    required this.child,
    this.minHeight = 220,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final appColors = theme.extension<AppThemeColors>();

    return LayoutBuilder(
      builder: (context, constraints) {
        // The card can appear inside a scroll view (unbounded height),
        // so the chart area needs an explicit height instead of Expanded.
        const titleAreaHeight = 50.0;
        final availableHeight = constraints.hasBoundedHeight
            ? constraints.maxHeight - titleAreaHeight
            : minHeight - titleAreaHeight;
        final contentHeight = math.max(130.0, availableHeight);

        return Container(
          constraints: BoxConstraints(minHeight: minHeight),
          padding: const EdgeInsets.all(12),
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
              Text(
                title,
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w700,
                  color: colorScheme.onSurface,
                ),
              ),
              const SizedBox(height: 10),
              SizedBox(height: contentHeight, child: child),
            ],
          ),
        );
      },
    );
  }
}
