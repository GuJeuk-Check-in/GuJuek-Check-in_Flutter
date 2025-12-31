import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gujuek_check_in_flutter/core/images.dart';

class LoadingDialog extends StatelessWidget {
  const LoadingDialog({super.key});

  @override
  Widget build(BuildContext context) {
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
                style: TextStyle(
                  fontSize: 24.sp,
                  color: const Color(0xff404040),
                  fontWeight: FontWeight.w600,
                ),
              ),
              SizedBox(height: 7.h),
              Text(
                '조금만 기다려주세요.',
                style: TextStyle(
                  fontSize: 16.sp,
                  color: const Color(0xff6A6A6A),
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
