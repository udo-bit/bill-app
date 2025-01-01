import 'package:bil_app/core/hi_state.dart';
import 'package:bil_app/http/core/hi_error.dart';
import 'package:bil_app/http/dao/home_dao.dart';
import 'package:bil_app/page/home_tab_page.dart';
import 'package:bil_app/util/toast.dart';
import 'package:bil_app/widget/loading_container.dart';
import 'package:bil_app/widget/navigation_bar_plus.dart';
import 'package:flutter/material.dart';

import '../model/home_mo.dart';
import '../navigator/hi_navigator.dart';

class HomePage extends StatefulWidget {
  final ValueChanged<int>? onJumpTo;
  const HomePage({super.key, this.onJumpTo});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends HiState<HomePage>
    with AutomaticKeepAliveClientMixin, TickerProviderStateMixin {
  RouteChangeListener? listener;
  late TabController _controller;
  List<CategoryMo> categoryList = [];
  List<BannerMo> bannerList = [];
  bool _isLoading = true;

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
    super.build(context);
    return Scaffold(
        body: LoadingContainer(
      isLoading: _isLoading,
      cover: true,
      child: Column(
        children: [
          NavigationBarPlus(child: _appBar()),
          Container(
            color: Colors.white,
            child: _tabBar(),
          ),
          Flexible(
              child: Padding(
            padding: const EdgeInsets.only(top: 5, left: 2, right: 2),
            child: TabBarView(
              controller: _controller,
              children: categoryList.map<HomeTabPage>((tab) {
                return HomeTabPage(tab.name,
                    bannerList: tab.name == "推荐" ? bannerList : null);
              }).toList(),
            ),
          ))
        ],
      ),
    ));
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
        _isLoading = false;
      });
    } on NeedAuth catch (e) {
      showWarnToast(e.message);
      setState(() {
        _isLoading = false;
      });
    } on HiNetError catch (e) {
      showWarnToast(e.message);
      setState(() {
        _isLoading = false;
      });
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

  _appBar() {
    return Padding(
      padding: const EdgeInsets.only(left: 15, right: 15),
      child: Row(
        children: [
          InkWell(
            onTap: () {
              if (widget.onJumpTo != null) {
                widget.onJumpTo!(3);
              }
            },
            child: ClipRRect(
              borderRadius: BorderRadius.circular(23),
              child: const Image(
                height: 38,
                width: 38,
                image: AssetImage('images/avatar.png'),
              ),
            ),
          ),
          Expanded(
              child: Padding(
            padding: const EdgeInsets.only(left: 15, right: 15),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: Container(
                padding: const EdgeInsets.only(left: 10),
                height: 32,
                alignment: Alignment.centerLeft,
                decoration: BoxDecoration(color: Colors.grey[100]),
                child: const Icon(
                  Icons.search,
                  color: Colors.grey,
                ),
              ),
            ),
          )),
          const Icon(
            Icons.import_export_outlined,
            color: Colors.grey,
          ),
          const Padding(
              padding: EdgeInsets.only(left: 12),
              child: Icon(
                Icons.mail_outline,
                color: Colors.grey,
              ))
        ],
      ),
    );
  }
}
