import 'package:bil_app/core/hi_base_tab_state.dart';
import 'package:bil_app/http/dao/ranking_dao.dart';
import 'package:bil_app/model/ranking_mo.dart';
import 'package:bil_app/model/video_model.dart';
import 'package:bil_app/widget/video_large_card.dart';
import 'package:flutter/material.dart';

class RankingTabPage extends StatefulWidget {
  final String sort;
  const RankingTabPage({super.key, required this.sort});

  @override
  State<RankingTabPage> createState() => _RankingTabPageState();
}

class _RankingTabPageState
    extends HiBaseTabState<RankingMo, VideoModel, RankingTabPage> {
  @override
  get contentChild => ListView.builder(
      controller: controller,
      itemCount: dataList.length,
      itemBuilder: (BuildContext context, int index) {
        return VideoLargeCard(videoModel: dataList[index]);
      });

  @override
  Future<RankingMo> getData(int pageIndex) async {
    var result = await RankingDao.get(widget.sort);
    return result;
  }

  @override
  List<VideoModel> parseList(RankingMo result) {
    return result.list;
  }
}
