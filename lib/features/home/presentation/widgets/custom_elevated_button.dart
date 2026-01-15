import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CustomElevatedButton extends StatelessWidget {
  final String text;
  final TextStyle textStyle;
  final VoidCallback onPressed;
  final Color backgroundColor;

  const CustomElevatedButton({
    super.key,
    required this.text,
    required this.textStyle,
    required this.onPressed,
    required this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    // 홈 화면의 큰 타일형 버튼
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        minimumSize: Size(345.w, 280.h),
        backgroundColor: backgroundColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(55.r),
        ),
      ),
      onPressed: onPressed,
      child: Center(
        child: Text(
          text,
          style: textStyle,
        ),
      ),
    );
  }
}
