import 'base_request.dart';

class TestRequest extends BaseRequest {
  @override
  bool needLogin() {
    return false;
  }

  @override
  String path() {
    return 'uapi/test/test';
  }

  @override
  HttpMethod httpMethod() {
    return HttpMethod.get;
  }
}
