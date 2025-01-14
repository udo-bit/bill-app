import 'package:bil_app/http/dao/ranking_dao.dart';
import 'package:bil_app/page/ranking_tab_page.dart';
import 'package:bil_app/widget/navigation_bar_plus.dart';
import 'package:flutter/material.dart';

import '../widget/hi_tab.dart';

class RankingPage extends StatefulWidget {
  const RankingPage({super.key});

  @override
  State<RankingPage> createState() => _RankingPageState();
}

class _RankingPageState extends State<RankingPage>
    with TickerProviderStateMixin {
  late TabController _controller;
  static const TABS = [
    {"key": "like", "name": "最热"},
    {"key": "pubdate", "name": "最新"},
    {"key": "favorite", "name": "收藏"}
  ];

  @override
  void initState() {
    super.initState();
    _controller = TabController(length: TABS.length, vsync: this);
    RankingDao.get("like");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [_buildNavigationBar(), _buildTabView()],
      ),
    );
  }

  _buildNavigationBar() {
    return NavigationBarPlus(
      child: Container(
        child: _tabBar(),
      ),
    );
  }

  _tabBar() {
    return HiTab(
        TABS.map<Tab>((tab) {
          return Tab(
            text: tab['name'],
          );
        }).toList(),
        fontSize: 16,
        borderWidth: 3,
        unselectedLabelColor: Colors.black54,
        controller: _controller);
  }

  _buildTabView() {
    return Flexible(
        child: TabBarView(
      controller: _controller,
      children: TABS.map((tab) {
        return RankingTabPage(sort: tab['key']!);
      }).toList(),
    ));
  }
}
