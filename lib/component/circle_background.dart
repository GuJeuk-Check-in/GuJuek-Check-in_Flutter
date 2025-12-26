import 'package:flutter/cupertino.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CircleBackground extends StatelessWidget {
  const CircleBackground({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: buildCircles(),
    );
  }

  List<Widget> buildCircles() {
    return [
      _buildCircles(const Color(0xff2ABFEC), 124, left: 248, top: -50),
      _buildCircles(const Color(0xff0F50A0), 493, left: -211, top: -268),
      _buildCircles(const Color(0xffFBBC18), 181, left: -127, top: 152),
      _buildCircles(const Color(0xffE6222C), 53, left: 298, top: 80),
      _buildCircles(const Color(0xff2BBDEC), 28, left: 399, top: 26),
      _buildCircles(const Color(0xffA1298C), 87, left: 188, top: 187),
      _buildCircles(const Color(0xff17A753), 61, left: 76, top: 243),
      _buildCircles(const Color(0xff2BBDEC), 53, left: 178, top: 304),
      _buildCircles(const Color(0xff2BBDEC), 28, left: 54, top: 343),
      _buildCircles(const Color(0xffA1298C), 28, left: 586, top: 48),
      
      _buildCircles(const Color(0xff2ABFEC), 136, right: 128, top: 12),
      _buildCircles(const Color(0xffFBBC18), 53, right: 20, top: 74),
      _buildCircles(const Color(0xff17A753), 61, right: 64, top: 194),
      _buildCircles(const Color(0xffE8232C), 53, right: 332, top: 21),
      _buildCircles(const Color(0xff2BBDEC), 28, right: 543, top: 26),
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
