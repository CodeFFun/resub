import 'package:equatable/equatable.dart';
import 'package:resub/features/shop/domain/entities/shop_entity.dart';

enum ShopStatus { initial, loading, created, updated, deleted, error, loaded }

class ShopState extends Equatable {
  final ShopStatus? status;
  final ShopEntity? shop;
  final List<ShopEntity>? shops;
  final String? errorMessage;

  const ShopState({this.status, this.shop, this.shops, this.errorMessage});

  ShopState copyWith({
    ShopStatus? status,
    ShopEntity? shop,
    List<ShopEntity>? shops,
    String? errorMessage,
  }) {
    return ShopState(
      status: status ?? this.status,
      shop: shop ?? this.shop,
      shops: shops ?? this.shops,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [status, shop, shops, errorMessage];
}
