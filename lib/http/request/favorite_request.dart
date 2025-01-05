import 'base_request.dart';

class FavoriteRequest extends BaseRequest {
  @override
  HttpMethod httpMethod() {
    return HttpMethod.post;
  }

  @override
  bool needLogin() {
    return true;
  }

  @override
  String path() {
    return 'uapi/fa/favorite';
  }
}
