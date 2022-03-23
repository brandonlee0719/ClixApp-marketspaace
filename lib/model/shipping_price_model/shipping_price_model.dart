class ShippingPriceModel {
  String _deliveryTime;
  String _price;
  String _shippingOption;

  String get deliveryTime => _deliveryTime;
  String get price => _price;
  String get shippingOption => _shippingOption;

  ShippingPriceModel(
      {String deliveryTime, String price, String shippingOption}) {
    _deliveryTime = deliveryTime;
    _price = price;
    _shippingOption = shippingOption;
  }

  ShippingPriceModel.fromJson(dynamic json) {
    _deliveryTime = json["deliveryTime"];
    _price = json["price"];
    _shippingOption = json["shippingOption"];
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map["deliveryTime"] = _deliveryTime;
    map["price"] = _price;
    map["shippingOption"] = _shippingOption;
    return map;
  }
}
