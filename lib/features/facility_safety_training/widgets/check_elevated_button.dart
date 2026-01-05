import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CheckElevatedButton extends StatelessWidget {
  final VoidCallback onPressed;
  final String text;

  const CheckElevatedButton({super.key, required this.onPressed, required this.text});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        minimumSize: Size(244.w, 77.h),
        backgroundColor: const Color(0xff3AB9FF),
      ),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 30.sp,
          fontWeight: FontWeight.w600,
          color: const Color(0xffFFFFFF),
        ),
      ),
    );
  }
}
