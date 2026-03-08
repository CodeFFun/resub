import 'package:equatable/equatable.dart';

class ShopDashboardOverviewEntity extends Equatable {
  final ShopOverviewCardsEntity cards;
  final List<RevenueTrendPointEntity> revenueTrend;
  final List<PaymentSplitEntity> paymentSplit;
  final List<TopProductByRevenueEntity> topProductsByRevenue;

  const ShopDashboardOverviewEntity({
    required this.cards,
    required this.revenueTrend,
    required this.paymentSplit,
    required this.topProductsByRevenue,
  });

  ShopDashboardOverviewEntity copyWith({
    ShopOverviewCardsEntity? cards,
    List<RevenueTrendPointEntity>? revenueTrend,
    List<PaymentSplitEntity>? paymentSplit,
    List<TopProductByRevenueEntity>? topProductsByRevenue,
  }) {
    return ShopDashboardOverviewEntity(
      cards: cards ?? this.cards,
      revenueTrend: revenueTrend ?? this.revenueTrend,
      paymentSplit: paymentSplit ?? this.paymentSplit,
      topProductsByRevenue: topProductsByRevenue ?? this.topProductsByRevenue,
    );
  }

  @override
  List<Object?> get props => [
    cards,
    revenueTrend,
    paymentSplit,
    topProductsByRevenue,
  ];
}

class ShopOverviewCardsEntity extends Equatable {
  final double revenue;
  final int orders;
  final double aov;
  final double successfulPaymentRate;

  const ShopOverviewCardsEntity({
    required this.revenue,
    required this.orders,
    required this.aov,
    required this.successfulPaymentRate,
  });

  ShopOverviewCardsEntity copyWith({
    double? revenue,
    int? orders,
    double? aov,
    double? successfulPaymentRate,
  }) {
    return ShopOverviewCardsEntity(
      revenue: revenue ?? this.revenue,
      orders: orders ?? this.orders,
      aov: aov ?? this.aov,
      successfulPaymentRate:
          successfulPaymentRate ?? this.successfulPaymentRate,
    );
  }

  @override
  List<Object?> get props => [revenue, orders, aov, successfulPaymentRate];
}

class RevenueTrendPointEntity extends Equatable {
  final String bucket;
  final double value;

  const RevenueTrendPointEntity({required this.bucket, required this.value});

  RevenueTrendPointEntity copyWith({String? bucket, double? value}) {
    return RevenueTrendPointEntity(
      bucket: bucket ?? this.bucket,
      value: value ?? this.value,
    );
  }

  @override
  List<Object?> get props => [bucket, value];
}

class PaymentSplitEntity extends Equatable {
  final String provider;
  final int count;
  final double percentage;

  const PaymentSplitEntity({
    required this.provider,
    required this.count,
    required this.percentage,
  });

  PaymentSplitEntity copyWith({
    String? provider,
    int? count,
    double? percentage,
  }) {
    return PaymentSplitEntity(
      provider: provider ?? this.provider,
      count: count ?? this.count,
      percentage: percentage ?? this.percentage,
    );
  }

  @override
  List<Object?> get props => [provider, count, percentage];
}

class TopProductByRevenueEntity extends Equatable {
  final String productId;
  final String name;
  final double revenue;
  final int qty;

  const TopProductByRevenueEntity({
    required this.productId,
    required this.name,
    required this.revenue,
    required this.qty,
  });

  TopProductByRevenueEntity copyWith({
    String? productId,
    String? name,
    double? revenue,
    int? qty,
  }) {
    return TopProductByRevenueEntity(
      productId: productId ?? this.productId,
      name: name ?? this.name,
      revenue: revenue ?? this.revenue,
      qty: qty ?? this.qty,
    );
  }

  @override
  List<Object?> get props => [productId, name, revenue, qty];
}
