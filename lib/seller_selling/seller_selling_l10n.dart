import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:market_space/l10n/I10n.dart';
import 'package:market_space/services/l10n_services.dart';

enum _LKeys {
  sellNewProducts,
  addProductPhotos,
  useCamera,
  uploadPic,
  productPic,
  next
}

class SellerSellingL10n {
  static final Map<String, Map<_LKeys, String>> _localizedValues = {
    L10nService.enUS.toString(): {
      _LKeys.sellNewProducts: "Sell new products",
      _LKeys.addProductPhotos: "Add product photos",
      _LKeys.useCamera: "USE PHONE CAMERA",
      _LKeys.uploadPic: "UPLOAD PICTURE",
      _LKeys.productPic: "What makes good product pictures?",
      _LKeys.next: "NEXT",
    },
    L10nService.ptZh.toString(): {
      _LKeys.sellNewProducts: "出售新产品",
      _LKeys.addProductPhotos: "添加产品照片",
      _LKeys.useCamera: "使用手机摄像头",
      _LKeys.uploadPic: "上传图片",
      _LKeys.productPic: "什么使好的产品图片？",
      _LKeys.next: "下一个",
    },
  };

  String get sellNewProducts =>
      _localizedValues[locale.toString()][_LKeys.sellNewProducts];
  String get addProductPhotos =>
      _localizedValues[locale.toString()][_LKeys.addProductPhotos];
  String get useCamera => _localizedValues[locale.toString()][_LKeys.useCamera];
  String get uploadPic => _localizedValues[locale.toString()][_LKeys.uploadPic];
  String get productPic =>
      _localizedValues[locale.toString()][_LKeys.productPic];
  String get next => _localizedValues[locale.toString()][_LKeys.next];

  final Locale locale;

  SellerSellingL10n(this.locale);

  static const LocalizationsDelegate<dynamic> delegate =
      _SellerSellingL10nDelegate();
}

class _SellerSellingL10nDelegate extends AL10nDelegate<SellerSellingL10n> {
  const _SellerSellingL10nDelegate();

  @override
  Future<SellerSellingL10n> load(Locale locale) =>
      SynchronousFuture<SellerSellingL10n>(SellerSellingL10n(locale));
}
