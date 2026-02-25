// enum OrganLoginErrorType {
//   validation,
//   badRequest,
//   unauthorized,
//   notFound,
//   server,
//   network,
//   unknown,
// }
//
// class OrganLoginState {
//   const OrganLoginState({
//     this.isSubmitting = false,
//     this.errorType,
//     this.message,
//     this.isSuccess = false,
//     this.accessToken,
//     this.refreshToken,
//     this.organName,
//   });
//
//   final bool isSubmitting;
//   final OrganLoginErrorType? errorType;
//   final String? message;
//   final bool isSuccess;
//   final String? accessToken;
//   final String? refreshToken;
//   final String? organName;
//
//   OrganLoginState copyWith({
//     bool? isSubmitting,
//     OrganLoginErrorType? errorType,
//     String? message,
//     bool? isSuccess,
//     String? accessToken,
//     String? refreshToken,
//     String? organName,
//   }) {
//     return OrganLoginState(
//       isSubmitting: isSubmitting ?? this.isSubmitting,
//       errorType: errorType,
//       message: message,
//       isSuccess: isSuccess ?? this.isSuccess,
//       accessToken: accessToken ?? this.accessToken,
//       refreshToken: refreshToken ?? this.refreshToken,
//       organName: organName ?? this.organName,
//     );
//   }
// }
