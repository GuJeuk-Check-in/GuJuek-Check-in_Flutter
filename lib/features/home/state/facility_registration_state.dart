enum FacilityRegistrationErrorType {
  validation,
  notFound,
  server,
  network,
  unknown,
}

// 시설 이용 신청(로그인) 상태
class FacilityRegistrationState {
  const FacilityRegistrationState({
    this.isSubmitting = false,
    this.errorType,
    this.message,
    this.isSuccess = false,
  });

  final bool isSubmitting;
  final FacilityRegistrationErrorType? errorType;
  final String? message;
  final bool isSuccess;

  FacilityRegistrationState copyWith({
    bool? isSubmitting,
    FacilityRegistrationErrorType? errorType,
    String? message,
    bool? isSuccess,
  }) {
    return FacilityRegistrationState(
      isSubmitting: isSubmitting ?? this.isSubmitting,
      errorType: errorType,
      message: message,
      isSuccess: isSuccess ?? this.isSuccess,
    );
  }
}

// 시설 이용 신청에 필요한 입력값 묶음
class FacilityRegistrationFormData {
  const FacilityRegistrationFormData({
    required this.userId,
    required this.purpose,
    required this.maleCount,
    required this.femaleCount,
  });

  final String userId;
  final String? purpose;
  final int maleCount;
  final int femaleCount;
}
