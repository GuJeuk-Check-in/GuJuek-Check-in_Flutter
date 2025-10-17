import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gujuek_check_in_flutter/core/images.dart';

import '../widgets/custom_text_field.dart';

class SignUpDialog extends StatefulWidget {
  const SignUpDialog({super.key});

  @override
  State<SignUpDialog> createState() => _SignUpDialogState();
}

class _SignUpDialogState extends State<SignUpDialog> {
  late TextEditingController nameController;
  late TextEditingController birthController;
  late TextEditingController phoneNumberController;

  String? _selectedPurpose;
  String? _selectedAddress;

  int _selectedValue = 1;

  final List<String> _purposes = ['게임', '독서', '동아리', '댄스', '노래방', '미디어'];
  final List<String> _address = ['서울', '평택', '인천', '전주', '대전', '부산'];

  @override
  void initState() {
    super.initState();
    nameController = TextEditingController();
    birthController = TextEditingController();
    phoneNumberController = TextEditingController();
  }

  @override
  void dispose() {
    nameController.dispose();
    birthController.dispose();
    phoneNumberController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Container(
        width: 920.w,
        height: 544.h,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20.r),
        ),
        child: Row(
          children: [
            // 왼쪽 파란 영역
            Expanded(
              flex: 1,
              child: Container(
                decoration: BoxDecoration(
                    color: const Color(0xFF2DCBFA),
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(20.r),
                      bottomLeft: Radius.circular(20.r),
                    )),
                child: Stack(
                  children: [
                    Positioned(
                      top: 32.h,
                      left: 47.w,
                      child: const _CircleDecoration(
                        size: 32,
                        color: Color(0xffD4F2Fb),
                      ),
                    ),
                    Positioned(
                      right: 61.w,
                      top: 225.h,
                      child: const _CircleDecoration(
                        size: 24,
                        color: Color(0xffAAE5F7),
                      ),
                    ),
                    Positioned(
                      top: 244.h,
                      left: 88.h,
                      child: const _CircleDecoration(
                        size: 45,
                        color: Color(0xffD4F2FB),
                      ),
                    ),
                    Positioned(
                      bottom: 170.h,
                      right: 126.w,
                      child: const _CircleDecoration(
                        size: 45,
                        color: Color(0xffAAE5F7),
                      ),
                    ),

                    //왼쪽 벽
                    Positioned(
                      top: 96.h,
                      left: -205.w,
                      child: const _CircleDecoration(
                        size: 250,
                        color: Colors.white,
                      ),
                    ),
                    Positioned(
                      top: 103.h,
                      left: -210.w,
                      child: const _CircleDecoration(
                        size: 237,
                        color: Color(0xff2ABFEC),
                      ),
                    ),

                    //오른쪽 위
                    Positioned(
                      top: -140.h,
                      right: -140.w,
                      child: const _CircleDecoration(
                        size: 250,
                        color: Colors.white,
                      ),
                    ),
                    Positioned(
                      top: -140.h,
                      right: -140.w,
                      child: const _CircleDecoration(
                        size: 237,
                        color: Color(0xff2ABFEC),
                      ),
                    ),

                    //왼쪽 아래
                    Positioned(
                      bottom: -120.h,
                      left: -120.w,
                      child: const _CircleDecoration(
                        size: 250,
                        color: Colors.white,
                      ),
                    ),
                    Positioned(
                      bottom: -120.h,
                      left: -120.w,
                      child: const _CircleDecoration(
                        size: 237,
                        color: Color(0xff2ABFEC),
                      ),
                    ),

                    //오른쪽 구석 아래
                    Positioned(
                      bottom: 10.h,
                      right: -180.w,
                      child: const _CircleDecoration(
                        size: 250,
                        color: Colors.white,
                      ),
                    ),
                    Positioned(
                      bottom: 15.h,
                      right: -180.w,
                      child: const _CircleDecoration(
                        size: 237,
                        color: Color(0xff2ABFEC),
                      ),
                    ),

                    Center(
                      child: Column(
                        children: [
                          SizedBox(height: 120.h),
                          Text(
                            '회원가입',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 48.sp,
                              fontFamily: 'Jua',
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // 오른쪽 폼 영역
            Expanded(
              flex: 2,
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 56.w),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: buildColumn(
                            '이름',
                            CustomTextField(
                              width: 244.w,
                              controller: nameController,
                              hintText: '이름을 입력해 주세요',
                              imagePath: Images.personIcon,
                            ),
                          ),
                        ),
                        SizedBox(width: 10.w),
                        Expanded(
                          child: buildColumn(
                            '생년월일',
                            CustomTextField(
                              width: 244.w,
                              controller: birthController,
                              hintText: '생년월일을 입력해주세요.',
                              imagePath: Images.calendarIcon,
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 10.h),
                    buildColumn(
                      '전화번호',
                      CustomTextField(
                        width: 508.w,
                        controller: phoneNumberController,
                        hintText: '연락처를 입력해주세요 예시)010-1234-5678',
                        imagePath: Images.callIcon,
                      ),
                    ),
                    SizedBox(height: 10.h),
                    buildColumn(
                      '방문 목적',
                      buildDropDownButton(
                        _selectedPurpose,
                        _purposes,
                        '방문 목적을 입력해주세요',
                        Images.locationPinIcon,
                      ),
                    ),
                    SizedBox(height: 15.h),
                    Row(
                      children: [
                        Expanded(
                          child: buildColumn(
                              '성별',
                              Row(
                                children: [
                                  buildRadioButton(1, '남성'),
                                  SizedBox(width: 12.w),
                                  buildRadioButton(2, '여성'),
                                ],
                              )),
                        ),
                        SizedBox(width: 10.w),
                        Expanded(
                          child: buildColumn(
                            '거주지',
                            buildDropDownButton(_selectedAddress, _address,
                                '거주지를 선택해주세요', Images.homeIcon),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 15.h),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          '개인정보 수집 및 이용 동의',
                          style: TextStyle(
                            fontSize: 16.sp,
                            fontWeight: FontWeight.w600,
                            color: const Color(0xff2E2E32),
                          ),
                        ),
                        Checkbox(
                          value: false,
                          onChanged: (v) {},
                        ),
                      ],
                    ),
                    SizedBox(height: 10.h),
                    Container(
                      width: 140.w,
                      height: 42.h,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20.r),
                        border: Border.all(
                            width: 1.w, color: const Color(0xff2ABFEC)),
                      ),
                      child: Center(
                        child: Text(
                          '완료',
                          style: TextStyle(
                            fontSize: 20.sp,
                            fontWeight: FontWeight.w600,
                            color: const Color(0xff2ABFEC),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildColumn(String text, Widget child) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          text,
          style: TextStyle(
            color: const Color(0xff2E2E32),
            fontWeight: FontWeight.w600,
            fontSize: 14.sp,
          ),
        ),
        SizedBox(height: 8.h),
        child,
      ],
    );
  }

  Widget buildDropDownButton(
      String? value, List<String> items, String text, String imagePath) {
    return Container(
      width: 508.w,
      height: 48.h,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8.r),
        border: Border.all(width: 1.w, color: const Color(0xff404040)),
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.w),
        child: Row(
          children: [
            Image.asset(
              imagePath,
              width: 25.w,
              height: 25.h,
            ),
            SizedBox(width: 10.w),
            DropdownButtonHideUnderline(
              child: DropdownButton2<String>(
                value: value,
                hint: Text(
                  text,
                  style: TextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w600,
                    color: const Color(0xff404040),
                  ),
                ),
                items: items.map((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Center(
                      child: Text(
                        value,
                        style: TextStyle(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w500,
                          color: Colors.black,
                        ),
                      ),
                    ),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedPurpose = value;
                  });
                },

                //드롭다운 스타일
                dropdownStyleData: DropdownStyleData(
                  maxHeight: 400, // 스크롤 높이 제한
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8.r),
                    color: Colors.white,
                    border: Border.all(
                      width: 1.w,
                      color: const Color(0xff0F50A0),
                    ),
                  ),

                  //스크롤바 스타일
                  scrollbarTheme: ScrollbarThemeData(
                      crossAxisMargin: 8.w,
                      mainAxisMargin: 10.h,
                      radius: Radius.circular(100.r),
                      thumbColor:
                          const WidgetStatePropertyAll(Color(0xffB5B5B5))),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildRadioButton(int value, String gender) {
    return Container(
      width: 116.w,
      height: 48.h,
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8.r),
          border: Border.all(
            width: 1.w,
            color: const Color(0xff404040),
          )),
      child: Row(
        children: [
          Radio(
            value: value,
            groupValue: _selectedValue,
            onChanged: (value) {
              setState(() {
                _selectedValue = value!;
              });
            },
          ),
          SizedBox(width: 20.w),
          Text(
            gender,
            style: TextStyle(
              fontSize: 14.sp,
              color: const Color(0xff2E2E32),
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}

class _CircleDecoration extends StatelessWidget {
  final double size;
  final Color color;

  const _CircleDecoration({
    super.key,
    required this.size,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size.w,
      height: size.h,
      decoration: BoxDecoration(
        color: color,
        shape: BoxShape.circle,
      ),
    );
  }
}
