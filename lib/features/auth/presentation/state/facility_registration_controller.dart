import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/models/login/login_model.dart';
import '../../domain/repositories/auth_repository.dart';
import 'facility_registration_state.dart';

class FacilityRegistrationController
    extends StateNotifier<FacilityRegistrationState> {
  FacilityRegistrationController(this._authRepository)
      : super(const FacilityRegistrationState());

  final AuthRepository _authRepository;

  // 시설 이용 신청(로그인) 처리
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

    // ApiResponse.message는 클라이언트 사전 오류
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
    // 일회성 알림(토스트/다이얼로그) 초기화
    state = state.copyWith(
      errorType: null,
      message: null,
      isSuccess: false,
    );
  }

  String? _validate(FacilityRegistrationFormData form) {
    // 기본 입력값 검증
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
