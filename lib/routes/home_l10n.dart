import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:market_space/l10n/I10n.dart';
import 'package:market_space/services/l10n_services.dart';

enum _LKeys {
  home,
  messages,
  wallet,
  profile,
  search,
}

class HomeL10n {
  static final Map<String, Map<_LKeys, String>> _localizedValues = {
    L10nService.enUS.toString(): {
      _LKeys.home: "Home",
      _LKeys.messages: "Messages",
      _LKeys.profile: "Profile",
      _LKeys.wallet: "Wallet",
      _LKeys.search: "Search",
    },
    L10nService.ptZh.toString(): {
      _LKeys.home: "家",
      _LKeys.messages: "留言内容",
      _LKeys.profile: "个人资料",
      _LKeys.wallet: "钱包",
      _LKeys.search: "搜索",
    },
  };

  String get home => _localizedValues[locale.toString()][_LKeys.home];
  String get messages => _localizedValues[locale.toString()][_LKeys.messages];
  String get profile => _localizedValues[locale.toString()][_LKeys.profile];
  String get wallet => _localizedValues[locale.toString()][_LKeys.wallet];
  String get search => _localizedValues[locale.toString()][_LKeys.search];

  final Locale locale;

  HomeL10n(this.locale);

  static const LocalizationsDelegate<dynamic> delegate = _HomeL10nDelegate();
}

class _HomeL10nDelegate extends AL10nDelegate<HomeL10n> {
  const _HomeL10nDelegate();

  @override
  Future<HomeL10n> load(Locale locale) =>
      SynchronousFuture<HomeL10n>(HomeL10n(locale));
}
