import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gujuek_check_in_flutter/core/images.dart';

class AddCompanionDialog extends StatefulWidget {
  const AddCompanionDialog({super.key});

  @override
  State<AddCompanionDialog> createState() => _AddCompanionDialogState();
}

class _AddCompanionDialogState extends State<AddCompanionDialog> {
  late TextEditingController companionController;

  @override
  void initState() {
    super.initState();
    companionController = TextEditingController();
  }

  @override
  void dispose() {
    companionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Container(
        width: 440.w,
        height: 520.h,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20.r),
          color: Colors.white,
        ),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 70.w, vertical: 40.h),
          child: Column(
            children: [
              Container(
                width: 300.w,
                height: 48.h,
                padding: EdgeInsets.symmetric(horizontal: 20.w),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(30.r),
                  border: Border.all(
                    width: 1.w,
                    color: const Color(0xff404040),
                  ),
                ),
                child: Row(
                  children: [
                    Image.asset(
                      Images.personIcon,
                      width: 22.w,
                      height: 24.h,
                    ),
                    SizedBox(width: 8.w),
                    Image.asset(
                      Images.lineIcon,
                      width: 1.w,
                      height: 36.h,
                    ),
                    SizedBox(width: 8.w),
                    Expanded(
                      child: TextField(
                        controller: companionController,
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 14.sp,
                          color: const Color(0xff404040),
                        ),
                        decoration: InputDecoration(
                          hintText: '동행인 아이디를 입력해주세요',
                          focusColor: Colors.black,
                          hintStyle: TextStyle(
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w600,
                            color: const Color(0xff6A6A6A),
                          ),
                          fillColor: Colors.white,
                          border: InputBorder.none,
                          focusedBorder: InputBorder.none,
                          errorBorder: InputBorder.none,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 10.h),
              Center(
                child: Image.asset(
                  Images.plusIcon,
                  width: 23.w,
                  height: 23.h,
                ),
              ),
              SizedBox(height: 20.h),
              Text(
                '동행인이 있으신가요?',
                style: TextStyle(
                  fontSize: 24.sp,
                  fontWeight: FontWeight.w700,
                  color: const Color(0xff404040),
                ),
              ),
              Text(
                '있으시다면 추가해주세 없으면 넘어가도 됩니다.',
                style: TextStyle(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w700,
                  color: const Color(0xff6A6A6A),
                ),
              ),
              SizedBox(height: 221.h),
              TextButton(
                onPressed: () {},
                child: Text(
                  '확인',
                  style: TextStyle(
                    fontSize: 20.sp,
                    fontWeight: FontWeight.w700,
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
