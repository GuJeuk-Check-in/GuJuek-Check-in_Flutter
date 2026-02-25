import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gujuek_check_in_flutter/core/network/api_client.dart';
import 'package:gujuek_check_in_flutter/core/network/api_client_provider.dart';
import 'package:gujuek_check_in_flutter/core/storage/secure_storage_service.dart';

import '../../data/models/purpose/purpose_model.dart';

class PurposeRepository {
  PurposeRepository(this._client);

  final ApiClient? _client;

  // 방문 목적 목록을 서버에서 가져옴
  Future<List<PurposeModel>> fetchPurposes() async {
    final client = _client;
    if (client == null) {
      // BASE_URL 누락 시 빈 목록 반환
      debugPrint('BASE_URL이 설정되지 않았습니다.');
      return [];
    }

    try {
      // final tokens = await _secureStorage?.readOrganTokens();
      // final String? rawToken = tokens?['access_token'];
      // final accessToken = rawToken?.trim();
      final response = await client.dio.get('purpose/all');
      //  options: Options(headers: {'Authorization':'Bearer $accessToken'}));
      final List<dynamic> jsonList = response.data;
      return jsonList.map((e) => PurposeModel.fromJson(e)).toList();
    } catch (error) {
      debugPrint('PURPOSE ERROR: $error');
      return [];
    }
  }
}

// 전역에서 PurposeRepository를 주입하기 위한 Provider
final purposeRepositoryProvider = Provider<PurposeRepository>((ref) {
  final apiClient = ref.watch(apiClientProvider);
  return PurposeRepository(apiClient);
});
