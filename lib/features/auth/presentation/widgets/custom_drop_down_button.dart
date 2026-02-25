import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gujuek_check_in_flutter/features/auth/domain/repositories/resident_repository.dart';
import 'package:gujuek_check_in_flutter/features/auth/presentation/state/resident_provider.dart';

import '../../data/models/purpose/purpose_model.dart';
import '../state/purpose_list_provider.dart';

class CustomDropDownButton extends ConsumerStatefulWidget {
  final Function(PurposeModel?) onPurposeSelected;
  final double width;
  final double height;
  final String text;
  final String imagePath;
  final BoxDecoration decoration;

  const CustomDropDownButton({
    super.key,
    required this.onPurposeSelected,
    required this.width,
    required this.height,
    required this.text,
    required this.imagePath,
    required this.decoration,
  });

  @override
  ConsumerState<CustomDropDownButton> createState() =>
      _CustomDropDownButtonState();
}

class _CustomDropDownButtonState
    extends ConsumerState<CustomDropDownButton> {
  PurposeModel? selectedPurpose;

  @override
  Widget build(BuildContext context) {
    // 방문 목적 목록 비동기 로드
    final purposeListAsync = ref.watch(purposeListProvider);
    return purposeListAsync.when(
      loading: () => SizedBox(
        width: widget.width,
        height: widget.height,
        child: const Center(child: CircularProgressIndicator()),
      ),
      error: (error, stackTrace) => SizedBox(
        width: widget.width,
        height: widget.height,
        child: const Center(child: Text('불러오기 실패')),
      ),
      data: (purposeList) {
        // 데이터 로드 완료 후 드롭다운 표시
        return Container(
          width: widget.width,
          height: widget.height,
          padding: EdgeInsets.symmetric(horizontal: 20.w),
          decoration: widget.decoration,
          child: DropdownButtonHideUnderline(
            child: DropdownButton2<PurposeModel>(
              isExpanded: true,
              hint: Text(
                widget.text,
                style: TextStyle(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w600,
                  color: const Color(0xff404040),
                ),
              ),
              value: selectedPurpose,
              items: purposeList.map((purpose) {
                return DropdownMenuItem<PurposeModel>(
                  value: purpose,
                  child: Center(
                    child: Text(
                      purpose.purpose,
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
                  // 선택값 로컬 상태에 저장
                  selectedPurpose = value;
                });
                widget.onPurposeSelected(value);
              },

              //드롭다운 스타일
              dropdownStyleData: DropdownStyleData(
                maxHeight: 400.h,
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
                      const WidgetStatePropertyAll(Color(0xffB5B5B5)),
                ),
              ),

              // ▼ 아이콘 스타일
              iconStyleData: IconStyleData(
                icon: Image.asset(widget.imagePath, width: 22.w, height: 24.h),
              ),
            ),
          ),
        );
      },
    );
  }
}
