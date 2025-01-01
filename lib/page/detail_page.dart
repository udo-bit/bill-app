import 'package:bil_app/model/video_model.dart';
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
      appBar: AppBar(),
      body: Column(
        children: [
          Text(widget.videoModel.vid),
          Text(widget.videoModel.title),
          VideoView(widget.videoModel.url!, cover: widget.videoModel.cover)
        ],
      ),
    );
  }
}
