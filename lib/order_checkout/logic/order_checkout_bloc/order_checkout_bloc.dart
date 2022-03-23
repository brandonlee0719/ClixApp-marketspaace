import 'dart:async';
import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:market_space/apis/orderApi/orderManager.dart';
import 'package:market_space/apis/orderApi/walletApi.dart';
import 'package:market_space/apis/userApi/UserApi.dart';
import 'package:market_space/apis/userApi/models/addressModel.dart';
import 'package:market_space/investment/network/wallet_provider.dart';
import 'package:market_space/model/address_model/address_model.dart';
import 'package:market_space/model/order/order_model.dart';
import 'package:market_space/model/payment_method/payment_model.dart';
import 'package:market_space/model/product_detail_model/product_det_model.dart';
import 'package:market_space/model/product_model.dart';
import 'package:market_space/order_checkout/model/chekout_mode.dart';
import 'package:market_space/order_checkout/model/update_address_model/update_address_model.dart';
import 'package:market_space/order_checkout/network/checkoutProvider.dart';
import 'package:market_space/order_checkout/order_checkout_route.dart';
import 'package:market_space/order_checkout/presentation/widgets/addressCard.dart';
import 'package:market_space/profile_settings/model/debit_card_model.dart';
import 'package:market_space/providers/auth/auth_provider.dart';
import 'package:market_space/providers/payment_providers/cardProvider.dart';
import 'package:market_space/repositories/auth/auth_repository.dart';
import 'package:market_space/repositories/checkout_repository/checkout_repository.dart';
import 'package:market_space/repositories/paymentRepositrory/card_repository.dart';
import 'package:market_space/repositories/wallet_repository/wallet_repository.dart';
import 'package:market_space/services/locator.dart';
import 'package:meta/meta.dart';

part 'order_checkout_event.dart';
part 'order_checkout_state.dart';

class OrderCheckoutBloc extends Bloc<OrderCheckoutEvent, OrderCheckoutState> {
  OrderCheckoutBloc(OrderCheckoutState initialState) : super(initialState);
  CheckoutRepository _checkoutRepository = CheckoutRepository();
  WalletRepository wallet = WalletRepository();
  AuthRepository _authRepository = AuthRepository();
  DebitCardModel debitCardModel;
  List<ProductDetModel> productList = List();
  AuthRepository auth = new AuthRepository();
  String lastDigit;
  CheckoutProvider provider = CheckoutProvider();
  CheckModel checkModel = new CheckModel();
  double selectedAmount;
  double costAmount;
  bool isShippingBillingSame = true;
  List<UpdateAddressModel> billingAddresses;

  @override
  OrderCheckoutState get initialState => Initial();

  void setShippingAddress(AddressOptions option) {}

  void setBillingAddress(AddressOptions option) {
    isShippingBillingSame = false;
  }

  AddressOptions getShippingAddress() {
    return AddressOptions.AddressTWO;
  }

  AddressOptions getBillingAddress() {
    return AddressOptions.AddressOne;
  }

  int getNumber(AddressOptions option) {
    if (option == AddressOptions.AddressOne) {
      return 0;
    }
    if (option == AddressOptions.AddressTWO) {
      return 1;
    }
    return 2;
  }

  @override
  Stream<OrderCheckoutState> mapEventToState(
    OrderCheckoutEvent event,
  ) async* {
    // print("I am called 007");
    // if (event is OrderCheckoutScreenEvent) {
    //   yield Loading();
    //   _prepareOrderData();
    //   yield Loaded(); // In this state we can load the HOME PAGE
    // }

    if (event is ViewAddressesEvent) {
      yield AddressLoading();
      await locator<OrderManager>().getAddress();
      String uid = await AuthProvider().getUserUID();
      billingAddresses =
          await UserApi(FirebaseFirestore.instance, uid).getBillingAddress();

      var products = await _authRepository.getCartProducts();
      if (!OrderCheckoutRoute.isBuyNow) {
        List<dynamic> favlst = jsonDecode(products);
        productList.clear();
        OrderCheckoutRoute.productList = List<int>();
        for (int i = 0; i < favlst.length; i++) {
          ProductDetModel fav = ProductDetModel.fromJson(favlst[i]);
          productList.add(fav);
          OrderCheckoutRoute.productList.add(fav.productNum);
        }
      }

      yield ViewAddressSuccessfully();
    }

    if (event is DebitCardDetailsEvent) {
      yield Loading();
      CardRepository repo = new CardRepository();

      wallet.wallet = locator<WalletApi>().wallet.value;
      await locator<OrderManager>().getCard();
      // debitCardModel = await CardProvider().getCard();
      // print(debitCardModel?.toJson());
    }

    if (event is CheckoutEvent1) {
      yield CheckoutOngoing();

      // if(costAmount>selectedAmount){
      //   yield CheckoutFailed();
      // }
      // else{
      CheckModel model = locator<OrderManager>().getCheckoutModel();
      int code = await provider.checkOut(model);
      if (code == 200) {
        yield CheckoutSuccess();
      } else {
        yield CheckoutFailed();
      }
      // }

    }

    if (event is CreditCardCheckoutEvent) {
      yield CheckoutOngoing();

      // if(costAmount>selectedAmount){
      //   yield CheckoutFailed();
      // }
      // else{
      CheckModel model = locator<OrderManager>().getCheckoutModel();
      int code = await provider.checkOut(model);
      if (code == 200) {
        yield AwaitingAuthentication();
      } else {
        yield CheckoutFailed();
      }
    }

    if (event is FinalizeCreditCardCheckout) {
      int code =
          await provider.authenticateCard(locator<OrderManager>().cardAuth);
      if (code == 200) {
        yield CheckoutSuccess();
      } else {
        yield CheckoutFailed();
      }
    }

    if (event is ChooseAddressEvent) {
      if (event.isBilling) {
        setBillingAddress(event.add);

        // if(costAmount>selectedAmount){
        //   yield CheckoutFailed();
        // }
        // else{
        CheckModel model = locator<OrderManager>().getCheckoutModel();
        int code = await provider.checkOut(model);
        if (code == 200) {
          yield AwaitingAuthentication();
        } else {
          yield CheckoutFailed();
        }
      }

      if (event is FinalizeCreditCardCheckout) {
        int code =
            await provider.authenticateCard(locator<OrderManager>().cardAuth);
        if (code == 200) {
          yield CheckoutSuccess();
        } else {
          yield CheckoutFailed();
        }
      }

      if (event is ChooseAddressEvent) {
        if (event.isBilling) {
          setBillingAddress(event.add);
        } else {
          setShippingAddress(event.add);
        }

        yield SelectAddress();
      }
    }

    Future<List<UpdateAddressModel>> _getAddress() async {
      String uid = await _authRepository.getUserId();
      return UserApi(FirebaseFirestore.instance, uid).getAddress();
    }

    Future<void> prepareCheckout() async {
      checkModel.productList = OrderCheckoutRoute.productList;
      // print(checkModel.productList);

      checkModel.uid = await auth.getUserId();
    }

    void setPaymentMethod(String method) {
      checkModel.paymentMethod = method;
    }

    void setPaymentCurrency(String currency) {
      checkModel.paymentCurrency = currency;
    }

    // Future<DebitCardModel> _getDebitCard() async{
    //   return _checkoutRepository.getDebitCardDetails();
    // }
  }
}
