import 'package:resub/features/graph/domain/entities/shop_dashboard_overview_entity.dart';

class ShopDashboardOverviewApiModel {
  final ShopOverviewCardsApiModel cards;
  final List<RevenueTrendPointApiModel> revenueTrend;
  final List<PaymentSplitApiModel> paymentSplit;
  final List<TopProductByRevenueApiModel> topProductsByRevenue;

  ShopDashboardOverviewApiModel({
    required this.cards,
    required this.revenueTrend,
    required this.paymentSplit,
    required this.topProductsByRevenue,
  });

  factory ShopDashboardOverviewApiModel.fromJson(Map<String, dynamic> json) {
    final cardsJson = json['cards'] as Map<String, dynamic>?;
    final revenueTrendJson = json['revenueTrend'] as List<dynamic>?;
    final paymentSplitJson = json['paymentSplit'] as List<dynamic>?;
    final topProductsJson = json['topProductsByRevenue'] as List<dynamic>?;

    return ShopDashboardOverviewApiModel(
      cards: ShopOverviewCardsApiModel.fromJson(cardsJson ?? const {}),
      revenueTrend: (revenueTrendJson ?? const [])
          .map(
            (item) => RevenueTrendPointApiModel.fromJson(
              item as Map<String, dynamic>,
            ),
          )
          .toList(),
      paymentSplit: (paymentSplitJson ?? const [])
          .map(
            (item) =>
                PaymentSplitApiModel.fromJson(item as Map<String, dynamic>),
          )
          .toList(),
      topProductsByRevenue: (topProductsJson ?? const [])
          .map(
            (item) => TopProductByRevenueApiModel.fromJson(
              item as Map<String, dynamic>,
            ),
          )
          .toList(),
    );
  }

  ShopDashboardOverviewEntity toEntity() {
    return ShopDashboardOverviewEntity(
      cards: cards.toEntity(),
      revenueTrend: revenueTrend.map((item) => item.toEntity()).toList(),
      paymentSplit: paymentSplit.map((item) => item.toEntity()).toList(),
      topProductsByRevenue: topProductsByRevenue
          .map((item) => item.toEntity())
          .toList(),
    );
  }
}

class ShopOverviewCardsApiModel {
  final double revenue;
  final int orders;
  final double aov;
  final double successfulPaymentRate;

  ShopOverviewCardsApiModel({
    required this.revenue,
    required this.orders,
    required this.aov,
    required this.successfulPaymentRate,
  });

  factory ShopOverviewCardsApiModel.fromJson(Map<String, dynamic> json) {
    return ShopOverviewCardsApiModel(
      revenue: (json['revenue'] as num?)?.toDouble() ?? 0,
      orders: (json['orders'] as num?)?.toInt() ?? 0,
      aov: (json['aov'] as num?)?.toDouble() ?? 0,
      successfulPaymentRate:
          (json['successfulPaymentRate'] as num?)?.toDouble() ?? 0,
    );
  }

  ShopOverviewCardsEntity toEntity() {
    return ShopOverviewCardsEntity(
      revenue: revenue,
      orders: orders,
      aov: aov,
      successfulPaymentRate: successfulPaymentRate,
    );
  }
}

class RevenueTrendPointApiModel {
  final String bucket;
  final double value;

  RevenueTrendPointApiModel({required this.bucket, required this.value});

  factory RevenueTrendPointApiModel.fromJson(Map<String, dynamic> json) {
    return RevenueTrendPointApiModel(
      bucket: json['bucket'] as String? ?? '',
      value: (json['value'] as num?)?.toDouble() ?? 0,
    );
  }

  RevenueTrendPointEntity toEntity() {
    return RevenueTrendPointEntity(bucket: bucket, value: value);
  }
}

class PaymentSplitApiModel {
  final String provider;
  final int count;
  final double percentage;

  PaymentSplitApiModel({
    required this.provider,
    required this.count,
    required this.percentage,
  });

  factory PaymentSplitApiModel.fromJson(Map<String, dynamic> json) {
    return PaymentSplitApiModel(
      provider: json['provider'] as String? ?? '',
      count: (json['count'] as num?)?.toInt() ?? 0,
      percentage: (json['percentage'] as num?)?.toDouble() ?? 0,
    );
  }

  PaymentSplitEntity toEntity() {
    return PaymentSplitEntity(
      provider: provider,
      count: count,
      percentage: percentage,
    );
  }
}

class TopProductByRevenueApiModel {
  final String productId;
  final String name;
  final double revenue;
  final int qty;

  TopProductByRevenueApiModel({
    required this.productId,
    required this.name,
    required this.revenue,
    required this.qty,
  });

  factory TopProductByRevenueApiModel.fromJson(Map<String, dynamic> json) {
    return TopProductByRevenueApiModel(
      productId: json['productId'] as String? ?? '',
      name: json['name'] as String? ?? '',
      revenue: (json['revenue'] as num?)?.toDouble() ?? 0,
      qty: (json['qty'] as num?)?.toInt() ?? 0,
    );
  }

  TopProductByRevenueEntity toEntity() {
    return TopProductByRevenueEntity(
      productId: productId,
      name: name,
      revenue: revenue,
      qty: qty,
    );
  }
}
