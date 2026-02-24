import 'package:resub/features/user/data/models/user_api_model.dart';
import 'package:resub/features/user/data/models/user_hive_model.dart';

abstract interface class IProfileLocalDatasource {
  Future<bool> updatePersonalInfo(UserHiveModel personalInfo);
  Future<UserHiveModel?> getUserById(String userId);
}

abstract interface class IProfileRemoteDatasource {
  Future<UserApiModel?> updatePersonalInfo(UserApiModel personalInfo);
  Future<UserApiModel?> getUserById(String userId);
}
