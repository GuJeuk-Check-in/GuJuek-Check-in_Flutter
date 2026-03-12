import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gujuek_check_in_flutter/core/constants/color.dart';
import 'package:gujuek_check_in_flutter/core/constants/text_style.dart';
import 'package:gujuek_check_in_flutter/core/images.dart';
import 'package:gujuek_check_in_flutter/features/auth/data/models/resident/resident_model.dart';
import 'package:gujuek_check_in_flutter/features/auth/presentation/widgets/resident_custom_drop_down_button.dart';

import '../../../../core/widgets/dialogs/loading_dialog.dart';
import '../../data/sign_up_options.dart';
import '../state/sign_up_controller.dart';
import '../state/sign_up_state.dart';
import '../widgets/people_counter_widget.dart';
import '../dialogs/check_id_dialog.dart';

class SecondSignUpView extends ConsumerStatefulWidget {
  const SecondSignUpView({super.key, required this.firstData});

  final FirstSignUpFormData firstData;

  @override
  ConsumerState<SecondSignUpView> createState() => _SecondSignUpViewState();
}

class _SecondSignUpViewState extends ConsumerState<SecondSignUpView> {
  String? _selectedGender;
  ResidentModel? _selectedAddress;
  bool _isPrivacyAgreed = false;
  int _selectedValue = 1;
  int maleCount = 0;
  int femaleCount = 0;
  bool _isLoadingDialogVisible = false;

  static const String _customInputValue = '__custom_input__';

  void _submitSignUp() {
    ref
        .read(signUpControllerProvider.notifier)
        .submit(
          SignUpFormData(
            name: widget.firstData.name,
            phone: widget.firstData.phone,
            birthYmd: widget.firstData.birthYmd,
            purpose: widget.firstData.purpose,
            genderValue: _selectedValue,
            privacyAgreed: _isPrivacyAgreed,
            maleCount: maleCount,
            femaleCount: femaleCount,
            residence: _selectedAddress?.residence ?? '',
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

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      if (Navigator.of(context, rootNavigator: true).canPop()) {
        Navigator.of(context, rootNavigator: true).pop();
      }
    });
  }

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
      WidgetsBinding.instance.addPostFrameCallback((_) {
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (_) => CheckIdDialog(generatedId: generatedId),
        );
      });

      ref.read(signUpControllerProvider.notifier).clearNotifications();
      return;
    }

    final message = next.message;
    if (message == null || message.isEmpty) return;

    if (next.errorType == SignUpErrorType.duplicateUser) {
      _showDuplicateUserDialog(message);
    } else {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(message)));
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
            onPressed: () => Navigator.pop(context),
            child: Text(
              '확인',
              style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w600),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    ref.listen<SignUpState>(signUpControllerProvider, _handleSignUpState);

    return Scaffold(
      backgroundColor: GuJuekColor.white,
      body: Stack(
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
                        children: [
                          Column(
                            children: [
                              buildColumn(
                                '성별',
                                buildDropDownButton(
                                  _selectedGender,
                                  signUpGender,
                                  '성별을 선택해주세요',
                                  Images.genderIcon,
                                  (val) {
                                    setState(() {
                                      final temp = _selectedGender;
                                      if (val == '남성' && _selectedGender != '남성') {
                                        if(temp == '여성') femaleCount -= 1;
                                        _selectedValue = 1;
                                        maleCount += 1;
                                      } else if (val == '여성' && _selectedGender != '여성') {
                                        if(temp == '남성') maleCount -= 1;
                                        _selectedValue = 2;
                                        femaleCount += 1;
                                      }
                                      _selectedGender = val;
                                    });
                                  },
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 20.w),
                          buildColumn(
                            '사는 지역',
                            ResidentCustomDropDownButton(
                              onResidentSelected: (resident) {
                                setState(() {
                                  _selectedAddress = resident;
                                });
                              },
                              width: 1080.w,
                              height: 80.h,
                              text: '거주지를 선택해주세요',
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
                          SizedBox(height: 20.h),
                          buildCountingBlock(),
                          SizedBox(height: 61.h),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                padding: EdgeInsets.only(bottom: 1.h),
                                decoration: BoxDecoration(
                                  border: Border(
                                    bottom: BorderSide(
                                      color: Colors.redAccent,
                                      width: 1.w,
                                    ),
                                  ),
                                ),
                                child: Text(
                                  '개인정보 수집 및 이용 동의',
                                  style: TextStyle(
                                    fontSize: 16.sp,
                                    fontWeight: FontWeight.w600,
                                    color: GuJuekColor.gray40,
                                  ),
                                ),
                              ),
                              Checkbox(
                                value: _isPrivacyAgreed,
                                onChanged: (v) {
                                  setState(() => _isPrivacyAgreed = v ?? false);
                                },
                                activeColor: GuJuekColor.skyBlue,
                                checkColor: Colors.white,
                              ),
                            ],
                          ),
                          Text(
                            '(이름,생년월일,연락처,방문 목적,성별,cctv 촬영,거주지)',
                            style: TextStyle(
                              fontSize: 12.sp,
                              fontWeight: FontWeight.w600,
                              color: GuJuekColor.gray10,
                            ),
                          ),
                          SizedBox(height: 24.h),
                          GestureDetector(
                            onTap: _submitSignUp,
                            child: Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: 60.w,
                                vertical: 20.h,
                              ),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20.r),
                                border: Border.all(
                                  width: 1.w,
                                  color: GuJuekColor.skyBlue,
                                ),
                              ),
                              child: Text(
                                '완료',
                                style: TextStyle(
                                  fontSize: 20.sp,
                                  fontWeight: FontWeight.w600,
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

  Widget buildDropDownButton(
    String? value,
    List<String> items,
    String text,
    String imagePath,
    ValueChanged<String?> onChanged,
  ) {
    List<String> displayItems = List.from(items);
    if (value != null && !displayItems.contains(value)) {
      displayItems.add(value);
    }

    return Container(
      width: double.infinity,
      height: 80.h,
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
                  selectedItemBuilder: (context) => displayItems
                      .map(
                        (e) => Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            e,
                            style: TextStyle(
                              fontSize: 20.sp,
                              color: Colors.black,
                            ),
                          ),
                        ),
                      )
                      .toList(),
                  iconStyleData: IconStyleData(
                    icon: Image.asset(
                      Images.downIcon,
                      width: 20.w,
                      height: 20.h,
                    ),
                  ),
                  isExpanded: true,
                  value: value,
                  hint: Text(text, style: GuJuekTextStyle.secondHintText),
                  items: displayItems
                      .map(
                        (e) => DropdownMenuItem<String>(
                          value: e,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            child: Center(
                              child: Text(
                                e,
                                style: TextStyle(
                                  fontSize: 20.sp,
                                  color: Colors.black,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ),
                        ),
                      )
                      .toList(),
                  onChanged: onChanged,
                  dropdownStyleData: DropdownStyleData(
                    maxHeight: 300.h,
                    width: 925.w,
                    offset: Offset(-55.w, 0),
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

  Widget buildCountingBlock() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Expanded(
          child: buildCountingItem(
            isMale: true,
            initialValue: maleCount,
            onChanged: (value) => setState(() => maleCount = value),
          ),
        ),
        SizedBox(width: 20.w),
        Expanded(
          child: buildCountingItem(
            isMale: false,
            initialValue: femaleCount,
            onChanged: (value) => setState(() => femaleCount = value),
          ),
        ),
      ],
    );
  }

  Widget buildCountingItem({
    bool isMale = true,
    int initialValue = 0,
    ValueChanged<int>? onChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(isMale ? '남성 사람 수' : '여성 사람 수', style: GuJuekTextStyle.labelText),
        SizedBox(height: 5.h),
        PeopleCounterWidget(
          key: ValueKey(initialValue),
          initialValue: initialValue,
          onChanged: onChanged,
        ),
      ],
    );
  }
}
