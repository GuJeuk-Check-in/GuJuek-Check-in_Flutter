import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gujuek_check_in_flutter/core/network/api_client.dart';

final apiClientProvider = Provider<ApiClient?>((ref) {
  return ApiClient.fromEnv();
});
