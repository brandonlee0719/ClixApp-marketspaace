class ProductModel {
  List<Products> _products;

  List<Products> get products => _products;

  ProductModel({List<Products> products}) {
    _products = products;
  }

  ProductModel.fromJson(dynamic json) {
    if (json["products"] != null) {
      _products = [];
      json["products"].forEach((v) {
        _products.add(Products.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    if (_products != null) {
      map["products"] = _products.map((v) => v.toJson()).toList();
    }
    return map;
  }
}

class Products {
  String _category;
  String _cryptoPrice;
  String _imgURL;
  String _likedItem;
  String _price;
  String _productName;
  String _productNum;
  int _promoNum;
  List<dynamic> _tags;
  bool _loadFav;

  bool get loadFav => _loadFav;

  set loadFav(bool value) {
    _loadFav = value;
  }

  String get category => _category;
  String get cryptoPrice => _cryptoPrice;
  String get imgURL => _imgURL;
  String get likedItem => _likedItem;
  String get price => _price;
  String get productName => _productName;
  String get productNum => _productNum;
  int get promoNum => _promoNum;
  List<dynamic> get tags => _tags;

  Products(
      {String category,
      String cryptoPrice,
      String imgURL,
      String likedItem,
      String price,
      String productName,
      String productNum,
      int promoNum,
      List<dynamic> tags}) {
    _category = category;
    _cryptoPrice = cryptoPrice;
    _imgURL = imgURL;
    _likedItem = likedItem;
    _price = price;
    _productName = productName;
    _productNum = productNum;
    _promoNum = promoNum;
    _tags = tags;
  }

  Products.fromJson(dynamic json) {
    _category = json["category"];
    _cryptoPrice = json["cryptoPrice"];
    _imgURL = json["imgURL"];
    _likedItem = json["likedItem"];
    _price = json["price"];
    _productName = json["productName"];
    _productNum = json["productNum"];
    _promoNum = json["promoNum"];
    _tags = json["tags"];
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map["category"] = _category;
    map["cryptoPrice"] = _cryptoPrice;
    map["imgURL"] = _imgURL;
    map["likedItem"] = _likedItem;
    map["price"] = _price;
    map["productName"] = _productName;
    map["productNum"] = _productNum;
    map["promoNum"] = _promoNum;
    if (_tags != null) {
      map["tags"] = _tags;
    }
    return map;
  }
}

class Tags {
  List<String> _tags;

  Tags({List<String> tags}) {
    _tags = tags;
  }

  Tags.fromJson(dynamic json) {
    _tags = json["tags"] != null ? json["tags"].cast<String>() : [];
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map["tags"] = _tags;
    return map;
  }
}
