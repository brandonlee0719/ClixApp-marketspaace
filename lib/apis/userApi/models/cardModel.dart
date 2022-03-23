import 'package:market_space/profile_settings/model/debit_card_model.dart';

class CardModel{
  final String cardHolder;
  final String expireDate;
  final String lastFourDigit;

  CardModel(this.cardHolder, this.expireDate, this.lastFourDigit);
  static CardModel fromJson(Map<String, dynamic> map){
    return CardModel(map["cardHolder"], map['expireDate'], map['lastFourDigit']);
  }

  Map<String, dynamic> toJson(){
    return {
      "cardHolder": cardHolder,
      "expireDate" : expireDate,
      "lastFourDigit": lastFourDigit
    };
  }

  DebitCardModel toDebit(){
    return DebitCardModel(
      cardExpiry: expireDate,
      cardHolder: cardHolder,
      cardNumber: "xxxx xxxx xxxx $lastFourDigit",
    );
  }
}