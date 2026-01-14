import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class ApiClient {
  ApiClient(this._dio);

  final Dio _dio;

  // 외부에서는 dio 인스턴스만 노출
  Dio get dio => _dio;

  static ApiClient? fromEnv() {
    // .env의 BASE_URL을 기준으로 Dio 설정
    final baseUrl = dotenv.env['BASE_URL'];
    if (baseUrl == null || baseUrl.isEmpty) {
      return null;
    }

    return ApiClient(
      Dio(
        BaseOptions(
          baseUrl: baseUrl,
          headers: {'Content-Type': 'application/json'},
        ),
      ),
    );
  }
}
