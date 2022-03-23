import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:market_space/sell_new_products/sell_new_products_bloc.dart';

enum SellerPageState {
  initial,
  advanceSetting,
  shippingScreen,
  sellingPage2,
  complete,
  popScreen
}

enum SellerPageEvent { toNextPage, goBackPage, loadAdvancedSetting }

class SellerPageBloc extends Bloc<SellerPageEvent, SellerPageState> {
  SellerPageBloc(SellerPageState initialState) : super(initialState);

  @override
  Stream<SellerPageState> mapEventToState(
    SellerPageEvent event,
  ) async* {
    if (event == SellerPageEvent.loadAdvancedSetting) {
      yield SellerPageState.advanceSetting;
    }
    if (event == SellerPageEvent.toNextPage) {
      switch (this.state) {
        case SellerPageState.initial:
          {
            yield SellerPageState.shippingScreen;
          }
          break;
        case SellerPageState.shippingScreen:
          {
            yield SellerPageState.sellingPage2;
          }
          break;
        // case SellerPageState.otherDetail:
        //   {
        //     yield SellerPageState.advanceSetting;
        //   }
        //   break;
        case SellerPageState.advanceSetting:
          {
            yield SellerPageState.popScreen;
          }
          break;

        case SellerPageState.sellingPage2:
          {
            yield SellerPageState.complete;
          }
          break;
        case SellerPageState.complete:
          {
            yield SellerPageState.popScreen;
          }
          break;
      }
    } else if (event == SellerPageEvent.goBackPage)
      switch (this.state) {
        case SellerPageState.initial:
          {
            yield SellerPageState.popScreen;
          }
          break;

        case SellerPageState.shippingScreen:
          {
            yield SellerPageState.initial;
          }
          break;

        case SellerPageState.sellingPage2:
          {
            yield SellerPageState.shippingScreen;
          }
          break;

        case SellerPageState.advanceSetting:
          {
            yield SellerPageState.initial;
          }
          break;

        // case SellerPageState.otherDetail:
        //   {
        //     yield SellerPageState.initial;
        //   }
        //   break;

        // case SellerPageState.sellingPage2:
        //   {
        //     yield SellerPageState.initial;
        //   }
        //   break;
        // case SellerPageState.complete:
        //   {
        //     yield SellerPageState.initial;
        //   }
        //   break;
      }
  }
}
