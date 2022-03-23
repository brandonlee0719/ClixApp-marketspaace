import 'package:market_space/model/product_detail_model/product_det_model.dart';
import 'package:market_space/model/recent_product_feedback/recent_product_feedback.dart';
import 'package:market_space/model/shipping_price_model/shipping_price_model.dart';
import 'package:market_space/providers/product_detail_provider/product_detail_provider.dart';

class ProductDetailRepository {
  ProductDetailProvider _productDetailProvider = ProductDetailProvider();

  Future<ProductDetModel> getProduct(int productNum) {
    return _productDetailProvider.getProduct(productNum);
  }

  Future<SellerData> getSellerData(int productNum) async {
    return await _productDetailProvider.getSellerDetails(productNum);
  }

  Future<List<RelatedItems>> getRelatedItems(
      String category, int pageCount) async {
    return await _productDetailProvider.getRelatedItems(category, pageCount);
  }

  Future<List<RecentFeedback>> getRecentFeedback(
      int productNum, int feedbackId) {
    return _productDetailProvider.getRecentFeedback(productNum, feedbackId);
  }

  Future<ShippingPriceModel> calculateShipping(
      int productNum, String zipCode, String country) async {
    return _productDetailProvider.calculateShipping(
        productNum, zipCode, country);
  }
}
