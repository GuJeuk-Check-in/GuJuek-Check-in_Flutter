import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/models/residence/residence_model.dart';
import '../../domain/repositories/residence_repository.dart';

// 거주지 목록을 전역에서 비동기로 제공
final residenceListProvider = FutureProvider<List<ResidenceModel>>((ref) async {
  return ref.watch(residenceRepositoryProvider).fetchResidences();
});
