import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:market_space/apis/userApi/UserApi.dart';
import 'package:market_space/apis/userApi/models/addressModel.dart';
import 'package:market_space/model/recently_bought_options/buyer_options.dart';
import 'package:market_space/order_checkout/model/chekout_mode.dart';
import 'package:market_space/order_checkout/model/paymentCurrency.dart';
import 'package:market_space/order_checkout/model/update_address_model/update_address_model.dart';
import 'package:market_space/profile_settings/model/debit_card_model.dart';
import 'package:market_space/providers/payment_providers/cardProvider.dart';
import 'package:market_space/repositories/auth/auth_repository.dart';
import 'package:rxdart/rxdart.dart';

enum PaymentMethodType {
  wallet,
  card,
}

extension stringValue on PaymentMethodType {
  String getType() {
    switch (this) {
      case PaymentMethodType.card:
        return "DEBITCARD";
      case PaymentMethodType.wallet:
        return "WALLET";
      default:
        return "";
    }
  }
}

extension paymentCurrencyExtension on PaymentCurrency {
  String paymentCurrencyType() {
    switch (this) {
      case PaymentCurrency.AUD:
        return "FIAT";
      case PaymentCurrency.CNY:
        return "FIAT";

      default:
        return "CRYPTO";
    }
  }

  String paymentString() {
    switch (this) {
      case PaymentCurrency.AUD:
        return "AUD";
      case PaymentCurrency.CNY:
        return "CNY";

      case PaymentCurrency.USDC:
        return "USDC";

      case PaymentCurrency.BTC:
        return "BTC";

      case PaymentCurrency.ETH:
        return "ETH";

      default:
        return "CRYPTO";
    }
  }
}

class OrderManager {
  // need some comments
  // need some
  // dummy data
  List<UpdateAddressModel> billingAddresses = List<UpdateAddressModel>();
  List<UpdateAddressModel> addressList = List<UpdateAddressModel>();
  PaymentMethodType paymentMethod = PaymentMethodType.wallet;
  List<int> productList;
  ValueNotifier<int> value = ValueNotifier(0);
  ValueNotifier<int> paymentValue = ValueNotifier(0);
  ValueNotifier<PaymentCurrency> currency = ValueNotifier(PaymentCurrency.AUD);
  AuthRepository _authRepository = AuthRepository();
  bool isAddressLoading = true;
  DebitCardModel debitCardModel;
  String orderId;
  Map cardAuth;
  BehaviorSubject<String> sink = BehaviorSubject<String>();
  Future<void> notify() async {
    await Future.delayed(Duration(seconds: 5));
    DateTime time = DateTime.now();
    sink.add(time.millisecondsSinceEpoch.toString());
  }

  Future<void> getAddress() async {
    String uid = await _authRepository.getUserId();
    addressList = await UserApi(FirebaseFirestore.instance, uid).getAddress();
    billingAddresses =
        await UserApi(FirebaseFirestore.instance, uid).getBillingAddress();
  }

  Future<DebitCardModel> getCard() async {
    debitCardModel = await CardProvider().getCard();
    return debitCardModel;
  }

  UpdateAddressModel getShippingAddress() {
    return addressList[value.value];
  }

  UpdateAddressModel getBillingAddress() {
    if (paymentValue.value == 0) {
      return addressList[value.value];
    }
    return billingAddresses[paymentValue.value - 1];
  }

  CheckModel getCheckoutModel() {
    CheckModel check = CheckModel();
    check.address = getShippingAddress();
    check.billingAddress = getBillingAddress();
    check.isBillingSame = paymentValue.value == 0;
    check.paymentMethod = paymentMethod.getType();
    check.productList = this.productList;
    check.paymentType = this.currency.value.paymentCurrencyType();
    check.paymentCurrency = this.currency.value.paymentString();

    return check;
  }
}
