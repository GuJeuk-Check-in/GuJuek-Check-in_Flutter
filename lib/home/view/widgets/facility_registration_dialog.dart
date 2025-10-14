import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gujuek_check_in_flutter/core/images.dart';
import 'package:gujuek_check_in_flutter/home/view/widgets/add_companion_dialog.dart';

class FacilityRegistrationDialog extends StatefulWidget {
  const FacilityRegistrationDialog({super.key});

  @override
  _FacilityRegistrationDialogState createState() =>
      _FacilityRegistrationDialogState();
}

class _FacilityRegistrationDialogState
    extends State<FacilityRegistrationDialog> {
  late TextEditingController nameController;
  String? _selectedPurpose;

  final List<String> _purposes = ['게임', '독서', '동아리', '댄스', '노래방', '미디어'];

  int currentStep = 1;

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

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Container(
        width: 920.w,
        height: 544.h,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20.r),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20.r),
          child: Row(
            children: [
              //왼쪽 영역
              Expanded(
                flex: 1,
                child: Container(
                  color: Colors.white,
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 47.0.w),
                    child: Stack(
                      children: [
                        Positioned(
                          left: 110.w,
                          top: 206.h,
                          child: buildDot(),
                        ),
                        Positioned(
                          left: 152.w,
                          top: 206.h,
                          child: buildDot(),
                        ),
                        Column(
                          children: [
                            SizedBox(height: 54.h),
                            Image.asset(
                              Images.guLogo,
                              width: 366.w,
                              height: 140.h,
                            ),
                            Align(
                              alignment: Alignment.centerRight,
                              child: Image.asset(
                                Images.goormIcon,
                                width: 76.w,
                                height: 17.5.h,
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
                                      fontSize: 48.sp,
                                    ),
                                  ),
                                  TextSpan(
                                    text: '미래',
                                    style: TextStyle(
                                      fontFamily: 'Jua',
                                      color: const Color(0xffF86879),
                                      fontSize: 55.sp,
                                    ),
                                  ),
                                  TextSpan(
                                    text: '는\n      ',
                                    style: TextStyle(
                                      fontFamily: 'Jua',
                                      color: const Color(0xff2F68C2),
                                      fontSize: 48.sp,
                                    ),
                                  ),
                                  TextSpan(
                                    text: '내가 만드는거야',
                                    style: TextStyle(
                                      fontFamily: 'Jua',
                                      color: const Color(0xff2F68C2),
                                      fontSize: 48.sp,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(height: 10.h),
                            Container(
                              width: 342.w,
                              height: 23.h,
                              decoration: const BoxDecoration(
                                color: Color(0xff5E97DB),
                              ),
                              child: Center(
                                child: Text(
                                  '미래를 만들어가는 청소년, 구즉청소년문화의집이 함께 하겠습니다.',
                                  style: TextStyle(
                                    fontFamily: 'Jua',
                                    color: Colors.white,
                                    fontSize: 12.5.sp,
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(height: 20.h),
                            buildItem('청소년이 호기심을 발견하는 창의 발전소'),
                            SizedBox(height: 5.h),
                            buildItem('청소년이 행복한 문화 다락방'),
                            SizedBox(height: 5.h),
                            buildItem('청소년이 재미 있는 놀이 아지트'),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              //오른쪽 영역
              Expanded(
                flex: 1,
                child: Container(
                  color: const Color(0xff0F50A0),
                  child: Column(
                    children: [
                      SizedBox(height: 69.h),
                      Text(
                        '시설 이용 신청',
                        style: TextStyle(
                          fontSize: 40.sp,
                          fontFamily: 'Jua',
                          color: Colors.white,
                        ),
                      ),
                      SizedBox(height: 52.h),
                      currentStep == 1
                          ? Column(
                              children: [
                                SizedBox(
                                  width: 300.w,
                                  height: 48.h,
                                  child: buildTextField(),
                                ),
                                SizedBox(height: 20.h),
                                SizedBox(
                                  width: 300.w,
                                  height: 48.h,
                                  child: buildDropDown(),
                                ),
                              ],
                            )
                          : Column(
                              children: [
                                buildAddCompanion(),
                                SizedBox(height: 68.h),
                              ],
                            ),
                      SizedBox(height: 44.h),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 80.w),
                        child: Row(
                          children: List.generate(
                            2,
                            (index) {
                              return Expanded(
                                child: Container(
                                  margin: EdgeInsets.symmetric(horizontal: 8.w),
                                  height: 4.h,
                                  decoration: BoxDecoration(
                                    color: currentStep > index
                                        ? const Color(0xffA4DFFF)
                                        : const Color(0xff012859),
                                    borderRadius: BorderRadius.circular(100.r),
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                      SizedBox(height: 60.h),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 160.w),
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            minimumSize: Size(140.w, 52.h),
                            backgroundColor: const Color(0xff3C71B2),
                            shape: RoundedRectangleBorder(
                              side: BorderSide(width: 2.w, color: Colors.white),
                              borderRadius: BorderRadius.circular(50.r),
                            ),
                          ),
                          onPressed: () {
                            setState(() {
                              if (currentStep < 2) currentStep++;
                            });
                          },
                          child: Center(
                            child: Text(
                              '다음',
                              style: TextStyle(
                                fontSize: 24.sp,
                                color: Colors.white,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 35.h),
                      TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            border: Border(
                              bottom: BorderSide(
                                  color: const Color(0xffA4DFFF), width: 2.h),
                            ),
                          ),
                          child: Text(
                            '계졍이 없으신가요?',
                            style: TextStyle(
                              fontSize: 20.sp,
                              fontWeight: FontWeight.w600,
                              color: const Color(0xffA4DFFF),
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

  Widget buildTextField() {
    return Container(
      width: 300.w,
      height: 48.h,
      padding: EdgeInsets.symmetric(horizontal: 20.w),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(30.r),
        color: Colors.white,
        border: Border.all(
          width: 1.w,
          color: const Color(0xff0F50A0),
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
              controller: nameController,
              style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 14.sp,
                color: const Color(0xff404040),
              ),
              decoration: InputDecoration(
                hintText: 'ex) 김정욱0709',
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
    );
  }

  Widget buildDropDown() {
    return Container(
      width: 300.w,
      height: 48.h,
      padding: EdgeInsets.symmetric(horizontal: 20.w),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(30.r),
        color: Colors.white,
        border: Border.all(width: 1.w, color: const Color(0xff0F50A0)),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton2<String>(
          hint: Text(
            '목적을 선택하세요',
            style: TextStyle(
              fontSize: 14.sp,
              fontWeight: FontWeight.w600,
              color: const Color(0xff404040),
            ),
          ),
          value: _selectedPurpose,
          items: _purposes.map((String purpose) {
            return DropdownMenuItem<String>(
              value: purpose,
              child: Center(
                child: Text(
                  purpose,
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
              _selectedPurpose = value;
            });
          },

          //드롭다운 스타일
          dropdownStyleData: DropdownStyleData(
            maxHeight: 400, // 스크롤 높이 제한
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
                thumbColor: const WidgetStatePropertyAll(Color(0xffB5B5B5))),
          ),

          // ▼ 아이콘 스타일 — 오른쪽에 아이콘 추가
          iconStyleData: IconStyleData(
            icon: Image.asset(
              Images.upDown,
              width: 22.w,
              height: 24.h,
            ),
          ),
        ),
      ),
    );
  }

  Widget buildAddCompanion() {
    return GestureDetector(
      onTap: () {
        showDialog(
          context: context,
          builder: (_) => const AddCompanionDialog(),
        );
      },
      child: Container(
        width: 300.w,
        height: 48.h,
        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 13.h),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(30.r),
          color: Colors.white,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              '동행인 추가',
              style: TextStyle(
                fontSize: 14.sp,
                color: const Color(0xff404040),
                fontWeight: FontWeight.w600,
              ),
            ),
            Image.asset(
              Images.plusIcon,
              width: 25.w,
              height: 25.h,
            ),
          ],
        ),
      ),
    );
  }

  Widget buildItem(String text) {
    return Row(
      children: [
        Container(
          width: 6.w,
          height: 6.h,
          decoration:
              const BoxDecoration(color: Colors.black, shape: BoxShape.circle),
        ),
        SizedBox(width: 9.w),
        Text(
          text,
          style: TextStyle(
              fontSize: 13.5.sp,
              fontWeight: FontWeight.w600,
              color: const Color(0xff232323)),
        )
      ],
    );
  }

  Widget buildDot() => Container(
        width: 11.w,
        height: 11.h,
        decoration: const BoxDecoration(
            shape: BoxShape.circle, color: Color(0xffF86879)),
      );
}
