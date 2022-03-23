class BankDetailsRequestModel {
  String _country;
  String _bsb;
  String _accountNum;
  String _bankAddressOne;
  String _bankAddressTwo;
  String _bankCity;
  String _name;
  String _branchName;

  set country(String value) {
    _country = value;
  }

  String _bankName;
  String _bankProvince;

  String get country => _country;
  String get bsb => _bsb;
  String get accountNum => _accountNum;
  String get bankAddressOne => _bankAddressOne;
  String get bankAddressTwo => _bankAddressTwo;
  String get bankCity => _bankCity;
  String get name => _name;
  String get branchName => _branchName;
  String get bankName => _bankName;
  String get bankProvince => _bankProvince;

  BankDetailsRequestModel(
      {String country,
      String bsb,
      String accountNum,
      String bankAddressOne,
      String bankAddressTwo,
      String bankCity,
      String name,
      String branchName,
      String bankName,
      String bankProvince}) {
    _country = country;
    _bsb = bsb;
    _accountNum = accountNum;
    _bankAddressOne = bankAddressOne;
    _bankAddressTwo = bankAddressTwo;
    _bankCity = bankCity;
    _name = name;
    _branchName = branchName;
    _bankName = bankName;
    _bankProvince = bankProvince;
  }

  BankDetailsRequestModel.fromJson(dynamic json) {
    _country = json["country"];
    _bsb = json["bsb"];
    _accountNum = json["accountNum"];
    _bankAddressOne = json["bankAddressOne"];
    _bankAddressTwo = json["bankAddressTwo"];
    _bankCity = json["bankCity"];
    _name = json["name"];
    _branchName = json["branchName"];
    _bankName = json["bankName"];
    _bankProvince = json["bankProvince"];
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map["country"] = _country;
    map["bsb"] = _bsb;
    map["accountNum"] = _accountNum;
    map["bankAddressOne"] = _bankAddressOne;
    map["bankAddressTwo"] = _bankAddressTwo;
    map["bankCity"] = _bankCity;
    map["name"] = _name;
    map["branchName"] = _branchName;
    map["bankName"] = _bankName;
    map["bankProvince"] = _bankProvince;
    return map;
  }

  set bsb(String value) {
    _bsb = value;
  }

  set accountNum(String value) {
    _accountNum = value;
  }

  set bankAddressOne(String value) {
    _bankAddressOne = value;
  }

  set bankAddressTwo(String value) {
    _bankAddressTwo = value;
  }

  set bankCity(String value) {
    _bankCity = value;
  }

  set name(String value) {
    _name = value;
  }

  set branchName(String value) {
    _branchName = value;
  }

  set bankName(String value) {
    _bankName = value;
  }

  set bankProvince(String value) {
    _bankProvince = value;
  }
}
