import 'package:bil_app/http/core/hi_error.dart';
import 'package:bil_app/http/dao/home_dao.dart';
import 'package:bil_app/util/color.dart';
import 'package:bil_app/util/toast.dart';
import 'package:bil_app/widget/hi_banner.dart';
import 'package:bil_app/widget/video_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

import '../model/home_mo.dart';
import '../model/video_model.dart';

class HomeTabPage extends StatefulWidget {
  final String categoryName;
  final List<BannerMo>? bannerList;
  const HomeTabPage(
    this.categoryName, {
    super.key,
    this.bannerList,
  });

  @override
  State<HomeTabPage> createState() => _HomeTabPageState();
}

class _HomeTabPageState extends State<HomeTabPage>
    with AutomaticKeepAliveClientMixin {
  ScrollController controller = ScrollController();
  bool _loading = false;
  @override
  void initState() {
    super.initState();

    controller.addListener(() {
      var dist =
          controller.position.maxScrollExtent - controller.position.pixels;
      if (dist < 300 && !_loading) {
        _loadData(loadMore: true);
      }
    });

    _loadData();
  }

  List<VideoModel> videoList = [];
  int pageIndex = 1;
  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      body: RefreshIndicator(
        color: primary,
        onRefresh: _loadData,
        child: MediaQuery.removePadding(
            context: context,
            removeTop: true,
            child: StaggeredGridView.countBuilder(
              controller: controller,
              itemCount: videoList.length,
              crossAxisCount: 2,
              itemBuilder: (BuildContext context, int index) {
                if (index == 0 && widget.bannerList != null) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: _banner(),
                  );
                } else {
                  return VideoCard(videoList[index]);
                }
              },
              staggeredTileBuilder: (int index) {
                if (index == 0 && widget.bannerList != null) {
                  return const StaggeredTile.fit(2);
                }
                return const StaggeredTile.fit(1);
              },
            )),
      ),
    );
  }

  _banner() {
    return Padding(
      padding: const EdgeInsets.only(left: 5, right: 5, top: 2),
      child: HiBanner(widget.bannerList!),
    );
  }

  Future<void> _loadData({loadMore = false}) async {
    _loading = true;
    if (!loadMore) {
      pageIndex = 1;
    }
    var currentIndex = pageIndex + (loadMore ? 1 : 0);
    try {
      HomeMo result = await HomeDao.get(widget.categoryName,
          pageIndex: pageIndex, pageSize: 10);
      setState(() {
        if (loadMore) {
          if (result.videoList.isNotEmpty) {
            videoList = [...videoList, ...result.videoList];
            pageIndex++;
          }
        } else {
          videoList = result.videoList;
        }
      });
      Future.delayed(const Duration(milliseconds: 1000), () {
        _loading = false;
      });
    } on NeedAuth catch (e) {
      showWarnToast(e.message);
      _loading = false;
    } on HiNetError catch (e) {
      showWarnToast(e.message);
      _loading = false;
    }
  }

  @override
  bool get wantKeepAlive => true;
}
