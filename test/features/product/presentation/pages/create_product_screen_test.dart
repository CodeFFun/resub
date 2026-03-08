import 'package:flutter_test/flutter_test.dart';
import 'package:resub/features/category/domain/entities/category_entity.dart';
import 'package:resub/features/product/presentation/pages/create_product_screen.dart';
import 'package:resub/features/shop/domain/entities/shop_entity.dart';

import '../../../../helpers/widget_test_helpers.dart';

void main() {
  testWidgets('create product screen renders and handles add tap', (
    tester,
  ) async {
    setLargeTestScreen(tester);

    await tester.pumpWidget(
      wrapWithApp(
        CreateProductScreen(
          onProductCreated: (_) {},
          shops: const [ShopEntity(id: 's1', name: 'Shop 1')],
          categories: const [CategoryEntity(id: 'c1', name: 'Category 1')],
        ),
      ),
    );
    await tester.pump();

    await tester.tap(find.text('Add Product'));
    await tester.pump();

    expect(find.text('Add New Product'), findsOneWidget);
  });
}
