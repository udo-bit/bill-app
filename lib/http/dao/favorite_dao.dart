import 'dart:convert';

import 'package:bil_app/http/request/base_request.dart';
import 'package:bil_app/http/request/cancel_favorite_request.dart';
import 'package:bil_app/http/request/favorite_request.dart';

import '../core/hi_net.dart';

class FavoriteDao {
  static favorite(String vid, bool favorite) async {
    BaseRequest request =
        favorite ? FavoriteRequest() : CancelFavoriteRequest();
    request.pathParams = vid;
    var result = await HiNet.getInstance().fire(request);
    print(json.encode(result));
    return result;
  }
}
