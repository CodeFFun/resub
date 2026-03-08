import 'package:flutter_test/flutter_test.dart';
import 'package:resub/features/graph/presentation/pages/shop_overview_screen.dart';
import 'package:resub/features/graph/presentation/state/graph_state.dart';
import 'package:resub/features/graph/presentation/view_models/graph_view_model.dart';

import '../../../../helpers/widget_test_helpers.dart';

void main() {
  testWidgets('shop overview screen renders empty overview and handles tap', (
    tester,
  ) async {
    setLargeTestScreen(tester);

    final overrides = await buildBaseOverrides(role: 'seller');
    overrides.add(
      graphViewModelProvider.overrideWith(
        () => FakeGraphViewModel(const GraphState(status: GraphStatus.initial)),
      ),
    );

    await tester.pumpWidget(
      wrapWithApp(const ShopOverviewScreen(), overrides: overrides),
    );
    await tester.pump();

    await tester.tap(find.text('No overview data available'));
    await tester.pump();

    expect(find.text('No overview data available'), findsOneWidget);
  });
}
