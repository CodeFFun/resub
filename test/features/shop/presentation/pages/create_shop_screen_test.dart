import 'package:flutter_test/flutter_test.dart';
import 'package:resub/features/address/domain/entities/address_entity.dart';
import 'package:resub/features/category/domain/entities/category_entity.dart';
import 'package:resub/features/shop/presentation/pages/create_shop_screen.dart';

import '../../../../helpers/widget_test_helpers.dart';

void main() {
  testWidgets('create shop screen renders and handles submit tap', (
    tester,
  ) async {
    setLargeTestScreen(tester);

    await tester.pumpWidget(
      wrapWithApp(
        CreateShopScreen(
          onShopCreated: (_) {},
          categories: const [CategoryEntity(id: 'c1', name: 'Food')],
          addresses: const [AddressEntity(id: 'a1', label: 'Home')],
        ),
      ),
    );
    await tester.pump();

    await tester.tap(find.text('Add Shop'));
    await tester.pump();

    expect(find.text('Add New Shop'), findsOneWidget);
  });
}
