import 'package:flutter_test/flutter_test.dart';
import 'package:resub/features/category/presentation/state/category_state.dart';
import 'package:resub/features/category/presentation/view_models/category_view_model.dart';
import 'package:resub/features/home/presentation/pages/home_page_screen.dart';
import 'package:resub/features/shop/presentation/state/shop_state.dart';
import 'package:resub/features/shop/presentation/view_models/shop_view_model.dart';

import '../../../../helpers/widget_test_helpers.dart';

void main() {
  testWidgets('home page screen renders and handles category tap', (
    tester,
  ) async {
    setLargeTestScreen(tester);

    final overrides = await buildBaseOverrides(role: 'customer');
    overrides.addAll([
      categoryViewModelProvider.overrideWith(
        () => FakeCategoryViewModel(
          const CategoryState(status: CategoryStatus.initial),
        ),
      ),
      shopViewModelProvider.overrideWith(
        () => FakeShopViewModel(const ShopState(status: ShopStatus.initial)),
      ),
    ]);

    await tester.pumpWidget(
      wrapWithApp(const HomePageScreen(), overrides: overrides),
    );
    await tester.pump();

    await tester.tap(find.text('Food'));
    await tester.pump();

    expect(find.text('What do you feel like today?'), findsOneWidget);
  });
}
