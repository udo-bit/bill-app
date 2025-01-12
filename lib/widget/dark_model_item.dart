import 'package:bil_app/navigator/hi_navigator.dart';
import 'package:bil_app/provider/theme_provider.dart';
import 'package:bil_app/util/view_util.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class DarkModelItem extends StatelessWidget {
  const DarkModelItem({super.key});

  @override
  Widget build(BuildContext context) {
    var themeProvider = context.watch<ThemeProvider>();
    var icon = themeProvider.isDark()
        ? Icons.nightlight_round
        : Icons.wb_sunny_rounded;
    return InkWell(
      onTap: () {
        HiNavigator.getInstance().onJumpTo(RouteStatus.darkMode);
      },
      child: Container(
        padding: const EdgeInsets.only(top: 10, left: 15, bottom: 15),
        margin: const EdgeInsets.only(top: 15),
        decoration: BoxDecoration(border: borderLine(context)),
        child: Row(
          children: [
            const Text(
              '夜间模式',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            Padding(
                padding: const EdgeInsets.only(top: 2, left: 10),
                child: Icon(icon))
          ],
        ),
      ),
    );
  }
}
