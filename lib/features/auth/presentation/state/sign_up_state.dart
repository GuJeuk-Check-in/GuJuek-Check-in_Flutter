enum SignUpErrorType {
  validation,
  duplicateUser,
  server,
  network,
  unknown,
}

// 회원가입 UI 상태
class SignUpState {
  const SignUpState({
    this.isSubmitting = false,
    this.errorType,
    this.message,
    this.generatedId,
  });

  final bool isSubmitting;
  final SignUpErrorType? errorType;
  final String? message;
  final String? generatedId;

  SignUpState copyWith({
    bool? isSubmitting,
    SignUpErrorType? errorType,
    String? message,
    String? generatedId,
  }) {
    return SignUpState(
      isSubmitting: isSubmitting ?? this.isSubmitting,
      errorType: errorType,
      message: message,
      generatedId: generatedId,
    );
  }
}

// 1단계 입력값 (이름, 생일, 연락처, 방문 목적)
class FirstSignUpFormData {
  const FirstSignUpFormData({
    required this.name,
    required this.phone,
    required this.birthYmd,
    required this.purpose,
  });

  final String name;
  final String phone;
  final String birthYmd;
  final String? purpose;
}

// 최종 제출용 통합 데이터
class SignUpFormData {
  const SignUpFormData({
    required this.name,
    required this.phone,
    required this.birthYmd,
    required this.purpose,
    required this.genderValue,
    required this.privacyAgreed,
    required this.maleCount,
    required this.femaleCount,
    required this.residence,
  });

  final String name;
  final String phone;
  final String birthYmd;
  final String? purpose;
  final int genderValue; // 1=남성, 2=여성
  final bool privacyAgreed;
  final int maleCount;
  final int femaleCount;
  final String residence;
}
