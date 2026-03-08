import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:resub/features/profile/presentation/state/profile_state.dart';
import 'package:resub/features/profile/presentation/view_models/profile_view_model.dart';
import 'package:resub/features/settings/presentation/pages/profile_page_screen.dart';

import '../../../../helpers/widget_test_helpers.dart';

void main() {
  testWidgets('profile page screen renders and handles appearance switch tap', (
    tester,
  ) async {
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
      wrapWithApp(const ProfilePageScreen(), overrides: overrides),
    );
    await tester.pump();

    await tester.tap(find.byType(Switch).first);
    await tester.pump();

    expect(find.text('Appearance'), findsOneWidget);
  });
}
