import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

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
      backgroundColor: Colors.white,
      appBar: appBar,
      body: child,
    );
  }
}
