class PromoModel {
  String _type;
  String _image;
  String _title;
  String _subTitle;
  String _price;

  set type(String value) {
    _type = value;
  }

  String _discount;

  String get type => _type;
  String get image => _image;
  String get title => _title;
  String get subTitle => _subTitle;
  String get price => _price;
  String get discount => _discount;

  PromoModel(
      {String type,
      String image,
      String title,
      String subTitle,
      String price,
      String discount}) {
    _type = type;
    _image = image;
    _title = title;
    _subTitle = subTitle;
    _price = price;
    _discount = discount;
  }

  PromoModel.fromJson(dynamic json) {
    _type = json["type"];
    _image = json["image"];
    _title = json["title"];
    _subTitle = json["subTitle"];
    _price = json["price"];
    _discount = json["discount"];
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map["type"] = _type;
    map["image"] = _image;
    map["title"] = _title;
    map["subTitle"] = _subTitle;
    map["price"] = _price;
    map["discount"] = _discount;
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
    _discount = value;
  }
}
