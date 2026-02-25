import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gujuek_check_in_flutter/core/constants/color.dart';
import 'package:gujuek_check_in_flutter/core/constants/text_style.dart';
import 'package:gujuek_check_in_flutter/core/images.dart';
import 'package:gujuek_check_in_flutter/features/auth/data/models/resident/resident_model.dart';
import 'package:gujuek_check_in_flutter/features/auth/presentation/state/resident_provider.dart';

class ResidentCustomDropDownButton extends ConsumerStatefulWidget {
  final ValueChanged<ResidentModel?> onResidentSelected;
  final double width;
  final double height;
  final String text;
  final String imagePath;
  final BoxDecoration decoration;

  const ResidentCustomDropDownButton({
    super.key,
    required this.onResidentSelected,
    required this.width,
    required this.height,
    required this.text,
    required this.imagePath,
    required this.decoration,
  });

  @override
  ConsumerState<ResidentCustomDropDownButton> createState() =>
      _ResidentCustomDropDownButtonState();
}

class _ResidentCustomDropDownButtonState
    extends ConsumerState<ResidentCustomDropDownButton> {
  static const int _customId = -1;
  ResidentModel? selectedResident;
  ResidentModel? _customResident;

  @override
  Widget build(BuildContext context) {
    final residentAsync = ref.watch(residentListProvider);

    return residentAsync.when(
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
      data: (residentList) {
        // items 리스트 생성: 기존 + custom + '기타'
        final items = [
          ...residentList,
          if (_customResident != null) _customResident!,
          ResidentModel(id: _customId, residence: '기타'),
        ];

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
              Expanded(
                child: DropdownButtonHideUnderline(
                  child: DropdownButton2<ResidentModel>(
                    hint: Text(widget.text, style: GuJuekTextStyle.hintText),
                    value: selectedResident,
                    items: items.map((resident) {
                      return DropdownMenuItem<ResidentModel>(
                        value: resident,
                        child: Center(
                          child: Text(
                            resident.residence,
                            style: TextStyle(
                              fontSize: 16.sp,
                              fontWeight: FontWeight.w500,
                              color: Colors.black,
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                    onChanged: (value) async {
                      if (value == null) return;

                      // 기타 선택
                      if (value.id == _customId) {
                        final otherValue = await _showCustomAddressDialog();
                        if (otherValue == null || otherValue.isEmpty) return;

                        final customResident = ResidentModel(
                          id: DateTime.now().millisecondsSinceEpoch,
                          residence: otherValue,
                        );

                        setState(() {
                          _customResident = customResident;
                          selectedResident = customResident;
                        });

                        widget.onResidentSelected(customResident);
                        return;
                      }

                      // 일반 선택
                      setState(() {
                        selectedResident = value;
                      });
                      widget.onResidentSelected(value);
                    },
                    dropdownStyleData: DropdownStyleData(
                      maxHeight: 218.h,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8.r),
                        color: Colors.white,
                        border: Border.all(width: 1.w, color: GuJuekColor.blue),
                      ),
                      scrollbarTheme: ScrollbarThemeData(
                        crossAxisMargin: 8.w,
                        mainAxisMargin: 10.h,
                        radius: Radius.circular(100.r),
                        thumbColor:
                        const MaterialStatePropertyAll(Color(0xffB5B5B5)),
                      ),
                    ),
                    iconStyleData: IconStyleData(
                      icon: Image.asset(Images.downIcon, width: 22.w, height: 24.h),
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

  Future<String?> _showCustomAddressDialog() async {
    final controller = TextEditingController();

    return showDialog<String>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('기타 입력', style: TextStyle(fontWeight: FontWeight.w700)),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('거주 지역을 적어주세요.'),
              SizedBox(height: 12.h),
              TextField(
                controller: controller,
                autofocus: true,
                decoration: const InputDecoration(hintText: '예: 대전'),
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
  }
}