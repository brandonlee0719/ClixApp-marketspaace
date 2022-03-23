class Address {
  String _addressType;
  String _line1;
  String _line2;
  String _line3;
  String _pincode;
  String _city;
  String _state;
  bool _isDefault;

  bool get isDefault => _isDefault;

  set isDefault(bool value) {
    _isDefault = value;
  }

  set addressType(String value) {
    _addressType = value;
  }

  String _country;

  String get addressType => _addressType;
  String get line1 => _line1;
  String get line2 => _line2;
  String get line3 => _line3;
  String get pincode => _pincode;
  String get city => _city;
  String get state => _state;
  String get country => _country;

  Address({
    String addressType,
    String line1,
    String line2,
    String line3,
    String pincode,
    String city,
    String state,
    String country,
    bool isDefault,
  }) {
    _addressType = addressType;
    _line1 = line1;
    _line2 = line2;
    _line3 = line3;
    _pincode = pincode;
    _city = city;
    _state = state;
    _country = country;
    _isDefault = isDefault;
  }

  Address.fromJson(dynamic json) {
    _addressType = json["addressType"];
    _line1 = json["line1"];
    _line2 = json["line2"];
    _line3 = json["line3"];
    _pincode = json["pincode"];
    _city = json["city"];
    _state = json["state"];
    _country = json["country"];
    _isDefault = json["isDefault"];
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map["addressType"] = _addressType;
    map["line1"] = _line1;
    map["line2"] = _line2;
    map["line3"] = _line3;
    map["pincode"] = _pincode;
    map["city"] = _city;
    map["state"] = _state;
    map["country"] = _country;
    map["isDefault"] = _isDefault;
    return map;
  }

  set line1(String value) {
    _line1 = value;
  }

  set line2(String value) {
    _line2 = value;
  }

  set line3(String value) {
    _line3 = value;
  }

  set pincode(String value) {
    _pincode = value;
  }

  set city(String value) {
    _city = value;
  }

  set state(String value) {
    _state = value;
  }

  set country(String value) {
    _country = value;
  }
}
