import 'dart:io';

import 'package:bil_app/model/video_model.dart';
import 'package:bil_app/widget/appbar.dart';
import 'package:bil_app/widget/expandable_content.dart';
import 'package:bil_app/widget/hi_tab.dart';
import 'package:bil_app/widget/navigation_bar_plus.dart';
import 'package:bil_app/widget/video_view.dart';
import 'package:flutter/material.dart';

import '../widget/video_header.dart';

class DetailPage extends StatefulWidget {
  final VideoModel videoModel;
  const DetailPage({super.key, required this.videoModel});

  @override
  State<DetailPage> createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> with TickerProviderStateMixin {
  late TabController tabController;
  List tabs = ['简介', '评论288'];

  @override
  void initState() {
    super.initState();
    tabController = TabController(length: tabs.length, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: MediaQuery.removePadding(
        context: context,
        removeTop: Platform.isIOS,
        child: Column(
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
              children: [
                _buildDetailList(),
                Container(
                  child: const Text('敬请期待。。。'),
                )
              ],
            )),
          ],
        ),
      ),
    );
  }

  _buildVideoView() {
    var model = widget.videoModel;
    return VideoView(
      widget.videoModel.url!,
      cover: model.cover,
      overlayUi: videoAppBar(),
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
              const Padding(
                padding: EdgeInsets.only(right: 20),
                child: Icon(
                  Icons.live_tv_rounded,
                  color: Colors.grey,
                ),
              )
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
        const SizedBox(
          height: 500,
          child: Placeholder(),
        )
      ],
    );
  }

  buildContents() {
    return [
      VideoHeader(
        owner: widget.videoModel.owner,
      ),
      ExpandableContent(mo: widget.videoModel),
    ];
  }
}
