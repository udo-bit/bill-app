import 'package:bil_app/http/request/video_detail_request.dart';
import 'package:bil_app/model/video_detail_mo.dart';

import '../core/hi_net.dart';

class VideoDetailDao {
  static get(String vid) async {
    VideoDetailRequest request = VideoDetailRequest();
    request.pathParams = vid;
    var result = await HiNet.getInstance().fire(request);
    return VideoDetailMo.fromJson(result['data']);
  }
}
