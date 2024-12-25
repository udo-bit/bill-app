import 'package:bil_app/widget/login_effect.dart';
import 'package:bil_app/widget/login_input.dart';
import 'package:flutter/material.dart';

import '../widget/appbar.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  bool protect = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar('注册', '登陆', () {
        debugPrint('right button click.');
      }),
      body: Container(
        child: ListView(
          children: [
            LoginEffect(protect: protect),
            const LoginInput(
              '用户名',
              '输入用户名',
            ),
            LoginInput(
              "密码",
              '请输入密码',
              lineStretch: true,
              focusChanged: (focus) {
                setState(() {
                  protect = focus;
                });
              },
            )
          ],
        ),
      ),
    );
  }
}
