import 'package:flutter/foundation.dart';

import '../request/base_request.dart';
import 'dio_adapter.dart';
import 'hi_error.dart';
import 'hi_net_adapter.dart';

class HiNet {
  HiNet._();
  static HiNet? _instance;
  static HiNet getInstance() {
    _instance ??= HiNet._();
    return _instance!;
  }

  Future fire(BaseRequest request) async {
    HiNetResponse? response;
    dynamic error;
    try {
      response = await send(request);
    } on HiNetError catch (e) {
      error = e;
      response = e.data;
    } catch (e) {
      error = e;
    }
    if (response == null) {
      printLog(error);
    }
    var result = response?.data;
    var status = response?.status;
    switch (status) {
      case 200:
        return result;
      case 401:
        throw NeedLogin();
      case 403:
        throw NeedAuth(response.toString(), data: result);
      default:
        throw HiNetError(status ?? -1, result.toString(), data: result);
    }
  }

  Future<HiNetResponse<T>> send<T>(BaseRequest request) {
    HiNetAdapter adapter = DioAdapter();
    return adapter.send(request);
  }

  void printLog(dynamic log) {
    debugPrint('HiNet:${log.toString()}');
  }
}
