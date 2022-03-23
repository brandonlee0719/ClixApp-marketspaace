class PaymentModel {
  String _paymentMethod;
  String _cardType;
  String _cardName;
  String _cardHolderName;
  String _dOE;
  bool _isDefault;
  String _id;

  String get id => _id;

  set id(String value) {
    _id = value;
  }

  bool get isDefault => _isDefault;

  set isDefault(bool value) {
    _isDefault = value;
  }

  set paymentMethod(String value) {
    _paymentMethod = value;
  }

  List<Investment_list> _investmentList;

  List<Investment_list> get investmentList => _investmentList;

  String get paymentMethod => _paymentMethod;
  String get cardType => _cardType;
  String get cardName => _cardName;
  String get cardHolderName => _cardHolderName;
  String get dOE => _dOE;

  PaymentModel(
      {String paymentMethod,
      String cardType,
      String cardName,
      String cardHolderName,
      String dOE,
      List<Investment_list> investmentList,
      bool isDefault,
      String id}) {
    _paymentMethod = paymentMethod;
    _cardType = cardType;
    _cardName = cardName;
    _cardHolderName = cardHolderName;
    _dOE = dOE;
    _investmentList = investmentList;
    _isDefault = isDefault;
    _id = id;
  }

  PaymentModel.fromJson(dynamic json) {
    _paymentMethod = json["paymentMethod"];
    _cardType = json["cardType"];
    _cardName = json["cardName"];
    _cardHolderName = json["cardHolderName"];
    _dOE = json["DOE"];
    _investmentList = json["investmentList"];
    _isDefault = json["isDefault"];
    _id = json["id"];
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map["paymentMethod"] = _paymentMethod;
    map["cardType"] = _cardType;
    map["cardName"] = _cardName;
    map["cardHolderName"] = _cardHolderName;
    map["DOE"] = _dOE;
    map["investmentList"] = _investmentList;
    map["isDefault"] = _isDefault;
    map["id"] = _id;
    return map;
  }

  set cardType(String value) {
    _cardType = value;
  }

  set cardName(String value) {
    _cardName = value;
  }

  set cardHolderName(String value) {
    _cardHolderName = value;
  }

  set dOE(String value) {
    _dOE = value;
  }

  set investmentList(List<Investment_list> value) {
    _investmentList = value;
  }
}

class Investment_list {
  String _name;
  String _cAD;

  String get name => _name;
  String get cAD => _cAD;

  Investment_list({String name, String cAD}) {
    _name = name;
    _cAD = cAD;
  }

  Investment_list.fromJson(dynamic json) {
    _name = json["name"];
    _cAD = json["CAD"];
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map["name"] = _name;
    map["CAD"] = _cAD;
    return map;
  }
}
