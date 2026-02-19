import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gujuek_check_in_flutter/core/network/api_client.dart';
import 'package:gujuek_check_in_flutter/core/network/api_client_provider.dart';
import 'package:gujuek_check_in_flutter/core/storage/secure_storage_service.dart';

import '../../data/models/login/login_model.dart';
import '../../data/models/organ_login/organ_login_request.dart';
import '../../data/models/organ_login/organ_login_response.dart';
import '../../data/models/sign_up/user_model.dart';

class ApiResponse {
  ApiResponse({this.statusCode, this.data, this.exception, this.message});

  final int? statusCode;
  final dynamic data;
  final DioException? exception;
  final String? message;

  // 예외 발생 여부를 한 곳에서 확인하기 위한 헬퍼
  bool get hasException => exception != null;
}

// 로그인/회원가입 API 호출을 담당하는 리포지토리
class AuthRepository {
  AuthRepository(this._client, this._secureStorage);

  final ApiClient? _client;
  final SecureStorageService _secureStorage;

  Future<ApiResponse> signUp(UserModel user) async {
    final client = _client;
    if (client == null) {
      // BASE_URL이 비어 있으면 호출 자체를 막음
      return ApiResponse(message: 'BASE_URL이 설정되지 않았습니다.');
    }

    try {
      final response = await client.dio.post(
        '/user/sign-up',
        data: user.toJson(),
        options: Options(validateStatus: (status) {
          return status != null && status < 600;
        }),
      );
      return ApiResponse(statusCode: response.statusCode, data: response.data);
    } on DioException catch (e) {
      debugPrint('SIGN UP DioException: ${e.message}');
      return ApiResponse(
        statusCode: e.response?.statusCode,
        data: e.response?.data,
        exception: e,
      );
    }
  }

  Future<ApiResponse> login(LoginModel loginModel) async {
    final client = _client;
    if (client == null) {
      // BASE_URL이 비어 있으면 호출 자체를 막음
      return ApiResponse(message: 'BASE_URL이 설정되지 않았습니다.');
    }

    final tokens = await _secureStorage.readOrganTokens();
    final accessToken = tokens['access_token'];
    if (accessToken == null || accessToken.isEmpty) {
      return ApiResponse(message: '기관 로그인 토큰이 없습니다.');
    }

    try {
      final response = await client.dio.post(
        '/user/login',
        data: loginModel.toJson(),
        options: Options(
          headers: {'Authorization': 'Bearer $accessToken'},
          validateStatus: (status) => status != null && status < 600,
        ),
      );
      return ApiResponse(statusCode: response.statusCode, data: response.data);
    } on DioException catch (e) {
      debugPrint('LOGIN DioException: ${e.message}');
      return ApiResponse(
        statusCode: e.response?.statusCode,
        data: e.response?.data,
        exception: e,
      );
    }
  }

  Future<ApiResponse> organLogin(OrganLoginRequest request) async {
    final client = _client;
    if (client == null) {
      return ApiResponse(message: 'BASE_URL이 설정되지 않았습니다.');
    }

    try {
      final response = await client.dio.post(
        '/organ/login',
        data: request.toJson(),
        options: Options(validateStatus: (status) {
          return status != null && status < 600;
        }),
      );

      if (response.statusCode == 200 && response.data is Map<String, dynamic>) {
        return ApiResponse(
          statusCode: response.statusCode,
          data: OrganLoginResponse.fromJson(
            response.data as Map<String, dynamic>,
          ),
        );
      }

      return ApiResponse(statusCode: response.statusCode, data: response.data);
    } on DioException catch (e) {
      debugPrint('ORGAN LOGIN DioException: ${e.message}');
      return ApiResponse(
        statusCode: e.response?.statusCode,
        data: e.response?.data,
        exception: e,
      );
    }
  }
}

// 전역에서 AuthRepository를 주입하기 위한 Provider
final authRepositoryProvider = Provider<AuthRepository>((ref) {
  return AuthRepository(
    ref.watch(apiClientProvider),
    ref.watch(secureStorageServiceProvider),
  );
});
