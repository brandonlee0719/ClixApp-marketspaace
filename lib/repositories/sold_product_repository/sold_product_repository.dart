import 'package:market_space/model/buyer_info_model/buyer_info_model.dart';
import 'package:market_space/model/seller_option_model/seller_options_model.dart';
import 'package:market_space/model/sold_product_model/sold_product_model.dart';
import 'package:market_space/providers/sold_product_provider/sold_product_provider.dart';

class SoldProductRepository {
  final SoldProductProvider soldProductProvider = SoldProductProvider();

  Future<int> getSoldProducts() {
    return soldProductProvider.getOrders();
  }

  Future<int> updateSellerTracking(String orderId, String shippingCompany,
      String trackingNumber, String shippingDate) {
    return soldProductProvider.updateSellerTracking(
        orderId, shippingCompany, trackingNumber, shippingDate);
  }

  Future<BuyerInfoModel> getBuyerInfo(String orderId) {
    return soldProductProvider.getBuyerInfo(orderId);
  }

  Future<int> cancelOrder(String orderId, String reason, String detail) {
    return soldProductProvider.cancelOrder(orderId, reason, detail);
  }

  Future<int> extendProtection(
      String orderId, String reason, int extensionTime) {
    return soldProductProvider.extendProtection(orderId, reason, extensionTime);
  }

  Future<int> markShippedItem(String orderId, String shippedDate) {
    return soldProductProvider.markItemShipped(orderId, shippedDate);
  }

  Future<SellerOptionsModel> sellerOptions(String orderId) {
    return soldProductProvider.sellerOptions(orderId);
  }

  Future<int> raiseClaim(String orderId, String reason, String detail) {
    return soldProductProvider.raiseClaim(orderId, reason, detail);
  }

  Future<int> leaveFeedback(String orderId, double rating, String comment) {
    return soldProductProvider.leaveFeedback(orderId, rating, comment);
  }
}
