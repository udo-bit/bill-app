import 'package:bil_app/page/home_tab_page.dart';
import 'package:flutter/material.dart';

import '../navigator/hi_navigator.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with AutomaticKeepAliveClientMixin, TickerProviderStateMixin {
  var tabs = ["推荐", "热门", "追播", "影视", "搞笑", "日常", "综合", "手机游戏", "短片·手书·配音"];

  RouteChangeListener? listener;
  late TabController _controller;
  @override
  void initState() {
    super.initState();
    // 页面第一次加载时，将监听加入到列表中
    HiNavigator.getInstance().addListener((current, pre) {
      debugPrint('home: current: ${current.page}');
      debugPrint('home: pre: ${pre?.page}');
    });
    _controller = TabController(length: tabs.length, vsync: this);
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
            children: tabs.map<HomeTabPage>((tab) {
              return HomeTabPage(name: tab);
            }).toList(),
          ))
        ],
      ),
    );
  }

  _tabBar() {
    return TabBar(
      isScrollable: true,
      tabAlignment: TabAlignment.start,
      labelColor: Colors.black,
      tabs: tabs.map<Tab>((tab) {
        return Tab(
          child: Padding(
            padding: const EdgeInsets.only(left: 5, right: 5),
            child: Text(
              tab,
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
