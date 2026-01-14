import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gujuek_check_in_flutter/data/models/purpose/purpose_model.dart';
import 'package:gujuek_check_in_flutter/data/repositories/purpose_repository.dart';

final purposeListProvider = FutureProvider<List<PurposeModel>>((ref) async {
  return ref.watch(purposeRepositoryProvider).fetchPurposes();
});
