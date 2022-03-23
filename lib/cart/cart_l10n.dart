import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:market_space/l10n/I10n.dart';
import 'package:market_space/services/l10n_services.dart';

enum _LKeys { TimeLeft, cart, proceedToCheckout, OrderTotal, YourCartEmpty }

class CartL10n {
  static final Map<String, Map<_LKeys, String>> _localizedValues = {
    L10nService.enUS.toString(): {
      _LKeys.TimeLeft: "Time left",
      _LKeys.cart: "My cart",
      _LKeys.proceedToCheckout: "PROCEED TO CHECK OUT",
      _LKeys.OrderTotal: "Order Total",
      _LKeys.YourCartEmpty: "Your cart is empty",
    },
    L10nService.ptZh.toString(): {
      _LKeys.TimeLeft: "剩下的时间",
      _LKeys.cart: "我的车",
      _LKeys.proceedToCheckout: "进行结算",
      _LKeys.OrderTotal: "合计订单",
      _LKeys.YourCartEmpty: "您的购物车是空的",
    },
  };

  String get TimeLeft => _localizedValues[locale.toString()][_LKeys.TimeLeft];
  String get cart => _localizedValues[locale.toString()][_LKeys.cart];
  String get proceedToCheckout =>
      _localizedValues[locale.toString()][_LKeys.proceedToCheckout];
  String get orderTotal =>
      _localizedValues[locale.toString()][_LKeys.OrderTotal];
  String get YourCartEmpty =>
      _localizedValues[locale.toString()][_LKeys.YourCartEmpty];

  final Locale locale;

  CartL10n(this.locale);

  static const LocalizationsDelegate<dynamic> delegate = _CartL10nDelegate();
}

class _CartL10nDelegate extends AL10nDelegate<CartL10n> {
  const _CartL10nDelegate();

  @override
  Future<CartL10n> load(Locale locale) =>
      SynchronousFuture<CartL10n>(CartL10n(locale));
}
