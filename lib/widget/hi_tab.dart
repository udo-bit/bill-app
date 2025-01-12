import 'package:bil_app/provider/theme_provider.dart';
import 'package:bil_app/util/color.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HiTab extends StatelessWidget {
  final List<Widget> tabs;
  final TabController? controller;
  final double fontSize;
  final double borderWidth;
  final double insets;
  final Color unselectedLabelColor;
  const HiTab(this.tabs,
      {super.key,
      this.controller,
      this.fontSize = 13,
      this.borderWidth = 2,
      this.insets = 15,
      this.unselectedLabelColor = Colors.grey});

  @override
  Widget build(BuildContext context) {
    var themeProvider = context.watch<ThemeProvider>();
    var _unselectedLabelColor =
        themeProvider.isDark() ? Colors.white70 : unselectedLabelColor;
    return TabBar(
        controller: controller,
        isScrollable: true,
        tabAlignment: TabAlignment.center,
        labelColor: primary,
        unselectedLabelColor: _unselectedLabelColor,
        labelStyle: TextStyle(fontSize: fontSize),
        tabs: tabs);
  }
}
