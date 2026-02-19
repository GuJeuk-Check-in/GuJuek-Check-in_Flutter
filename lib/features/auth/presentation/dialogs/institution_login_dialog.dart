import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gujuek_check_in_flutter/core/constants/color.dart';
import 'package:gujuek_check_in_flutter/core/constants/text_style.dart';
import 'package:gujuek_check_in_flutter/core/images.dart';

class InstitutionLoginDialog extends StatefulWidget {
  final void Function(String institutionId, String password)? onConfirm;

  const InstitutionLoginDialog({super.key, this.onConfirm});

  @override
  State<InstitutionLoginDialog> createState() => _InstitutionLoginDialogState();
}

class _InstitutionLoginDialogState extends State<InstitutionLoginDialog> {
  // 입력값 유지 및 폐기 관리
  late final TextEditingController _idController;
  late final TextEditingController _passwordController;

  @override
  void initState() {
    super.initState();
    _idController = TextEditingController();
    _passwordController = TextEditingController();
  }

  @override
  void dispose() {
    _idController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _handleConfirm() {
    // 화면에서 입력한 값 전달
    widget.onConfirm?.call(_idController.text.trim(), _passwordController.text);
  }

  @override
  Widget build(BuildContext context) {
    // 작은 화면에서도 안전하게 보이도록 다이얼로그 최대 크기 제한
    final screenSize = MediaQuery.sizeOf(context);
    final horizontalMargin = 24.w;
    final verticalMargin = 24.h;
    final dialogWidth = math.min(
      460.w,
      math.max(0.0, screenSize.width - horizontalMargin * 2),
    );
    final dialogHeight = math.min(
      560.h,
      math.max(0.0, screenSize.height - verticalMargin * 2),
    );

    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: EdgeInsets.symmetric(
        horizontal: horizontalMargin,
        vertical: verticalMargin,
      ),
      child: Container(
        width: dialogWidth,
        height: dialogHeight,
        padding: EdgeInsets.symmetric(horizontal: 36.w),
        decoration: BoxDecoration(
          color: GuJuekColor.blue,
          borderRadius: BorderRadius.circular(20.r),
          boxShadow: const [
            BoxShadow(
              blurRadius: 26,
              spreadRadius: 2,
              offset: Offset(0, 12),
              color: Color(0x33000000),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // 타이틀
            Text(
              '기관 로그인',
              style: TextStyle(
                fontFamily: 'Jua',
                fontSize: 40.sp,
                color: Colors.white,
              ),
            ),
            SizedBox(height: 42.h),
            // 아이디 입력
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 50.w),
              child: _LoginField(
                controller: _idController,
                hintText: '기관 아이디를 입력해주세요',
                leading: Image.asset(
                  Images.personIcon,
                  width: 20.w,
                  height: 20.h,
                ),
              ),
            ),
            SizedBox(height: 20.h),
            // 비밀번호 입력
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 50.w),
              child: _LoginField(
                controller: _passwordController,
                hintText: '비밀번호를 입력해주세요.',
                obscureText: true,
                leading: Image.asset(
                  Images.lockIcon,
                  width: 20.w,
                  height: 20.h,
                ),
              ),
            ),
            SizedBox(height: 92.h),
            // 확인 버튼
            ElevatedButton(
              onPressed: _handleConfirm,
              style: ElevatedButton.styleFrom(
                backgroundColor: GuJuekColor.primary,
                foregroundColor: GuJuekColor.white,
                padding: EdgeInsets.symmetric(horizontal: 50.w, vertical: 15.h),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(50.r),
                  side: BorderSide(color: GuJuekColor.white, width: 2.w),
                ),
              ),
              child: Text(
                '확인',
                style: TextStyle(
                  fontSize: 24.sp,
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            SizedBox(height: 16.h),
          ],
        ),
      ),
    );
  }
}

class _LoginField extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final Widget leading;
  final bool obscureText;

  const _LoginField({
    required this.controller,
    required this.hintText,
    required this.leading,
    this.obscureText = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 44.h,
      padding: EdgeInsets.fromLTRB(20.w, 6.h, 20.w, 6.h),
      decoration: BoxDecoration(
        color: GuJuekColor.white,
        borderRadius: BorderRadius.circular(30.r),
        border: Border.all(color: GuJuekColor.blue, width: 1.w),
      ),
      child: Row(
        children: [
          // 아이콘 + 구분선 + 텍스트 입력으로 구성
          leading,
          SizedBox(width: 10.w),
          Image.asset(Images.lineIcon, width: 1.w, height: 24.h),
          SizedBox(width: 10.w),
          Expanded(
            child: TextField(
              controller: controller,
              obscureText: obscureText,
              style: GuJuekTextStyle.hintText.copyWith(
                color: GuJuekColor.gray30,
                fontWeight: FontWeight.w500,
                fontSize: 16.sp,
              ),
              decoration: InputDecoration(
                hintText: hintText,
                hintStyle: GuJuekTextStyle.hintText.copyWith(
                  color: GuJuekColor.gray30,
                  fontWeight: FontWeight.w500,
                  fontSize: 16.sp,
                ),
                border: InputBorder.none,
                isDense: true,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
