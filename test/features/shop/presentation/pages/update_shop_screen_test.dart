import 'package:flutter_test/flutter_test.dart';
import 'package:resub/features/address/domain/entities/address_entity.dart';
import 'package:resub/features/category/domain/entities/category_entity.dart';
import 'package:resub/features/shop/domain/entities/shop_entity.dart';
import 'package:resub/features/shop/presentation/pages/update_shop_screen.dart';

import '../../../../helpers/widget_test_helpers.dart';

void main() {
  testWidgets('update shop screen renders and handles update tap', (
    tester,
  ) async {
    setLargeTestScreen(tester);

    await tester.pumpWidget(
      wrapWithApp(
        UpdateShopScreen(
          shop: const ShopEntity(
            id: 's1',
            name: 'Demo Shop',
            categoryId: 'c1',
            addressId: 'a1',
          ),
          onShopUpdated: (_) {},
          categories: const [CategoryEntity(id: 'c1', name: 'Food')],
          addresses: const [AddressEntity(id: 'a1', label: 'Home')],
        ),
      ),
    );
    await tester.pump();

    await tester.tap(find.text('Update'));
    await tester.pump();

    expect(find.text('Update Shop'), findsOneWidget);
  });
}
