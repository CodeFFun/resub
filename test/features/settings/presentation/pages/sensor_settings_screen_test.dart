import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:resub/features/settings/presentation/pages/sensor_settings_screen.dart';

import '../../../../helpers/widget_test_helpers.dart';

void main() {
  testWidgets('sensor settings screen renders and handles switch tap', (
    tester,
  ) async {
    setLargeTestScreen(tester);

    final overrides = await buildBaseOverrides(role: 'seller');

    await tester.pumpWidget(
      wrapWithApp(const SensorSettingsScreen(), overrides: overrides),
    );
    await tester.pump();

    await tester.tap(find.byType(Switch).first);
    await tester.pump();

    expect(find.text('Sensor Settings'), findsOneWidget);
  });
}
