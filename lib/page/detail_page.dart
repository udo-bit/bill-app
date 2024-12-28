import 'package:bil_app/model/video_model.dart';
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
      body: Text("vid: ${widget.videoModel.vid}"),
    );
  }
}
