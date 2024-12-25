import '../request/base_request.dart';
import 'hi_net_adapter.dart';

class MockAdapter extends HiNetAdapter {
  @override
  Future<HiNetResponse<T>> send<T>(BaseRequest request) {
    return Future.delayed(const Duration(milliseconds: 1000), () {
      return HiNetResponse(
          request: request,
          data: {'code': 0, 'message': 'success'} as T,
          status: 401);
    });
  }
}
