import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:market_space/l10n/I10n.dart';
import 'package:market_space/services/l10n_services.dart';

enum _LKeys {
  next,
  email,
  address,
  confirm,
  newE,
  enter,
  password,
  edit,
}

class HelpCenterL10n {
  static final Map<String, Map<_LKeys, String>> _localizedValues = {
    L10nService.enUS.toString(): {
      _LKeys.next: "NEXT",
      _LKeys.address: "Address",
      _LKeys.email: "Email",
      _LKeys.confirm: "Confirm",
      _LKeys.enter: "Enter",
      _LKeys.newE: "New",
      _LKeys.password: "Password",
      _LKeys.edit: "Edit",
    },
    L10nService.ptZh.toString(): {
      _LKeys.next: "下一个",
      _LKeys.address: "地址",
      _LKeys.email: "电子邮件",
      _LKeys.confirm: "确认",
      _LKeys.enter: "输入",
      _LKeys.newE: "新",
      _LKeys.password: "密码",
      _LKeys.edit: "编辑"
    },
  };

  String get next => _localizedValues[locale.toString()][_LKeys.next];
  String get address => _localizedValues[locale.toString()][_LKeys.address];
  String get email => _localizedValues[locale.toString()][_LKeys.email];
  String get confirm => _localizedValues[locale.toString()][_LKeys.confirm];
  String get enter => _localizedValues[locale.toString()][_LKeys.enter];
  String get newE => _localizedValues[locale.toString()][_LKeys.newE];
  String get password => _localizedValues[locale.toString()][_LKeys.password];
  String get edit => _localizedValues[locale.toString()][_LKeys.edit];

  final Locale locale;

  HelpCenterL10n(this.locale);

  static const LocalizationsDelegate<dynamic> delegate =
      _HelpCenterL10nDelegate();
}

class _HelpCenterL10nDelegate extends AL10nDelegate<HelpCenterL10n> {
  const _HelpCenterL10nDelegate();

  @override
  Future<HelpCenterL10n> load(Locale locale) =>
      SynchronousFuture<HelpCenterL10n>(HelpCenterL10n(locale));
}
