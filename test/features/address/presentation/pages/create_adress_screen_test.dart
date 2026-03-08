import 'package:flutter_test/flutter_test.dart';
import 'package:resub/features/address/presentation/pages/create_adress_screen.dart';

import '../../../../helpers/widget_test_helpers.dart';

void main() {
  testWidgets('create address screen renders and handles create tap', (
    tester,
  ) async {
    setLargeTestScreen(tester);

    await tester.pumpWidget(
      wrapWithApp(CreateAddressScreen(onAddressCreated: (_) {})),
    );
    await tester.pump();

    await tester.tap(find.text('Create'));
    await tester.pump();

    expect(find.text('Add New Address'), findsOneWidget);
  });
}
