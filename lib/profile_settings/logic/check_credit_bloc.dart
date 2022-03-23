import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:market_space/apis/userApi/UserApi.dart';
import 'package:market_space/common/util/creditCardHelper.dart';
import 'package:market_space/profile_settings/model/debit_card_model.dart';
import 'package:market_space/profile_settings/network/keyProvider.dart';
import 'package:market_space/profile_settings/network/vaultProvider.dart';
import 'package:market_space/providers/payment_providers/cardProvider.dart';
import 'package:market_space/repositories/auth/auth_repository.dart';
import 'package:market_space/repositories/paymentRepositrory/card_repository.dart';

enum CheckCreditEvent { checkCredit, deleteCredit, uploadCredit }

enum CheckCreditState {
  init,
  hasCredit,
  noCredit,
  loading,
  creditCardDownloadSuccess,
  uploadingFail,
  uploadingCard,
  uploadingSuccess,
}

class CheckCreditBloc extends Bloc<CheckCreditEvent, CheckCreditState> {
  int result;

  CheckCreditBloc() : super(CheckCreditState.init);
  VaultProvider vault = new VaultProvider();
  KeyProvider key = new KeyProvider();
  DebitCardModel model;
  AuthRepository _auth = new AuthRepository();
  String lastFourDigit;
  String _expiryDate;
  String _cardNumber;
  String _cardHolderName;
  CreditCardHelper helper = CreditCardHelper();

  void setBankDetails(
      String expiryDate, String cardHolderName, String cardNumber) {
    this._expiryDate = expiryDate;
    this._cardHolderName = cardHolderName;
    this._cardNumber = cardNumber;
  }

  @override
  Stream<CheckCreditState> mapEventToState(CheckCreditEvent event) async* {
    if (event == CheckCreditEvent.checkCredit) {
      // throw Exception([]);
      yield CheckCreditState.loading;
      CardRepository provider = CardRepository();

      model = await provider.getCard();

      if (model != null) {
        yield CheckCreditState.hasCredit;

        yield CheckCreditState.creditCardDownloadSuccess;
      } else {
        yield CheckCreditState.noCredit;
      }
    }

    if (event == CheckCreditEvent.deleteCredit) {
      // CardRepository provider = CardRepository();
      // print("deleting cards......");
      yield CheckCreditState.loading;
      // await vault.deleteKey();
      // await provider.deleteCard();
      await helper.deleteCard();
      String _uid = await _auth.getUserId();
      await UserApi(FirebaseFirestore.instance, _uid).deleteCard();
      yield CheckCreditState.noCredit;
    }

    if (event == CheckCreditEvent.uploadCredit) {
      yield CheckCreditState.uploadingCard;
      await helper.addCard(_expiryDate, _cardHolderName, _cardNumber);
      this.add(CheckCreditEvent.checkCredit);
      // ignore: unrelated_type_equality_checks

      yield CheckCreditState.uploadingSuccess;
    }
  }
}
