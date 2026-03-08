import 'package:flutter_test/flutter_test.dart';
import 'package:resub/features/address/presentation/pages/address_page_screen.dart';
import 'package:resub/features/address/presentation/state/address_state.dart';
import 'package:resub/features/address/presentation/view_models/address_view_model.dart';

import '../../../../helpers/widget_test_helpers.dart';

void main() {
  testWidgets('address page screen renders and handles add address tap', (
    tester,
  ) async {
    setLargeTestScreen(tester);

    final overrides = await buildBaseOverrides(role: 'seller');
    overrides.add(
      addressViewModelProvider.overrideWith(
        () => FakeAddressViewModel(
          const AddressState(status: AddressStatus.loaded, addresses: []),
        ),
      ),
    );

    await tester.pumpWidget(
      wrapWithApp(const AddressPageScreen(), overrides: overrides),
    );
    await tester.pump();

    await tester.tap(find.text('Add New Address'));
    await tester.pump();

    expect(find.text('My Addresses'), findsOneWidget);
  });
}
