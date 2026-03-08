import 'package:flutter_test/flutter_test.dart';
import 'package:resub/features/address/domain/entities/address_entity.dart';
import 'package:resub/features/address/presentation/pages/update_address_screen.dart';

import '../../../../helpers/widget_test_helpers.dart';

void main() {
  testWidgets('update address screen renders and handles update tap', (
    tester,
  ) async {
    setLargeTestScreen(tester);

    await tester.pumpWidget(
      wrapWithApp(
        UpdateAddressScreen(
          address: const AddressEntity(
            id: 'a1',
            label: 'Home',
            line1: 'Line 1',
            city: 'City',
            state: 'State',
            country: 'Country',
          ),
          onAddressUpdated: (_) {},
        ),
      ),
    );
    await tester.pump();

    await tester.tap(find.text('Update'));
    await tester.pump();

    expect(find.text('Update Address'), findsOneWidget);
  });
}
