import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:market_space/l10n/I10n.dart';
import 'package:market_space/services/l10n_services.dart';

enum _LKeys {
  CONFIRM,
  Quantity,
  pleseEnter,
  condition,
  Sale,
  confirmed,
}

class SaleConditionL10n {
  static final Map<String, Map<_LKeys, String>> _localizedValues = {
    L10nService.enUS.toString(): {
      _LKeys.CONFIRM: "CONFIRM",
      _LKeys.Quantity: "Quantity",
      _LKeys.pleseEnter: "Please enter",
      _LKeys.condition: "condition",
      _LKeys.Sale: "Sale",
      _LKeys.confirmed: "confirmed",
    },
    L10nService.ptZh.toString(): {
      _LKeys.CONFIRM: "确认",
      _LKeys.Quantity: "数量",
      _LKeys.pleseEnter: "请输入",
      _LKeys.condition: "健康）状况",
      _LKeys.Sale: "特卖",
      _LKeys.confirmed: "特卖",
    },
  };

  String get CONFIRM => _localizedValues[locale.toString()][_LKeys.CONFIRM];
  String get Quantity => _localizedValues[locale.toString()][_LKeys.Quantity];
  String get pleseEnter =>
      _localizedValues[locale.toString()][_LKeys.pleseEnter];
  String get condition => _localizedValues[locale.toString()][_LKeys.condition];
  String get Sale => _localizedValues[locale.toString()][_LKeys.Sale];
  String get confirmed => _localizedValues[locale.toString()][_LKeys.confirmed];

  final Locale locale;

  SaleConditionL10n(this.locale);

  static const LocalizationsDelegate<dynamic> delegate =
      _SaleConditionL10nDelegate();
}

class _SaleConditionL10nDelegate extends AL10nDelegate<SaleConditionL10n> {
  const _SaleConditionL10nDelegate();

  @override
  Future<SaleConditionL10n> load(Locale locale) =>
      SynchronousFuture<SaleConditionL10n>(SaleConditionL10n(locale));
}
