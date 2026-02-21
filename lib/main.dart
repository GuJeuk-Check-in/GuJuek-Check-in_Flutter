import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:gujuek_check_in_flutter/core/storage/secure_storage_service.dart';

import 'features/auth/presentation/ui/institution_login_gate_screen.dart';
import 'features/home/presentation/ui/home_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // .env에서 API 주소 같은 환경변수 로드
  await dotenv.load(fileName: ".env");

  // Riverpod 전역 Provider 범위를 앱 최상단에 등록
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final loginState = ref.watch(loginStateProvider);
    return ScreenUtilInit(
      // 디자인 기준 해상도
      designSize: const Size(1280, 800),
      child: MaterialApp(
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            fontFamily: 'Pretendard',
            splashFactory: NoSplash.splashFactory,
            splashColor: Colors.transparent,
            highlightColor: Colors.transparent,
          ),
          builder: (context, child) {
            return GestureDetector(
              behavior: HitTestBehavior.translucent,
              // 화면 탭 시 키보드 포커스 해제
              onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
              child: child ?? const SizedBox.shrink(),
            );
          },
          home: loginState.when(data: (isLogin) =>
          isLogin ? const HomeScreen()
              : const InstitutionLoginGateScreen(),
              error: (err, stack) => const InstitutionLoginGateScreen(),
      loading: () =>
      const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      ),)),
    );
  }
}
