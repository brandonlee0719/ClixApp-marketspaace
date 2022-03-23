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
}

class EditVariatorL10n {
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

  final Locale locale;

  EditVariatorL10n(this.locale);

  static const LocalizationsDelegate<dynamic> delegate =
      _EditVariatorL10nDelegate();
}

class _EditVariatorL10nDelegate extends AL10nDelegate<EditVariatorL10n> {
  const _EditVariatorL10nDelegate();

  @override
  Future<EditVariatorL10n> load(Locale locale) =>
      SynchronousFuture<EditVariatorL10n>(EditVariatorL10n(locale));
}
