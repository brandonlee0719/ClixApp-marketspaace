import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:market_space/l10n/I10n.dart';
import 'package:market_space/services/l10n_services.dart';

enum _LKeys { brand, name, image, description, custom, brandSmall, CONFIRM }

class SellerAddBrandL10n {
  static final Map<String, Map<_LKeys, String>> _localizedValues = {
    L10nService.enUS.toString(): {
      _LKeys.brand: "Brand",
      _LKeys.brandSmall: "brand",
      _LKeys.name: "name",
      _LKeys.image: "image",
      _LKeys.description: "description",
      _LKeys.custom: "Custom",
      _LKeys.CONFIRM: "CONFIRM",
    },
    L10nService.ptZh.toString(): {
      _LKeys.brand: "牌",
      _LKeys.brandSmall: "牌",
      _LKeys.name: "名称",
      _LKeys.image: "图片",
      _LKeys.description: "图description片",
      _LKeys.custom: "习俗",
      _LKeys.CONFIRM: "确认",
    },
  };

  String get brand => _localizedValues[locale.toString()][_LKeys.brand];
  String get brandSmall =>
      _localizedValues[locale.toString()][_LKeys.brandSmall];
  String get name => _localizedValues[locale.toString()][_LKeys.name];
  String get image => _localizedValues[locale.toString()][_LKeys.image];
  String get description =>
      _localizedValues[locale.toString()][_LKeys.description];
  String get custom => _localizedValues[locale.toString()][_LKeys.custom];
  String get CONFIRM => _localizedValues[locale.toString()][_LKeys.CONFIRM];

  final Locale locale;

  SellerAddBrandL10n(this.locale);

  static const LocalizationsDelegate<dynamic> delegate =
      _SellerAddBrandL10nDelegate();
}

class _SellerAddBrandL10nDelegate extends AL10nDelegate<SellerAddBrandL10n> {
  const _SellerAddBrandL10nDelegate();

  @override
  Future<SellerAddBrandL10n> load(Locale locale) =>
      SynchronousFuture<SellerAddBrandL10n>(SellerAddBrandL10n(locale));
}
