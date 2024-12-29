import 'package:bil_app/core/hi_state.dart';
import 'package:bil_app/http/core/hi_error.dart';
import 'package:bil_app/http/dao/home_dao.dart';
import 'package:bil_app/page/home_tab_page.dart';
import 'package:bil_app/util/toast.dart';
import 'package:flutter/material.dart';

import '../model/home_mo.dart';
import '../navigator/hi_navigator.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends HiState<HomePage>
    with AutomaticKeepAliveClientMixin, TickerProviderStateMixin {
  RouteChangeListener? listener;
  late TabController _controller;
  List<CategoryMo> categoryList = [];
  List<BannerMo> bannerList = [];

  @override
  void initState() {
    super.initState();
    // 页面第一次加载时，将监听加入到列表中
    HiNavigator.getInstance().addListener((current, pre) {
      // debugPrint('home: current: ${current.page}');
      // debugPrint('home: pre: ${pre?.page}');
    });
    _controller = TabController(length: categoryList.length, vsync: this);

    loadData();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double top = MediaQuery.of(context).padding.top;
    super.build(context);
    return Scaffold(
      body: Column(
        children: [
          Container(
            color: Colors.white,
            padding: EdgeInsets.only(top: top),
            child: _tabBar(),
          ),
          Flexible(
              child: TabBarView(
            controller: _controller,
            children: categoryList.map<HomeTabPage>((tab) {
              return HomeTabPage(
                name: tab.name,
                bannerList: bannerList,
              );
            }).toList(),
          ))
        ],
      ),
    );
  }

  void loadData() async {
    try {
      HomeMo result = await HomeDao.get("推荐");
      if (result.categoryList != null) {
        _controller = TabController(
            length: result.categoryList?.length ?? 0, vsync: this);
      }
      setState(() {
        categoryList = result.categoryList ?? [];
        bannerList = result.bannerList ?? [];
      });
    } on NeedAuth catch (e) {
      showWarnToast(e.message);
    } on HiNetError catch (e) {
      showWarnToast(e.message);
    }
  }

  _tabBar() {
    return TabBar(
      isScrollable: true,
      tabAlignment: TabAlignment.start,
      labelColor: Colors.black,
      tabs: categoryList.map<Tab>((tab) {
        return Tab(
          child: Padding(
            padding: const EdgeInsets.only(left: 5, right: 5),
            child: Text(
              tab.name,
              style: const TextStyle(fontSize: 16),
            ),
          ),
        );
      }).toList(),
      controller: _controller,
    );
  }

  @override
  bool get wantKeepAlive => true;
}
