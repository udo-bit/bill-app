import 'dart:io';

import 'package:bil_app/barrage/barrage_input.dart';
import 'package:bil_app/barrage/barrage_switch.dart';
import 'package:bil_app/http/core/hi_error.dart';
import 'package:bil_app/http/dao/favorite_dao.dart';
import 'package:bil_app/http/dao/video_detail_dao.dart';
import 'package:bil_app/model/video_detail_mo.dart';
import 'package:bil_app/model/video_model.dart';
import 'package:bil_app/util/hi_constants.dart';
import 'package:bil_app/util/toast.dart';
import 'package:bil_app/widget/appbar.dart';
import 'package:bil_app/widget/expandable_content.dart';
import 'package:bil_app/widget/hi_tab.dart';
import 'package:bil_app/widget/navigation_bar_plus.dart';
import 'package:bil_app/widget/video_large_card.dart';
import 'package:bil_app/widget/video_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_overlay/flutter_overlay.dart';

import '../barrage/hi_barrage.dart';
import '../widget/video_header.dart';
import '../widget/video_toolbar.dart';

class DetailPage extends StatefulWidget {
  final VideoModel videoModel;
  const DetailPage({super.key, required this.videoModel});

  @override
  State<DetailPage> createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> with TickerProviderStateMixin {
  bool _inoutShowing = false;
  late TabController tabController;
  List tabs = ['简介', '评论288'];
  VideoModel? videoModel;
  VideoDetailMo? videoDetailMo;
  List<VideoModel> videoList = [];
  final _barrageKey = GlobalKey<HiBarrageState>();
  // late HiSocket _hiSocket;

  @override
  void initState() {
    super.initState();
    tabController = TabController(length: tabs.length, vsync: this);
    videoModel = widget.videoModel;
    // _initSocket();
    _loadDetail();
  }

  @override
  void dispose() {
    // _hiSocket.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: MediaQuery.removePadding(
        context: context,
        removeTop: Platform.isIOS,
        child: videoModel?.url != null
            ? Column(
                children: [
                  if (Platform.isIOS)
                    const NavigationBarPlus(
                      color: Colors.black,
                      statusStyle: StatusStyle.lightContent,
                    ),
                  _buildVideoView(),
                  _buildTabNavigation(),
                  Flexible(
                      child: TabBarView(
                    controller: tabController,
                    children: [_buildDetailList(), const Text('敬请期待。。。')],
                  )),
                ],
              )
            : Container(),
      ),
    );
  }

  _buildVideoView() {
    var model = videoModel;
    return VideoView(
      videoModel!.url!,
      cover: model!.cover,
      overlayUi: videoAppBar(),
      barrageUi: HiBarrage(
        key: _barrageKey,
        vid: model.vid,
        autoPlay: true,
        headers: HiConstants.headers(),
      ),
    );
  }

  _buildTabNavigation() {
    return Material(
        elevation: 5,
        shadowColor: Colors.grey[100],
        child: Container(
          alignment: Alignment.centerLeft,
          padding: const EdgeInsets.only(left: 20),
          height: 39,
          color: Colors.white,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _tabBar(),
              _buildBarrageBtn(),
            ],
          ),
        ));
  }

  _tabBar() {
    return HiTab(
      tabs
          .map<Tab>((item) => Tab(
                text: item,
              ))
          .toList(),
      controller: tabController,
    );
  }

  _buildDetailList() {
    return ListView(
      padding: const EdgeInsets.all(0),
      children: [
        ...buildContents(),
        ...buildVideoList(),
      ],
    );
  }

  buildContents() {
    return [
      VideoHeader(
        owner: videoModel!.owner,
      ),
      ExpandableContent(mo: videoModel!),
      VideoToolBar(
        videoModel: videoModel!,
        detailMo: videoDetailMo,
        onLike: _doLike,
        onUnLike: _onUnLike,
        onFavorite: _onFavourite,
      )
    ];
  }

  void _loadDetail() async {
    try {
      VideoDetailMo result = await VideoDetailDao.get(videoModel!.vid);
      setState(() {
        videoDetailMo = result;
        videoModel = result.videoInfo;
        videoList = result.videoList;
      });
    } on NeedAuth catch (e) {
      showWarnToast(e.message);
    } on HiNetError catch (e) {
      print(e);
    }
  }

  void _doLike() {}

  void _onUnLike() {}

  void _onFavourite() async {
    try {
      var result = await FavoriteDao.favorite(
          videoModel!.vid, !videoDetailMo!.isFavorite);
      print(result);
      videoDetailMo!.isFavorite = !videoDetailMo!.isFavorite;
      videoDetailMo!.isFavorite
          ? videoModel!.favorite += 1
          : videoModel!.favorite -= 1;
      setState(() {
        videoModel = videoModel;
        videoDetailMo = videoDetailMo;
      });
      showToast(result['msg']);
    } on NeedAuth catch (e) {
      print(e);
      showWarnToast(e.message);
    } on HiNetError catch (e) {
      print(e);
    }
  }

  buildVideoList() {
    return videoList.map((VideoModel mo) {
      return VideoLargeCard(videoModel: mo);
    }).toList();
  }

  _buildBarrageBtn() {
    return BarrageSwitch(
        inoutShowing: _inoutShowing,
        onShowInput: () {
          setState(() {
            _inoutShowing = true;
          });
          HiOverlay.show(context, child: BarrageInput(onTabClose: () {
            setState(() {
              _inoutShowing = false;
            });
          })).then((value) {
            _barrageKey.currentState?.send(value);
          });
        },
        onBarrageSwitch: (open) {
          if (open) {
            _barrageKey.currentState!.play();
          } else {
            _barrageKey.currentState!.pause();
          }
        });
  }

  // void _initSocket() {
  //   _hiSocket = HiSocket(HiConstants.headers());
  //   _hiSocket.open(videoModel!.vid).listen((value) {
  //     print('接收到：$value');
  //   });
  // }
}
