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
      backgroundColor: GuJuekColor.white,
      appBar: appBar,
      body: Container(
        width: double.infinity,
        height: double.infinity,
        color: GuJuekColor.white,
        child: child,
      ),
    );
  }
}