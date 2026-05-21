import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gujuek_check_in_flutter/core/constants/color.dart';
import 'package:gujuek_check_in_flutter/core/constants/text_style.dart';
import 'package:gujuek_check_in_flutter/core/images.dart';
import 'package:gujuek_check_in_flutter/core/widgets/dialogs/complete_facility_registration.dart';

class CheckIdDialog extends StatelessWidget {
  final String generatedId;

  const CheckIdDialog({super.key, required this.generatedId});

  @override
  Widget build(BuildContext context) {
    // 회원가입 후 생성된 아이디 안내 다이얼로그
    const primaryBlue = Color(0xFF1E5DBB); // 이미지와 비슷한 블루 톤

    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: EdgeInsets.symmetric(horizontal: 50.w),
      child: Container(
        padding: EdgeInsets.fromLTRB(80.w, 32.h, 80.w, 76.h),
        decoration: BoxDecoration(
          color: GuJuekColor.white,
          borderRadius: BorderRadius.circular(22.r),
          border: Border.all(color: const Color(0xFFE7E7E7), width: 1.w),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.asset(Images.circlePersonIcon, width: 50.w, height: 50.h),
            SizedBox(height: 10.h),
            Text(
              "아이디가 자동 생성되었습니다",
              textAlign: TextAlign.center,
              style: GuJuekTextStyle.bigIdText,
            ),
            SizedBox(height: 8.h),
            Text(
              "아이디 : 이름 + 생일",
              textAlign: TextAlign.center,
              style: GuJuekTextStyle.smallIdText,
            ),
            SizedBox(height: 12.h),
            Text(
              "시설 이용 신청 시 생성된 아이디를 입력해주세요",
              textAlign: TextAlign.center,
              style: GuJuekTextStyle.smallIdText,
            ),
            SizedBox(height: 10.h),

            // 생성된 아이디 (파란색 라벨 + 일반 텍스트)
            RichText(
              textAlign: TextAlign.center,
              text: TextSpan(
                children: [
                  TextSpan(
                    text: "생성된 아이디: ",
                    style: GuJuekTextStyle.labelText.copyWith(color: primaryBlue)
                  ),
                  TextSpan(
                    text: generatedId,
                    style: GuJuekTextStyle.labelText
                  ),
                ],
              ),
            ),

            SizedBox(height: 18.h),

            // 다음 버튼 (텍스트만)
            TextButton(
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (_) =>
                  const CompleteFacilityRegistration(text: '이용해주셔서 감사합니다.'),
                );
              },
              style: TextButton.styleFrom(
                  foregroundColor: primaryBlue,
                  padding: EdgeInsets.symmetric(
                      horizontal: 16.w, vertical: 10.h),
                  textStyle: GuJuekTextStyle.labelText
              ),
              child: const Text("확인"),
            ),
          ],
        ),
      ),
    );
  }
}
