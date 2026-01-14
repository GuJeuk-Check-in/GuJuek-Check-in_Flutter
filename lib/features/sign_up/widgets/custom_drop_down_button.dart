import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gujuek_check_in_flutter/core/images.dart';
import 'package:gujuek_check_in_flutter/data/models/purpose/purpose_model.dart';
import 'package:gujuek_check_in_flutter/features/shared/state/purpose_list_provider.dart';

class LocationCustomDropDownButton extends ConsumerStatefulWidget {
  final Function(PurposeModel?) onPurposeSelected;
  final double width;
  final double height;
  final String text;
  final String imagePath;
  final BoxDecoration decoration;

  const LocationCustomDropDownButton({
    super.key,
    required this.onPurposeSelected,
    required this.width,
    required this.height,
    required this.text,
    required this.imagePath,
    required this.decoration,
  });

  @override
  ConsumerState<LocationCustomDropDownButton> createState() =>
      _LocationCustomDropDownButtonState();
}

class _LocationCustomDropDownButtonState
    extends ConsumerState<LocationCustomDropDownButton> {
  PurposeModel? selectedPurpose;

  @override
  Widget build(BuildContext context) {
    final purposeListAsync = ref.watch(purposeListProvider);

    return purposeListAsync.when(
      loading: () => Container(
        width: widget.width.w,
        height: widget.height.h,
        alignment: Alignment.center,
        child: const CircularProgressIndicator(),
      ),
      error: (error, stackTrace) => Container(
        width: widget.width.w,
        height: widget.height.h,
        alignment: Alignment.center,
        child: const Text('불러오기 실패'),
      ),
      data: (purposeList) {
        return Container(
          width: widget.width.w,
          height: widget.height.h,
          padding: EdgeInsets.symmetric(horizontal: 20.w),
          decoration: widget.decoration,
          child: Row(
            children: [
              Image.asset(
                Images.locationPinIcon,
                width: 25.w,
                height: 25.h,
              ),
              SizedBox(width: 10.w),
              SizedBox(
                width: 412.w,
                child: DropdownButtonHideUnderline(
                  child: DropdownButton2<PurposeModel>(
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
                      icon:
                          Image.asset(Images.upIcon, width: 22.w, height: 24.h),
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
