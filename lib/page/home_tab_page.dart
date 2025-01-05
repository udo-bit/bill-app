import 'package:bil_app/core/hi_base_tab_state.dart';
import 'package:bil_app/http/dao/home_dao.dart';
import 'package:bil_app/model/video_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

import '../model/home_mo.dart';
import '../widget/hi_banner.dart';
import '../widget/video_card.dart';

class HomeTabPage extends StatefulWidget {
  final String categoryName;
  final List<BannerMo>? bannerList;

  const HomeTabPage(this.categoryName, {super.key, this.bannerList});

  @override
  State<HomeTabPage> createState() => _HomeTabPageState();
}

class _HomeTabPageState
    extends HiBaseTabState<HomeMo, VideoModel, HomeTabPage> {
  @override
  void initState() {
    super.initState();
    debugPrint(widget.categoryName);
    debugPrint("${widget.bannerList}");
  }

  @override
  bool get wantKeepAlive => true;

  _banner() {
    return Padding(
      padding: const EdgeInsets.only(left: 5, right: 5, top: 2),
      child: HiBanner(widget.bannerList!),
    );
  }

  @override
  get contentChild => StaggeredGridView.countBuilder(
        controller: controller,
        itemCount: dataList.length,
        crossAxisCount: 2,
        itemBuilder: (BuildContext context, int index) {
          if (index == 0 && widget.bannerList != null) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: _banner(),
            );
          } else {
            return VideoCard(dataList[index]);
          }
        },
        staggeredTileBuilder: (int index) {
          if (index == 0 && widget.bannerList != null) {
            return const StaggeredTile.fit(2);
          }
          return const StaggeredTile.fit(1);
        },
      );

  @override
  Future<HomeMo> getData(int pageIndex) async {
    var result = await HomeDao.get(widget.categoryName,
        pageIndex: pageIndex, pageSize: 10);
    return result;
  }

  @override
  List<VideoModel> parseList(result) {
    return result.videoList;
  }
}
