import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:resub/features/dashboard/presentation/pages/bottom_navigation_screen/bottom_profile_screen.dart';
import 'package:resub/features/profile/presentation/state/profile_state.dart';
import 'package:resub/features/profile/presentation/view_models/profile_view_model.dart';

import '../../../../../helpers/widget_test_helpers.dart';

void main() {
  testWidgets(
    'bottom profile screen renders profile page and handles switch tap',
    (tester) async {
      setLargeTestScreen(tester);

      final overrides = await buildBaseOverrides(role: 'seller');
      overrides.add(
        profileViewModelProvider.overrideWith(
          () => FakeProfileViewModel(
            const ProfileState(status: ProfileStatus.initial),
          ),
        ),
      );

      await tester.pumpWidget(
        wrapWithApp(const BottomProfileScreen(), overrides: overrides),
      );
      await tester.pump();

      await tester.tap(find.byType(Switch).first);
      await tester.pump();

      expect(find.text('Appearance'), findsOneWidget);
    },
  );
}
