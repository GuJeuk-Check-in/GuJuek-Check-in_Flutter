import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gujuek_check_in_flutter/core/network/api_client.dart';
import 'package:gujuek_check_in_flutter/core/network/api_client_provider.dart';
import 'package:gujuek_check_in_flutter/features/auth/data/models/resident/resident_model.dart';

class ResidentRepository {
  ResidentRepository({this.apiClient});

  final ApiClient? apiClient;

  Future<List<ResidentModel>> residentCheck() async {
    final client = apiClient;
    if (client == null) {
      debugPrint('BASE_URL이 설정되지 않았습니다.');
      return [];
    }
    try {
      final response = await client.dio.get('residence/all');
      final List<dynamic> jsonList = response.data;
      return jsonList.map((e) => ResidentModel.fromJson(e)).toList();
    } catch (e) {
      debugPrint('Resident ERROR: $e');
    }
    return [];
  }
}

final residentRepositoryProvider = Provider<ResidentRepository>((ref) {
  final apiClient = ref.watch(apiClientProvider);
  return ResidentRepository(apiClient: apiClient);
});
