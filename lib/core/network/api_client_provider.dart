import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gujuek_check_in_flutter/core/network/api_client.dart';

// API 클라이언트를 .env 설정 기반으로 주입
final apiClientProvider = Provider<ApiClient?>((ref) {
  return ApiClient.fromEnv();
});
