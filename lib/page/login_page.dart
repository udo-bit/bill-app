import 'package:bil_app/navigator/hi_navigator.dart';
import 'package:bil_app/util/toast.dart';
import 'package:bil_app/widget/appbar.dart';
import 'package:bil_app/widget/login_button.dart';
import 'package:bil_app/widget/login_effect.dart';
import 'package:bil_app/widget/login_input.dart';
import 'package:flutter/material.dart';

import '../http/core/hi_error.dart';
import '../http/dao/login_dao.dart';
import '../util/string_util.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool protect = false;
  bool loginEnable = false;
  String? userName;
  String? password;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar('账号密码登陆', '注册', () {
        HiNavigator.getInstance().onJumpTo(RouteStatus.registration);
      }),
      body: Container(
        child: ListView(
          children: [
            LoginEffect(protect: protect),
            LoginInput(
              '用户名',
              '请输入用户名',
              onChanged: (text) {
                userName = text;
                checkInput();
              },
            ),
            LoginInput(
              '密码',
              '请输入密码',
              obscureText: true,
              onChanged: (text) {
                password = text;
                checkInput();
              },
              focusChanged: (focus) {
                setState(() {
                  protect = focus;
                });
              },
            ),
            Padding(
              padding: const EdgeInsets.only(left: 20, right: 20, top: 20),
              child: LoginButton(
                '登陆',
                enable: loginEnable,
                onChanged: send,
              ),
            )
          ],
        ),
      ),
    );
  }

  void checkInput() {
    bool enable;
    if (isNotEmpty(userName) && isNotEmpty(password)) {
      enable = true;
    } else {
      enable = false;
    }
    setState(() {
      loginEnable = enable;
    });
  }

  void send() async {
    try {
      var result = await LoginDao.login(userName!, password!);
      if (result['code'] == 0) {
        showToast("登陆成功");
        HiNavigator.getInstance().onJumpTo(RouteStatus.home);
        // 跳转首页
      } else {
        showWarnToast(result['msg']);
      }
    } on NeedAuth catch (e) {
      showWarnToast(e.message);
    } on NeedLogin catch (e) {
      showWarnToast(e.message);
    } on HiNetError catch (e) {
      showWarnToast(e.message);
    } catch (e) {
      showWarnToast('登陆失败');
    }
  }
}
