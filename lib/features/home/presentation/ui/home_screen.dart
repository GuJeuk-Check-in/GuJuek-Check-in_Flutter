import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gujuek_check_in_flutter/core/constants/color.dart';
import 'package:gujuek_check_in_flutter/core/constants/text_style.dart';
import 'package:gujuek_check_in_flutter/core/widgets/circle_background.dart';
import 'package:gujuek_check_in_flutter/core/widgets/custom_layout.dart';
import 'package:gujuek_check_in_flutter/core/images.dart';
import 'package:gujuek_check_in_flutter/features/auth/presentation/ui/sign_up_view.dart';
import 'package:gujuek_check_in_flutter/features/facility_safety_training/ui/facility_safety_training_screen.dart';

import '../../../auth/presentation/dialogs/facility_registration_dialog.dart';
import '../widgets/custom_elevated_button.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // 메인 진입 화면(이용 신청/처음 방문 등록)
    return CustomLayout(
      child: Stack(
        children: [
          const Positioned.fill(child: CircleBackground()),
          Column(
            children: [
              SizedBox(height: 80.h),
              Center(
                child: Image.asset(Images.guLogo, width: 758.w, height: 290.h),
              ),
              SizedBox(height: 50.h),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CustomElevatedButton(
                    text: '시설 이용 신청',
                    textStyle: GuJuekTextStyle.title,
                    onPressed: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) => FacilitySafetyTrainingScreen(
                            nextPage: (context) =>
                                const FacilityRegistrationDialog(),
                          ),
                        ),
                      );
                    },
                    backgroundColor: GuJuekColor.blueButton,
                  ),
                  SizedBox(width: 108.w),
                  CustomElevatedButton(
                    text: '처음 방문 등록',
                    textStyle: GuJuekTextStyle.title,
                    onPressed: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) => FacilitySafetyTrainingScreen(
                            nextPage: (context) => const SignUpView(),
                          ),
                        ),
                      );
                    },
                    backgroundColor: GuJuekColor.purpleButton,
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
