import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:market_space/l10n/I10n.dart';
import 'package:market_space/services/l10n_services.dart';

enum _LKeys { brand, search, searchCaps }

class SearchL10n {
  static final Map<String, Map<_LKeys, String>> _localizedValues = {
    L10nService.enUS.toString(): {
      _LKeys.brand: "Brand",
      _LKeys.search: "Search",
      _LKeys.searchCaps: "SEARCH",
    },
    L10nService.ptZh.toString(): {
      _LKeys.brand: "牌",
      _LKeys.search: "搜索",
      _LKeys.searchCaps: "搜索",
    },
  };

  String get brand => _localizedValues[locale.toString()][_LKeys.brand];
  String get search => _localizedValues[locale.toString()][_LKeys.search];
  String get searchCaps =>
      _localizedValues[locale.toString()][_LKeys.searchCaps];

  final Locale locale;

  SearchL10n(this.locale);

  static const LocalizationsDelegate<dynamic> delegate = _SearchL10nDelegate();
}

class _SearchL10nDelegate extends AL10nDelegate<SearchL10n> {
  const _SearchL10nDelegate();

  @override
  Future<SearchL10n> load(Locale locale) =>
      SynchronousFuture<SearchL10n>(SearchL10n(locale));
}
