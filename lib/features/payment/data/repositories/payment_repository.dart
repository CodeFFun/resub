import 'package:dartz/dartz.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:resub/core/error/failure.dart';
import 'package:resub/core/services/connectivity/network_info.dart';
import 'package:resub/core/services/storage/user_session_service.dart';
import 'package:resub/features/payment/data/datasources/local/payment_local_datasource.dart';
import 'package:resub/features/payment/data/datasources/payment_datasource.dart';
import 'package:resub/features/payment/data/datasources/remote/payment_remote_datasource.dart';
import 'package:resub/features/payment/data/models/payment_hive_model.dart';
import 'package:resub/features/payment/data/models/payment_model.dart';
import 'package:resub/features/payment/domain/entities/payment_entity.dart';
import 'package:resub/features/payment/domain/repositories/payment_repository.dart';

final paymentRepositoryProvider = Provider<IPaymentRepository>((ref) {
  final paymentRemoteDatasource = ref.read(paymentRemoteDatasourceProvider);
  final paymentLocalDatasource = ref.read(paymentLocalDatasourceProvider);
  final networkInfo = ref.read(networkInfoProvider);
  final userSession = ref.read(userSessionServiceProvider);
  return PaymentRepository(
    paymentRemoteDatasource: paymentRemoteDatasource,
    paymentLocalDatasource: paymentLocalDatasource,
    networkInfo: networkInfo,
    userSession: userSession,
  );
});

class PaymentRepository implements IPaymentRepository {
  final NetworkInfo _networkInfo;
  final IPaymentRemoteDatasource _paymentRemoteDatasource;
  final IPaymentLocalDatasource _paymentLocalDatasource;
  final UserSessionService _userSession;

  PaymentRepository({
    required NetworkInfo networkInfo,
    required IPaymentRemoteDatasource paymentRemoteDatasource,
    required IPaymentLocalDatasource paymentLocalDatasource,
    required UserSessionService userSession,
  }) : _networkInfo = networkInfo,
       _paymentRemoteDatasource = paymentRemoteDatasource,
       _paymentLocalDatasource = paymentLocalDatasource,
       _userSession = userSession;

  @override
  Future<Either<Failure, PaymentEntity>> createPayment(
    PaymentEntity paymentEntity,
  ) async {
    if (await _networkInfo.isConnected) {
      try {
        final apiModel = PaymentApiModel.fromEntity(paymentEntity);
        final model = await _paymentRemoteDatasource.createPayment(apiModel);
        // Sync to local
        final hiveModel = PaymentHiveModel.fromEntity(model.toEntity());
        await _paymentLocalDatasource.createPayment(hiveModel);
        return Right(model.toEntity());
      } catch (e) {
        return Left(ApiFailure(message: e.toString()));
      }
    } else {
      try {
        final hiveModel = PaymentHiveModel.fromEntity(paymentEntity);
        final model = await _paymentLocalDatasource.createPayment(hiveModel);
        return Right(model.toEntity());
      } catch (e) {
        return Left(LocalDatabaseFailure(message: e.toString()));
      }
    }
  }

  @override
  Future<Either<Failure, PaymentEntity?>> getPaymentById(String id) async {
    if (await _networkInfo.isConnected) {
      try {
        final model = await _paymentRemoteDatasource.getPaymentById(id);
        // Sync to local
        if (model != null) {
          final hiveModel = PaymentHiveModel.fromEntity(model.toEntity());
          await _paymentLocalDatasource.createPayment(hiveModel);
        }
        return Right(model?.toEntity());
      } catch (e) {
        return Left(ApiFailure(message: e.toString()));
      }
    } else {
      try {
        final model = await _paymentLocalDatasource.getPaymentById(id);
        return Right(model?.toEntity());
      } catch (e) {
        return Left(LocalDatabaseFailure(message: e.toString()));
      }
    }
  }

  @override
  Future<Either<Failure, List<PaymentEntity>>> getPaymentsByUserId() async {
    if (await _networkInfo.isConnected) {
      try {
        final models = await _paymentRemoteDatasource.getPaymentsByUserId();
        // Sync to local
        for (final model in models) {
          final hiveModel = PaymentHiveModel.fromEntity(model.toEntity());
          await _paymentLocalDatasource.createPayment(hiveModel);
        }
        return Right(models.map((model) => model.toEntity()).toList());
      } catch (e) {
        return Left(ApiFailure(message: e.toString()));
      }
    } else {
      try {
        final userId = _userSession.getCurrentUserId();
        if (userId == null) {
          return const Left(ApiFailure(message: 'User not logged in'));
        }
        final models = await _paymentLocalDatasource.getPaymentsByUserId(
          userId,
        );
        return Right(models.map((model) => model.toEntity()).toList());
      } catch (e) {
        return Left(LocalDatabaseFailure(message: e.toString()));
      }
    }
  }

  @override
  Future<Either<Failure, List<PaymentEntity>>> getPaymentsOfShop() async {
    if (await _networkInfo.isConnected) {
      try {
        final models = await _paymentRemoteDatasource.getPaymentsOfShop();
        // Sync to local
        for (final model in models) {
          final hiveModel = PaymentHiveModel.fromEntity(model.toEntity());
          await _paymentLocalDatasource.createPayment(hiveModel);
        }
        return Right(models.map((model) => model.toEntity()).toList());
      } catch (e) {
        return Left(ApiFailure(message: e.toString()));
      }
    } else {
      try {
        final models = await _paymentLocalDatasource.getAllPayments();
        return Right(models.map((model) => model.toEntity()).toList());
      } catch (e) {
        return Left(LocalDatabaseFailure(message: e.toString()));
      }
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
        // Sync to local
        if (model != null) {
          final hiveModel = PaymentHiveModel.fromEntity(model.toEntity());
          await _paymentLocalDatasource.updatePayment(id, hiveModel);
        }
        return Right(model?.toEntity());
      } catch (e) {
        return Left(ApiFailure(message: e.toString()));
      }
    } else {
      try {
        final hiveModel = PaymentHiveModel.fromEntity(paymentEntity);
        final result = await _paymentLocalDatasource.updatePayment(
          id,
          hiveModel,
        );
        if (result) {
          return Right(paymentEntity);
        } else {
          return const Left(
            LocalDatabaseFailure(message: 'Failed to update payment'),
          );
        }
      } catch (e) {
        return Left(LocalDatabaseFailure(message: e.toString()));
      }
    }
  }

  @override
  Future<Either<Failure, bool>> deletePayment(String id) async {
    if (await _networkInfo.isConnected) {
      try {
        final result = await _paymentRemoteDatasource.deletePayment(id);
        // Sync to local
        await _paymentLocalDatasource.deletePayment(id);
        return Right(result);
      } catch (e) {
        return Left(ApiFailure(message: e.toString()));
      }
    } else {
      try {
        final result = await _paymentLocalDatasource.deletePayment(id);
        return Right(result);
      } catch (e) {
        return Left(LocalDatabaseFailure(message: e.toString()));
      }
    }
  }
}
