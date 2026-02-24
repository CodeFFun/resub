import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:resub/core/api/api_client.dart';
import 'package:resub/core/api/api_endpoints.dart';
import 'package:resub/core/services/storage/token_service.dart';
import 'package:resub/core/services/storage/user_session_service.dart';
import 'package:resub/features/profile/data/datasources/profile_datasource.dart';
import 'package:resub/features/user/data/models/user_api_model.dart';

final profileRemoteDatasourceProvider = Provider<IProfileRemoteDatasource>((
  ref,
) {
  return ProfileRemoteDatasource(
    apiClient: ref.read(apiClientProvider),
    userSessionService: ref.read(userSessionServiceProvider),
    tokenService: ref.read(tokenServiceProvider),
  );
});

class ProfileRemoteDatasource implements IProfileRemoteDatasource {
  final ApiClient _apiClient;
  final UserSessionService _userSessionService;
  final TokenService _tokenService;
  ProfileRemoteDatasource({
    required ApiClient apiClient,
    required UserSessionService userSessionService,
    required TokenService tokenService,
  }) : _apiClient = apiClient,
       _userSessionService = userSessionService,
       _tokenService = tokenService;
  @override
  Future<UserApiModel?> updatePersonalInfo(UserApiModel personalInfo) async {
    final token = await _tokenService.getToken();
    final formData = FormData.fromMap({
      ...personalInfo.toJson(),
      if (personalInfo.profilePictureUrl != null)
        'profilePictureUrl': await MultipartFile.fromFile(
          personalInfo.profilePictureUrl!.path,
          filename: 'profile.jpg',
        ),
    });
    final response = await _apiClient.patch(
      ApiEndpoints.updateProfile,
      data: formData,
      options: Options(headers: {'Authorization': 'Bearer $token'}),
    );

    if (response.data['success'] == true) {
      final data = response.data['data'] as Map<String, dynamic>;
      final updatedUser = UserApiModel.fromJson(data);
      await _userSessionService.saveUserSession(
        userId: updatedUser.userId!,
        email: updatedUser.email!,
        username: updatedUser.username!,
        role: updatedUser.role!,
      );
      return updatedUser;
    }
    return null;
  }

  @override
  Future<UserApiModel?> getUserById(String userId) async {
    final response = await _apiClient.get('${ApiEndpoints.getUser}/$userId');
    if (response.data['success'] == true) {
      final data = response.data['data'] as Map<String, dynamic>;
      final user = UserApiModel.fromJson(data);
      return user;
    } else {
      return null;
    }
  }
}
