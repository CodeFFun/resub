import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:resub/features/graph/domain/usecases/get_shop_overview_usecase.dart';
import 'package:resub/features/graph/presentation/state/graph_state.dart';

final graphViewModelProvider = NotifierProvider<GraphViewModel, GraphState>(
  () => GraphViewModel(),
);

class GraphViewModel extends Notifier<GraphState> {
  late final GetShopOverviewUsecase _getShopOverviewUsecase;

  @override
  GraphState build() {
    _getShopOverviewUsecase = ref.read(getShopOverviewUsecaseProvider);
    return const GraphState(status: GraphStatus.initial);
  }

  Future<void> getShopOverview() async {
    state = state.copyWith(status: GraphStatus.loading);
    final result = await _getShopOverviewUsecase();

    result.fold(
      (failure) {
        state = state.copyWith(
          status: GraphStatus.error,
          errorMessage: failure.message,
        );
      },
      (overview) {
        state = state.copyWith(status: GraphStatus.loaded, overview: overview);
      },
    );
  }
}
