import 'package:bil_app/http/request/favorite_request.dart';

import 'base_request.dart';

class CancelFavoriteRequest extends FavoriteRequest {
  @override
  HttpMethod httpMethod() {
    return HttpMethod.delete;
  }
}
