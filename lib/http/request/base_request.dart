import 'package:bil_app/http/dao/login_dao.dart';

enum HttpMethod { get, post, delete }

abstract class BaseRequest {
  var ustHttps = true;
  // 路径参数
  String? pathParams;
  // 查询参数
  Map<String, String> params = {};
  // header参数
  Map<String, dynamic> header = {
    'course-flag': 'fa',
    'auth-token': 'ZmEtMjAyMS0wNC0xMiAyMToyMjoyMC1mYQ==fa'
  };

  HttpMethod httpMethod();

  // 域名
  String authority() {
    return 'api.devio.org';
  }

  // 路径-抽象方法
  String path();

  String url() {
    Uri uri;
    var pathStr = path();
    if (pathParams != null) {
      if (pathStr.endsWith('/')) {
        pathStr = "$pathStr$pathParams";
      } else {
        pathStr = "$pathStr/$pathParams";
      }
    }
    if (ustHttps) {
      uri = Uri.https(authority(), pathStr, params);
    } else {
      uri = Uri.http(authority(), pathStr, params);
    }
    if (needLogin()) {
      addHeader(LoginDao.BOARDING_PASS, LoginDao.getBoardingPass());
    }

    return uri.toString();
  }

  // 是否需要登陆-抽象方法
  bool needLogin();

  BaseRequest add(String k, dynamic v) {
    params[k] = v.toString();
    return this;
  }

  BaseRequest addHeader(String k, dynamic v) {
    header[k] = v.toString();
    return this;
  }
}
