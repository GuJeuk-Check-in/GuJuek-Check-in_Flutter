import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gujuek_check_in_flutter/features/auth/data/models/resident/resident_model.dart';
import 'package:gujuek_check_in_flutter/features/auth/domain/repositories/resident_repository.dart';

import '../../data/models/purpose/purpose_model.dart';
import '../../domain/repositories/purpose_repository.dart';

// 방문 목적 목록을 전역에서 비동기로 제공
final residentListProvider = FutureProvider<List<ResidentModel>>((ref) async {
  return ref.watch(residentRepositoryProvider).residentCheck();
});
