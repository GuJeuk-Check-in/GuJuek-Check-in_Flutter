import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CustomTextField extends StatelessWidget {
  final double width;
  final TextEditingController controller;
  final String hintText;
  final String imagePath;
  final List<TextInputFormatter>? inputFormatters; // 추가
  final TextInputType? keyboardType;

  const CustomTextField({
    super.key,
    required this.width,
    required this.controller,
    required this.hintText,
    required this.imagePath,
    this.inputFormatters, // 추가
    this.keyboardType,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: 48.h,
      padding: EdgeInsets.symmetric(horizontal: 20.w),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8.r),
        border: Border.all(width: 1.w, color: const Color(0xff2E2E32)),
      ),
      child: Row(
        children: [
          Image.asset(imagePath, width: 25.w, height: 25.h),
          SizedBox(width: 10.w),
          Expanded(
            child: TextField(
              controller: controller,
              inputFormatters: inputFormatters, // 추가
              keyboardType: keyboardType,
              style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 14.sp,
                color: const Color(0xff404040),
              ),
              decoration: InputDecoration(
                hintText: hintText,
                hintStyle: TextStyle(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w600,
                  color: const Color(0xff6A6A6A),
                ),
                border: InputBorder.none,
                isDense: true,
                contentPadding: EdgeInsets.zero,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
