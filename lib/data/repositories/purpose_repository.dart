import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gujuek_check_in_flutter/core/network/api_client.dart';
import 'package:gujuek_check_in_flutter/core/network/api_client_provider.dart';
import 'package:gujuek_check_in_flutter/data/models/purpose/purpose_model.dart';

class PurposeRepository {
  PurposeRepository(this._client);

  final ApiClient? _client;

  Future<List<PurposeModel>> fetchPurposes() async {
    final client = _client;
    if (client == null) {
      debugPrint('BASE_URL이 설정되지 않았습니다.');
      return [];
    }

    try {
      final response = await client.dio.get('/purpose/all');
      final List<dynamic> jsonList = response.data;
      return jsonList.map((e) => PurposeModel.fromJson(e)).toList();
    } catch (error) {
      debugPrint('PURPOSE ERROR: $error');
      return [];
    }
  }
}

final purposeRepositoryProvider = Provider<PurposeRepository>((ref) {
  return PurposeRepository(ref.watch(apiClientProvider));
});
