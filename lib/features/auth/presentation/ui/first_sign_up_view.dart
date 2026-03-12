import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gujuek_check_in_flutter/core/constants/color.dart';
import 'package:gujuek_check_in_flutter/core/constants/text_style.dart';
import 'package:gujuek_check_in_flutter/core/images.dart';

import '../state/sign_up_state.dart';
import '../widgets/location_custom_drop_down_button.dart';
import '../widgets/custom_text_field.dart';
import '../widgets/phone_input_formatter.dart';
import 'second_sign_up_view.dart';

class FirstSignUpView extends ConsumerStatefulWidget {
  const FirstSignUpView({super.key});

  @override
  ConsumerState<FirstSignUpView> createState() => _FirstSignUpViewState();
}

class _FirstSignUpViewState extends ConsumerState<FirstSignUpView> {
  late TextEditingController nameController;
  late TextEditingController phoneNumberController;
  String? _selectedPurpose;

  int selectedYear = 2000;
  int selectedMonth = 1;
  int selectedDay = 1;
  String displayDate = '생년월일을 입력해주세요';
  String apiDate = '';

  @override
  void initState() {
    super.initState();
    nameController = TextEditingController();
    phoneNumberController = TextEditingController();
  }

  @override
  void dispose() {
    nameController.dispose();
    phoneNumberController.dispose();
    super.dispose();
  }

  void _goToNext() {
    if (nameController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('이름을 입력해주세요')),
      );
      return;
    }
    if (apiDate.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('생년월일을 선택해주세요')),
      );
      return;
    }
    if (phoneNumberController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('연락처를 입력해주세요')),
      );
      return;
    }
    if (_selectedPurpose == null || _selectedPurpose!.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('방문 목적을 선택해주세요')),
      );
      return;
    }

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => SecondSignUpView(
          firstData: FirstSignUpFormData(
            name: nameController.text,
            phone: phoneNumberController.text,
            birthYmd: apiDate,
            purpose: _selectedPurpose,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: GuJuekColor.white,
      body: SafeArea(
        child: Stack(
          children: [
            SvgPicture.asset('assets/images/logo/back.svg', fit: BoxFit.fill),
            Positioned(
              right: 450.w,
              top: 52.h,
              child: Text('처음 방문 등록', style: GuJuekTextStyle.signUpText),
            ),
            Padding(
              padding: EdgeInsets.only(right: 100.w, left: 100.w, top: 150.h),
              child: SingleChildScrollView(
                child: Row(
                  children: [
                    Expanded(
                      flex: 2,
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: 78.w,
                          vertical: 47.h,
                        ),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Row(
                              children: [
                                Expanded(
                                  child: buildColumn(
                                    '이름',
                                    CustomTextField(
                                      width: 530.w,
                                      controller: nameController,
                                      hintText: '이름을 입력해 주세요',
                                      imagePath: Images.personIcon,
                                    ),
                                  ),
                                ),
                                SizedBox(width: 20.w),
                                Expanded(
                                  child: buildColumn(
                                    '생일',
                                    GestureDetector(
                                      onTap: () => buildDatePicker(),
                                      child: Container(
                                        width: 530.w,
                                        height: 80.h,
                                        padding: EdgeInsets.symmetric(
                                          horizontal: 20.w,
                                        ),
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(8.r),
                                          border: Border.all(
                                            width: 1.w,
                                            color: const Color(0xff2E2E32),
                                          ),
                                        ),
                                        child: Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            Image.asset(
                                              Images.calendarIcon,
                                              width: 25.w,
                                              height: 25.h,
                                            ),
                                            SizedBox(width: 10.w),
                                            Text(
                                              displayDate,
                                              style: GuJuekTextStyle.hintText
                                                  .copyWith(
                                                    color: apiDate.isEmpty
                                                        ? GuJuekColor.gray10
                                                        : GuJuekColor.gray40,
                                                  ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 20.h),
                            buildColumn(
                              '연락처를 입력해주세요',
                              CustomTextField(
                                width: 1080.w,
                                controller: phoneNumberController,
                                hintText: '연락처를 입력해주세요(010-1234-5678)',
                                imagePath: Images.callIcon,
                                inputFormatters: [PhoneInputFormatter()],
                                keyboardType: TextInputType.number,
                              ),
                            ),
                            SizedBox(height: 20.h),
                            buildColumn(
                              '방문 목적',
                              LocationCustomDropDownButton(
                                onPurposeSelected: (purpose) {
                                  _selectedPurpose = purpose!.purpose;
                                },
                                width: 1080.w,
                                height: 80.h,
                                text: '방문 목적을 입력해주세요',
                                imagePath: Images.downIcon,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(8.r),
                                  border: Border.all(
                                    width: 1.w,
                                    color: GuJuekColor.gray30,
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(height: 60.h,),
                            GestureDetector(
                              onTap: _goToNext,
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 60,
                                  vertical: 20,
                                ),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20),
                                  border: Border.all(color: GuJuekColor.skyBlue),
                                ),
                                child: Text(
                                  '다음',
                                  style: GuJuekTextStyle.dialogBigText.copyWith(
                                    color: GuJuekColor.skyBlue,
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
            ),
          ],
        ),
      ),
    );
  }

  Widget buildColumn(String text, Widget child) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(text, style: GuJuekTextStyle.labelText),
        SizedBox(height: 8.h),
        child,
      ],
    );
  }

  Future buildDatePicker() {
    return showDialog(
      context: context,
      builder: (context) => Dialog(
        child: Container(
          width: 440.w,
          height: 520.h,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20.r),
            color: Colors.white,
          ),
          child: Column(
            children: [
              SizedBox(height: 40.h),
              Text(
                '생년월일',
                style: TextStyle(
                  fontSize: 32.sp,
                  color: const Color(0xff282626),
                  fontWeight: FontWeight.w500,
                ),
              ),
              SizedBox(height: 56.h),
              SizedBox(
                height: 200.h,
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        children: [
                          Text(
                            '년',
                            style: TextStyle(
                              fontSize: 20.sp,
                              color: const Color(0xff2E2E32),
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          Expanded(
                            child: CupertinoPicker(
                              itemExtent: 50,
                              scrollController: FixedExtentScrollController(
                                initialItem: selectedYear - 1950,
                              ),
                              onSelectedItemChanged: (index) {
                                selectedYear = 1950 + index;
                              },
                              children: List.generate(
                                DateTime.now().year - 1950 + 1,
                                (index) => Center(
                                  child: Text(
                                    '${1950 + index}',
                                    style: TextStyle(fontSize: 18.sp),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: Column(
                        children: [
                          Text(
                            '월',
                            style: TextStyle(
                              fontSize: 20.sp,
                              color: const Color(0xff2E2E32),
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          Expanded(
                            child: CupertinoPicker(
                              itemExtent: 50,
                              scrollController: FixedExtentScrollController(
                                initialItem: selectedMonth - 1,
                              ),
                              onSelectedItemChanged: (index) {
                                selectedMonth = index + 1;
                              },
                              children: List.generate(
                                12,
                                (index) => Center(
                                  child: Text(
                                    '${index + 1}',
                                    style: TextStyle(fontSize: 18.sp),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: Column(
                        children: [
                          Text(
                            '일',
                            style: TextStyle(
                              fontSize: 20.sp,
                              color: const Color(0xff2E2E32),
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          Expanded(
                            child: CupertinoPicker(
                              itemExtent: 50,
                              scrollController: FixedExtentScrollController(
                                initialItem: selectedDay - 1,
                              ),
                              onSelectedItemChanged: (index) {
                                selectedDay = index + 1;
                              },
                              children: List.generate(
                                31,
                                (index) => Center(
                                  child: Text(
                                    '${index + 1}',
                                    style: TextStyle(fontSize: 18.sp),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 40.h),
              TextButton(
                onPressed: () {
                  final selectedDate = DateTime(
                    selectedYear,
                    selectedMonth,
                    selectedDay,
                  );
                  setState(() {
                    displayDate =
                        '${selectedDate.year}/${selectedDate.month}/${selectedDate.day}';
                    apiDate =
                        '${selectedDate.year}-${selectedDate.month.toString().padLeft(2, '0')}-${selectedDate.day.toString().padLeft(2, '0')}';
                  });
                  Navigator.pop(context);
                },
                child: Text(
                  '확인',
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
      ),
    );
  }
}
