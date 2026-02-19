import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gujuek_check_in_flutter/core/constants/color.dart';
import 'package:gujuek_check_in_flutter/core/constants/text_style.dart';
import 'package:gujuek_check_in_flutter/core/images.dart';
import 'package:gujuek_check_in_flutter/features/auth/presentation/dialogs/sign_up_dialog.dart';

import '../../../../core/widgets/dialogs/complete_facility_registration.dart';
import '../../../../core/widgets/dialogs/loading_dialog.dart';
import 'error_id_dialog.dart';
import '../widgets/custom_drop_down_button.dart';
import '../state/facility_registration_controller.dart';
import '../widgets/quantity_counter_widget.dart';
import '../state/facility_registration_state.dart';

class FacilityRegistrationDialog extends ConsumerStatefulWidget {
  const FacilityRegistrationDialog({super.key});

  @override
  ConsumerState<FacilityRegistrationDialog> createState() =>
      _FacilityRegistrationDialogState();
}

class _FacilityRegistrationDialogState
    extends ConsumerState<FacilityRegistrationDialog> {
  late TextEditingController nameController;

  int maleCount = 0;
  int femaleCount = 0;
  String? _selectedPurpose;
  bool _isLoadingDialogVisible = false;

  @override
  void initState() {
    super.initState();
    nameController = TextEditingController();
  }

  @override
  void dispose() {
    nameController.dispose();
    super.dispose();
  }

  // 입력값을 FormData로 변환해 제출
  void _submitLogin() {
    ref
        .read(facilityRegistrationControllerProvider.notifier)
        .submit(
          FacilityRegistrationFormData(
            userId: nameController.text,
            purpose: _selectedPurpose,
            maleCount: maleCount,
            femaleCount: femaleCount,
          ),
        );
  }

  void _showLoadingDialog() {
    if (_isLoadingDialogVisible) return;
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

  // 상태 변화에 따라 로딩/성공/오류 처리
  void _handleRegistrationState(
    FacilityRegistrationState? previous,
    FacilityRegistrationState next,
  ) {
    if (!mounted) return;

    final wasSubmitting = previous?.isSubmitting ?? false;
    if (!wasSubmitting && next.isSubmitting) {
      _showLoadingDialog();
    } else if (wasSubmitting && !next.isSubmitting) {
      _hideLoadingDialog();
    }

    if (next.isSuccess) {
      showDialog(
        context: context,
        builder: (_) =>
            const CompleteFacilityRegistration(text: '이용해주셔서 감사합니다.'),
      );
      ref
          .read(facilityRegistrationControllerProvider.notifier)
          .clearNotifications();
      return;
    }

    if (next.errorType == FacilityRegistrationErrorType.notFound) {
      showDialog(context: context, builder: (_) => const ErrorIdDialog());
      ref
          .read(facilityRegistrationControllerProvider.notifier)
          .clearNotifications();
      return;
    }

    if (next.message != null && next.message!.isNotEmpty) {
      ref
          .read(facilityRegistrationControllerProvider.notifier)
          .clearNotifications();
    }
  }

  @override
  Widget build(BuildContext context) {
    ref.listen<FacilityRegistrationState>(
      facilityRegistrationControllerProvider,
      _handleRegistrationState,
    );

    // 화면 크기에 맞춰 다이얼로그 크기/여백 계산
    final viewInsets = MediaQuery.of(context).viewInsets;
    final screenSize = MediaQuery.sizeOf(context);
    final horizontalMargin = 24.w;
    final verticalMargin = 24.h;
    final dialogWidth = math.min(
      920.w,
      math.max(0.0, screenSize.width - horizontalMargin * 2),
    );
    final dialogHeight = math.min(
      544.h,
      math.max(0.0, screenSize.height - verticalMargin * 2),
    );
    final isCompact = dialogWidth < 700.w;
    final compactFormWidth = math.max(
      0.0,
      dialogWidth - (horizontalMargin * 2),
    );
    final formWidth = isCompact ? math.min(320.w, compactFormWidth) : 300.w;

    return AnimatedPadding(
      padding: EdgeInsets.only(bottom: viewInsets.bottom),
      duration: const Duration(milliseconds: 200),
      curve: Curves.easeOut,
      child: MediaQuery(
        data: MediaQuery.of(context).copyWith(viewInsets: EdgeInsets.zero),
        child: Dialog(
          child: Container(
            width: dialogWidth,
            height: dialogHeight,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20.r),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20.r),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Expanded(child: buildLeftPanel(isCompact: isCompact)),
                  Expanded(
                    child: buildRightPanel(
                      isCompact: isCompact,
                      formWidth: formWidth,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget buildLeftPanel({required bool isCompact}) {
    // 좌측 안내 영역(로고/문구)
    final sidePadding = isCompact ? 24.w : 47.w;
    final logoWidth = isCompact ? 260.w : 366.w;
    final logoHeight = isCompact ? 100.h : 140.h;
    final dotOffset = isCompact ? null : 206.h;

    return Container(
      width: double.infinity,
      color: GuJuekColor.white,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: sidePadding),
        child: SingleChildScrollView(
          child: Stack(
            children: [
              if (!isCompact)
                Positioned(left: 110.w, top: dotOffset, child: buildDot()),
              if (!isCompact)
                Positioned(left: 152.w, top: dotOffset, child: buildDot()),
              Column(
                children: [
                  SizedBox(height: isCompact ? 32.h : 54.h),
                  Image.asset(
                    Images.guLogo,
                    width: logoWidth,
                    height: logoHeight,
                  ),
                  Align(
                    alignment: Alignment.centerRight,
                    child: Image.asset(
                      Images.goormIcon,
                      width: isCompact ? 64.w : 76.w,
                      height: isCompact ? 14.h : 17.5.h,
                    ),
                  ),
                  SizedBox(height: 8.h),
                  RichText(
                    textAlign: TextAlign.left,
                    text: TextSpan(
                      style: null,
                      children: [
                        TextSpan(
                          text: '나의 ',
                          style: TextStyle(
                            fontFamily: 'Jua',
                            color: const Color(0xff2F68C2),
                            fontSize: isCompact ? 36.sp : 48.sp,
                          ),
                        ),
                        TextSpan(
                          text: '미래',
                          style: TextStyle(
                            fontFamily: 'Jua',
                            color: const Color(0xffF86879),
                            fontSize: isCompact ? 42.sp : 55.sp,
                          ),
                        ),
                        TextSpan(
                          text: '는\n      ',
                          style: TextStyle(
                            fontFamily: 'Jua',
                            color: const Color(0xff2F68C2),
                            fontSize: isCompact ? 36.sp : 48.sp,
                          ),
                        ),
                        TextSpan(
                          text: '내가 만드는거야',
                          style: TextStyle(
                            fontFamily: 'Jua',
                            color: const Color(0xff2F68C2),
                            fontSize: isCompact ? 36.sp : 48.sp,
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 10.h),
                  Container(
                    width: isCompact ? double.infinity : 342.w,
                    padding: EdgeInsets.symmetric(horizontal: 12.w),
                    height: 23.h,
                    decoration: const BoxDecoration(color: Color(0xff5E97DB)),
                    child: Center(
                      child: Text(
                        '미래를 만들어가는 청소년, 구즉청소년문화의집이 함께 하겠습니다.',
                        style: TextStyle(
                          fontFamily: 'Jua',
                          color: Colors.white,
                          fontSize: 12.5.sp,
                        ),
                        textAlign: TextAlign.center,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ),
                  SizedBox(height: 20.h),
                  buildItem('청소년이 호기심을 발견하는 창의 발전소'),
                  SizedBox(height: 5.h),
                  buildItem('청소년이 행복한 문화 다락방'),
                  SizedBox(height: 5.h),
                  buildItem('청소년이 재미 있는 놀이 아지트'),
                  SizedBox(height: isCompact ? 24.h : 100.h),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
  Widget buildRightPanel({required bool isCompact, required double formWidth}) {
    // 우측 입력 폼 영역
    final buttonPadding = isCompact ? 40.w : 90.w;

    return Container(
      width: double.infinity,
      color: GuJuekColor.blue,
      child: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: isCompact ? 24.w : 40.w),
        child: Column(
          children: [
            SizedBox(height: isCompact ? 36.h : 54.h),
            Text(
              '시설 이용 신청',
              style: GuJuekTextStyle.title.copyWith(
                fontFamily: 'Jua',
                fontSize: isCompact ? 28.sp : 34.sp,
                color: GuJuekColor.white,
              ),
            ),
            SizedBox(height: isCompact ? 28.h : 36.h),
            Column(
              children: [
                buildTextField(width: formWidth),
                SizedBox(height: 20.h),
                buildDropDown(width: formWidth),
                SizedBox(height: 8.h),
                buildCountingBlock(),
              ],
            ),
            SizedBox(height: 32.h),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: buttonPadding),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  minimumSize: Size(140.w, 48.h),
                  backgroundColor: GuJuekColor.primary,
                  shape: RoundedRectangleBorder(
                    side: BorderSide(width: 2.w, color: GuJuekColor.white),
                    borderRadius: BorderRadius.circular(50.r),
                  ),
                ),
                onPressed: () {
                  _submitLogin();
                },
                child: Center(
                  child: Text(
                    '확인',
                    style: GuJuekTextStyle.check.copyWith(
                      fontSize: 20.sp,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(height: 20.h),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: GestureDetector(
                onTap: () {
                  showDialog(
                    context: context,
                    builder: (_) => const SignUpDialog(),
                  );
                },
                child: Container(
                  decoration: BoxDecoration(
                    border: Border(
                      bottom: BorderSide(
                        color: GuJuekColor.skyBlue,
                        width: 2.h,
                      ),
                    ),
                  ),
                  child: Text(
                    '계정이 없으신가요?',
                    style: GuJuekTextStyle.labelText.copyWith(
                      fontSize: 20.sp,
                      fontWeight: FontWeight.w600,
                      color: GuJuekColor.skyBlue,
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(height: 12.h),
          ],
        ),
      ),
    );
  }

  Widget buildTextField({required double width}) {
    return Container(
      width: width,
      height: 44.h,
      padding: EdgeInsets.symmetric(horizontal: 18.w),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(30.r),
        color: GuJuekColor.white,
        border: Border.all(width: 1.w, color: GuJuekColor.blue),
      ),
      child: Row(
        children: [
          Image.asset(Images.personIcon, width: 20.w, height: 20.h),
          SizedBox(width: 10.w),
          Image.asset(Images.lineIcon, width: 1.w, height: 24.h),
          SizedBox(width: 10.w),
          Expanded(
            child: TextField(
              controller: nameController,
              style: GuJuekTextStyle.hintText.copyWith(
                fontWeight: FontWeight.w600,
                fontSize: 13.sp,
                color: GuJuekColor.gray30,
              ),
              decoration: InputDecoration(
                hintText: 'ex) 김정욱0709',
                focusColor: Colors.black,
                hintStyle: GuJuekTextStyle.hintText.copyWith(
                  fontSize: 13.sp,
                  fontWeight: FontWeight.w600,
                  color: GuJuekColor.gray10,
                ),
                fillColor: GuJuekColor.white,
                border: InputBorder.none,
                focusedBorder: InputBorder.none,
                errorBorder: InputBorder.none,
                isDense: true,
                contentPadding: EdgeInsets.zero,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildDropDown({required double width}) {
    return CustomDropDownButton(
      width: width,
      height: 44.h,
      text: '방문목적 선택',
      imagePath: Images.upDown,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(30.r),
        color: GuJuekColor.white,
        border: Border.all(width: 1.w, color: GuJuekColor.blue),
      ),
      onPurposeSelected: (purpose) {
        setState(() {
          _selectedPurpose = purpose!.purpose;
        });
      },
    );
  }

  Widget buildCountingBlock() {
    // 동행인 수 입력 블록 (보류: 현재 사용 안함)
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        buildCountingGender(isMale: true),
        SizedBox(width: 12.w),
        buildCountingGender(isMale: false),
      ],
    );
  }

  Widget buildCountingGender({bool isMale = true}) {
    final label = isMale ? '남성 동행인 수' : '여성 동행인 수';
    final initialValue = isMale ? maleCount : femaleCount;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: GuJuekTextStyle.hintText.copyWith(
            fontSize: 16.sp,
            fontWeight: FontWeight.w500,
            color: GuJuekColor.white,
          ),
        ),
        SizedBox(height: 2.h),ㅌ₩
        QuantityCounter(
          initialValue: initialValue,
          onChanged: (value) {
            setState(() {
              if (isMale) {
                maleCount = value;
              } else {
                femaleCount = value;
              }
            });
          },
        ),
      ],
    );
  }

  Widget buildItem(String text) {
    return Row(
      children: [
        Container(
          width: 6.w,
          height: 6.h,
          decoration: const BoxDecoration(
            color: Colors.black,
            shape: BoxShape.circle,
          ),
        ),
        SizedBox(width: 9.w),
        Text(
          text,
          style: TextStyle(
            fontSize: 13.5.sp,
            fontWeight: FontWeight.w600,
            color: const Color(0xff232323),
          ),
        ),
      ],
    );
  }

  Widget buildDot() => Container(
    width: 11.w,
    height: 11.h,
    decoration: const BoxDecoration(
      shape: BoxShape.circle,
      color: Color(0xffF86879),
    ),
  );
}
