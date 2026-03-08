import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:resub/app/theme/theme_data.dart';
import 'package:resub/features/graph/domain/entities/shop_dashboard_overview_entity.dart';

class PaymentSplitChart extends StatelessWidget {
  final List<PaymentSplitEntity> splits;

  const PaymentSplitChart({required this.splits, super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final appColors = theme.extension<AppThemeColors>();

    if (splits.isEmpty) {
      return Center(
        child: Text(
          'No payment split data',
          style: TextStyle(
            fontSize: 16,
            color:
                appColors?.secondaryText ??
                colorScheme.onSurface.withValues(alpha: 0.8),
          ),
        ),
      );
    }

    const colors = [
      Color(0xFF5D56E8),
      Color(0xFF17B482),
      Color(0xFFF2994A),
      Color(0xFFEB5757),
    ];

    return Column(
      children: [
        Expanded(
          child: PieChart(
            PieChartData(
              centerSpaceRadius: 42,
              sectionsSpace: 3,
              startDegreeOffset: 90,
              sections: [
                for (int i = 0; i < splits.length; i++)
                  PieChartSectionData(
                    value: splits[i].percentage,
                    color: colors[i % colors.length],
                    title: '',
                    radius: 40,
                  ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 8),
        for (int i = 0; i < splits.length; i++)
          Padding(
            padding: const EdgeInsets.only(bottom: 6),
            child: Row(
              children: [
                Container(
                  width: 10,
                  height: 10,
                  decoration: BoxDecoration(
                    color: colors[i % colors.length],
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    _capitalize(splits[i].provider),
                    style: TextStyle(
                      fontSize: 14,
                      color: colorScheme.onSurface,
                    ),
                  ),
                ),
                Text(
                  '${splits[i].percentage.round()}%',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: colorScheme.onSurface,
                  ),
                ),
              ],
            ),
          ),
      ],
    );
  }

  String _capitalize(String text) {
    if (text.isEmpty) return text;
    return '${text[0].toUpperCase()}${text.substring(1)}';
  }
}
