import 'package:flutter/material.dart';

import '../model/video_detail_mo.dart';
import '../model/video_model.dart';
import '../util/color.dart';
import '../util/format_util.dart';
import '../util/view_util.dart';

///视频点赞分享收藏等工具栏
class VideoToolBar extends StatelessWidget {
  final VideoDetailMo? detailMo;
  final VideoModel videoModel;
  final VoidCallback? onLike;
  final VoidCallback? onUnLike;
  final VoidCallback? onCoin;
  final VoidCallback? onFavorite;
  final VoidCallback? onShare;

  const VideoToolBar(
      {Key? key,
      this.detailMo,
      required this.videoModel,
      this.onLike,
      this.onUnLike,
      this.onCoin,
      this.onFavorite,
      this.onShare})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(top: 15, bottom: 10),
      decoration: BoxDecoration(border: borderLine(context)),
      margin: const EdgeInsets.only(bottom: 15),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildIconText(Icons.thumb_up_alt_rounded, videoModel.like,
              onClick: onLike, tint: detailMo?.isLike ?? false),
          _buildIconText(Icons.thumb_down_alt_rounded, '不喜欢',
              onClick: onUnLike),
          _buildIconText(Icons.monetization_on, videoModel.coin,
              onClick: onCoin),
          _buildIconText(Icons.grade_rounded, videoModel.favorite,
              onClick: onFavorite, tint: detailMo?.isFavorite ?? false),
          _buildIconText(Icons.share_rounded, videoModel.share,
              onClick: onShare),
        ],
      ),
    );
  }

  _buildIconText(IconData iconData, text, {onClick, bool tint = false}) {
    if (text is int) {
      //显示格式化
      text = countFormat(text);
    } else if (text == null) {
      text = '';
    }
    tint = tint == null ? false : tint;
    return InkWell(
      onTap: onClick,
      child: Column(
        children: [
          Icon(
            iconData,
            color: tint ? primary : Colors.grey,
            size: 20,
          ),
          hiSpace(height: 5),
          Text(text, style: TextStyle(color: Colors.grey, fontSize: 12))
        ],
      ),
    );
  }
}
