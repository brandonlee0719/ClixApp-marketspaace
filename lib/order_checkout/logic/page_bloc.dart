import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:market_space/apis/orderApi/orderManager.dart';
import 'package:market_space/order_checkout/logic/order_checkout_bloc/order_checkout_bloc.dart';
import 'package:market_space/services/locator.dart';

enum PageState {
  initial,
  wallet,
  checkout,
  complete,
  popScreen,
  billingAddress,
}

enum PageEvent {
  toNextPage,
  goBackPage,
}

class PageBloc extends Bloc<PageEvent, PageState> {
  PageBloc(PageState initialState, this.orderCheckoutBloc)
      : super(initialState);
  final OrderCheckoutBloc orderCheckoutBloc;

  @override
  Stream<PageState> mapEventToState(
    PageEvent event,
  ) async* {
    if (event == PageEvent.toNextPage) {
      switch (this.state) {
        case PageState.initial:
          {
            if (locator<OrderManager>().addressList != null) {
              if (locator<OrderManager>().addressList.length > 0) {
                yield PageState.wallet;
              }
            }
            break;
          }
        case PageState.wallet:
          {
            yield PageState.checkout;
          }
          break;

        case PageState.checkout:
          {
            yield PageState.complete;
          }
          break;
        case PageState.complete:
          {
            yield PageState.popScreen;
          }
          break;

        case PageState.billingAddress:
          {
            yield PageState.wallet;
          }
          break;
      }
    } else
      switch (this.state) {
        case PageState.initial:
          {
            yield PageState.popScreen;
          }
          break;

        case PageState.wallet:
          {
            yield PageState.initial;
          }
          break;

        case PageState.checkout:
          {
            yield PageState.wallet;
          }
          break;
        case PageState.complete:
          {
            yield PageState.checkout;
          }
          break;
      }
  }
}
