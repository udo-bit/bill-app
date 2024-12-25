import 'package:bil_app/db/hi_cache.dart';
import 'package:bil_app/http/core/hi_net.dart';
import 'package:bil_app/http/request/base_request.dart';
import 'package:bil_app/http/request/login_request.dart';
import 'package:bil_app/http/request/register_request.dart';

class LoginDao {
  static const BOARDING_PASS = 'boarding-pass';
  static login(String userName, String password) {
    return _send(userName, password);
  }

  static register(
      String userName, String password, String imoocId, String orderId) {
    return _send(userName, password, imoocId: imoocId, orderId: orderId);
  }

  static _send(String userName, String password,
      {String? imoocId, String? orderId}) async {
    BaseRequest request;
    if (imoocId != null && orderId != null) {
      request = RegisterRequest();
    } else {
      request = LoginRequest();
    }
    // 添加参数
    request
        .add("userName", userName)
        .add('password', password)
        .add('imoocId', imoocId ?? "")
        .add('orderId', orderId ?? "");
    // 发送请求
    var result = await HiNet.getInstance().fire(request);
    if (result['code'] == 0 && result['data'] != null) {
      HiCache.getInstance().setString(BOARDING_PASS, result['data']);
    }
  }

  static getBoardingPass() {
    return HiCache.getInstance().get(BOARDING_PASS);
  }
}
