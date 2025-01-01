import 'package:flutter/material.dart';

enum StatusStyle { lightContent, dartContent }

class NavigationBarPlus extends StatelessWidget {
  final double height;
  final StatusStyle statusStyle;
  final Color color;
  final Widget child;
  const NavigationBarPlus(
      {super.key,
      this.height = 46,
      this.statusStyle = StatusStyle.dartContent,
      this.color = Colors.white,
      required this.child});

  @override
  Widget build(BuildContext context) {
    final top = MediaQuery.of(context).padding.top;
    return Container(
      width: MediaQuery.of(context).size.width,
      height: top + height,
      padding: EdgeInsets.only(top: top),
      decoration: BoxDecoration(color: color),
      child: child,
    );
  }
}
