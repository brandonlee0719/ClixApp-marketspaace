import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:market_space/l10n/I10n.dart';
import 'package:market_space/services/l10n_services.dart';

enum _LKeys {
  technology,
  womensFashion,
  mensFashion,
  herAccessories,
  hisAccessories,
  office,
  sports,
  homeandKitchen
}

class InterestedCategoriesL10n {
  static final Map<String, Map<_LKeys, String>> _localizedValues = {
    L10nService.enUS.toString(): {
      _LKeys.technology: "Technology",
      _LKeys.womensFashion: "Women's Fashion",
      _LKeys.mensFashion: "Men's Fashion",
      _LKeys.herAccessories: "Her Accessories",
      _LKeys.hisAccessories: "His Accessories",
      _LKeys.office: "Office",
      _LKeys.sports: "Sports",
      _LKeys.homeandKitchen: "Home & Kitchen"
    },
    L10nService.ptZh.toString(): {
      _LKeys.womensFashion: "女装时尚",
      _LKeys.mensFashion: "男士时装",
      _LKeys.herAccessories: "她的配件",
      _LKeys.hisAccessories: "他的配件",
      _LKeys.technology: "技术",
      _LKeys.sports: "运动的",
      _LKeys.homeandKitchen: "家庭和厨房",
      _LKeys.office: "办公室"
    },
  };

  String get womensFashion =>
      _localizedValues[locale.toString()][_LKeys.womensFashion];
  String get mensFashion =>
      _localizedValues[locale.toString()][_LKeys.mensFashion];
  String get herAccessories =>
      _localizedValues[locale.toString()][_LKeys.herAccessories];
  String get hisAccessories =>
      _localizedValues[locale.toString()][_LKeys.hisAccessories];
  String get technology =>
      _localizedValues[locale.toString()][_LKeys.technology];
  String get sports => _localizedValues[locale.toString()][_LKeys.sports];
  String get homeandKitchen =>
      _localizedValues[locale.toString()][_LKeys.homeandKitchen];
  String get office => _localizedValues[locale.toString()][_LKeys.office];

  final Locale locale;

  InterestedCategoriesL10n(this.locale);

  static const LocalizationsDelegate<dynamic> delegate =
      _InterestedCategoriesL10nDelegate();
}

class _InterestedCategoriesL10nDelegate
    extends AL10nDelegate<InterestedCategoriesL10n> {
  const _InterestedCategoriesL10nDelegate();

  @override
  Future<InterestedCategoriesL10n> load(Locale locale) =>
      SynchronousFuture<InterestedCategoriesL10n>(
          InterestedCategoriesL10n(locale));
}
