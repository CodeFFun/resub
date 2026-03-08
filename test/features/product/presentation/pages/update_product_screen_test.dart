import 'package:flutter_test/flutter_test.dart';
import 'package:resub/features/category/domain/entities/category_entity.dart';
import 'package:resub/features/product/domain/entities/product_entity.dart';
import 'package:resub/features/product/presentation/pages/update_product_screen.dart';
import 'package:resub/features/shop/domain/entities/shop_entity.dart';

import '../../../../helpers/widget_test_helpers.dart';

void main() {
  testWidgets('update product screen renders and handles update tap', (
    tester,
  ) async {
    setLargeTestScreen(tester);

    await tester.pumpWidget(
      wrapWithApp(
        UpdateProductScreen(
          product: const ProductEntity(
            id: 'p1',
            name: 'Product',
            description: 'Description',
            basePrice: 100,
            stockQuantity: 5,
            discount: 0,
            shopIds: ['s1'],
            categoryId: 'c1',
            shopId: 's1',
          ),
          onProductUpdated: (_) {},
          shops: const [ShopEntity(id: 's1', name: 'Shop 1')],
          categories: const [CategoryEntity(id: 'c1', name: 'Category 1')],
        ),
      ),
    );
    await tester.pump();

    await tester.tap(find.text('Update'));
    await tester.pump();

    expect(find.text('Update Product'), findsOneWidget);
  });
}
