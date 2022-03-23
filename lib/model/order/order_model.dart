class OrderModel {
  String _title;
  String _id;
  String _price;

  set title(String value) {
    _title = value;
  }

  String get title => _title;
  String get id => _id;
  String get price => _price;

  OrderModel({String title, String id, String price}) {
    _title = title;
    _id = id;
    _price = price;
  }

  OrderModel.fromJson(dynamic json) {
    _title = json["title"];
    _id = json["id"];
    _price = json["price"];
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map["title"] = _title;
    map["id"] = _id;
    map["price"] = _price;
    return map;
  }

  set id(String value) {
    _id = value;
  }

  set price(String value) {
    _price = value;
  }
}
