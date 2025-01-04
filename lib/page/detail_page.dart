import 'dart:io';

import 'package:bil_app/model/video_model.dart';
import 'package:bil_app/widget/appbar.dart';
import 'package:bil_app/widget/navigation_bar_plus.dart';
import 'package:bil_app/widget/video_view.dart';
import 'package:flutter/material.dart';

class DetailPage extends StatefulWidget {
  final VideoModel videoModel;
  const DetailPage({super.key, required this.videoModel});

  @override
  State<DetailPage> createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
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
            _videoView(),
            Text(widget.videoModel.vid),
            Text(widget.videoModel.title),
          ],
        ),
      ),
    );
  }

  _videoView() {
    var model = widget.videoModel;
    return VideoView(
      widget.videoModel.url!,
      cover: model.cover,
      overlayUi: videoAppBar(),
    );
  }
}
