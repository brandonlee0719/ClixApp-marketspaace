class WalletModel {
  int _aud;
  int _eth;
  int _usdc;
  int _cny;
  int _btc;

  int get aud => _aud;
  int get eth => _eth;
  int get usdc => _usdc;
  int get cny => _cny;
  int get btc => _btc;

  WalletModel({int aud, int eth, int usdc, int cny, int btc}) {
    _aud = aud;
    _eth = eth;
    _usdc = usdc;
    _cny = cny;
    _btc = btc;
  }

  WalletModel.fromJson(dynamic json) {
    _aud = json["AUD"];
    _eth = json["ETH"];
    _usdc = json["USDC"];
    _cny = json["CNY"];
    _btc = json["BTC"];
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map["AUD"] = _aud;
    map["ETH"] = _eth;
    map["USDC"] = _usdc;
    map["CNY"] = _cny;
    map["BTC"] = _btc;
    return map;
  }
}
