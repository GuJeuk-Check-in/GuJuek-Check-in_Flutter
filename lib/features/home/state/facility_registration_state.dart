enum FacilityRegistrationErrorType {
  validation,
  notFound,
  server,
  network,
  unknown,
}

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
