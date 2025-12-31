import 'package:dio/dio.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gujuek_check_in_flutter/data/models/purpose/purpose_model.dart';

class CustomDropDownButton extends StatefulWidget {
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
  State<CustomDropDownButton> createState() => _CustomDropDownButtonState();
}

class _CustomDropDownButtonState extends State<CustomDropDownButton> {
  List<PurposeModel> purposeList = [];
  PurposeModel? selectedPurpose;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchPurpose();
  }

  Future<void> fetchPurpose() async {
    final dio = Dio(
      BaseOptions(
        baseUrl: dotenv.env['BASE_URL'] ?? '',
        headers: {'Content-Type': 'application/json'},
      ),
    );

    try {
      debugPrint('API 호출 시작: ${dotenv.env['BASE_URL']}/purpose/all');
      final response = await dio.get('/purpose/all');
      debugPrint('API 응답: ${response.data}');
      final List<dynamic> jsonList = response.data;
      setState(() {
        purposeList = jsonList.map((e) => PurposeModel.fromJson(e)).toList();
        debugPrint('purposeList 개수: ${purposeList.length}');
        isLoading = false;
      });
    } catch (e) {
      debugPrint('ERROR: $e');
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return SizedBox(
        width: widget.width,
        height: widget.height,
        child: const Center(child: CircularProgressIndicator()),
      );
    }

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
              thumbColor: const WidgetStatePropertyAll(Color(0xffB5B5B5)),
            ),
          ),

          // ▼ 아이콘 스타일
          iconStyleData: IconStyleData(
            icon: Image.asset(widget.imagePath, width: 22.w, height: 24.h),
          ),
        ),
      ),
    );
  }
}
