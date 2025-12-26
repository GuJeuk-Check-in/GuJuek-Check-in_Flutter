import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class FacilitySafetyText {
  static final TextStyle baseStyle = TextStyle(
    fontSize: 35.sp,
    color: Colors.black,
    fontWeight: FontWeight.w500,
  );

  static final TextStyle boldStyle = baseStyle.copyWith(
    fontWeight: FontWeight.w700,
  );

  static final text1 = TextSpan(
    children: [
      TextSpan(text: '활동 중 ', style: baseStyle),
      TextSpan(text: '화재 발생 ', style: boldStyle),
      TextSpan(text: '시 ', style: baseStyle),
      TextSpan(
        text: '"불이야!" ',
        style: baseStyle.copyWith(
          color: const Color(0xffD70000),
          fontWeight: FontWeight.w700,
        ),
      ),
      TextSpan(text: '외친 후\n외부로 대피해주세요.', style: baseStyle),
    ],
  );

  static final text2 = TextSpan(
    children: [
      TextSpan(text: '활동 중 ', style: baseStyle),
      TextSpan(text: '안전 사고', style: boldStyle),
      TextSpan(text: '가 발생하면\n주변 선생님에게 즉시 알려주세요.', style: baseStyle),
    ],
  );

  static final text3 = TextSpan(text: '활동 중 몸이 아프면\n주변 선생님에게 즉시 알려주세요.', style: baseStyle);

  static final text4 = TextSpan(text: '계단은 조심조심 이용해주세요.', style: baseStyle);

  static final text5 = TextSpan(text: '친구들은 친절하게 대해주세요.', style: baseStyle);

  static final text6 = TextSpan(text: '쓰레기는 쓰레기통에 버려주세요.', style: baseStyle);

  static final text7 = TextSpan(
    children: [
      TextSpan(text: '손은 항상 ', style: baseStyle),
      TextSpan(text: '깨끗하게 ', style: boldStyle),
      TextSpan(text: '씻고\n', style: baseStyle),
      TextSpan(text: '기침 예절', style: boldStyle),
      TextSpan(text: '을 지켜주세요.', style: baseStyle),
    ],
  );

  static final text8 = TextSpan(
    children: [
      TextSpan(text: '선생님의 말씀', style: boldStyle),
      TextSpan(text: '에 항상 귀를 귀울여 주세요', style: baseStyle),
    ],
  );

  static final text9 = TextSpan(
    children: [
      TextSpan(text: '존중', style: boldStyle),
      TextSpan(text: '은 ', style: baseStyle),
      TextSpan(text: '기본, 강요', style: boldStyle),
      TextSpan(text: '는 ', style: baseStyle),
      TextSpan(text: '금지!', style: boldStyle),
    ],
  );

  static final text10 = TextSpan(
    children: [
      TextSpan(text: '상대가 ', style: baseStyle),
      TextSpan(text: '싫다고 ', style: boldStyle),
      TextSpan(text: '하면 즉시 ', style: baseStyle),
      TextSpan(text: '멈춰요.', style: boldStyle),
    ],
  );

  static final text11 = TextSpan(
    children: [
      TextSpan(text: '농담이라도 상대방이 불쾌하면\n', style: baseStyle),
      TextSpan(text: '성희롱', style: boldStyle),
      TextSpan(text: '이에요', style: baseStyle),
    ],
  );

  static final text12 = TextSpan(text: '성별에 따라 역할을 강요하지 않아요', style: baseStyle,);

  static final text13 = TextSpan(
    children: [
      TextSpan(
        text: '존중하는 말, 배려하는 행동이\n',
        style: baseStyle,
      ),
      TextSpan(
        text: '성인지 감수성',
        style: boldStyle,
      ),
      TextSpan(
        text: '의 시작!',
        style: baseStyle,
      ),
    ],
  );
}
