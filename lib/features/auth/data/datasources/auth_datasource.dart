import 'package:resub/features/user/data/models/user_hive_model.dart';

abstract interface class IAuthDatasource {
  Future<bool> register(UserHiveModel authEntity);
  Future<UserHiveModel?> login(String email, String password);
  Future<bool> logout(String userId);
  Future<UserHiveModel?> getCurrentUser(String userId);
}