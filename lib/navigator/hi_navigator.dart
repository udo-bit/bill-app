import 'package:bil_app/page/detail_page.dart';
import 'package:bil_app/page/home_page.dart';
import 'package:bil_app/page/login_page.dart';
import 'package:bil_app/page/register_page.dart';
import 'package:flutter/material.dart';

// 封装页面
pageWrap(Widget child) {
  return MaterialPage(child: child, key: ValueKey(child.hashCode));
}

// 路由状态
enum RouteStatus { login, registration, home, detail, unknown }

// 获取routeStatus在路由堆栈中的位置
// 堆栈中存的是页面，路由状态可以看作是地址栏的url
int getPageIndex(List<MaterialPage> pages, RouteStatus routeStatus) {
  for (int i = 0; i < pages.length; i++) {
    MaterialPage page = pages[i];
    if (getStatus(page) == routeStatus) {
      return i;
    }
  }
  return -1;
}

// 根据页面获取对应的路由状态
RouteStatus getStatus(MaterialPage page) {
  if (page.child is LoginPage) {
    return RouteStatus.login;
  } else if (page.child is RegisterPage) {
    return RouteStatus.registration;
  } else if (page.child is HomePage) {
    return RouteStatus.home;
  } else if (page.child is DetailPage) {
    return RouteStatus.detail;
  } else {
    return RouteStatus.unknown;
  }
}

// 将路由和页面封装为对象
class RouteStatusInfo {
  final RouteStatus routeStatus;
  final Widget page;

  RouteStatusInfo(this.routeStatus, this.page);
}

class HiNavigator extends _RouteJumpListener {
  static HiNavigator? _instance;
  HiNavigator._();
  static HiNavigator getInstance() {
    _instance ??= HiNavigator._();
    return _instance!;
    // return _instance ?? HiNavigator._();
  }

  // routeJump初始为空
  RouteJumpListener? _routeJump;

  @override
  void onJumpTo(RouteStatus routeStatus, {Map? args}) {
    _routeJump?.onJumpTo(routeStatus, args: args);
  }

  void registerRouteJump(RouteJumpListener routeJumpListener) {
    debugPrint('在赋值。。。。');
    _routeJump = routeJumpListener;
  }
}

abstract class _RouteJumpListener {
  void onJumpTo(RouteStatus routeStatus, {Map? args});
}

typedef OnJumpTo = void Function(RouteStatus routeStatus, {Map? args});

class RouteJumpListener {
  final OnJumpTo onJumpTo;

  RouteJumpListener({required this.onJumpTo});
}
