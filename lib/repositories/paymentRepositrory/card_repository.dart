import 'package:market_space/profile_settings/model/debit_card_model.dart';
import 'package:market_space/providers/localProvider/localCardProvider.dart';
import 'package:market_space/providers/payment_providers/cardProvider.dart';

class CardRepository {
  LocalCardProvider _localCard = new LocalCardProvider();
  CardProvider _cardProvider = new CardProvider();

  Future<DebitCardModel> getCard() async {
    DebitCardModel card = await _cardProvider.getCard(isMasked: true);

    return card;
  }

  Future<void> deleteCard() async {
    await _localCard.delete();
  }
}
