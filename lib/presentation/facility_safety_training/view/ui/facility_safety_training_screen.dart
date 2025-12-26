import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gujuek_check_in_flutter/component/custom_layout.dart';
import 'package:gujuek_check_in_flutter/core/images.dart';
import 'package:gujuek_check_in_flutter/presentation/facility_safety_training/view/widgets/check_elevated_button.dart';
import 'package:gujuek_check_in_flutter/presentation/facility_safety_training/view/widgets/facility_safety_text.dart';
import 'package:gujuek_check_in_flutter/presentation/facility_safety_training/view/widgets/facility_safety_training_app_bar.dart';

class FacilitySafetyTrainingScreen extends StatefulWidget {
  final WidgetBuilder nextPage;

  const FacilitySafetyTrainingScreen({super.key, required this.nextPage});

  @override
  State<FacilitySafetyTrainingScreen> createState() =>
      _FacilitySafetyTrainingScreenState();
}

class _FacilitySafetyTrainingScreenState
    extends State<FacilitySafetyTrainingScreen> {
  final List<Map<String, dynamic>> safetyRules = [
    {'image': Images.fire, 'text': FacilitySafetyText.text1},
    {'image': Images.accident, 'text': FacilitySafetyText.text2},
    {'image': Images.sick, 'text': FacilitySafetyText.text3},
    {'image': Images.stair, 'text': FacilitySafetyText.text4},
    {'image': Images.kind, 'text': FacilitySafetyText.text5},
    {'image': Images.trash, 'text': FacilitySafetyText.text6},
    {'image': Images.clean, 'text': FacilitySafetyText.text7},
    {'image': Images.listen, 'text': FacilitySafetyText.text8},
    {'image': Images.talk, 'text': FacilitySafetyText.text9},
    {'image': Images.no, 'text': FacilitySafetyText.text10},
    {'image': Images.bad, 'text': FacilitySafetyText.text11},
    {'image': Images.role, 'text': FacilitySafetyText.text12},
    {'image': Images.respect, 'text': FacilitySafetyText.text13},
  ];

  int _currentIndex = 0;

  void increaseIndex() {
    setState(() {
      _currentIndex++;
    });
  }

  void decreaseIndex() {
    setState(() {
      _currentIndex--;
    });
  }

  @override
  Widget build(BuildContext context) {
    return CustomLayout(
      appBar: FacilitySafetyTrainingAppBar(
        text: _currentIndex < 8 ? '시설 이용 안전교육' : '성희롱 예방 교육',
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 122.w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // 상단 이미지 + 좌우 버튼
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                buildIconButton(
                  _currentIndex == 0
                      ? Images.leftButton
                      : Images.coloredLeftButton,
                      () {
                    if (_currentIndex > 0) decreaseIndex();
                  },
                ),
                Image.asset(
                  safetyRules[_currentIndex]['image'],
                  width: 809.w,
                  height: 455.h,
                  fit: BoxFit.cover,
                ),
                SizedBox(width: 50.w), // 오른쪽 간격 확보
              ],
            ),

            SizedBox(height: 25.h),

            // 텍스트 + 버튼 (하단 정렬)
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                // 왼쪽 여백 확보용
                SizedBox(width: 80.w),

                // 텍스트 (가운데 정렬 + 줄바꿈)
                Expanded(
                  child: Text.rich(
                    safetyRules[_currentIndex]['text'],
                    textAlign: TextAlign.center,
                    softWrap: true,
                  ),
                ),

                // 버튼 (텍스트 오른쪽 아래)
                Padding(
                  padding: EdgeInsets.only(left: 40.w),
                  child: CheckElevatedButton(
                    onPressed: () {
                      if (_currentIndex == 12) {
                        Navigator.pop(context);
                        showDialog(
                          context: context,
                          builder: widget.nextPage,
                          barrierDismissible: false,
                        );
                      } else {
                        increaseIndex();
                      }
                    },
                    text: _currentIndex == 12 ? '모두 확인했어요.' : '확인했어요.',
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }


  Widget buildIconButton(String imagePath, VoidCallback onPressed) {
    return IconButton(
      onPressed: onPressed,
      icon: Image.asset(imagePath, width: 50.w, height: 150.h),
    );
  }
}
