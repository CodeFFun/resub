import 'package:equatable/equatable.dart';
import 'package:resub/features/graph/domain/entities/shop_dashboard_overview_entity.dart';

enum GraphStatus { initial, loading, loaded, error }

class GraphState extends Equatable {
  final GraphStatus? status;
  final ShopDashboardOverviewEntity? overview;
  final String? errorMessage;

  const GraphState({this.status, this.overview, this.errorMessage});

  GraphState copyWith({
    GraphStatus? status,
    ShopDashboardOverviewEntity? overview,
    String? errorMessage,
  }) {
    return GraphState(
      status: status ?? this.status,
      overview: overview ?? this.overview,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [status, overview, errorMessage];
}
