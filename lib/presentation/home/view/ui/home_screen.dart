import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gujuek_check_in_flutter/component/circle_background.dart';
import 'package:gujuek_check_in_flutter/component/custom_layout.dart';
import 'package:gujuek_check_in_flutter/core/images.dart';
import 'package:gujuek_check_in_flutter/presentation/sign_up/view/ui/sign_up_dialog.dart';

import '../../../facility_safety_training/view/ui/facility_safety_training_screen.dart';

import '../widgets/custom_elevated_button.dart';
import '../widgets/facility_registration_dialog.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomLayout(
      child: Stack(
        children: [
          const CircleBackground(),
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
                    textStyle: TextStyle(
                      color: Colors.white,
                      fontSize: 48.sp,
                      fontWeight: FontWeight.w700,
                    ),
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
                    backgroundColor: const Color(0xff3AB9FF),
                  ),
                  SizedBox(width: 108.w),
                  CustomElevatedButton(
                    text: '회원가입',
                    textStyle: TextStyle(
                      color: Colors.white,
                      fontSize: 48.sp,
                      fontWeight: FontWeight.w700,
                    ),
                    onPressed: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) => FacilitySafetyTrainingScreen(
                            nextPage: (context) => const SignUpDialog(),
                          ),
                        ),
                      );
                    },
                    backgroundColor: const Color(0xff6C39AE),
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
