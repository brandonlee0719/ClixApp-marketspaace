

import 'package:market_space/recently_brought_details/widgets/addressDetialWidget.dart';

class IShippingProvider{
  // ignore: missing_return
  Future<ShippingDetail> getDetail(String orderNum){

  }

  // ignore: missing_return
  Future<int> uploadShipping(ShippingDetail detail){

  }
}

class MockShippingProvider implements IShippingProvider{
  @override
  Future<ShippingDetail> getDetail(String orderNum) async{
    await Future.delayed(Duration(seconds: 4));
    // return ShippingDetail("AU post", "jccjsdjnvc9r893_vnfv92e83");
    return null;
  }

  @override
  Future<int> uploadShipping(ShippingDetail detail) async {
    return 200;
  }

}