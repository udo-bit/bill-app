import 'package:bil_app/http/core/hi_net.dart';
import 'package:bil_app/http/request/home_request.dart';
import 'package:bil_app/model/home_mo.dart';

class HomeDao {
  static get(String categoryName,
      {int pageIndex = 1, int pageSize = 10}) async {
    HomeRequest request = HomeRequest();
    request.pathParams = categoryName;
    request.add('pageIndex', pageIndex);
    request.add('pageSize', pageSize);
    var result = await HiNet.getInstance().fire(request);
    print("*****");
    print(request.header);
    print("*****");
    return HomeMo.fromJson(result['data']);
  }
}
