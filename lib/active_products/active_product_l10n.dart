import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:market_space/l10n/I10n.dart';
import 'package:market_space/services/l10n_services.dart';

enum _LKeys {
  ACTIVEPRODUCTS,
}

class ActiveProductL10n {
  static final Map<String, Map<_LKeys, String>> _localizedValues = {
    L10nService.enUS.toString(): {
      _LKeys.ACTIVEPRODUCTS: "ACTIVE PRODUCTS",
    },
    L10nService.ptZh.toString(): {
      _LKeys.ACTIVEPRODUCTS: "活性产品",
    },
  };
  String get ACTIVEPRODUCTS =>
      _localizedValues[locale.toString()][_LKeys.ACTIVEPRODUCTS];

  final Locale locale;

  ActiveProductL10n(this.locale);

  static const LocalizationsDelegate<dynamic> delegate =
      _ActiveProductL10nDelegate();
}

class _ActiveProductL10nDelegate extends AL10nDelegate<ActiveProductL10n> {
  const _ActiveProductL10nDelegate();

  @override
  Future<ActiveProductL10n> load(Locale locale) =>
      SynchronousFuture<ActiveProductL10n>(ActiveProductL10n(locale));
}
