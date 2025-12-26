import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gujuek_check_in_flutter/core/images.dart';

class FacilitySafetyTrainingAppBar extends StatelessWidget
    implements PreferredSizeWidget {
  final String text;

  const FacilitySafetyTrainingAppBar({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 1.sw,
      decoration: const BoxDecoration(
        color: Colors.white,
        boxShadow: [
          //bottom shadow
          BoxShadow(
            color: Color(0xffF1FAFF),
            spreadRadius: 0,
            blurRadius: 7,
            offset: Offset(0,4)
          ),
        ]
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 40.w),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image.asset(Images.guLogo, width: 261.w, height: 100.h),
            Text(
              text,
              style: TextStyle(
                fontSize: 50.sp,
                color: const Color(0xff3AB9FF),
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(132.h);
}
