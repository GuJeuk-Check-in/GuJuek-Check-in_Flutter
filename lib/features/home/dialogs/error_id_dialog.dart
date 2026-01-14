import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gujuek_check_in_flutter/core/images.dart';

class ErrorIdDialog extends StatelessWidget {
  const ErrorIdDialog({super.key});

  @override
  Widget build(BuildContext context) {
    // 아이디가 없을 때 표시하는 오류 다이얼로그
    const errorRed = Color(0xFFFF6B6B); // 이미지 느낌의 연한 레드
    const titleColor = Color(0xFF3A3A3A);
    const bodyColor = Color(0xFF7A7A7A);

    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.symmetric(horizontal: 24),
      child: Container(
        width: 360,
        padding: const EdgeInsets.fromLTRB(24, 22, 24, 18),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(22),
          boxShadow: const [
            BoxShadow(
              blurRadius: 20,
              spreadRadius: 2,
              offset: Offset(0, 10),
              color: Color(0x33000000),
            ),
          ],
          border: Border.all(color: const Color(0xFFE7E7E7), width: 1),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // 상단 아이콘 (이미지처럼 메가폰/경고 느낌)
            Image.asset(Images.noIdIcon, width: 50.w, height: 50.h),
            SizedBox(height: 10.h),

            // 제목
            Text(
              "존재하지 않는 아이디입니다.",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 24.sp,
                fontWeight: FontWeight.w700,
                color: titleColor,
              ),
            ),
            SizedBox(height: 4.h),

            // 보조 텍스트
            Text(
              "다시 확인 바랍니다.",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16.sp,
                fontWeight: FontWeight.w700,
                color: bodyColor,
              ),
            ),

            SizedBox(height: 30.h),

            // 이전으로 버튼 (텍스트만)
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              style: TextButton.styleFrom(
                foregroundColor: errorRed,
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 10,
                ),
                textStyle: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                ),
              ),
              child: const Text("이전으로"),
            ),
          ],
        ),
      ),
    );
  }
}
