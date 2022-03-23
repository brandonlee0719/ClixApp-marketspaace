class RecentlyBroughtModel {
  List<RecentlyBrought> _orders;

  List<RecentlyBrought> get orders => _orders;

  RecentlyBroughtModel({List<RecentlyBrought> orders}) {
    _orders = orders;
  }

  RecentlyBroughtModel.fromJson(dynamic json) {
    // print('but we here?');
    if (json["orders"] != null) {
      _orders = [];
      json["orders"].forEach((v) {
        // print(RecentlyBrought.fromJson(v));
        _orders.add(RecentlyBrought.fromJson(v));
      });
    }
    // print("orders at json method: ${_orders.toString()}");
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    if (_orders != null) {
      map["orders"] = _orders.map((v) => v.toJson()).toList();
    }
    return map;
  }
}

class BasicProductModel {
  String _description;
  String get description => _description;
  String _fiatPrice;
  String get fiatPrice => _fiatPrice;
  String _imgLink;
  String get imgLink => _imgLink;
  String _productNumber;
  String get productNumber => _productNumber;
  String _title;
  String get title => _title != null ? _title : 'No title';

  BasicProductModel(this._description, this._fiatPrice, this._imgLink,
      this._productNumber, this._title);
  BasicProductModel.fromJson(dynamic json) {
    _fiatPrice = json["fiatPrice"].toString();
    _imgLink = json["imgLink"];
    _description = json["description"];
    _title = json["title"];
    _productNumber = json["productNumber"];
  }
  set description(String value) {
    _description = value;
  }
}

class RecentlyBrought extends BasicProductModel {
  String _destAmount;
  String _destCurrency;
  String _fiatCurrency;
  String _orderID;
  String _shippingCompany;
  String _shippingStatus;
  List<String> _tags;
  String _trackingNumber;
  bool _trackingSet;

  String get destAmount => _destAmount;
  String get destCurrency => _destCurrency;
  String get description => _description;
  String get fiatCurrency => _fiatCurrency;
  String get orderID => _orderID;
  String get shippingCompany => _shippingCompany;
  String get shippingStatus => _shippingStatus;
  List<String> get tags => _tags;
  String get trackingNumber => _trackingNumber;
  bool get trackingSet => _trackingSet;

  RecentlyBrought() : super('', '', '', '', '');

  // ignore: unnecessary_getters_setters

  RecentlyBrought.fromJson(dynamic json) : super.fromJson(json) {
    _destAmount = json["destAmount"].toString();
    _destCurrency = json["destCurrency"].toString();
    _fiatCurrency = json["fiatCurrency"].toString();
    _orderID = json["orderID"].toString();
    _shippingCompany =
        json["shippingCompany"] != null ? json["shippingCompany"] : "";
    _shippingStatus = json["shippingStatus"];
    _tags = json["tags"] != null ? json["tags"].cast<String>() : [];

    _trackingNumber = json["trackingNumber"] ?? "";
    _trackingSet = json["trackingSet"];
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map["destAmount"] = _destAmount;
    map["destCurrency"] = _destCurrency;
    map["description"] = _description;
    map["fiatCurrency"] = _fiatCurrency;
    map["fiatPrice"] = _fiatPrice;
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
