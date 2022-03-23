enum CardType {
  visa,
  mastercard,
}

class DebitCardModel {
  String _cardExpiry;
  String _cardHolder;
  CardType cardType;

  set cardExpiry(String value) {
    _cardExpiry = value;
  }

  String _cardNumber;

  String get cardExpiry => _cardExpiry;
  String get cardHolder => _cardHolder;
  String get cardNumber => _cardNumber;

  DebitCardModel({String cardExpiry, String cardHolder, String cardNumber}) {
    _cardExpiry = cardExpiry;
    _cardHolder = cardHolder;
    _cardNumber = cardNumber;
  }

  DebitCardModel.fromJson(dynamic json, {bool isMasked = true}) {
    _cardExpiry = json["card_expiry"];
    _cardHolder = json["card_holder"];
    _cardNumber = json["card_number"].toString();
    if (_cardNumber[0] == '5') {
      cardType = CardType.visa;
    } else {
      cardType = CardType.mastercard;
    }
    if (isMasked) {
      _cardNumber = "XXXXXXXXXXXX" + _maskCard(cardNumber);
    }
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map["card_expiry"] = _cardExpiry;
    map["card_holder"] = _cardHolder;
    map["card_number"] = _cardNumber;

    return map;
  }

  String _maskCard(String cardNumber) {
    // mask the card and leave the last 4 digits only
    String maskedNumber = cardNumber.substring(cardNumber.length - 4);
    return maskedNumber;
  }

  String _getCardTypeString() {
    if (cardType == CardType.visa) {
      return "visa";
    }
    return "mastercard";
  }

  set cardHolder(String value) {
    _cardHolder = value;
  }

  set cardNumber(String value) {
    _cardNumber = value;
  }
}
