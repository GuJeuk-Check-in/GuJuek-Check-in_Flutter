import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gujuek_check_in_flutter/data/models/login/login_model.dart';
import 'package:gujuek_check_in_flutter/data/repositories/auth_repository.dart';
import 'package:gujuek_check_in_flutter/features/home/state/facility_registration_state.dart';

class FacilityRegistrationController
    extends StateNotifier<FacilityRegistrationState> {
  FacilityRegistrationController(this._authRepository)
      : super(const FacilityRegistrationState());

  final AuthRepository _authRepository;

  Future<void> submit(FacilityRegistrationFormData form) async {
    if (state.isSubmitting) return;

    final validationMessage = _validate(form);
    if (validationMessage != null) {
      state = state.copyWith(
        errorType: FacilityRegistrationErrorType.validation,
        message: validationMessage,
        isSuccess: false,
      );
      return;
    }

    state = state.copyWith(
      isSubmitting: true,
      errorType: null,
      message: null,
      isSuccess: false,
    );

    final loginModel = LoginModel(
      userId: form.userId,
      purpose: form.purpose!,
      maleCount: form.maleCount,
      femaleCount: form.femaleCount,
    );

    debugPrint('LOGIN DATA: ${loginModel.toJson()}');

    final response = await _authRepository.login(loginModel);
    state = state.copyWith(isSubmitting: false);

    if (response.message != null) {
      state = state.copyWith(
        errorType: FacilityRegistrationErrorType.unknown,
        message: response.message,
      );
      return;
    }

    if (response.hasException && response.statusCode == null) {
      state = state.copyWith(
        errorType: FacilityRegistrationErrorType.network,
        message: response.exception?.message ?? '네트워크 오류가 발생했습니다.',
      );
      return;
    }

    final statusCode = response.statusCode ?? 0;
    if (statusCode == 200 || statusCode == 201) {
      state = state.copyWith(isSuccess: true);
      return;
    }

    if (statusCode == 404) {
      state = state.copyWith(
        errorType: FacilityRegistrationErrorType.notFound,
        message: response.data?['message']?.toString() ?? '아이디를 찾을 수 없습니다.',
      );
      return;
    }

    if (statusCode == 500) {
      state = state.copyWith(
        errorType: FacilityRegistrationErrorType.server,
        message: '서버 오류: ${response.data}',
      );
      return;
    }

    state = state.copyWith(
      errorType: FacilityRegistrationErrorType.unknown,
      message: '로그인 실패: ${response.data}',
    );
  }

  void clearNotifications() {
    state = state.copyWith(
      errorType: null,
      message: null,
      isSuccess: false,
    );
  }

  String? _validate(FacilityRegistrationFormData form) {
    if (form.userId.trim().isEmpty) {
      return '아이디를 입력해주세요';
    }
    if (form.purpose == null || form.purpose!.isEmpty) {
      return '방문 목적을 선택해주세요';
    }
    return null;
  }
}

final facilityRegistrationControllerProvider =
    StateNotifierProvider<FacilityRegistrationController,
        FacilityRegistrationState>((ref) {
  return FacilityRegistrationController(ref.watch(authRepositoryProvider));
});
