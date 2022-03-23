import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:market_space/l10n/I10n.dart';
import 'package:market_space/services/l10n_services.dart';

enum _LKeys {
  SOLDPRODUCTS,
  TrackingNumber,
  ItemShippedCheck,
  ShippingCompany,
  moreOptions,
  BuyerInfo,
  CancelOrder,
  Name,
  ShippingAddress,
  ShippingInstructions,
  MARKITEMSHIPPED,
  enterTrackingNumber,
  enterShippingCompany,
}

class SoldProductL10n {
  static final Map<String, Map<_LKeys, String>> _localizedValues = {
    L10nService.enUS.toString(): {
      _LKeys.SOLDPRODUCTS: "SOLD PRODUCTS",
      _LKeys.TrackingNumber: "Tracking number",
      _LKeys.ItemShippedCheck: "Has the item been shipped",
      _LKeys.ShippingCompany: "Shipping Company",
      _LKeys.moreOptions: "MORE OPTIONS",
      _LKeys.BuyerInfo: "Buyer's Info",
      _LKeys.CancelOrder: "Cancel order",
      _LKeys.Name: "Name",
      _LKeys.ShippingAddress: "Shipping Address",
      _LKeys.ShippingInstructions: "Shipping instructions",
      _LKeys.MARKITEMSHIPPED: "MARK ITEM SHIPPED",
      _LKeys.enterTrackingNumber: "Please enter tracking number",
      _LKeys.enterShippingCompany: "Please enter shipping company",
    },
    L10nService.ptZh.toString(): {
      _LKeys.SOLDPRODUCTS: "售出产品",
      _LKeys.TrackingNumber: "追踪号码",
      _LKeys.ItemShippedCheck: "该物品已发货吗",
      _LKeys.ShippingCompany: "航运公司",
      _LKeys.moreOptions: "更多选择",
      _LKeys.BuyerInfo: "买家信息",
      _LKeys.CancelOrder: "取消订单",
      _LKeys.Name: "名称",
      _LKeys.ShippingAddress: "收件地址",
      _LKeys.ShippingInstructions: "运输说明",
      _LKeys.MARKITEMSHIPPED: "标记商品已发货",
      _LKeys.enterTrackingNumber: "请输入跟踪号码",
      _LKeys.enterShippingCompany: "请输入货运公司",
    },
  };
  String get SOLDPRODUCTS =>
      _localizedValues[locale.toString()][_LKeys.SOLDPRODUCTS];
  String get TrackingNumber =>
      _localizedValues[locale.toString()][_LKeys.TrackingNumber];
  String get ItemShippedCheck =>
      _localizedValues[locale.toString()][_LKeys.ItemShippedCheck];
  String get ShippingCompany =>
      _localizedValues[locale.toString()][_LKeys.ShippingCompany];
  String get moreOptions =>
      _localizedValues[locale.toString()][_LKeys.moreOptions];
  String get BuyerInfo => _localizedValues[locale.toString()][_LKeys.BuyerInfo];
  String get CancelOrder =>
      _localizedValues[locale.toString()][_LKeys.CancelOrder];
  String get Name => _localizedValues[locale.toString()][_LKeys.Name];
  String get ShippingAddress =>
      _localizedValues[locale.toString()][_LKeys.ShippingAddress];
  String get ShippingInstructions =>
      _localizedValues[locale.toString()][_LKeys.ShippingInstructions];
  String get MARKITEMSHIPPED =>
      _localizedValues[locale.toString()][_LKeys.MARKITEMSHIPPED];
  String get enterTrackingNumber =>
      _localizedValues[locale.toString()][_LKeys.enterTrackingNumber];
  String get enterShippingCompany =>
      _localizedValues[locale.toString()][_LKeys.enterShippingCompany];

  final Locale locale;

  SoldProductL10n(this.locale);

  static const LocalizationsDelegate<dynamic> delegate =
      _SoldProductL10nDelegate();
}

class _SoldProductL10nDelegate extends AL10nDelegate<SoldProductL10n> {
  const _SoldProductL10nDelegate();

  @override
  Future<SoldProductL10n> load(Locale locale) =>
      SynchronousFuture<SoldProductL10n>(SoldProductL10n(locale));
}
