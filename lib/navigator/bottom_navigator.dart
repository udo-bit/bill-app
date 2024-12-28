import 'package:bil_app/navigator/hi_navigator.dart';
import 'package:bil_app/page/favorite_page.dart';
import 'package:bil_app/page/home_page.dart';
import 'package:bil_app/page/profile_page.dart';
import 'package:bil_app/page/ranking_page.dart';
import 'package:bil_app/util/color.dart';
import 'package:flutter/material.dart';

class BottomNavigator extends StatefulWidget {
  const BottomNavigator({super.key});

  @override
  State<BottomNavigator> createState() => _BottomNavigatorState();
}

class _BottomNavigatorState extends State<BottomNavigator> {
  final _defaultColor = Colors.grey;
  final _activeColor = primary;
  static const initialPage = 0;
  final PageController _controller = PageController(initialPage: initialPage);
  int _currentIndex = initialPage;

  bool _hasBuild = false;
  List<Widget> pages = const [
    HomePage(),
    RankingPage(),
    FavoritePage(),
    ProfilePage()
  ];

  @override
  Widget build(BuildContext context) {
    if (!_hasBuild) {
      HiNavigator.getInstance()
          .onBottomTabChange(initialPage, pages[initialPage]);
      _hasBuild = true;
    }

    return Scaffold(
      body: PageView(
        physics: const NeverScrollableScrollPhysics(),
        onPageChanged: (index) => _onJumpTo(index, pageChange: true),
        controller: _controller,
        children: pages,
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) => _onJumpTo(index),
        selectedItemColor: _activeColor,
        type: BottomNavigationBarType.fixed,
        items: [
          buildItems('首页', Icons.home, 0),
          buildItems('排行榜', Icons.local_fire_department, 1),
          buildItems('收藏', Icons.favorite, 2),
          buildItems('我的', Icons.live_tv, 3)
        ],
      ),
    );
  }

  buildItems(String title, IconData icon, int index) {
    return BottomNavigationBarItem(
        icon: Icon(
          icon,
          color: _defaultColor,
          size: 30,
        ),
        activeIcon: Icon(
          icon,
          color: _activeColor,
          size: 30,
        ),
        label: title);
  }

  _onJumpTo(int index, {bool pageChange = false}) {
    if (!pageChange) {
      _controller.jumpToPage(index);
    } else {
      HiNavigator.getInstance().onBottomTabChange(index, pages[index]);
    }

    setState(() {
      _currentIndex = index;
    });
  }
}
