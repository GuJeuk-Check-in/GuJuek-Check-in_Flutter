import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gujuek_check_in_flutter/core/constants/color.dart';
import 'package:gujuek_check_in_flutter/core/constants/text_style.dart';

class CheckElevatedButton extends StatelessWidget {
  final VoidCallback onPressed;
  final String text;

  const CheckElevatedButton({
    super.key,
    required this.onPressed,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    // 안전교육 확인 버튼
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        minimumSize: Size(276.w, 77.h),
        backgroundColor: GuJuekColor.blueButton,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.r)),
      ),
      child: Text(text, style: GuJuekTextStyle.check),
    );
  }
}
