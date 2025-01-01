import 'package:bil_app/model/video_model.dart';
import 'package:bil_app/navigator/hi_navigator.dart';
import 'package:bil_app/util/format_util.dart';
import 'package:flutter/material.dart';

import '../util/view_util.dart';

class VideoCard extends StatelessWidget {
  final VideoModel videoModel;
  const VideoCard(
    this.videoModel, {
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
        onTap: () {
          HiNavigator.getInstance()
              .onJumpTo(RouteStatus.detail, args: {"videoMo": videoModel});
        },
        child: SizedBox(
          height: 200,
          child: Card(
            margin: const EdgeInsets.only(left: 4, right: 4, bottom: 8),
            child: ClipRRect(
              clipBehavior: Clip.antiAlias,
              borderRadius: BorderRadius.circular(5),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [_itemImage(context), _infoText()],
              ),
            ),
          ),
        ));
  }

  _itemImage(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Stack(children: [
      cachedImage(videoModel.cover, height: 120, width: size.width / 2),
      Positioned(
        left: 0,
        right: 0,
        bottom: 0,
        child: Container(
          padding: const EdgeInsets.only(left: 8, right: 8, bottom: 3, top: 5),
          decoration: const BoxDecoration(
              gradient: LinearGradient(
                  begin: Alignment.bottomCenter,
                  end: Alignment.topCenter,
                  colors: [Colors.black54, Colors.transparent])),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _iconText(Icons.ondemand_video, videoModel.view),
              _iconText(Icons.favorite_border, videoModel.favorite),
              _iconText(null, videoModel.duration)
            ],
          ),
        ),
      )
    ]);

    return Container();
  }

  _infoText() {
    return Expanded(
        child: Container(
      padding: const EdgeInsets.only(top: 5, left: 8, right: 8, bottom: 5),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            videoModel.title,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(fontSize: 12, color: Colors.black87),
          ),
          _owner()
        ],
      ),
    ));
  }

  _iconText(IconData? icon, int count) {
    String views = "";
    if (icon != null) {
      views = countFormat(count);
    } else {
      views = durationTransform(count);
    }
    return Row(
      children: [
        if (icon != null)
          Icon(
            icon,
            color: Colors.white,
            size: 12,
          ),
        Padding(
          padding: const EdgeInsets.only(left: 3),
          child: Text(
            views,
            style: const TextStyle(color: Colors.white, fontSize: 10),
          ),
        )
      ],
    );
  }

  _owner() {
    var owner = videoModel.owner;
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: cachedImage(owner.face, height: 24, width: 24),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 8),
              child: Text(
                owner.name,
                style: const TextStyle(fontSize: 11, color: Colors.black87),
              ),
            )
          ],
        ),
        const Icon(
          Icons.more_vert_sharp,
          size: 15,
          color: Colors.grey,
        )
      ],
    );
  }
}
