import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gujuek_check_in_flutter/data/models/sign_up/user_model.dart';
import 'package:gujuek_check_in_flutter/data/repositories/auth_repository.dart';
import 'package:gujuek_check_in_flutter/features/auth/presentation/state/sign_up_state.dart';

class SignUpController extends StateNotifier<SignUpState> {
  SignUpController(this._authRepository) : super(const SignUpState());

  final AuthRepository _authRepository;

  // 회원가입 요청 처리
  Future<void> submit(SignUpFormData form) async {
    if (state.isSubmitting) return;

    final validationMessage = _validate(form);
    if (validationMessage != null) {
      state = state.copyWith(
        errorType: SignUpErrorType.validation,
        message: validationMessage,
        generatedId: null,
      );
      return;
    }

    state = state.copyWith(
      isSubmitting: true,
      errorType: null,
      message: null,
      generatedId: null,
    );

    final user = UserModel(
      name: form.name,
      gender: form.genderValue == 1 ? Gender.MAN : Gender.WOMAN,
      phone: form.phone,
      birthYMD: form.birthYmd,
      privacyAgreed: form.privacyAgreed,
      purpose: form.purpose!,
      residence: form.residence!,
      maleCount: form.maleCount,
      femaleCount: form.femaleCount,
    );

    debugPrint('SIGN UP DATA: ${user.toJson()}');

    final response = await _authRepository.signUp(user);
    state = state.copyWith(isSubmitting: false);

    // ApiResponse.message는 클라이언트 사전 오류
    if (response.message != null) {
      state = state.copyWith(
        errorType: SignUpErrorType.unknown,
        message: response.message,
      );
      return;
    }

    if (response.hasException && response.statusCode == null) {
      state = state.copyWith(
        errorType: SignUpErrorType.network,
        message: response.exception?.message ?? '네트워크 오류가 발생했습니다.',
      );
      return;
    }

    final statusCode = response.statusCode ?? 0;
    if (statusCode == 200 || statusCode == 201) {
      final generatedId = response.data?['userId']?.toString() ?? '';
      state = state.copyWith(generatedId: generatedId);
      return;
    }

    if (statusCode == 401) {
      state = state.copyWith(
        errorType: SignUpErrorType.duplicateUser,
        message: '이미 존재하는 회원입니다.',
      );
      return;
    }

    if (statusCode == 500) {
      state = state.copyWith(
        errorType: SignUpErrorType.server,
        message: '서버 오류: ${response.data}',
      );
      return;
    }

    state = state.copyWith(
      errorType: SignUpErrorType.unknown,
      message: '회원가입 실패: ${response.data}',
    );
  }

  void clearNotifications() {
    // 일회성 알림(토스트/다이얼로그) 초기화
    state = state.copyWith(
      errorType: null,
      message: null,
      generatedId: null,
    );
  }

  String? _validate(SignUpFormData form) {
    // 기본 입력값 검증
    if (form.name.trim().isEmpty) {
      return '이름을 입력해주세요';
    }
    if (form.phone.trim().isEmpty) {
      return '전화번호를 입력해주세요';
    }
    if (form.birthYmd.trim().isEmpty) {
      return '생년월일을 선택해주세요';
    }
    if (!form.privacyAgreed) {
      return '개인정보 수집 및 이용에 동의해주세요';
    }
    if (form.purpose == null || form.purpose!.isEmpty) {
      return '방문 목적을 선택해주세요';
    }
    if (form.residence == null || form.residence!.isEmpty) {
      return '거주지를 선택해주세요';
    }
    return null;
  }
}

final signUpControllerProvider =
    StateNotifierProvider<SignUpController, SignUpState>((ref) {
  return SignUpController(ref.watch(authRepositoryProvider));
});
