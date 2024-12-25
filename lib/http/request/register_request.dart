import 'package:bil_app/http/request/base_request.dart';

class RegisterRequest extends BaseRequest {
  @override
  HttpMethod httpMethod() {
    return HttpMethod.post;
  }

  @override
  bool needLogin() {
    return false;
  }

  @override
  String path() {
    return '/uapi/user/registration';
  }
}
