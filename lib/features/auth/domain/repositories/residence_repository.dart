import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gujuek_check_in_flutter/core/network/api_client.dart';
import 'package:gujuek_check_in_flutter/core/network/api_client_provider.dart';
import 'package:gujuek_check_in_flutter/features/auth/data/models/residence/residence_model.dart';

class ResidenceRepository {
  ResidenceRepository(this._client);

  final ApiClient? _client;

  // 거주지 목록을 서버에서 가져옴
  Future<List<ResidenceModel>> fetchResidences() async {
    final client = _client;
    if (client == null) {
      // BASE_URL 누락 시 빈 목록 반환
      debugPrint('BASE_URL이 설정되지 않았습니다.');
      return [];
    }

    try {
      final response = await client.dio.get('/residence/all');
      final List<dynamic> jsonList = response.data;
      return jsonList.map((e) => ResidenceModel.fromJson(e)).toList();
    } catch (error) {
      debugPrint('RESIDENCE ERROR: $error');
      return [];
    }
  }
}

// 전역에서 ResidenceRepository를 주입하기 위한 Provider
final residenceRepositoryProvider = Provider<ResidenceRepository>((ref) {
  final apiClient = ref.watch(apiClientProvider);
  return ResidenceRepository(apiClient);
});
