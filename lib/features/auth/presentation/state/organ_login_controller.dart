// import 'package:flutter/foundation.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:gujuek_check_in_flutter/core/storage/secure_storage_service.dart';
//
// import '../../data/models/organ_login/organ_login_request.dart';
// import '../../data/models/organ_login/organ_login_response.dart';
// import '../../domain/repositories/auth_repository.dart';
// import 'organ_login_state.dart';
//
// class OrganLoginController extends StateNotifier<OrganLoginState> {
//   OrganLoginController(this._authRepository, this._secureStorage)
//       : super(const OrganLoginState());
//
//   final AuthRepository _authRepository;
//   final SecureStorageService _secureStorage;
//
//   Future<void> submit({
//     required String organName,
//     required String password,
//   }) async {
//     if (state.isSubmitting) return;
//
//     final validationMessage = _validate(organName, password);
//     if (validationMessage != null) {
//       state = state.copyWith(
//         errorType: OrganLoginErrorType.validation,
//         message: validationMessage,
//         isSuccess: false,
//       );
//       return;
//     }
//
//     state = state.copyWith(
//       isSubmitting: true,
//       errorType: null,
//       message: null,
//       isSuccess: false,
//     );
//
//     final response = await _authRepository.organLogin(
//       OrganLoginRequest(
//         organName: organName.trim(),
//         password: password,
//       ),
//     );
//     state = state.copyWith(isSubmitting: false);
//
//     if (response.message != null) {
//       state = state.copyWith(
//         errorType: OrganLoginErrorType.unknown,
//         message: response.message,
//       );
//       return;
//     }
//
//     if (response.hasException && response.statusCode == null) {
//       state = state.copyWith(
//         errorType: OrganLoginErrorType.network,
//         message: response.exception?.message ?? '네트워크 오류가 발생했습니다.',
//       );
//       return;
//     }
//
//     final statusCode = response.statusCode ?? 0;
//     if (statusCode == 200) {
//       final data = response.data;
//       if (data is OrganLoginResponse) {
//         await _secureStorage.saveOrganTokens(
//           accessToken: data.accessToken,
//           refreshToken: data.refreshToken,
//           organName: data.organName,
//         );
//         state = state.copyWith(
//           isSuccess: true,
//           accessToken: data.accessToken,
//           refreshToken: data.refreshToken,
//           organName: data.organName,
//         );
//       } else {
//         state = state.copyWith(isSuccess: true);
//       }
//       return;
//     }
//
//     String? _messageFromData() {
//       final data = response.data;
//       if (data is Map<String, dynamic>) {
//         return data['message']?.toString();
//       }
//       return null;
//     }
//
//     if (statusCode == 400) {
//       state = state.copyWith(
//         errorType: OrganLoginErrorType.badRequest,
//         message: _messageFromData() ?? '요청이 올바르지 않습니다.',
//       );
//       return;
//     }
//
//     if (statusCode == 401) {
//       state = state.copyWith(
//         errorType: OrganLoginErrorType.unauthorized,
//         message: _messageFromData() ?? '비밀번호가 일치하지 않습니다.',
//       );
//       return;
//     }
//
//     if (statusCode == 404) {
//       state = state.copyWith(
//         errorType: OrganLoginErrorType.notFound,
//         message: _messageFromData() ?? '해당 기관 계정이 없습니다.',
//       );
//       return;
//     }
//
//     if (statusCode == 500) {
//       state = state.copyWith(
//         errorType: OrganLoginErrorType.server,
//         message: '서버 오류가 발생했습니다.',
//       );
//       return;
//     }
//
//     debugPrint('ORGAN LOGIN UNKNOWN: ${response.data}');
//     state = state.copyWith(
//       errorType: OrganLoginErrorType.unknown,
//       message: '로그인 실패: ${response.data}',
//     );
//   }
//
//   void clearNotifications() {
//     state = state.copyWith(
//       errorType: null,
//       message: null,
//       isSuccess: false,
//     );
//   }
//
//   String? _validate(String organName, String password) {
//     if (organName.trim().isEmpty) {
//       return '기관 아이디를 입력해주세요';
//     }
//     if (password.isEmpty) {
//       return '비밀번호를 입력해주세요';
//     }
//     return null;
//   }
// }
//
//
// final organLoginControllerProvider =
//     StateNotifierProvider<OrganLoginController, OrganLoginState>((ref) {
//       return OrganLoginController(
//     ref.watch(authRepositoryProvider),
//     ref.watch(secureStorageServiceProvider),
//   );
// });
