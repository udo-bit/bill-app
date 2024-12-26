import 'package:bil_app/http/core/hi_error.dart';
import 'package:bil_app/http/dao/login_dao.dart';
import 'package:bil_app/widget/login_button.dart';
import 'package:bil_app/widget/login_effect.dart';
import 'package:bil_app/widget/login_input.dart';
import 'package:flutter/material.dart';

import '../util/string_util.dart';
import '../widget/appbar.dart';

class RegisterPage extends StatefulWidget {
  final VoidCallback? onJumpToLogin;

  const RegisterPage({super.key, this.onJumpToLogin});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  bool protect = false;
  bool loginEnable = false;
  String? userName;
  String? password;
  String? rePassword;
  String? imoocId;
  String? orderId;
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
            LoginInput(
              '用户名',
              '输入用户名',
              onChanged: (text) {
                userName = text;
                checkInput();
              },
            ),
            LoginInput(
              "密码",
              '请输入密码',
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
            LoginInput(
              "确认密码",
              '再次输入密码',
              onChanged: (text) {
                rePassword = text;
                checkInput();
              },
              focusChanged: (focus) {
                setState(() {
                  protect = focus;
                });
              },
            ),
            LoginInput(
              "慕课网ID",
              '请输入慕课网用户ID',
              keyboardType: TextInputType.number,
              onChanged: (text) {
                imoocId = text;
                checkInput();
              },
            ),
            LoginInput(
              "订单ID",
              '请输入订单ID',
              keyboardType: TextInputType.number,
              onChanged: (text) {
                orderId = text;
                checkInput();
              },
            ),
            Padding(
                padding: const EdgeInsets.only(left: 20, right: 20, top: 20),
                child: LoginButton(
                  '注册',
                  enable: loginEnable,
                  onChanged: checkParams,
                ))
          ],
        ),
      ),
    );
  }

  loginButton(String s) {
    return InkWell(
      onTap: () {
        if (loginEnable) {
          checkParams();
        } else {
          debugPrint('输入不能为空');
        }
      },
      child: Text(s),
    );
  }

  void checkInput() {
    bool enable;
    if (isNotEmpty(userName) &&
        isNotEmpty(password) &&
        isNotEmpty(rePassword) &&
        isNotEmpty(imoocId) &&
        isNotEmpty(orderId)) {
      enable = true;
    } else {
      enable = false;
    }
    setState(() {
      loginEnable = enable;
    });
  }

  void checkParams() {
    String? tips;
    if (password != rePassword) {
      tips = "两次密码不一致";
    } else if (orderId?.length != 4) {
      tips = '请输入订单号后四位';
    }
    if (tips != null) {
      debugPrint(tips);
      return;
    }
    send();
  }

  void send() async {
    try {
      var result =
          await LoginDao.register(userName!, password!, imoocId!, orderId!);
      if (result['code'] == 0) {
        debugPrint('注册成功');
        if (widget.onJumpToLogin != null) {
          widget.onJumpToLogin!();
        } else {
          debugPrint(result['msg']);
        }
      }
    } on NeedAuth catch (e) {
      debugPrint(e.message);
    } on NeedLogin catch (e) {
      debugPrint(e.message);
    } on HiNetError catch (e) {
      debugPrint(e.message);
    }
  }
}
