import 'package:flutter/cupertino.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gujuek_check_in_flutter/core/constants/color.dart';

class CircleBackground extends StatelessWidget {
  const CircleBackground({super.key});

  @override
  Widget build(BuildContext context) {
    // 배경 장식 원들을 겹쳐 배치
    return Stack(
      children: buildCircles(),
    );
  }

  List<Widget> buildCircles() {
    // 위치/색상/크기를 리스트로 관리
    return [
      _buildCircles(GuJuekColor.skyBlue, 124, left: 248, top: -50),
      _buildCircles(GuJuekColor.blue, 493, left: -211, top: -268),
      _buildCircles(GuJuekColor.yellow, 181, left: -127, top: 152),
      _buildCircles(GuJuekColor.red, 53, left: 298, top: 80),
      _buildCircles(GuJuekColor.skyBlue, 28, left: 399, top: 26),
      _buildCircles(GuJuekColor.purple, 87, left: 188, top: 187),
      _buildCircles(GuJuekColor.green, 61, left: 76, top: 243),
      _buildCircles(GuJuekColor.skyBlue, 53, left: 178, top: 304),
      _buildCircles(GuJuekColor.skyBlue, 28, left: 54, top: 343),
      _buildCircles(GuJuekColor.purple, 28, left: 586, top: 48),
      
      _buildCircles(GuJuekColor.skyBlue, 136, right: 128, top: 12),
      _buildCircles(GuJuekColor.yellow, 53, right: 20, top: 74),
      _buildCircles(GuJuekColor.green, 61, right: 64, top: 194),
      _buildCircles(GuJuekColor.red, 53, right: 332, top: 21),
      _buildCircles(GuJuekColor.skyBlue, 28, right: 543, top: 26),
    ];
  }

  Widget _buildCircles(
    Color color,
    double size, {
    double? left,
    double? top,
    double? right,
    double? bottom,
  }) {
    return Positioned(
      left: left?.w,
      right: right?.w,
      top: top?.h,
      bottom: bottom?.h,
      child: Container(
        width: size.w,
        height: size.h,
        decoration: BoxDecoration(
          color: color.withOpacity(1),
          shape: BoxShape.circle,
        ),
      ),
    );
  }
}
