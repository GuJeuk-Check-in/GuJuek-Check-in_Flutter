import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/models/purpose/purpose_model.dart';
import '../../domain/repositories/purpose_repository.dart';

// 방문 목적 목록을 전역에서 비동기로 제공
final purposeListProvider = FutureProvider<List<PurposeModel>>((ref) async {
  return ref.watch(purposeRepositoryProvider).fetchPurposes();
});
