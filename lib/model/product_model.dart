class ProductModel {
  String _type;
  String _image;
  String _title;
  String _subTitle;
  String _price;
  String _description;
  String _id;
  bool _isFav;

  bool get isFav => _isFav;

  set isFav(bool value) {
    _isFav = value;
  }

  String get id => _id;

  set id(String value) {
    _id = value;
  }

  String get description => _description;

  set description(String value) {
    _description = value;
  }

  List<String> _tags;

  List<String> get tags => _tags;

  set tags(List<String> value) {
    _tags = value;
  }

  set type(String value) {
    _type = value;
  }

  String _btcPrice;

  String get type => _type;
  String get image => _image;
  String get title => _title;
  String get subTitle => _subTitle;
  String get price => _price;
  String get btcPrice => _btcPrice;

  ProductModel(
      {String type,
      String image,
      String title,
      String subTitle,
      String price,
      String btcPrice}) {
    _type = type;
    _image = image;
    _title = title;
    _subTitle = subTitle;
    _price = price;
    _btcPrice = btcPrice;
    _description = description;
    _id = id;
    _isFav = isFav;
  }

  ProductModel.fromJson(dynamic json) {
    _type = json["type"];
    _image = json["image"];
    _title = json["title"];
    _subTitle = json["subTitle"];
    _price = json["price"];
    _btcPrice = json["btcPrice"];
    _tags = json["tags"];
    _description = json["description"];
    _id = json["id"];
    _isFav = json["isFav"];
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map["type"] = _type;
    map["image"] = _image;
    map["title"] = _title;
    map["subTitle"] = _subTitle;
    map["price"] = _price;
    map["btcPrice"] = _btcPrice;
    map["tags"] = _tags;
    map["description"] = _description;
    map["id"] = _id;
    map["isFav"] = _isFav;
    return map;
  }

  set image(String value) {
    _image = value;
  }

  set title(String value) {
    _title = value;
  }

  set subTitle(String value) {
    _subTitle = value;
  }

  set price(String value) {
    _price = value;
  }

  set discount(String value) {
    _btcPrice = value;
  }
}
