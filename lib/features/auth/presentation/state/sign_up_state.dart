import 'package:gujuek_check_in_flutter/features/auth/data/models/resident/resident_model.dart';

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

// 회원가입 제출에 필요한 입력값 묶음
class SignUpFormData {
  const SignUpFormData({
    required this.name,
    required this.phone,
    required this.genderValue,
    required this.birthYmd,
    required this.privacyAgreed,
    required this.purpose,
    required this.residence,
    required this.maleCount,
    required this.femaleCount,
  });

  final String name;
  final String phone;
  final int genderValue;
  final String birthYmd;
  final bool privacyAgreed;
  final String? purpose;
  final String residence;
  final int maleCount;
  final int femaleCount;
}
