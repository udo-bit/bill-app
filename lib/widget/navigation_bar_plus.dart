import 'package:bil_app/provider/theme_provider.dart';
import 'package:bil_app/util/color.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

enum StatusStyle { lightContent, dartContent }

class NavigationBarPlus extends StatelessWidget {
  final double height;
  final StatusStyle statusStyle;
  final Color color;
  final Widget? child;
  const NavigationBarPlus(
      {super.key,
      this.height = 55,
      this.statusStyle = StatusStyle.dartContent,
      this.color = Colors.white,
      this.child});

  @override
  Widget build(BuildContext context) {
    var themeProvider = context.watch<ThemeProvider>();
    Color _bgColor = themeProvider.isDark() ? HiColor.dark_bg : color;
    final top = MediaQuery.of(context).padding.top;
    print("top:$top");
    return Container(
      width: MediaQuery.of(context).size.width,
      height: top + height,
      padding: EdgeInsets.only(top: top),
      decoration: BoxDecoration(color: _bgColor),
      child: child,
    );
  }
}
