import 'package:flutter/material.dart';
import 'package:gujuek_check_in_flutter/core/constants/color.dart';

class CustomLayout extends StatelessWidget {
  final PreferredSizeWidget? appBar;
  final Widget child;

  const CustomLayout({
    super.key,
    this.appBar,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // 앱 공통 배경/레이아웃
      backgroundColor: GuJuekColor.white,
      resizeToAvoidBottomInset: false,
      appBar: appBar,
      body: child,
    );
  }
}
