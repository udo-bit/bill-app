import 'package:bil_app/http/request/base_request.dart';

class VideoDetailRequest extends BaseRequest {
  @override
  HttpMethod httpMethod() {
    return HttpMethod.get;
  }

  @override
  bool needLogin() {
    return true;
  }

  @override
  String path() {
    return 'uapi/fa/detail';
  }
}
