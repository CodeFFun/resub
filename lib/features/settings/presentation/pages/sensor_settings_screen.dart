import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:resub/app/theme/theme_data.dart';
import 'package:resub/app/theme/theme_mode_provider.dart';
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
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Ambient Light Sensor Section
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.wb_sunny,
                        color: colorScheme.primary,
                        size: 28,
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          'Ambient Light Theme',
                          style: TextStyle(
                            fontSize: 18,
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
                        activeColor: colorScheme.primary,
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'Automatically switch between light and dark theme based on ambient light levels. Dark mode activates when light is below 50 lux.',
                    style: TextStyle(
                      fontSize: 14,
                      color: appColors?.secondaryText ?? Colors.grey,
                      height: 1.4,
                    ),
                  ),
                  if (isAutoThemeEnabled) ...[
                    const SizedBox(height: 12),
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: colorScheme.primary.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: colorScheme.primary.withOpacity(0.3),
                        ),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            Icons.info_outline,
                            color: colorScheme.primary,
                            size: 20,
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              'Theme will change automatically based on your environment',
                              style: TextStyle(
                                fontSize: 12,
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
          const SizedBox(height: 16),

          // Proximity Sensor Section
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(Icons.sensors, color: colorScheme.primary, size: 28),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          'Proximity Logout',
                          style: TextStyle(
                            fontSize: 18,
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
                        activeColor: colorScheme.primary,
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'Automatically trigger logout when proximity sensor detects an object near the device for 3 seconds. Useful for privacy protection.',
                    style: TextStyle(
                      fontSize: 14,
                      color: appColors?.secondaryText ?? Colors.grey,
                      height: 1.4,
                    ),
                  ),
                  if (isProximityLogoutEnabled) ...[
                    const SizedBox(height: 12),
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.orange.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: Colors.orange.withOpacity(0.3),
                        ),
                      ),
                      child: Row(
                        children: [
                          const Icon(
                            Icons.warning_amber_rounded,
                            color: Colors.orange,
                            size: 20,
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              'You will be prompted before logout is triggered',
                              style: TextStyle(
                                fontSize: 12,
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
          const SizedBox(height: 24),

          // Info Section
          Card(
            color: colorScheme.surface,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.help_outline,
                        color: appColors?.secondaryText ?? Colors.grey,
                        size: 20,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        'About Sensors',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: colorScheme.onSurface,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  _buildInfoItem(
                    context,
                    'Ambient Light Sensor',
                    'Measures the light intensity around your device in lux units.',
                    appColors,
                  ),
                  const SizedBox(height: 8),
                  _buildInfoItem(
                    context,
                    'Proximity Sensor',
                    'Detects objects near your device, typically used during phone calls.',
                    appColors,
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'Note: Sensor availability depends on your device hardware.',
                    style: TextStyle(
                      fontSize: 12,
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
          width: 4,
          height: 4,
          margin: const EdgeInsets.only(top: 8),
          decoration: BoxDecoration(
            color: appColors?.mutedText ?? Colors.grey,
            shape: BoxShape.circle,
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: RichText(
            text: TextSpan(
              style: TextStyle(
                fontSize: 13,
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
