import 'dart:math' as math;

import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gujuek_check_in_flutter/core/images.dart';
import 'package:gujuek_check_in_flutter/features/sign_up/dialogs/check_id_dialog.dart';
import 'package:gujuek_check_in_flutter/features/sign_up/data/sign_up_options.dart';
import 'package:gujuek_check_in_flutter/features/sign_up/state/sign_up_controller.dart';
import 'package:gujuek_check_in_flutter/features/sign_up/state/sign_up_state.dart';
import 'package:gujuek_check_in_flutter/shared/dialogs/loading_dialog.dart';
import 'package:gujuek_check_in_flutter/features/sign_up/widgets/custom_drop_down_button.dart';
import 'package:gujuek_check_in_flutter/features/sign_up/widgets/phone_input_formatter.dart';
import 'package:gujuek_check_in_flutter/features/sign_up/widgets/people_counter_widget.dart';

import '../widgets/custom_text_field.dart';

class SignUpDialog extends ConsumerStatefulWidget {
  const SignUpDialog({super.key});

  @override
  ConsumerState<SignUpDialog> createState() => _SignUpDialogState();
}

class _SignUpDialogState extends ConsumerState<SignUpDialog> {
  late TextEditingController nameController;
  late TextEditingController phoneNumberController;

  String? _selectedPurpose;
  String? _selectedAddress;
  bool _isPrivacyAgreed = false;
  int _selectedValue = 1;

  // 생년월일 관련 변수 추가
  int selectedYear = 2000;
  int selectedMonth = 1;
  int selectedDay = 1;
  String displayDate = '생년월일을 입력해주세요';
  String apiDate = '';
  String idDate = '';
  bool _isLoadingDialogVisible = false;
  int maleCount = 0;
  int femaleCount = 0;

  static const String _customInputValue = '__custom_input__';

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

  // 입력 폼을 SignUpFormData로 변환해 제출
  void _submitSignUp() {
    ref.read(signUpControllerProvider.notifier).submit(
          SignUpFormData(
            name: nameController.text,
            phone: phoneNumberController.text,
            genderValue: _selectedValue,
            birthYmd: apiDate,
            privacyAgreed: _isPrivacyAgreed,
            purpose: _selectedPurpose,
            residence: _selectedAddress,
            maleCount: maleCount,
            femaleCount: femaleCount,
          ),
        );
  }

  void _showLoadingDialog() {
    _isLoadingDialogVisible = true;
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => const LoadingDialog(),
    );
  }

  void _hideLoadingDialog() {
    if (!_isLoadingDialogVisible) return;
    _isLoadingDialogVisible = false;
    if (!mounted) return;
    Navigator.of(context, rootNavigator: true).pop();
  }

  // 상태 변화에 따라 로딩/완료/오류 처리
  void _handleSignUpState(SignUpState? previous, SignUpState next) {
    if (!mounted) return;

    final wasSubmitting = previous?.isSubmitting ?? false;
    if (!wasSubmitting && next.isSubmitting) {
      _showLoadingDialog();
    } else if (wasSubmitting && !next.isSubmitting) {
      _hideLoadingDialog();
    }

    final generatedId = next.generatedId;
    if (generatedId != null && generatedId.isNotEmpty) {
      showDialog(
        context: context,
        builder: (_) => CheckIdDialog(generatedId: generatedId),
      );
      ref.read(signUpControllerProvider.notifier).clearNotifications();
      return;
    }

    final message = next.message;
    if (message == null || message.isEmpty) return;

    if (next.errorType == SignUpErrorType.duplicateUser) {
      _showDuplicateUserDialog(message);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(message)),
      );
    }

    ref.read(signUpControllerProvider.notifier).clearNotifications();
  }

  void _showDuplicateUserDialog(String message) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text(
          '회원가입 실패',
          style: TextStyle(fontWeight: FontWeight.w700),
        ),
        content: Text(
          message,
          style: TextStyle(fontSize: 16.sp, height: 1.5.h),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: Text(
              '확인',
              style: TextStyle(
                fontSize: 16.sp,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    ref.listen<SignUpState>(signUpControllerProvider, _handleSignUpState);

    // 키보드 등장에 맞춰 다이얼로그 크기 계산
    final viewInsets = MediaQuery.of(context).viewInsets;
    final screenSize = MediaQuery.sizeOf(context);
    final horizontalMargin = 24.w;
    final verticalMargin = 24.h;
    final dialogWidth = math.min(
      920.w,
      math.max(0.0, screenSize.width - horizontalMargin * 2),
    );
    final availableHeight =
        screenSize.height - viewInsets.bottom - verticalMargin * 2;
    final dialogHeight = math.min(544.h, math.max(0.0, availableHeight));

    return AnimatedPadding(
      padding: EdgeInsets.only(bottom: viewInsets.bottom),
      duration: const Duration(milliseconds: 200),
      curve: Curves.easeOut,
      child: MediaQuery(
        data: MediaQuery.of(context).copyWith(viewInsets: EdgeInsets.zero),
        child: Dialog(
          insetPadding: EdgeInsets.symmetric(
            horizontal: horizontalMargin,
            vertical: verticalMargin,
          ),
          child: Container(
            width: dialogWidth,
            height: dialogHeight,
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(20.r), color: Colors.white),
            child: Row(
              children: [
                // 왼쪽 파란 배경 영역
                Expanded(
                  flex: 1,
                  child: Container(
                    decoration: BoxDecoration(
                      color: const Color(0xFF2DCBFA),
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(20.r),
                        bottomLeft: Radius.circular(20.r),
                      ),
                    ),
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
                              SizedBox(height: 100.h),
                              Text(
                                '처음 방문 등록',
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
                    padding: EdgeInsets.symmetric(horizontal: 56.w, vertical: 6.h),
                    child: SingleChildScrollView(
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
                                  GestureDetector(
                                    onTap: () => buildDatePicker(),
                                    child: Container(
                                      width: 244.w,
                                      height: 48.h,
                                      padding: EdgeInsets.symmetric(
                                        horizontal: 20.w,
                                      ),
                                      decoration: BoxDecoration(
                                        borderRadius:
                                            BorderRadius.circular(8.r),
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
                                            style: TextStyle(
                                              fontSize: 14.sp,
                                              color: apiDate.isEmpty
                                                  ? const Color(0xff6A6A6A)
                                                  : const Color(0xff2E2E32),
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
                          SizedBox(height: 8.h),
                          buildColumn(
                            '대표자 연락처',
                            CustomTextField(
                              width: 508.w,
                              controller: phoneNumberController,
                              hintText: '연락처를 입력해주세요(010-1234-5678)',
                              imagePath: Images.callIcon,
                              inputFormatters: [PhoneInputFormatter()],
                              keyboardType: TextInputType.number,
                            ),
                          ),
                          SizedBox(height: 8.h),
                          buildColumn(
                            '방문 목적',
                            LocationCustomDropDownButton(
                              onPurposeSelected: (purpose) {
                                _selectedPurpose = purpose!.purpose;
                              },
                              width: 508,
                              height: 48,
                              text: '방문 목적을 입력해주세요',
                              imagePath: Images.downIcon,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8.r),
                                border: Border.all(
                                  width: 1.w,
                                  color: const Color(0xff404040),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(height: 10.h),
                          Row(
                            children: [
                              Expanded(
                                child: buildColumn(
                                '성별',
                                Row(
                                  children: [
                                    Expanded(child: buildRadioButton(1, '남성')),
                                    SizedBox(width: 12.w),
                                    Expanded(child: buildRadioButton(2, '여성')),
                                  ],
                                ),
                              ),
                            ),
                              SizedBox(width: 10.w),
                              Expanded(
                                child: buildColumn(
                                  '거주지',
                                  buildDropDownButton(
                                    _selectedAddress,
                                    signUpAddressOptions,
                                    '거주지를 선택해주세요',
                                    Images.homeIcon,
                                    (val) => setState(
                                      () => _selectedAddress = val,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 10.h),
                          buildCountingBlock(),
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
                                value: _isPrivacyAgreed,
                                onChanged: (v) {
                                  setState(
                                    () => _isPrivacyAgreed = v ?? false,
                                  );
                                },
                                activeColor: const Color(0xff2ABFEC),
                                checkColor: Colors.white,
                              ),
                            ],
                          ),
                          Text(
                            '(이름,생년월일,연락처,방문 목적,성별,cctv 촬영,거주지)',
                            style: TextStyle(
                              fontSize: 12.sp,
                              fontWeight: FontWeight.w600,
                              color: const Color(0xff6A6A6A),
                            ),
                          ),
                          SizedBox(height: 8.h),
                          GestureDetector(
                            onTap: _submitSignUp,
                            child: Container(
                              width: 140.w,
                              height: 42.h,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20.r),
                                border: Border.all(
                                  width: 1.w,
                                  color: const Color(0xff2ABFEC),
                                ),
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
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget buildColumn(String text, Widget child) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          text,
          style: TextStyle(
            fontSize: 14.sp,
            fontWeight: FontWeight.w600,
            color: const Color(0xff2E2E32),
          ),
        ),
        SizedBox(height: 8.h),
        child,
      ],
    );
  }

  Widget buildDropDownButton(
    String? value,
    List<String> items,
    String text,
    String imagePath,
    ValueChanged<String?> onChanged,
  ) {
    // 현재 선택된 값이 items에 없으면 추가
    List<String> displayItems = List.from(items);
    if (value != null && !displayItems.contains(value)) {
      displayItems.add(value);
    }

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
            Image.asset(imagePath, width: 25.w, height: 25.h),
            SizedBox(width: 10.w),
            Expanded(
              child: DropdownButtonHideUnderline(
                child: DropdownButton2<String>(
                  isExpanded: true,
                  value: value,
                  hint: Text(
                    text,
                    style: TextStyle(
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w600,
                      color: const Color(0xff6A6A6A),
                    ),
                  ),
                  items: [
                    // 기존 항목들 + 직접 입력된 값
                    ...displayItems.map(
                      (e) => DropdownMenuItem<String>(
                        value: e,
                        child: Text(
                          e,
                          style: TextStyle(
                            fontSize: 14.sp,
                            color: Colors.black,
                          ),
                        ),
                      ),
                    ),
                    // 직접 입력 항목
                    DropdownMenuItem<String>(
                      value: _customInputValue,
                      child: Text(
                        '기타 입력',
                        style: TextStyle(
                          fontSize: 14.sp,
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ],
                  onChanged: (selected) async {
                    if (selected == null) return;
                    if (selected == _customInputValue) {
                      await _showCustomAddressDialog(onChanged);
                      return;
                    }
                    onChanged(selected);
                  },
                  dropdownStyleData: DropdownStyleData(
                    maxHeight: 300.h,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8.r),
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _showCustomAddressDialog(
    ValueChanged<String?> onChanged,
  ) async {
    // 기타 입력 선택 시 별도 입력창 표시
    final controller = TextEditingController();

    final result = await showDialog<String>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text(
            '기타 입력',
            style: TextStyle(fontWeight: FontWeight.w700),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                '거주 지역을 적어주세요.',
                style: TextStyle(color: Colors.black),
              ),
              SizedBox(height: 12.h),
              TextField(
                controller: controller,
                autofocus: true,
                style: const TextStyle(color: Colors.black),
                decoration: const InputDecoration(
                  hintText: '예: 대전',
                  hintStyle: TextStyle(color: Colors.black),
                  border: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.black),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.black),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.black),
                  ),
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(),
              child: const Text('취소'),
            ),
            TextButton(
              onPressed: () {
                final value = controller.text.trim();
                if (value.isEmpty) return;
                Navigator.of(dialogContext).pop(value);
              },
              child: const Text('확인'),
            ),
          ],
        );
      },
    );

    if (result == null || result.isEmpty) return;
    onChanged(result);
  }

  Widget buildRadioButton(int value, String label) {
    return Container(
      height: 48.h,
      padding: EdgeInsets.symmetric(horizontal: 8.w),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8.r),
        border: Border.all(width: 1.w, color: const Color(0xff404040)),
      ),
      child: Row(
        children: [
          Radio(
            value: value,
            activeColor: const Color(0xff2ABFEC),
            groupValue: _selectedValue,
            materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
            visualDensity: VisualDensity.compact,
            onChanged: (v) => setState(() => _selectedValue = v!),
          ),
          SizedBox(width: 8.w),
          Text(
            label,
            style: TextStyle(fontSize: 14.sp),
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  Future buildDatePicker() {
    // 생년월일을 3열 피커로 선택
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
                    // 년도 피커
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
                    // 월 피커
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
                    // 일 피커
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
                  // 선택 날짜를 화면 표시/서버 전송 형식으로 저장
                  // 날짜 저장
                  DateTime selectedDate = DateTime(
                    selectedYear,
                    selectedMonth,
                    selectedDay,
                  );

                  setState(() {
                    displayDate =
                        '${selectedDate.year}/${selectedDate.month}/${selectedDate.day}';

                    apiDate =
                        '${selectedDate.year}-${selectedDate.month.toString().padLeft(2, '0')}-${selectedDate.day.toString().padLeft(2, '0')}';
                    idDate =
                        '${selectedDate.month.toString().padLeft(2, '0')}${selectedDate.day.toString().padLeft(2, '0')}';
                  });

                  debugPrint('화면 표시: $displayDate');
                  debugPrint('API 전송: $apiDate');

                  Navigator.pop(context); // 다이얼로그 닫기
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

  Widget buildCountingBlock() {
    // 남/여 동행인 수 입력 블록 (보류: 현재 사용 안함)
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Expanded(
          child: buildCountingItem(
            isMale: true,
            initialValue: maleCount,
            onChanged: (value) {
              setState(() {
                maleCount = value;
              });
            },
          ),
        ),
        SizedBox(width: 20.w),
        Expanded(
          child: buildCountingItem(
            isMale: false,
            initialValue: femaleCount,
            onChanged: (value) {
              setState(() {
                femaleCount = value;
              });
            },
          ),
        ),
      ],
    );
  }
}

Widget buildCountingItem({
  bool isMale = true,
  int initialValue = 0,
  ValueChanged<int>? onChanged,
}) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        isMale ? '남성 동행인 수' : '여성 동행인 수',
        style: TextStyle(
          fontSize: 14.sp,
          fontWeight: FontWeight.w500,
          color: const Color(0xff2E2E32),
        ),
      ),
      SizedBox(height: 5.h),
      PeopleCounterWidget(
        initialValue: initialValue,
        onChanged: onChanged,
      ),
    ],
  );
}

class _CircleDecoration extends StatelessWidget {
  final double size;
  final Color color;

  const _CircleDecoration({super.key, required this.size, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size.w,
      height: size.h,
      decoration: BoxDecoration(color: color, shape: BoxShape.circle),
    );
  }
}
