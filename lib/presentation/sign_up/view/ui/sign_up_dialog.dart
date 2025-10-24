import 'package:dio/dio.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gujuek_check_in_flutter/core/images.dart';
import 'package:gujuek_check_in_flutter/presentation/home/view/widgets/complete_facility_registration.dart';
import 'package:gujuek_check_in_flutter/presentation/sign_up/view/widgets/custom_drop_down_button.dart';
import 'package:gujuek_check_in_flutter/presentation/sign_up/view/widgets/phone_input_formatter.dart';

import '../../../../data/models/sign_up/user_model.dart';
import '../widgets/custom_text_field.dart';

class SignUpDialog extends StatefulWidget {
  const SignUpDialog({super.key});

  @override
  State<SignUpDialog> createState() => _SignUpDialogState();
}

class _SignUpDialogState extends State<SignUpDialog> {
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

  final List<String> _address = [
    '관평동',
    '구즉동',
    '노은1동',
    '노은2동',
    '노은3동',
    '상대동',
    '신성동',
    '온천1동',
    '온천2동',
    '원신흥동',
    '전민동',
    '진잠동',
    '학하동',
  ];

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

  /// 회원가입 API 호출 함수
  Future<void> registerUser() async {
    try {
      debugPrint('=== 회원가입 시작 ===');
      debugPrint('이름: ${nameController.text}');
      debugPrint('성별: $_selectedValue');
      debugPrint('전화번호: ${phoneNumberController.text}');
      debugPrint('생년월일(API): $apiDate');
      debugPrint('개인정보 동의: $_isPrivacyAgreed');
      debugPrint('방문 목적: $_selectedPurpose');
      debugPrint('거주지: $_selectedAddress');

      // 필수 값 체크
      if (nameController.text.isEmpty) {
        debugPrint('이름이 비어있음');
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('이름을 입력해주세요')));
        return;
      }

      if (phoneNumberController.text.isEmpty) {
        debugPrint('전화번호가 비어있음');
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('전화번호를 입력해주세요')));
        return;
      }

      if (apiDate.isEmpty) {
        debugPrint('생년월일이 선택되지 않음');
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('생년월일을 선택해주세요')));
        return;
      }

      if (!_isPrivacyAgreed) {
        debugPrint('개인정보 동의가 필요함');
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('개인정보 수집 및 이용에 동의해주세요')));
        return;
      }

      if (_selectedPurpose == null) {
        debugPrint('방문 목적이 선택되지 않음');
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('방문 목적을 선택해주세요')));
        return;
      }

      if (_selectedAddress == null) {
        debugPrint('거주지가 선택되지 않음');
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('거주지를 선택해주세요')));
        return;
      }

      final user = UserModel(
        name: nameController.text,
        gender: _selectedValue == 1 ? Gender.MAN : Gender.WOMAN,
        phone: phoneNumberController.text,
        birthYMD: apiDate,
        privacyAgreed: _isPrivacyAgreed,
        purpose: _selectedPurpose!,
        residence: _selectedAddress!,
      );

      final data = user.toJson();
      debugPrint('전송할 JSON 데이터: $data');

      final baseUrl = dotenv.env['BASE_URL'];
      debugPrint('BASE_URL: $baseUrl');

      if (baseUrl == null || baseUrl.isEmpty) {
        debugPrint('BASE_URL이 설정되지 않음');
        return;
      }

      final dio = Dio(
        BaseOptions(
          baseUrl: baseUrl,
          headers: {'Content-Type': 'application/json'},
          validateStatus: (status) {
            return status != null && status < 600;
          },
        ),
      );

      debugPrint('POST 요청: $baseUrl/user/sign-up');

      final response = await dio.post('/user/sign-up', data: data);

      debugPrint('응답 상태코드: ${response.statusCode}');
      debugPrint('응답 데이터: ${response.data}');

      if (response.statusCode == 200 || response.statusCode == 201) {
        debugPrint('SUCCESS SIGN UP!!');
        if (mounted) {
          showDialog(
            context: context,
            builder: (_) => const CompleteFacilityRegistration(),
          );
        }
      } else if (response.statusCode == 401) {
        debugPrint('유저 중복 에러 401 - 응답 내용: ${response.data}');
        if (mounted) {
          final message = response.data['message'] ?? '이미 존재하는 회원입니다.';
          Future.microtask(() {
            if (!mounted) return;
            showDialog(
              context: context,
              builder: (_) => AlertDialog(
                title: const Text(
                  '회원가입 실패',
                  style: TextStyle(
                    fontWeight: FontWeight.w700,
                  ),
                ),
                content: Text(
                  message,
                  style: TextStyle(
                    fontSize: 16.sp,
                    height: 1.5.h,
                  ),
                ),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text(
                      '확인',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            );
          });
        }
      } else if (response.statusCode == 500) {
        debugPrint('서버 에러 500 - 응답 내용: ${response.data}');
        if (mounted) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text('서버 오류: ${response.data}')));
        }
      } else {
        debugPrint('회원가입 실패: ${response.statusCode}');
        debugPrint('응답 내용: ${response.data}');
        if (mounted) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text('회원가입 실패: ${response.data}')));
        }
      }
    } catch (e) {
      debugPrint('회원가입 에러: $e');
      if (e is DioException) {
        debugPrint('DioException 상세:');
        debugPrint('- 타입: ${e.type}');
        debugPrint('- 메시지: ${e.message}');
        debugPrint('- 응답 상태코드: ${e.response?.statusCode}');
        debugPrint('- 응답 데이터: ${e.response?.data}');

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('오류: ${e.response?.data ?? e.message}')),
          );
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return MediaQuery(
      data: MediaQuery.of(context).copyWith(viewInsets: EdgeInsets.zero),
      child: Dialog(
        child: Container(
          width: 920.w,
          height: 544.h,
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(20.r)),
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
                      // Positioned(
                      //   bottom: -120.h,
                      //   left: -120.w,
                      //   child: const _CircleDecoration(
                      //     size: 20,
                      //     color: Colors.white,
                      //   ),
                      // ),
                      // Positioned(
                      //   bottom: -120.h,
                      //   left: -120.w,
                      //   child: const _CircleDecoration(
                      //     size: 237,
                      //     color: Color(0xff2ABFEC),
                      //   ),
                      // ),
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
                              GestureDetector(
                                onTap: () => buildDatePicker(),
                                child: Container(
                                  width: 244.w,
                                  height: 48.h,
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
                      SizedBox(height: 10.h),
                      buildColumn(
                        '전화번호',
                        CustomTextField(
                          width: 508.w,
                          controller: phoneNumberController,
                          hintText: '연락처를 입력해주세요(010-1234-5678)',
                          imagePath: Images.callIcon,
                          inputFormatters: [PhoneInputFormatter()],
                        ),
                      ),
                      SizedBox(height: 10.h),
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
                              ),
                            ),
                          ),
                          SizedBox(width: 10.w),
                          Expanded(
                            child: buildColumn(
                              '거주지',
                              buildDropDownButton(
                                _selectedAddress,
                                _address,
                                '거주지를 선택해주세요',
                                Images.homeIcon,
                                (val) => setState(() => _selectedAddress = val),
                              ),
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
                            value: _isPrivacyAgreed,
                            onChanged: (v) {
                              setState(() => _isPrivacyAgreed = v ?? false);
                            },
                            activeColor: const Color(0xff2ABFEC),
                            checkColor: Colors.white,
                          ),
                        ],
                      ),
                      Text(
                        '(이름,연락처,나이,성별,cctv촬영)',
                        style: TextStyle(
                          fontSize: 12.sp,
                          fontWeight: FontWeight.w600,
                          color: const Color(0xff6A6A6A),
                        ),
                      ),
                      SizedBox(height: 10.h),
                      GestureDetector(
                        onTap: registerUser,
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
            ],
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
    final TextEditingController etcController = TextEditingController();

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
                      value: '__custom_input__',
                      enabled: false, // 선택 불가
                      child: Container(
                        padding: EdgeInsets.symmetric(vertical: 8.h),
                        child: Row(
                          children: [
                            Text(
                              '기타: ',
                              style: TextStyle(
                                fontSize: 14.sp,
                                color: const Color(0xff6A6A6A),
                              ),
                            ),
                            Expanded(
                              child: TextField(
                                controller: etcController,
                                decoration: InputDecoration(
                                  isDense: true,
                                  contentPadding: EdgeInsets.symmetric(
                                    horizontal: 8.w,
                                    vertical: 4.h,
                                  ),
                                  hintText: '직접 입력',
                                  hintStyle: TextStyle(
                                    fontSize: 14.sp,
                                    color: const Color(0xffAAAAAA),
                                  ),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(4.r),
                                    borderSide: BorderSide(
                                      color: const Color(0xffCCCCCC),
                                      width: 1.w,
                                    ),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(4.r),
                                    borderSide: BorderSide(
                                      color: const Color(0xffCCCCCC),
                                      width: 1.w,
                                    ),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(4.r),
                                    borderSide: BorderSide(
                                      color: const Color(0xff2ABFEC),
                                      width: 1.w,
                                    ),
                                  ),
                                ),
                                style: TextStyle(fontSize: 14.sp),
                              ),
                            ),
                            SizedBox(width: 8.w),
                            InkWell(
                              onTap: () {
                                final inputValue = etcController.text.trim();
                                if (inputValue.isNotEmpty) {
                                  // 드롭다운 닫기
                                  Navigator.of(context).pop();
                                  // 값 선택
                                  onChanged(inputValue);
                                  // TextField 초기화
                                  etcController.clear();
                                }
                              },
                              child: Container(
                                padding: EdgeInsets.symmetric(
                                  horizontal: 12.w,
                                  vertical: 6.h,
                                ),
                                decoration: BoxDecoration(
                                  color: const Color(0xff2ABFEC),
                                  borderRadius: BorderRadius.circular(4.r),
                                ),
                                child: Text(
                                  '선택',
                                  style: TextStyle(
                                    fontSize: 12.sp,
                                    color: Colors.white,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                  onChanged: (selected) {
                    if (selected != null && selected != '__custom_input__') {
                      onChanged(selected);
                    }
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

  Widget buildRadioButton(int value, String label) {
    return Container(
      width: 116.w,
      height: 48.h,
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
            onChanged: (v) => setState(() => _selectedValue = v!),
          ),
          SizedBox(width: 8.w),
          Text(label),
        ],
      ),
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
                                initialItem: 8, // 2008년
                              ),
                              onSelectedItemChanged: (index) {
                                selectedYear = 2000 + index;
                              },
                              children: List.generate(
                                100,
                                (index) => Center(
                                  child: Text(
                                    '${2000 + index}',
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
                                initialItem: 0, // 1월
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
                                initialItem: 0, // 1일
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
