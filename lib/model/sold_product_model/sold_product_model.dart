class SoldProductModel {
  List<Orders> _orders;

  List<Orders> get orders => _orders;

  SoldProductModel({List<Orders> orders}) {
    _orders = orders;
  }

  SoldProductModel.fromJson(dynamic json) {
    if (json["orders"] != null) {
      _orders = [];
      json["orders"].forEach((v) {
        _orders.add(Orders.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    if (_orders != null) {
      map["orders"] = _orders.map((v) => v.toJson()).toList();
    }
    return map;
  }
}

class Orders {
  String _destAmount;
  String _destCurrency;
  String _description;
  String _fiatCurrency;
  String _fiatPrice;
  String _imgLink;
  String _orderID;
  String _shippingCompany;
  String _shippingStatus;
  List<String> _tags;
  String _title;
  String _trackingNumber;
  bool _trackingSet;

  String get cryptoCheckoutPriceSeller => _destAmount;

  String get cryptoCurrencySeller => _destCurrency;

  String get description => _description;

  String get fiatCurrency => _fiatCurrency;

  String get fiatPrice => _fiatPrice;

  String get imgLink => _imgLink;

  String get orderID => _orderID;

  String get shippingCompany => _shippingCompany;

  String get shippingStatus => _shippingStatus;

  List<String> get tags => _tags;

  String get title => _title;

  String get trackingNumber => _trackingNumber;

  bool get trackingSet => _trackingSet;

  Orders(
      {String destAmount,
      String destCurrency,
      String description,
      String fiatCurrency,
      String fiatPrice,
      String imgLink,
      String orderID,
      String shippingCompany,
      String shippingStatus,
      List<String> tags,
      String title,
      String trackingNumber,
      bool trackingSet}) {
    _destAmount = destAmount;
    _destCurrency = destCurrency;
    _description = description;
    _fiatCurrency = fiatCurrency;
    _fiatPrice = fiatPrice;
    _imgLink = imgLink;
    _orderID = orderID;
    _shippingCompany = shippingCompany;
    _shippingStatus = shippingStatus;
    _tags = tags;
    _title = title;
    _trackingNumber = trackingNumber;
    _trackingSet = trackingSet;
  }

  Orders.fromJson(dynamic json) {
    _destAmount = json["destAmount"];
    _destCurrency = json["destCurrency"];
    _description = json["description"];
    _fiatCurrency = json["fiatCurrency"];
    _fiatPrice = json["fiatPrice"];
    _imgLink = json["imgLink"];
    _orderID = json["orderID"];
    _shippingCompany = json["shippingCompany"];
    _shippingStatus = json["shippingStatus"];
    _tags = json["tags"] != null ? json["tags"].cast<String>() : [];
    _title = json["title"];
    _trackingNumber = json["trackingNumber"];
    _trackingSet = json["trackingSet"];
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map["destAmount"] = _destAmount;
    map["destCurrency"] = _destCurrency;
    map["description"] = _description;
    map["fiatCurrency"] = _fiatCurrency;
    map["fiatPrice"] = _fiatPrice;
    map["imgLink"] = _imgLink;
    map["orderID"] = _orderID;
    map["shippingCompany"] = _shippingCompany;
    map["shippingStatus"] = _shippingStatus;
    map["tags"] = _tags;
    map["title"] = _title;
    map["trackingNumber"] = _trackingNumber;
    map["trackingSet"] = _trackingSet;
    return map;
  }
}
