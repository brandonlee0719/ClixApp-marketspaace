class RatesModel {
  CryptoRates _cryptoRates;
  FiatRates _fiatRates;

  CryptoRates get cryptoRates => _cryptoRates;
  FiatRates get fiatRates => _fiatRates;

  RatesModel({CryptoRates cryptoRates, FiatRates fiatRates}) {
    _cryptoRates = cryptoRates;
    _fiatRates = fiatRates;
  }

  RatesModel.fromJson(dynamic json) {
    _cryptoRates = json["cryptoRates"] != null
        ? CryptoRates.fromJson(json["cryptoRates"])
        : null;
    _fiatRates = json["fiatRates"] != null
        ? FiatRates.fromJson(json["fiatRates"])
        : null;
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    if (_cryptoRates != null) {
      map["cryptoRates"] = _cryptoRates.toJson();
    }
    if (_fiatRates != null) {
      map["fiatRates"] = _fiatRates.toJson();
    }
    return map;
  }
}

class FiatRates {
  String _aud;
  String _cny;

  String get aud => _aud;
  String get cny => _cny;

  FiatRates({String aud, String cny}) {
    _aud = aud;
    _cny = cny;
  }

  FiatRates.fromJson(dynamic json) {
    _aud = json["AUD"];
    _cny = json["CNY"];
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map["AUD"] = _aud;
    map["CNY"] = _cny;
    return map;
  }
}

class CryptoRates {
  String _btc;
  String _eth;
  String _usdc;

  String get btc => _btc;
  String get eth => _eth;
  String get usdc => _usdc;

  CryptoRates({String btc, String eth, String usdc}) {
    _btc = btc;
    _eth = eth;
    _usdc = usdc;
  }

  CryptoRates.fromJson(dynamic json) {
    _btc = json["BTC"];
    _eth = json["ETH"];
    _usdc = json["USDC"];
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map["BTC"] = _btc;
    map["ETH"] = _eth;
    map["USDC"] = _usdc;
    return map;
  }
}
