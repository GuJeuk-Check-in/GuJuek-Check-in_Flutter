import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gujuek_check_in_flutter/core/constants/color.dart';
import 'package:gujuek_check_in_flutter/core/constants/text_style.dart';
import 'package:gujuek_check_in_flutter/core/images.dart';

class LoadingDialog extends StatelessWidget {
  const LoadingDialog({super.key});

  @override
  Widget build(BuildContext context) {
    // 요청 처리 중 표시하는 로딩 다이얼로그
    return Dialog(
      child: Container(
        width: 440.w,
        height: 298.h,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20.r),
          color: Colors.white,
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(Images.timerIcon, width: 45.w, height: 45.h),
              SizedBox(height: 26.h),
              Text(
                '처리 중...',
                style: GuJuekTextStyle.dialogBigText
              ),
              SizedBox(height: 7.h),
              Text(
                '조금만 기다려주세요.',
                style: GuJuekTextStyle.dialogText
              ),
            ],
          ),
        ),
      ),
    );
  }
}
