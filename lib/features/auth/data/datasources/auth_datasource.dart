import 'package:resub/features/user/data/models/user_api_model.dart';
import 'package:resub/features/user/data/models/user_hive_model.dart';

abstract interface class IAuthLocalDatasource {
  Future<bool> register(UserHiveModel authEntity);
  Future<UserHiveModel?> login(String email, String password);
  Future<bool> logout(String userId);
  Future<UserHiveModel?> getCurrentUser(String userId);
}

abstract interface class IAuthRemoteDatasource {
  Future<UserApiModel> register(UserApiModel authEntity);
  Future<UserApiModel?> login(String email, String password);
  Future<bool> logout(String userId);
  Future<UserApiModel?> getCurrentUser(String userId);
}
