import 'package:bil_app/page/detail_page.dart';
import 'package:bil_app/page/login_page.dart';
import 'package:bil_app/page/register_page.dart';
import 'package:flutter/material.dart';

import 'bottom_navigator.dart';

// 回调函数类型，接收两个参数，是一种数据类型
typedef RouteChangeListener = Function(
    RouteStatusInfo current, RouteStatusInfo? pre);
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
  } else if (page.child is BottomNavigator) {
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
  // 当前的路由信息
  RouteStatusInfo? _current;
  // 维护监听类型的列表
  List<RouteChangeListener> _listeners = [];

  // 底部tab栏
  RouteStatusInfo? _bottomTab;

  @override
  void onJumpTo(RouteStatus routeStatus, {Map? args}) {
    _routeJump?.onJumpTo(routeStatus, args: args);
  }

  // 底部tab切换监听
  void onBottomTabChange(int index, Widget page) {
    // page是真实的页面，此时current.page是什么？
    _bottomTab = RouteStatusInfo(RouteStatus.home, page);
    _notify(_bottomTab!);
  }

  void registerRouteJump(RouteJumpListener routeJumpListener) {
    _routeJump = routeJumpListener;
  }

  /// 监听路由页面跳转
  /// 添加的时机是？
  void addListener(RouteChangeListener listener) {
    if (!_listeners.contains(listener)) {
      _listeners.add(listener);
    }
  }

  /// 移除监听
  void removeListener(RouteChangeListener listener) {
    _listeners.remove(listener);
  }

  /// 通知页面路由变化的函数
  /// 最新的页面堆栈和上一次的页面堆栈
  void notify(List<MaterialPage> currentPages, List<MaterialPage> prePages) {
    if (currentPages == prePages) return;
    var current =
        RouteStatusInfo(getStatus(currentPages.last), currentPages.last.child);
    _notify(current);
  }

  void _notify(RouteStatusInfo current) {
    if (current.page is BottomNavigator && _bottomTab != null) {
      current = _bottomTab!;
    }
    // debugPrint('打开的页面是：${current.page}');
    // debugPrint('之前的页面是：${_current?.page}');
    // 这里的作用是修改每个监听器回调的参数，从而通知每个监听器
    // 每个页面对应每个监听器，并且监听器的实现可以不一样
    // 只保证了监听器函数的签名是一样的
    for (var listener in _listeners) {
      listener(current, _current);
    }
    _current = current;
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
