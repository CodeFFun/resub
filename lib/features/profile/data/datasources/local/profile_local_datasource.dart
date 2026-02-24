import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:resub/core/services/hive/hive_service.dart';
import 'package:resub/features/profile/data/datasources/profile_datasource.dart';
import 'package:resub/features/user/data/models/user_hive_model.dart';

final profileLocalDatasourceProvider = Provider<IProfileLocalDatasource>((ref) {
  final hiveService = ref.watch(hiveServiceProvider);
  return ProfileLocalDatasource(hiveService: hiveService);
});

class ProfileLocalDatasource implements IProfileLocalDatasource {
  final HiveService _hiveService;

  ProfileLocalDatasource({required HiveService hiveService})
    : _hiveService = hiveService;

  @override
  Future<bool> updatePersonalInfo(UserHiveModel personalInfo) async {
    try {
      await _hiveService.updateUser(personalInfo);
      return Future.value(true);
    } catch (e) {
      return Future.value(false);
    }
  }

  @override
  Future<UserHiveModel?> getUserById(String userId) {
    try {
      final user = _hiveService.getUserById(userId);
      return Future.value(user);
    } catch (e) {
      return Future.value(null);
    }
  }
}
