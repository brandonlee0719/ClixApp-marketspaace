import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:market_space/l10n/I10n.dart';
import 'package:market_space/services/l10n_services.dart';

enum _LKeys {
  CONFIRM,
  Newvariation,
  Editvariation,
  Variator,
  Variation,
  Quantity,
  Addnewvariation,
  pleseEnter,
  Othervariatorsvariator,
  Product,
  NoRecentProductsAvailable,
  EDIT,
  Remove,
}

class SellerProductVariationL10n {
  static final Map<String, Map<_LKeys, String>> _localizedValues = {
    L10nService.enUS.toString(): {
      _LKeys.CONFIRM: "CONFIRM",
      _LKeys.Newvariation: "New variation",
      _LKeys.Editvariation: "Edit variation",
      _LKeys.Variator: "Variator",
      _LKeys.Variation: "Variation",
      _LKeys.Quantity: "Quantity",
      _LKeys.Addnewvariation: "Add additional variation for variator",
      _LKeys.pleseEnter: "Please enter",
      _LKeys.Othervariatorsvariator: "Other variators for this variator",
      _LKeys.Product: "Product",
      _LKeys.NoRecentProductsAvailable: "No image available",
      _LKeys.EDIT: "EDIT",
      _LKeys.Remove: "Remove",
    },
    L10nService.ptZh.toString(): {
      _LKeys.CONFIRM: "确认",
      _LKeys.Newvariation: "新变化",
      _LKeys.Editvariation: "编辑变化",
      _LKeys.Variator: "变异器",
      _LKeys.Variation: "变异",
      _LKeys.Quantity: "数量",
      _LKeys.Addnewvariation: "为变速器添加其他版本",
      _LKeys.pleseEnter: "请输入",
      _LKeys.Othervariatorsvariator: "该变速器的其他变速器",
      _LKeys.Product: "产品",
      _LKeys.NoRecentProductsAvailable: "没有可用的图像",
      _LKeys.EDIT: "编辑",
      _LKeys.Remove: "去掉",
    },
  };

  String get CONFIRM => _localizedValues[locale.toString()][_LKeys.CONFIRM];
  String get Newvariation =>
      _localizedValues[locale.toString()][_LKeys.Newvariation];
  String get Editvariation =>
      _localizedValues[locale.toString()][_LKeys.Editvariation];
  String get Variator => _localizedValues[locale.toString()][_LKeys.Variator];
  String get Variation => _localizedValues[locale.toString()][_LKeys.Variation];
  String get Quantity => _localizedValues[locale.toString()][_LKeys.Quantity];
  String get Addnewvariation =>
      _localizedValues[locale.toString()][_LKeys.Addnewvariation];
  String get pleseEnter =>
      _localizedValues[locale.toString()][_LKeys.pleseEnter];
  String get Othervariatorsvariator =>
      _localizedValues[locale.toString()][_LKeys.Othervariatorsvariator];
  String get Product => _localizedValues[locale.toString()][_LKeys.Product];
  String get NoRecentProductsAvailable =>
      _localizedValues[locale.toString()][_LKeys.NoRecentProductsAvailable];
  String get EDIT => _localizedValues[locale.toString()][_LKeys.EDIT];
  String get Remove => _localizedValues[locale.toString()][_LKeys.Remove];

  final Locale locale;

  SellerProductVariationL10n(this.locale);

  static const LocalizationsDelegate<dynamic> delegate =
      _SellerProductVariationL10nDelegate();
}

class _SellerProductVariationL10nDelegate
    extends AL10nDelegate<SellerProductVariationL10n> {
  const _SellerProductVariationL10nDelegate();

  @override
  Future<SellerProductVariationL10n> load(Locale locale) =>
      SynchronousFuture<SellerProductVariationL10n>(
          SellerProductVariationL10n(locale));
}
