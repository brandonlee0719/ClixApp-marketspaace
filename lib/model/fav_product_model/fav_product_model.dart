import 'package:market_space/model/flash_promo_model/flash_promo_algolia.dart';

class FavProductModel {
  List<FlashPromoAlgoliaObj> _favProductList;

  List<FlashPromoAlgoliaObj> get favProductList => _favProductList;

  set favProductList(List<FlashPromoAlgoliaObj> value) {
    _favProductList = value;
  }

  FavProductModel({List<FlashPromoAlgoliaObj> orders}) {
    _favProductList = orders;
  }
  // FavProductModel.fromJson(dynamic json) {
  //   _favProductList = json["favProduct"];
  //   // _promoNum = json["promoNum"];
  // }
  //
  // Map<String, dynamic> toJson() {
  //   var map = <String, dynamic>{};
  //
  //   if (_favProductList != null) {
  //     map["favProduct"] = _favProductList;
  //   }
  //   // map["promoNum"] = _promoNum;
  //   return map;
  // }
}
