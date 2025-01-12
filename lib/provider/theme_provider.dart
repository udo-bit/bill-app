import 'dart:ui';

import 'package:bil_app/db/hi_cache.dart';
import 'package:bil_app/util/color.dart';
import 'package:bil_app/util/hi_constants.dart';
import 'package:flutter/material.dart';

extension ThemeModeExtension on ThemeMode {
  String get value => <String>['System', 'Light', 'Dark'][index];
}

class ThemeProvider extends ChangeNotifier {
  ThemeMode? _themeMode;
  var _platformBrightness = PlatformDispatcher.instance.platformBrightness;

  void darkModeChange() {
    if (_platformBrightness != PlatformDispatcher.instance.platformBrightness) {
      _platformBrightness = PlatformDispatcher.instance.platformBrightness;
      // setTheme(_platformBrightness == Brightness.dark
      //     ? ThemeMode.dark
      //     : ThemeMode.light);
      notifyListeners();
    }
  }

  // 获取主题模式
  ThemeMode getThemeMode() {
    String? theme = HiCache.getInstance().get(HiConstants.theme);
    switch (theme) {
      case 'Dark':
        _themeMode = ThemeMode.dark;
        break;
      case 'System':
        _themeMode = ThemeMode.system;
        break;
      default:
        _themeMode = ThemeMode.light;
        break;
    }
    return _themeMode!;
  }

  bool isDark() {
    if (_themeMode == ThemeMode.system) {
      return PlatformDispatcher.instance.platformBrightness == Brightness.dark;
    }
    return _themeMode == ThemeMode.dark;
  }

  //设置主题模式
  void setTheme(ThemeMode themeMode) {
    HiCache.getInstance().setString(HiConstants.theme, themeMode.value);
    notifyListeners();
  }

  // 设置主题
  ThemeData getTheme({bool isDarkMode = false}) {
    var themeData = ThemeData(
        brightness: isDarkMode ? Brightness.dark : Brightness.light,
        primaryColor: isDarkMode ? HiColor.dark_bg : white,
        indicatorColor: isDarkMode ? primary[50] : white,
        scaffoldBackgroundColor: isDarkMode ? HiColor.dark_bg : white);
    return themeData;
  }
}
