import 'package:dartz/dartz.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:resub/core/error/failure.dart';
import 'package:resub/core/services/connectivity/network_info.dart';
import 'package:resub/features/payment/data/datasources/payment_datasource.dart';
import 'package:resub/features/payment/data/datasources/remote/payment_remote_datasource.dart';
import 'package:resub/features/payment/data/models/payment_model.dart';
import 'package:resub/features/payment/domain/entities/payment_entity.dart';
import 'package:resub/features/payment/domain/repositories/payment_repository.dart';

final paymentRepositoryProvider = Provider<IPaymentRepository>((ref) {
  final paymentRemoteDatasource = ref.read(paymentRemoteDatasourceProvider);
  final networkInfo = ref.read(networkInfoProvider);
  return PaymentRepository(
    paymentRemoteDatasource: paymentRemoteDatasource,
    networkInfo: networkInfo,
  );
});

class PaymentRepository implements IPaymentRepository {
  final NetworkInfo _networkInfo;
  final IPaymentRemoteDatasource _paymentRemoteDatasource;

  PaymentRepository({
    required NetworkInfo networkInfo,
    required IPaymentRemoteDatasource paymentRemoteDatasource,
  }) : _networkInfo = networkInfo,
       _paymentRemoteDatasource = paymentRemoteDatasource;

  @override
  Future<Either<Failure, PaymentEntity>> createPayment(
    PaymentEntity paymentEntity,
  ) async {
    if (await _networkInfo.isConnected) {
      try {
        final apiModel = PaymentApiModel.fromEntity(paymentEntity);
        final model = await _paymentRemoteDatasource.createPayment(apiModel);
        return Right(model.toEntity());
      } catch (e) {
        return Left(ApiFailure(message: e.toString()));
      }
    } else {
      return const Left(ApiFailure(message: 'No internet connection'));
    }
  }

  @override
  Future<Either<Failure, PaymentEntity?>> getPaymentById(String id) async {
    if (await _networkInfo.isConnected) {
      try {
        final model = await _paymentRemoteDatasource.getPaymentById(id);
        return Right(model?.toEntity());
      } catch (e) {
        return Left(ApiFailure(message: e.toString()));
      }
    } else {
      return const Left(ApiFailure(message: 'No internet connection'));
    }
  }

  @override
  Future<Either<Failure, List<PaymentEntity>>> getPaymentsByUserId() async {
    if (await _networkInfo.isConnected) {
      try {
        final models = await _paymentRemoteDatasource.getPaymentsByUserId();
        return Right(models.map((model) => model.toEntity()).toList());
      } catch (e) {
        return Left(ApiFailure(message: e.toString()));
      }
    } else {
      return const Left(ApiFailure(message: 'No internet connection'));
    }
  }

  @override
  Future<Either<Failure, List<PaymentEntity>>> getPaymentsOfShop() async {
    if (await _networkInfo.isConnected) {
      try {
        final models = await _paymentRemoteDatasource.getPaymentsOfShop();
        return Right(models.map((model) => model.toEntity()).toList());
      } catch (e) {
        return Left(ApiFailure(message: e.toString()));
      }
    } else {
      return const Left(ApiFailure(message: 'No internet connection'));
    }
  }

  @override
  Future<Either<Failure, PaymentEntity?>> updatePayment(
    String id,
    PaymentEntity paymentEntity,
  ) async {
    if (await _networkInfo.isConnected) {
      try {
        final apiModel = PaymentApiModel.fromEntity(paymentEntity);
        final model = await _paymentRemoteDatasource.updatePayment(
          id,
          apiModel,
        );
        return Right(model?.toEntity());
      } catch (e) {
        return Left(ApiFailure(message: e.toString()));
      }
    } else {
      return const Left(ApiFailure(message: 'No internet connection'));
    }
  }

  @override
  Future<Either<Failure, bool>> deletePayment(String id) async {
    if (await _networkInfo.isConnected) {
      try {
        final result = await _paymentRemoteDatasource.deletePayment(id);
        return Right(result);
      } catch (e) {
        return Left(ApiFailure(message: e.toString()));
      }
    } else {
      return const Left(ApiFailure(message: 'No internet connection'));
    }
  }
}
