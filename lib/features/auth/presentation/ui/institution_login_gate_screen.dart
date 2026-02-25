// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:gujuek_check_in_flutter/core/widgets/circle_background.dart';
// import 'package:gujuek_check_in_flutter/core/widgets/custom_layout.dart';
// import 'package:gujuek_check_in_flutter/core/widgets/dialogs/loading_dialog.dart';
// import 'package:gujuek_check_in_flutter/features/auth/presentation/dialogs/institution_login_dialog.dart';
// import 'package:gujuek_check_in_flutter/features/auth/presentation/state/organ_login_controller.dart';
// import 'package:gujuek_check_in_flutter/features/auth/presentation/state/organ_login_state.dart';
// import 'package:gujuek_check_in_flutter/features/home/presentation/ui/home_screen.dart';
//
// class InstitutionLoginGateScreen extends ConsumerStatefulWidget {
//   const InstitutionLoginGateScreen({super.key});
//
//   @override
//   ConsumerState<InstitutionLoginGateScreen> createState() =>
//       _InstitutionLoginGateScreenState();
// }
//
// class _InstitutionLoginGateScreenState
//     extends ConsumerState<InstitutionLoginGateScreen> {
//   bool _dialogShown = false;
//   bool _isLoadingDialogVisible = false;
//
//   @override
//   void didChangeDependencies() {
//     super.didChangeDependencies();
//     if (_dialogShown) return;
//     _dialogShown = true;
//     WidgetsBinding.instance.addPostFrameCallback((_) {
//       if (!mounted) return;
//       _showLoginDialog();
//     });
//   }
//
//   void _showLoginDialog() {
//     showDialog(
//       context: context,
//       barrierDismissible: false,
//       builder: (_) => InstitutionLoginDialog(
//         onConfirm: (id, password) {
//           Navigator.of(context, rootNavigator: true).pop();
//           ref
//               .read(organLoginControllerProvider.notifier)
//               .submit(organName: id, password: password);
//         },
//       ),
//     );
//   }
//
//   void _showLoadingDialog() {
//     if (_isLoadingDialogVisible) return;
//     _isLoadingDialogVisible = true;
//     showDialog(
//       context: context,
//       barrierDismissible: false,
//       builder: (_) => const LoadingDialog(),
//     );
//   }
//
//   void _hideLoadingDialog() {
//     if (!_isLoadingDialogVisible) return;
//     _isLoadingDialogVisible = false;
//     if (!mounted) return;
//     Navigator.of(context, rootNavigator: true).pop();
//   }
//
//   void _handleLoginState(OrganLoginState? prev, OrganLoginState next) {
//     if (!mounted) return;
//
//     final wasSubmitting = prev?.isSubmitting ?? false;
//     if (!wasSubmitting && next.isSubmitting) {
//       _showLoadingDialog();
//     } else if (wasSubmitting && !next.isSubmitting) {
//       _hideLoadingDialog();
//     }
//
//     if (next.isSuccess) {
//       WidgetsBinding.instance.addPostFrameCallback((_) {
//         if (!mounted) return;
//         Navigator.of(context).pushReplacement(
//           MaterialPageRoute(builder: (_) => const HomeScreen()),
//         );
//         ref.read(organLoginControllerProvider.notifier).clearNotifications();
//         return;
//       });
//     }
//
//     if (next.errorType != null && next.message != null) {
//       _showErrorDialog(next.message!);
//       ref.read(organLoginControllerProvider.notifier).clearNotifications();
//     }
//   }
//
//   void _showErrorDialog(String message) {
//     showDialog(
//       barrierDismissible: false,
//       context: context,
//       builder: (_) => AlertDialog(
//         title: const Text('로그인 실패'),
//         content: Text(message),
//         actions: [
//           TextButton(
//             onPressed: () {
//               Navigator.of(context).pop();
//               _showLoginDialog();
//             },
//             child: const Text('확인'),
//           ),
//         ],
//       ),
//     );
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     ref.listen<OrganLoginState>(
//       organLoginControllerProvider,
//       _handleLoginState,
//     );
//
//     return const CustomLayout(child: Stack(children: [CircleBackground()]));
//   }
// }
