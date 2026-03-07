import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:resub/app/theme/theme_data.dart';
import 'package:resub/app/theme/theme_mode_provider.dart';
import 'package:resub/core/utils/responsive_utils.dart';
import 'package:resub/core/widgets/proximity_logout_wrapper.dart';

class SensorSettingsScreen extends ConsumerWidget {
  const SensorSettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final appColors = theme.extension<AppThemeColors>();

    final isAutoThemeEnabled = ref
        .watch(themeModeProvider.notifier)
        .isAutoThemeEnabled;
    final isProximityLogoutEnabled = ref.watch(proximityLogoutEnabledProvider);

    return Scaffold(
      backgroundColor: colorScheme.surface,
      appBar: AppBar(
        backgroundColor: colorScheme.surface,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: colorScheme.onSurface),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Sensor Settings',
          style: TextStyle(
            color: colorScheme.onSurface,
            fontSize: context.rFont(20),
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: ListView(
        padding: EdgeInsets.all(context.rSpacing(16)),
        children: [
          // Ambient Light Sensor Section
          Card(
            child: Padding(
              padding: EdgeInsets.all(context.rSpacing(16)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.wb_sunny,
                        color: colorScheme.primary,
                        size: context.rIcon(28),
                      ),
                      SizedBox(width: context.rWidth(12)),
                      Expanded(
                        child: Text(
                          'Ambient Light Theme',
                          style: TextStyle(
                            fontSize: context.rFont(18),
                            fontWeight: FontWeight.bold,
                            color: colorScheme.onSurface,
                          ),
                        ),
                      ),
                      Switch(
                        value: isAutoThemeEnabled,
                        onChanged: (value) {
                          ref
                              .read(themeModeProvider.notifier)
                              .setAutoThemeEnabled(value);
                        },
                        activeThumbColor: colorScheme.primary,
                      ),
                    ],
                  ),
                  SizedBox(height: context.rHeight(12)),
                  Text(
                    'Automatically switch between light and dark theme based on ambient light levels. Dark mode activates when light is below 50 lux.',
                    style: TextStyle(
                      fontSize: context.rFont(14),
                      color: appColors?.secondaryText ?? Colors.grey,
                      height: 1.4,
                    ),
                  ),
                  if (isAutoThemeEnabled) ...[
                    SizedBox(height: context.rHeight(12)),
                    Container(
                      padding: EdgeInsets.all(context.rSpacing(12)),
                      decoration: BoxDecoration(
                        color: colorScheme.primary.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(context.rRadius(8)),
                        border: Border.all(
                          color: colorScheme.primary.withOpacity(0.3),
                        ),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            Icons.info_outline,
                            color: colorScheme.primary,
                            size: context.rIcon(20),
                          ),
                          SizedBox(width: context.rWidth(8)),
                          Expanded(
                            child: Text(
                              'Theme will change automatically based on your environment',
                              style: TextStyle(
                                fontSize: context.rFont(12),
                                color: colorScheme.primary,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
          SizedBox(height: context.rHeight(16)),

          // Proximity Sensor Section
          Card(
            child: Padding(
              padding: EdgeInsets.all(context.rSpacing(16)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.sensors,
                        color: colorScheme.primary,
                        size: context.rIcon(28),
                      ),
                      SizedBox(width: context.rWidth(12)),
                      Expanded(
                        child: Text(
                          'Proximity Logout',
                          style: TextStyle(
                            fontSize: context.rFont(18),
                            fontWeight: FontWeight.bold,
                            color: colorScheme.onSurface,
                          ),
                        ),
                      ),
                      Switch(
                        value: isProximityLogoutEnabled,
                        onChanged: (value) {
                          ref
                              .read(proximityLogoutEnabledProvider.notifier)
                              .setEnabled(value);
                        },
                        activeThumbColor: colorScheme.primary,
                      ),
                    ],
                  ),
                  SizedBox(height: context.rHeight(12)),
                  Text(
                    'Automatically trigger logout when proximity sensor detects an object near the device for 3 seconds. Useful for privacy protection.',
                    style: TextStyle(
                      fontSize: context.rFont(14),
                      color: appColors?.secondaryText ?? Colors.grey,
                      height: 1.4,
                    ),
                  ),
                  if (isProximityLogoutEnabled) ...[
                    SizedBox(height: context.rHeight(12)),
                    Container(
                      padding: EdgeInsets.all(context.rSpacing(12)),
                      decoration: BoxDecoration(
                        color: Colors.orange.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(context.rRadius(8)),
                        border: Border.all(
                          color: Colors.orange.withOpacity(0.3),
                        ),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            Icons.warning_amber_rounded,
                            color: Colors.orange,
                            size: context.rIcon(20),
                          ),
                          SizedBox(width: context.rWidth(8)),
                          Expanded(
                            child: Text(
                              'You will be prompted before logout is triggered',
                              style: TextStyle(
                                fontSize: context.rFont(12),
                                color: Colors.orange.shade800,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
          SizedBox(height: context.rHeight(24)),

          // Info Section
          Card(
            color: colorScheme.surface,
            child: Padding(
              padding: EdgeInsets.all(context.rSpacing(16)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.help_outline,
                        color: appColors?.secondaryText ?? Colors.grey,
                        size: context.rIcon(20),
                      ),
                      SizedBox(width: context.rWidth(8)),
                      Text(
                        'About Sensors',
                        style: TextStyle(
                          fontSize: context.rFont(16),
                          fontWeight: FontWeight.bold,
                          color: colorScheme.onSurface,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: context.rHeight(12)),
                  _buildInfoItem(
                    context,
                    'Ambient Light Sensor',
                    'Measures the light intensity around your device in lux units.',
                    appColors,
                  ),
                  SizedBox(height: context.rHeight(8)),
                  _buildInfoItem(
                    context,
                    'Proximity Sensor',
                    'Detects objects near your device, typically used during phone calls.',
                    appColors,
                  ),
                  SizedBox(height: context.rHeight(12)),
                  Text(
                    'Note: Sensor availability depends on your device hardware.',
                    style: TextStyle(
                      fontSize: context.rFont(12),
                      fontStyle: FontStyle.italic,
                      color: appColors?.mutedText ?? Colors.grey,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoItem(
    BuildContext context,
    String title,
    String description,
    AppThemeColors? appColors,
  ) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: context.rWidth(4),
          height: context.rHeight(4),
          margin: EdgeInsets.only(top: context.rHeight(8)),
          decoration: BoxDecoration(
            color: appColors?.mutedText ?? Colors.grey,
            shape: BoxShape.circle,
          ),
        ),
        SizedBox(width: context.rWidth(8)),
        Expanded(
          child: RichText(
            text: TextSpan(
              style: TextStyle(
                fontSize: context.rFont(13),
                color: appColors?.secondaryText ?? Colors.grey,
                height: 1.4,
              ),
              children: [
                TextSpan(
                  text: '$title: ',
                  style: const TextStyle(fontWeight: FontWeight.w600),
                ),
                TextSpan(text: description),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
