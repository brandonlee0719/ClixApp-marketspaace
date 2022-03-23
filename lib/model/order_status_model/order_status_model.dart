class OrderStatusModel {
  String _orderStatus;
  String _shippingCompany;
  String _trackingNumber;

  String get orderStatus => _orderStatus;
  String get shippingCompany => _shippingCompany;
  String get trackingNumber => _trackingNumber;

  OrderStatusModel(
      {String orderStatus, String shippingCompany, String trackingNumber}) {
    _orderStatus = orderStatus;
    _shippingCompany = shippingCompany;
    _trackingNumber = trackingNumber;
  }

  OrderStatusModel.fromJson(dynamic json) {
    _orderStatus = json["orderStatus"];
    _shippingCompany = json["shippingCompany"];
    _trackingNumber = json["trackingNumber"];
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map["orderStatus"] = _orderStatus;
    map["shippingCompany"] = _shippingCompany;
    map["trackingNumber"] = _trackingNumber;
    return map;
  }
}
