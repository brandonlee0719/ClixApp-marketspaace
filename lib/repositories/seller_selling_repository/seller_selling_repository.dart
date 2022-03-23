import 'package:market_space/model/sell_item_req_model/sell_item_req_model.dart';
import 'package:market_space/providers/seller_selling_provider/seller_selling_provider.dart';

class SellerSellingRepository {
  SellerSellingProvider _sellerSellingProvider = SellerSellingProvider();

  Future<String> sellItem(SellItemReqModel reqModel) async {
    return await _sellerSellingProvider.sellItem(reqModel);
  }
}
