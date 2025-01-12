import 'package:bil_app/provider/theme_provider.dart';
import 'package:bil_app/util/color.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class DarkModePage extends StatefulWidget {
  const DarkModePage({super.key});

  @override
  State<DarkModePage> createState() => _DarkModePageState();
}

class _DarkModePageState extends State<DarkModePage> {
  static const _items = [
    {"name": '跟随系统', "mode": ThemeMode.system},
    {"name": '开启', "mode": ThemeMode.dark},
    {"name": '关闭', "mode": ThemeMode.light},
  ];
  late Map<String, dynamic> _currentTheme;

  @override
  void initState() {
    super.initState();
    var themeMode = context.read<ThemeProvider>().getThemeMode();
    for (var element in _items) {
      if (element['mode'] == themeMode) {
        _currentTheme = element;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('夜间模式'),
      ),
      body: ListView.separated(
          itemBuilder: (BuildContext context, int index) {
            return _item(index);
          },
          separatorBuilder: (BuildContext context, int index) =>
              const Divider(),
          itemCount: _items.length),
    );
  }

  Widget _item(int index) {
    var theme = _items[index];
    return InkWell(
      onTap: () {
        _switchTheme(index);
      },
      child: Container(
        alignment: Alignment.centerLeft,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        height: 50,
        child: Row(
          children: <Widget>[
            Expanded(child: Text(theme['name'] as String)),
            Opacity(
              opacity: _currentTheme == theme ? 1 : 0,
              child: const Icon(
                Icons.done,
                color: primary,
              ),
            )
          ],
        ),
      ),
    );
  }

  void _switchTheme(int index) {
    var theme = _items[index];
    context.read<ThemeProvider>().setTheme(theme['mode'] as ThemeMode);
    setState(() {
      _currentTheme = theme;
    });
  }
}
