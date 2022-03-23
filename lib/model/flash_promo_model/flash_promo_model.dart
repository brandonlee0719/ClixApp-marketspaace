class FlashPromoModel {
  List<FlashPromo> _flashPromo;

  List<FlashPromo> get flashPromo => _flashPromo;

  FlashPromoModel({List<FlashPromo> flashPromo}) {
    _flashPromo = flashPromo;
  }

  FlashPromoModel.fromJson(dynamic json) {
    if (json["flashPromo"] != null) {
      _flashPromo = [];
      json["flashPromo"].forEach((v) {
        _flashPromo.add(FlashPromo.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    if (_flashPromo != null) {
      map["flashPromo"] = _flashPromo.map((v) => v.toJson()).toList();
    }
    return map;
  }
}

class FlashPromo {
  String _category;
  String _cryptoPrice;
  String _imgURL;
  String _likedItem;
  String _price;
  String _productName;
  String _productNum;
  int _promoNum;

  String get category => _category;
  String get cryptoPrice => _cryptoPrice;
  String get imgURL => _imgURL;
  String get likedItem => _likedItem;
  String get price => _price;
  String get productName => _productName;
  String get productNum => _productNum;
  int get promoNum => _promoNum;

  FlashPromo(
      {String category,
      String cryptoPrice,
      String imgURL,
      String likedItem,
      String price,
      String productName,
      String productNum,
      int promoNum}) {
    _category = category;
    _cryptoPrice = cryptoPrice;
    _imgURL = imgURL;
    _likedItem = likedItem;
    _price = price;
    _productName = productName;
    _productNum = productNum;
    _promoNum = promoNum;
  }

  FlashPromo.fromJson(dynamic json) {
    _category = json["category"];
    _cryptoPrice = json["cryptoPrice"];
    _imgURL = json["imgURL"];
    _likedItem = json["likedItem"];
    _price = json["price"];
    _productName = json["productName"];
    _productNum = json["productNum"];
    _promoNum = json["promoNum"];
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
    return map;
  }
}
