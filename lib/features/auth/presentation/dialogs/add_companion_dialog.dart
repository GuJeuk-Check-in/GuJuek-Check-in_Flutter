import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gujuek_check_in_flutter/core/images.dart';

// 동행인 기능 보류(현재 사용 안함)
class AddCompanionDialog extends StatefulWidget {
  final List<String>? initialIds; // 기존 ID 목록
  final bool readOnly; // 조회 모드 여부

  const AddCompanionDialog({
    super.key,
    this.initialIds,
    this.readOnly = false,
  });

  @override
  State<AddCompanionDialog> createState() => _AddCompanionDialogState();
}

class _AddCompanionDialogState extends State<AddCompanionDialog> {
  late List<TextEditingController> controllers;

  @override
  void initState() {
    super.initState();
    // 기존 ID가 있으면 입력칸을 미리 채움
    controllers = widget.initialIds != null
        ? widget.initialIds!.map((id) => TextEditingController(text: id)).toList()
        : [];
  }

  void addCompanionField() {
    // 입력칸 1개 추가
    setState(() {
      controllers.add(TextEditingController());
    });
  }

  void onConfirm() {
    if (widget.readOnly) {
      // 조회 모드면 닫기만 수행
      Navigator.pop(context);
      return;
    }

    final ids = controllers
        .map((c) => c.text.trim())
        .where((text) => text.isNotEmpty)
        .toList();

    // 입력된 ID 목록을 부모로 전달
    Navigator.pop(context, ids); // 부모로 ID 리스트 반환
  }

  @override
  Widget build(BuildContext context) {
    // 키보드 영향 없이 고정 높이로 표시
    return MediaQuery(
      data: MediaQuery.of(context).copyWith(viewInsets: EdgeInsets.zero),
      child: Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.r),
        ),
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
                // 상단: 안내문 or 입력필드
                Expanded(
                  child: controllers.isEmpty
                      ? Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(height: 20.h),
                      Text(
                        '동행인이 있으신가요?',
                        style: TextStyle(
                          fontSize: 24.sp,
                          fontWeight: FontWeight.w700,
                          color: const Color(0xff404040),
                        ),
                      ),
                      SizedBox(height: 5.h),
                      Text(
                        '있으시다면 추가해주세요. 없으면 넘어가도 됩니다.',
                        style: TextStyle(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w700,
                          color: const Color(0xff6A6A6A),
                        ),
                      ),
                    ],
                  )
                      : SingleChildScrollView(
                    child: Column(
                      children: [
                        for (int i = 0; i < controllers.length; i++)
                          Padding(
                            padding: EdgeInsets.only(bottom: 10.h),
                            child: Container(
                              width: 300.w,
                              height: 48.h,
                              padding: EdgeInsets.symmetric(
                                horizontal: 20.w,
                              ),
                              decoration: BoxDecoration(
                                borderRadius:
                                BorderRadius.circular(30.r),
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
                                      controller: controllers[i],
                                      readOnly: widget.readOnly,
                                      style: TextStyle(
                                        fontWeight: FontWeight.w600,
                                        fontSize: 14.sp,
                                        color:
                                        const Color(0xff404040),
                                      ),
                                      decoration: InputDecoration(
                                        hintText:
                                        '동행인 아이디를 입력해주세요',
                                        hintStyle: TextStyle(
                                          fontSize: 14.sp,
                                          fontWeight: FontWeight.w600,
                                          color:
                                          const Color(0xff6A6A6A),
                                        ),
                                        border: InputBorder.none,
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

                // 하단: + 버튼 + 확인 버튼
                Column(
                  children: [
                    if (!widget.readOnly)
                      IconButton(
                        icon: Image.asset(
                          Images.plusIcon,
                          width: 25.w,
                          height: 25.h,
                        ),
                        onPressed: addCompanionField,
                      ),
                    SizedBox(height: 10.h),
                    TextButton(
                      onPressed: onConfirm,
                      child: Text(
                        widget.readOnly ? '닫기' : '확인',
                        style: TextStyle(
                          fontSize: 20.sp,
                          fontWeight: FontWeight.w700,
                          color: const Color(0xff0F50A0),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
