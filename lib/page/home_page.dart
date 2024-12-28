import 'package:bil_app/model/video_model.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  final ValueChanged<VideoModel> onJumpToDetail;
  const HomePage({super.key, required this.onJumpToDetail});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Column(
        children: [
          const Text('首页'),
          MaterialButton(
            onPressed: () => widget.onJumpToDetail(VideoModel(111)),
            child: const Text('详情页'),
          )
        ],
      ),
    );
  }
}
