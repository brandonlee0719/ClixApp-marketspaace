class ActiveProductModel {
  List<ActiveProducts> _activeProducts;

  List<ActiveProducts> get activeProducts => _activeProducts;

  ActiveProductModel({List<ActiveProducts> activeProducts}) {
    _activeProducts = activeProducts;
  }

  ActiveProductModel.fromJson(dynamic json) {
    if (json["activeProducts"] != null) {
      _activeProducts = [];
      json["activeProducts"].forEach((v) {
        _activeProducts.add(ActiveProducts.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    if (_activeProducts != null) {
      map["activeProducts"] = _activeProducts.map((v) => v.toJson()).toList();
    }
    return map;
  }
}

class ActiveProducts {
  String _cryptoPrice;
  String _fiatPrice;
  String _imgLink;
  int _productNum;
  List<String> _tags;
  String _title;
  String _description;

  String get description => _description;

  String get cryptoPrice => _cryptoPrice;
  String get fiatPrice => _fiatPrice;
  String get imgLink => _imgLink;
  int get productNum => _productNum;
  List<String> get tags => _tags;
  String get title => _title;

  ActiveProducts(
      {String cryptoPrice,
      String fiatPrice,
      String imgLink,
      int productNum,
      List<String> tags,
      String title,
      String description}) {
    _cryptoPrice = cryptoPrice;
    _fiatPrice = fiatPrice;
    _imgLink = imgLink;
    _productNum = productNum;
    _tags = tags;
    _title = title;
    _description = description;
  }

  ActiveProducts.fromJson(dynamic json) {
    _cryptoPrice = json["cryptoPrice"];
    _fiatPrice = json["fiatPrice"];
    _imgLink = json["imgLink"];
    _productNum = json["productNum"];
    _tags = json["tags"] != null ? json["tags"].cast<String>() : [];
    _title = json["title"];
    _description = json["description"];
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map["cryptoPrice"] = _cryptoPrice;
    map["fiatPrice"] = _fiatPrice;
    map["imgLink"] = _imgLink;
    map["productNum"] = _productNum;
    map["tags"] = _tags;
    map["title"] = _title;
    map["description"] = _description;
    return map;
  }
}
