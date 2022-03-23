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
  next,
  physicalGoods,
  CONFIRM,
  freeShipping,
  length,
  Width,
  Height,
  Weight,
  EstimatedPrice,
  DeliveryInformation,
  CourierServices,
  AWB,
  ShippingMethod,
  ByAIR
}

class UploadProductKeyL10n {
  static final Map<String, Map<_LKeys, String>> _localizedValues = {
    L10nService.enUS.toString(): {
      _LKeys.sellNewProducts: "Sell new products",
      _LKeys.addProductPhotos: "Add product photos",
      _LKeys.useCamera: "USE PHONE CAMERA",
      _LKeys.uploadPic: "UPLOAD PICTURE",
      _LKeys.productPic: "What makes good product pictures?",
      _LKeys.next: "NEXT",
      _LKeys.physicalGoods: "Physical good",
      _LKeys.CONFIRM: "CONFIRM",
      _LKeys.freeShipping: "This product has free shipping",
      _LKeys.length: "Length",
      _LKeys.Width: "Width",
      _LKeys.Height: "Height",
      _LKeys.Weight: "Weight",
      _LKeys.EstimatedPrice: "Estimated Price",
      _LKeys.DeliveryInformation: "Delivery Information",
      _LKeys.CourierServices: "Courier Service",
      _LKeys.AWB: "AusPost",
      _LKeys.ShippingMethod: "Shipping Method",
      _LKeys.ByAIR: "ByAIR",
    },
    L10nService.ptZh.toString(): {
      _LKeys.sellNewProducts: "出售新产品",
      _LKeys.addProductPhotos: "添加产品照片",
      _LKeys.useCamera: "使用手机摄像头",
      _LKeys.uploadPic: "上传图片",
      _LKeys.productPic: "什么使好的产品图片？",
      _LKeys.next: "下一个",
      _LKeys.physicalGoods: "身体好",
      _LKeys.CONFIRM: "确认",
      _LKeys.freeShipping: "此产品免运费",
      _LKeys.length: "长度",
      _LKeys.Width: "宽度",
      _LKeys.Height: "高度",
      _LKeys.Weight: "重量",
      _LKeys.EstimatedPrice: "预计运费",
      _LKeys.DeliveryInformation: "配送信息",
      _LKeys.CourierServices: "快递服务",
      _LKeys.AWB: "AusPost",
      _LKeys.ShippingMethod: "邮寄方式",
      _LKeys.ByAIR: "空运",
    },
  };

  String get sellNewProducts =>
      _localizedValues[locale.toString()][_LKeys.sellNewProducts];
  String get length => _localizedValues[locale.toString()][_LKeys.length];
  String get width => _localizedValues[locale.toString()][_LKeys.Width];
  String get height => _localizedValues[locale.toString()][_LKeys.Height];
  String get weight => _localizedValues[locale.toString()][_LKeys.Weight];
  String get estimatedPrice =>
      _localizedValues[locale.toString()][_LKeys.EstimatedPrice];
  String get deliveryInformation =>
      _localizedValues[locale.toString()][_LKeys.DeliveryInformation];
  String get courierServices =>
      _localizedValues[locale.toString()][_LKeys.CourierServices];
  String get awb => _localizedValues[locale.toString()][_LKeys.AWB];
  String get shippingMethod =>
      _localizedValues[locale.toString()][_LKeys.ShippingMethod];
  String get byAir => _localizedValues[locale.toString()][_LKeys.ByAIR];
  String get freeShipping =>
      _localizedValues[locale.toString()][_LKeys.freeShipping];
  String get physicalGoods =>
      _localizedValues[locale.toString()][_LKeys.physicalGoods];
  String get addProductPhotos =>
      _localizedValues[locale.toString()][_LKeys.addProductPhotos];
  String get useCamera => _localizedValues[locale.toString()][_LKeys.useCamera];
  String get uploadPic => _localizedValues[locale.toString()][_LKeys.uploadPic];
  String get productPic =>
      _localizedValues[locale.toString()][_LKeys.productPic];
  String get next => _localizedValues[locale.toString()][_LKeys.next];
  String get confirm => _localizedValues[locale.toString()][_LKeys.CONFIRM];

  final Locale locale;

  UploadProductKeyL10n(this.locale);

  static const LocalizationsDelegate<dynamic> delegate =
      _UploadProductKeyL10nDelegate();
}

class _UploadProductKeyL10nDelegate
    extends AL10nDelegate<UploadProductKeyL10n> {
  const _UploadProductKeyL10nDelegate();

  @override
  Future<UploadProductKeyL10n> load(Locale locale) =>
      SynchronousFuture<UploadProductKeyL10n>(UploadProductKeyL10n(locale));
}
