import 'package:bil_app/util/view_util.dart';
import 'package:bil_app/widget/hi_video_controls.dart';
import 'package:chewie/chewie.dart' hide MaterialControls;
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

import '../util/color.dart';

class VideoView extends StatefulWidget {
  final String url;
  final String cover;
  final bool autoPlay;
  final bool looping;
  final double aspectRatio;
  final Widget? overlayUi;
  final Widget? barrageUi;

  const VideoView(this.url,
      {super.key,
      required this.cover,
      this.autoPlay = false,
      this.looping = false,
      this.aspectRatio = 16 / 9,
      this.overlayUi,
      this.barrageUi});

  @override
  State<VideoView> createState() => _VideoViewState();
}

class _VideoViewState extends State<VideoView> {
  late ChewieController _chewieController;
  late VideoPlayerController _videoPlayerController;

  get _placeholder => FractionallySizedBox(
        widthFactor: 1,
        child: cachedImage(widget.cover),
      );

  get _progressColors => ChewieProgressColors(
      playedColor: primary,
      handleColor: primary,
      backgroundColor: Colors.grey,
      bufferedColor: primary[50]!);

  @override
  void initState() {
    super.initState();
    _videoPlayerController =
        VideoPlayerController.networkUrl(Uri.parse(widget.url));

    _chewieController = ChewieController(
      videoPlayerController: _videoPlayerController,
      autoPlay: widget.autoPlay,
      looping: widget.autoPlay,
      aspectRatio: widget.aspectRatio,
      placeholder: _placeholder,
      allowMuting: false,
      allowPlaybackSpeedChanging: false,
      customControls: MaterialControls(
        showLoadingOnInitialize: false,
        showBigPlayIcon: false,
        bottomGradient: blackLinearGradient(fromTop: false),
        overlayUI: widget.overlayUi,
        barrageUI: widget.barrageUi,
      ),
      materialProgressColors: _progressColors,
    );
    _chewieController.addListener(_handleOrientation);
  }

  @override
  void dispose() {
    _chewieController.removeListener(_handleOrientation);
    _videoPlayerController.dispose();
    _chewieController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double playerHeight = screenWidth / widget.aspectRatio;
    return Container(
      width: screenWidth,
      height: playerHeight,
      color: Colors.grey,
      child: Chewie(
        controller: _chewieController,
      ),
    );
  }

  void _handleOrientation() {
    Size size = MediaQuery.of(context).size;
    if (size.width > size.height) {}
  }
}
