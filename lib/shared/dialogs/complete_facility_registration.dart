import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gujuek_check_in_flutter/core/images.dart';
import 'package:gujuek_check_in_flutter/features/home/ui/home_screen.dart';

class CompleteFacilityRegistration extends StatelessWidget {
  final String text;

  const CompleteFacilityRegistration({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Container(
        width: 440.w,
        height: 298.h,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20.r),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(Images.completeIcon, width: 45.w, height: 45.h),
            SizedBox(height: 23.h),
            Text(
              '시설 이용 신청이 완료되었습니다.',
              style: TextStyle(
                fontSize: 24.sp,
                color: const Color(0xff404040),
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(height: 4.h),
            Text(
              text,
              style: TextStyle(
                fontSize: 16.sp,
                fontWeight: FontWeight.w600,
                color: const Color(0xff6A6A6A),
              ),
            ),
            SizedBox(height: 59.h),
            TextButton(
              onPressed: () {
                Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(builder: (_) => const HomeScreen()),
                      (Route<dynamic> route) => false,
                );
              },
              child: Text(
                '처음으로',
                style: TextStyle(
                  fontSize: 20.sp,
                  fontWeight: FontWeight.w600,
                  color: const Color(0xff0F50A0),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
