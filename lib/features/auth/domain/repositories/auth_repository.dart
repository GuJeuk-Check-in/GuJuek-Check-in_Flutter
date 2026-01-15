import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gujuek_check_in_flutter/core/network/api_client.dart';
import 'package:gujuek_check_in_flutter/core/network/api_client_provider.dart';

import '../../data/models/login/login_model.dart';
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
  AuthRepository(this._client);

  final ApiClient? _client;

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

    try {
      final response = await client.dio.post(
        '/user/login',
        data: loginModel.toJson(),
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
}

// 전역에서 AuthRepository를 주입하기 위한 Provider
final authRepositoryProvider = Provider<AuthRepository>((ref) {
  return AuthRepository(ref.watch(apiClientProvider));
});
