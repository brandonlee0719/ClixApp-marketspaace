import 'package:dio/dio.dart';
import 'package:market_space/providers/marketSpaaceParentProvider.dart';

class CancelOrderProvider extends MarketSpaceParentProvider {
  Future<void> requestRefund(String orderId) async {
    // print("A request of refund is raised");
    Response res = await post("/refund_order", {
      "orderID": orderId,
    });
    // print(res.data);
  }

  Future<void> orderOperation(String orderId, String orderSpecialWord) async {
    /// accept special word:
    Response res = await post("/sale_notification_operations",
        {'orderID': orderId, 'orderSpecialWord': orderSpecialWord});
    // print(res.data);
  }

  Future<void> createMediation(
      String sellerId, String buyerId, String orderId) async {
    /// accept special word:
    Response res = await post("/create_mediation_client",
        {'buyerUID': buyerId, 'sellerUID': sellerId, "orderID": orderId});
    // print(res.data);
  }

  Future<void> confirmShipping(String orderId) async {
    Response res = await post("/confirm_item_reception", {'orderID': orderId});
    // print(res.data);
  }

  Future<int> submitCruiseService(
      String orderID, String shipmentDate, String trackingNumber) async {
    try {
      Response res = await post('/update_seller_tracking', {
        "orderID": orderID,
        "shipmentDate": shipmentDate,
        "trackingNumber": trackingNumber,
      });

      return res.statusCode;
    } catch (e) {
      return 500;
    }
  }
}
