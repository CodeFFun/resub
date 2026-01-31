import 'package:resub/features/user/data/models/user_api_model.dart';
import 'package:resub/features/user/data/models/user_hive_model.dart';

abstract interface class IAuthLocalDatasource {
  Future<UserHiveModel?> register(UserHiveModel authEntity);
  Future<UserHiveModel?> login(String email, String password);
  Future<bool> logout(String userId);
  Future<UserHiveModel?> getCurrentUser(String userId);
  Future<bool> updateUserByEmail(String email, UserHiveModel updateData);
}

abstract interface class IAuthRemoteDatasource {
  Future<UserApiModel> register(UserApiModel authEntity);
  Future<UserApiModel?> login(String email, String password);
  Future<bool> updateUserByEmail(String email, UserApiModel updateData);
}
