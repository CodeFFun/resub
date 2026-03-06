import 'dart:math' as math;

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:resub/app/theme/theme_data.dart';
import 'package:resub/features/graph/domain/entities/shop_dashboard_overview_entity.dart';

class RevenueTrendChart extends StatelessWidget {
  final List<RevenueTrendPointEntity> points;

  const RevenueTrendChart({required this.points, super.key});

  static const List<String> _months = [
    'Jan',
    'Feb',
    'Mar',
    'Apr',
    'May',
    'Jun',
    'Jul',
    'Aug',
    'Sep',
    'Oct',
    'Nov',
    'Dec',
  ];

  String _bucketLabel(String bucket) {
    try {
      final date = DateTime.parse(bucket);
      return '${_months[date.month - 1]} ${date.day}';
    } catch (_) {
      return bucket;
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final appColors = theme.extension<AppThemeColors>();

    if (points.isEmpty) {
      return Center(
        child: Text(
          'No revenue trend data',
          style: TextStyle(
            fontSize: 16,
            color:
                appColors?.secondaryText ??
                colorScheme.onSurface.withValues(alpha: 0.8),
          ),
        ),
      );
    }

    final maxValue = points
        .map((e) => e.value)
        .fold<double>(0.0, (prev, element) => prev > element ? prev : element);
    final maxY = math.max<double>(10.0, maxValue * 1.15);
    final leftInterval = math.max<double>(1.0, maxY / 4);

    return LineChart(
      LineChartData(
        minX: 0,
        maxX: (points.length - 1).toDouble(),
        minY: 0,
        maxY: maxY,
        lineTouchData: LineTouchData(enabled: true),
        gridData: FlGridData(
          drawVerticalLine: false,
          horizontalInterval: leftInterval,
          getDrawingHorizontalLine: (value) => FlLine(
            color: appColors?.border ?? theme.dividerColor,
            strokeWidth: 1,
          ),
        ),
        borderData: FlBorderData(
          show: true,
          border: Border(
            left: BorderSide(color: appColors?.border ?? theme.dividerColor),
            bottom: BorderSide(color: appColors?.border ?? theme.dividerColor),
            right: BorderSide.none,
            top: BorderSide.none,
          ),
        ),
        titlesData: FlTitlesData(
          topTitles: const AxisTitles(
            sideTitles: SideTitles(showTitles: false),
          ),
          rightTitles: const AxisTitles(
            sideTitles: SideTitles(showTitles: false),
          ),
          leftTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 44,
              interval: leftInterval,
              getTitlesWidget: (value, meta) {
                return Text(
                  value.toInt().toString(),
                  style: TextStyle(fontSize: 14, color: colorScheme.onSurface),
                );
              },
            ),
          ),
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              interval: 1,
              getTitlesWidget: (value, meta) {
                final index = value.toInt();
                if (index < 0 || index >= points.length) {
                  return const SizedBox.shrink();
                }
                return Padding(
                  padding: const EdgeInsets.only(top: 8),
                  child: Text(
                    _bucketLabel(points[index].bucket),
                    style: TextStyle(
                      fontSize: 14,
                      color: colorScheme.onSurface,
                    ),
                  ),
                );
              },
            ),
          ),
        ),
        lineBarsData: [
          LineChartBarData(
            spots: [
              for (int i = 0; i < points.length; i++)
                FlSpot(i.toDouble(), points[i].value),
            ],
            isCurved: false,
            color: appColors?.deepBrand ?? colorScheme.primary,
            barWidth: 2.5,
            isStrokeCapRound: true,
            dotData: FlDotData(
              show: true,
              getDotPainter: (spot, percent, barData, index) {
                return FlDotCirclePainter(
                  radius: 4,
                  color: appColors?.deepBrand ?? colorScheme.primary,
                  strokeWidth: 0,
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
