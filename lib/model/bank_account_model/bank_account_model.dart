class BankAccountModel {
  String _name;
  String _accountNum;

  String get name => _name;
  String get accountNum => _accountNum;

  BankAccountModel({String name, String accountNum}) {
    _name = name;
    _accountNum = accountNum;
  }

  BankAccountModel.fromJson(dynamic json) {
    _name = json["name"];
    _accountNum = json["accountNum"];
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map["name"] = _name;
    map["accountNum"] = _accountNum;
    return map;
  }
}
