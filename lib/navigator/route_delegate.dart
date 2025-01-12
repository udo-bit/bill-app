import 'package:bil_app/http/dao/login_dao.dart';
import 'package:bil_app/model/video_model.dart';
import 'package:bil_app/navigator/bottom_navigator.dart';
import 'package:bil_app/navigator/hi_navigator.dart';
import 'package:bil_app/page/dark_mode_page.dart';
import 'package:bil_app/page/detail_page.dart';
import 'package:bil_app/page/login_page.dart';
import 'package:bil_app/page/register_page.dart';
import 'package:bil_app/util/toast.dart';
import 'package:flutter/material.dart';

class BiliRouteDelegate extends RouterDelegate<BiliPath>
    with ChangeNotifier, PopNavigatorRouterDelegateMixin<BiliPath> {
  @override
  GlobalKey<NavigatorState> navigatorKey;
  BiliRouteDelegate() : navigatorKey = GlobalKey<NavigatorState>() {
    debugPrint("start...");
    HiNavigator.getInstance().registerRouteJump(
        // 这两个参数是由HiNavigator 传递给 RouteDelete
        RouteJumpListener(onJumpTo: (RouteStatus routeStatus, {Map? args}) {
      _routeStatus = routeStatus;
      if (routeStatus == RouteStatus.detail) {
        videoModel = args!['videoMo'];
      }
      notifyListeners();
    }));
  }
  RouteStatus _routeStatus = RouteStatus.home;
  List<MaterialPage> pages = [];
  VideoModel? videoModel;

  RouteStatus get routeStatus {
    if (_routeStatus != RouteStatus.registration && !hasLogin) {
      return _routeStatus = RouteStatus.login;
    } else if (videoModel != null) {
      return _routeStatus = RouteStatus.detail;
    } else {
      return _routeStatus;
    }
  }

  bool get hasLogin => LoginDao.getBoardingPass() != null;

  @override
  Widget build(BuildContext context) {
    // 查找目标路由在路由堆栈中是否已经存在
    var index = getPageIndex(pages, routeStatus);
    List<MaterialPage> tempPages = pages;
    if (index != -1) {
      // 已经存在，把栈顶到目标页面的元素去掉
      // 也可以根据业务需要，不把目前页面去掉
      tempPages = tempPages.sublist(0, index);
    }
    // 新创建一个页面
    MaterialPage page;
    if (routeStatus == RouteStatus.home) {
      // 如果是去往首页，把堆栈清空再创建
      pages.clear();
      page = pageWrap(const BottomNavigator());
    } else if (routeStatus == RouteStatus.detail) {
      page = pageWrap(DetailPage(videoModel: videoModel!));
    } else if (routeStatus == RouteStatus.darkMode) {
      page = pageWrap(const DarkModePage());
    } else if (routeStatus == RouteStatus.registration) {
      page = pageWrap(RegisterPage(
        onJumpToLogin: () {
          _routeStatus = RouteStatus.login;
          notifyListeners();
        },
      ));
    } else if (routeStatus == RouteStatus.login) {
      page = pageWrap(const LoginPage());
    } else {
      page = MaterialPage(child: Container());
    }

    tempPages = [...tempPages, page];
    // 原先页面和新页面,通知所有的页面监听
    HiNavigator.getInstance().notify(tempPages, pages);
    pages = tempPages;
    return WillPopScope(
        child: Navigator(
          key: navigatorKey,
          pages: pages,
          onPopPage: (Route<dynamic> route, dynamic result) {
            if (route.settings is MaterialPage) {
              if ((route.settings as MaterialPage).child is LoginPage) {
                if (!hasLogin) {
                  showWarnToast('请先登陆');
                  return false;
                }
              }
            }
            var tempPages = [...pages];
            pages.removeLast();
            HiNavigator.getInstance().notify(pages, tempPages);
            if (!route.didPop(result)) {
              debugPrint('到底了！');
              return false;
            }
            return true;
          },
        ),
        onWillPop: () async =>
            !(await navigatorKey.currentState?.maybePop() ?? false));
  }

  @override
  Future<void> setNewRoutePath(BiliPath configuration) async {}
}

class BiliPath {
  final String locate;
  BiliPath.home() : locate = "/";
  BiliPath.detail() : locate = "/detail";
}
