import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gujuek_check_in_flutter/core/constants/color.dart';
import 'package:gujuek_check_in_flutter/core/constants/text_style.dart';
import 'package:gujuek_check_in_flutter/core/images.dart';

import '../../../features/home/presentation/ui/home_screen.dart';

class CompleteFacilityRegistration extends StatelessWidget {
  final String text;

  const CompleteFacilityRegistration({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    // 시설 이용 신청 완료 안내 다이얼로그
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
              style: GuJuekTextStyle.dialogBigText
            ),
            SizedBox(height: 4.h),
            Text(
              text,
              style: GuJuekTextStyle.dialogText
            ),
            SizedBox(height: 59.h),
            TextButton(
              onPressed: () {
                // 확인 후 홈으로 복귀
                Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(builder: (_) => const HomeScreen()),
                  (Route<dynamic> route) => false,
                );
              },
              child: Text(
                '처음으로',
                style: GuJuekTextStyle.labelText.copyWith(
                  color: GuJuekColor.primaryBlue,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
