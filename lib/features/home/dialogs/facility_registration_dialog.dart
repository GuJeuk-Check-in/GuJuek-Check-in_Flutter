import 'dart:math' as math;

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gujuek_check_in_flutter/features/home/widgets/custom_drop_down_button.dart';
import 'package:gujuek_check_in_flutter/core/images.dart';
import 'package:gujuek_check_in_flutter/data/models/login/login_model.dart';
import 'package:gujuek_check_in_flutter/features/home/widgets/quantity_counter_widget.dart';
import 'package:gujuek_check_in_flutter/shared/dialogs/complete_facility_registration.dart';
import 'package:gujuek_check_in_flutter/shared/dialogs/loading_dialog.dart';

import 'package:gujuek_check_in_flutter/features/sign_up/dialogs/sign_up_dialog.dart';

class FacilityRegistrationDialog extends StatefulWidget {
  const FacilityRegistrationDialog({super.key});

  @override
  _FacilityRegistrationDialogState createState() =>
      _FacilityRegistrationDialogState();
}

class _FacilityRegistrationDialogState
    extends State<FacilityRegistrationDialog> {
  late TextEditingController nameController;

  int maleCount = 0;
  int femaleCount = 0;
  String? _selectedPurpose;

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

  Future<void> login() async {
    try {
      debugPrint('=== 로그인 시작 ===');
      debugPrint('userId: ${nameController.text}');
      debugPrint('purpose: $_selectedPurpose');
      debugPrint('maleCount: $maleCount');
      debugPrint('femaleCount: $femaleCount');

      if (nameController.text.isEmpty) {
        debugPrint('userId가 비어있음');
        return;
      }

      if (_selectedPurpose == null || _selectedPurpose!.isEmpty) {
        debugPrint('purpose가 선택되지 않음');
        return;
      }

      final user = LoginModel(
        userId: nameController.text,
        purpose: _selectedPurpose!,
        maleCount: maleCount,
        femaleCount: femaleCount,
      );

      final data = user.toJson();
      debugPrint('LOGIN DATA: $data');

      final baseUrl = dotenv.env['BASE_URL'];

      if (baseUrl == null || baseUrl.isEmpty) {
        debugPrint('BASE_URL이 설정되지 않음');
        return;
      }

      final dio = Dio(
        BaseOptions(
          baseUrl: baseUrl,
          headers: {'Content-Type': 'application/json'},
        ),
      );

      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (_) => const LoadingDialog(),
      );

      final response = await dio.post('/user/login', data: data);

      debugPrint('✅ 응답 받음 - 상태코드: ${response.statusCode}');
      debugPrint('응답 데이터: ${response.data}');

      if (response.statusCode == 200 || response.statusCode == 201) {
        debugPrint('SUCCESS LOGIN');
        if (mounted) {
          showDialog(
            context: context,
            builder: (_) =>
                const CompleteFacilityRegistration(text: '이용해주셔서 감사합니다.'),
          );
        }
      }
    } on DioException catch (e) {
      debugPrint('❌ DioException 발생!');
      debugPrint('타입: ${e.type}');
      debugPrint('상태코드: ${e.response?.statusCode}');
      debugPrint('에러 메시지: ${e.message}');
      debugPrint('응답 데이터: ${e.response?.data}');

      if (e.response?.statusCode == 404) {
        final errorData = e.response?.data;
        // description 필드에서 메시지 추출
        final description = errorData['message']!;
        Future.microtask(() {
          if (mounted) Navigator.pop(context);
          showDialog(
            context: context,
            builder: (_) => AlertDialog(
              title: const Text(
                '로그인 에러',
                style: TextStyle(fontWeight: FontWeight.w700),
              ),
              content: Text(
                description,
                style: const TextStyle(fontSize: 16, height: 1.5),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text(
                    '확인',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                  ),
                ),
              ],
            ),
          );
        });
      } else {
        debugPrint('LOGIN ERROR: ${e.message}');
      }
    } catch (error, stackTrace) {
      debugPrint('일반 에러 발생: $error');
      debugPrint('스택트레이스: $stackTrace');
    }
  }

  @override
  Widget build(BuildContext context) {
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

    return MediaQuery(
      data: MediaQuery.of(context).copyWith(viewInsets: EdgeInsets.zero),
      child: Dialog(
        child: Container(
          width: dialogWidth,
          height: dialogHeight,
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(20.r)),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(20.r),
            child: Row(
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
    );
  }

  Widget buildLeftPanel({required bool isCompact}) {
    final sidePadding = isCompact ? 24.w : 47.w;
    final logoWidth = isCompact ? 260.w : 366.w;
    final logoHeight = isCompact ? 100.h : 140.h;
    final dotOffset = isCompact ? null : 206.h;

    return Container(
      width: double.infinity,
      color: Colors.white,
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
    final buttonPadding = isCompact ? 40.w : 160.w;

    return Container(
      width: double.infinity,
      color: const Color(0xff0F50A0),
      child: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: isCompact ? 24.w : 0),
        child: Column(
          children: [
            SizedBox(height: isCompact ? 32.h : 69.h),
            Text(
              '시설 이용 신청',
              style: TextStyle(
                fontSize: isCompact ? 32.sp : 40.sp,
                fontFamily: 'Jua',
                color: Colors.white,
              ),
            ),
            SizedBox(height: isCompact ? 32.h : 52.h),
            Column(
              children: [
                buildTextField(width: formWidth),
                SizedBox(height: 20.h),
                buildDropDown(width: formWidth),
                SizedBox(height: 10.h),
                buildCountingBlock(),
              ],
            ),
            SizedBox(height: 40.h),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: buttonPadding),
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
                    login();
                  });
                },
                child: Center(
                  child: Text(
                    '확인',
                    style: TextStyle(
                      fontSize: 24.sp,
                      color: Colors.white,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(height: 24.h),
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
                        color: const Color(0xffA4DFFF),
                        width: 2.h,
                      ),
                    ),
                  ),
                  child: Text(
                    '계정이 없으신가요?',
                    style: TextStyle(
                      fontSize: 20.sp,
                      fontWeight: FontWeight.w600,
                      color: const Color(0xffA4DFFF),
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(height: 16.h),
          ],
        ),
      ),
    );
  }

  Widget buildTextField({required double width}) {
    return Container(
      width: width,
      height: 48.h,
      padding: EdgeInsets.symmetric(horizontal: 20.w),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(30.r),
        color: Colors.white,
        border: Border.all(width: 1.w, color: const Color(0xff0F50A0)),
      ),
      child: Row(
        children: [
          Image.asset(Images.personIcon, width: 22.w, height: 24.h),
          SizedBox(width: 8.w),
          Image.asset(Images.lineIcon, width: 1.w, height: 36.h),
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

  Widget buildDropDown({required double width}) {
    return CustomDropDownButton(
      width: width,
      height: 48.h,
      text: '방문목적 선택',
      imagePath: Images.upDown,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(30.r),
        color: Colors.white,
        border: Border.all(width: 1.w, color: const Color(0xff0F50A0)),
      ),
      onPurposeSelected: (purpose) {
        setState(() {
          _selectedPurpose = purpose!.purpose;
        });
      },
    );
  }

  Widget buildCountingBlock() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        buildCountingGender(isMale: true),
        SizedBox(width: 8.w),
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
          style: TextStyle(
            fontSize: 14.sp,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
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

  // Widget buildAddCompanion({required double width}) {
  //   return Column(
  //     children: [
  //       // 동행인 추가 버튼
  //       GestureDetector(
  //         onTap: () async {
  //           final result = await showDialog<List<String>>(
  //             context: context,
  //             builder: (_) => const AddCompanionDialog(),
  //           );
  //
  //           if (result != null && result.isNotEmpty) {
  //             setState(() {
  //               companionIds.addAll(result);
  //             });
  //           }
  //         },
  //         child: Container(
  //           width: width,
  //           height: 48.h,
  //           padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 13.h),
  //           decoration: BoxDecoration(
  //             borderRadius: BorderRadius.circular(30.r),
  //             color: Colors.white,
  //           ),
  //           child: Row(
  //             mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //             children: [
  //               Text(
  //                 '동행인 추가',
  //                 style: TextStyle(
  //                   fontSize: 14.sp,
  //                   color: const Color(0xff404040),
  //                   fontWeight: FontWeight.w600,
  //                 ),
  //               ),
  //               Image.asset(Images.plusIcon, width: 25.w, height: 25.h),
  //             ],
  //           ),
  //         ),
  //       ),
  //       SizedBox(height: 10.h),
  //
  //       // 동행인 목록 보기 컨테이너
  //       if (companionIds.isNotEmpty)
  //         GestureDetector(
  //           onTap: () async {
  //             final result = await showDialog<List<String>>(
  //               context: context,
  //               builder: (_) =>
  //                   _CompanionListDialog(companionIds: List.from(companionIds)),
  //             );
  //
  //             // 수정된 목록을 반영
  //             if (result != null) {
  //               setState(() {
  //                 companionIds.clear();
  //                 companionIds.addAll(result);
  //               });
  //             }
  //           },
  //           child: Container(
  //             width: width,
  //             height: 48.h,
  //             padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 13.h),
  //             decoration: BoxDecoration(
  //               borderRadius: BorderRadius.circular(30.r),
  //               color: Colors.white.withOpacity(0.9),
  //             ),
  //             child: Row(
  //               mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //               children: [
  //                 Text(
  //                   '동행인 보기',
  //                   style: TextStyle(
  //                     fontSize: 14.sp,
  //                     fontWeight: FontWeight.w600,
  //                     color: const Color(0xff404040),
  //                   ),
  //                 ),
  //                 Image.asset(Images.searchIcon, width: 25.w, height: 25.h),
  //               ],
  //             ),
  //           ),
  //         ),
  //     ],
  //   );
  // }

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

//요구 사항으로 인한 사용 X
// 동행인 목록 다이얼로그 (슬라이드 삭제 기능)
// class _CompanionListDialog extends StatefulWidget {
//   final List<String> companionIds;
//
//   const _CompanionListDialog({required this.companionIds});
//
//   @override
//   State<_CompanionListDialog> createState() => _CompanionListDialogState();
// }
//
// class _CompanionListDialogState extends State<_CompanionListDialog> {
//   late List<String> _companionIds;
//
//   @override
//   void initState() {
//     super.initState();
//     _companionIds = List.from(widget.companionIds);
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Dialog(
//       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.r)),
//       child: Container(
//         width: 400.w,
//         padding: EdgeInsets.all(24.w),
//         decoration: BoxDecoration(
//           color: Colors.white,
//           borderRadius: BorderRadius.circular(20.r),
//         ),
//         child: Column(
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             Text(
//               '동행인 목록',
//               style: TextStyle(
//                 fontSize: 24.sp,
//                 fontWeight: FontWeight.w700,
//                 color: const Color(0xff0F50A0),
//               ),
//             ),
//             SizedBox(height: 8.h),
//             Text(
//               '왼쪽으로 슬라이드하여 삭제',
//               style: TextStyle(
//                 fontSize: 14.sp,
//                 fontWeight: FontWeight.w500,
//                 color: const Color(0xff6A6A6A),
//               ),
//             ),
//             SizedBox(height: 20.h),
//             ConstrainedBox(
//               constraints: BoxConstraints(maxHeight: 300.h),
//               child: _companionIds.isEmpty
//                   ? Center(
//                       child: Padding(
//                         padding: EdgeInsets.symmetric(vertical: 40.h),
//                         child: Text(
//                           '동행인이 없습니다',
//                           style: TextStyle(
//                             fontSize: 16.sp,
//                             color: const Color(0xff6A6A6A),
//                           ),
//                         ),
//                       ),
//                     )
//                   : ListView.builder(
//                       shrinkWrap: true,
//                       itemCount: _companionIds.length,
//                       itemBuilder: (context, index) {
//                         final id = _companionIds[index];
//                         return Dismissible(
//                           key: Key(id),
//                           direction: DismissDirection.endToStart,
//                           onDismissed: (direction) {
//                             setState(() {
//                               _companionIds.removeAt(index);
//                             });
//                             ScaffoldMessenger.of(context).showSnackBar(
//                               SnackBar(
//                                 content: Text('$id 삭제됨'),
//                                 duration: const Duration(seconds: 1),
//                               ),
//                             );
//                           },
//                           background: Container(
//                             alignment: Alignment.centerRight,
//                             padding: EdgeInsets.only(right: 20.w),
//                             decoration: BoxDecoration(
//                               color: Colors.red,
//                               borderRadius: BorderRadius.circular(12.r),
//                             ),
//                             child: Icon(
//                               Icons.delete,
//                               color: Colors.white,
//                               size: 28.sp,
//                             ),
//                           ),
//                           child: Container(
//                             margin: EdgeInsets.only(bottom: 8.h),
//                             padding: EdgeInsets.symmetric(
//                               horizontal: 16.w,
//                               vertical: 12.h,
//                             ),
//                             decoration: BoxDecoration(
//                               color: const Color(0xffF5F5F5),
//                               borderRadius: BorderRadius.circular(12.r),
//                               border: Border.all(
//                                 width: 1.w,
//                                 color: const Color(0xffE0E0E0),
//                               ),
//                             ),
//                             child: Row(
//                               children: [
//                                 Container(
//                                   width: 8.w,
//                                   height: 8.h,
//                                   decoration: const BoxDecoration(
//                                     color: Color(0xff0F50A0),
//                                     shape: BoxShape.circle,
//                                   ),
//                                 ),
//                                 SizedBox(width: 12.w),
//                                 Expanded(
//                                   child: Text(
//                                     id,
//                                     style: TextStyle(
//                                       fontSize: 16.sp,
//                                       fontWeight: FontWeight.w600,
//                                       color: const Color(0xff404040),
//                                     ),
//                                   ),
//                                 ),
//                               ],
//                             ),
//                           ),
//                         );
//                       },
//                     ),
//             ),
//             SizedBox(height: 20.h),
//             Row(
//               children: [
//                 Expanded(
//                   child: ElevatedButton(
//                     style: ElevatedButton.styleFrom(
//                       backgroundColor: const Color(0xff0F50A0),
//                       shape: RoundedRectangleBorder(
//                         borderRadius: BorderRadius.circular(12.r),
//                       ),
//                       padding: EdgeInsets.symmetric(vertical: 14.h),
//                     ),
//                     onPressed: () {
//                       Navigator.pop(context, _companionIds);
//                     },
//                     child: Text(
//                       '확인',
//                       style: TextStyle(
//                         fontSize: 16.sp,
//                         fontWeight: FontWeight.w700,
//                         color: Colors.white,
//                       ),
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
