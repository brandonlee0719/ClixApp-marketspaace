import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:market_space/l10n/I10n.dart';
import 'package:market_space/services/l10n_services.dart';

enum _LKeys {
  CONFIRM,
  Description,
  Quantity,
  ADDTOCART,
  BUYNOW,
  ProductReviews,
  SEEALL,
  NoReviews,
  RelatedItems,
  NoProducts,
  SaleCondition,
  Freeshipping,
  Courierservice,
  ShippingMethod,
  Sellerhandlingtime,
  AboutTheBrand,
  DeliveryInformation,
  AboutTheSeller,
  CONTACTSELLER,
  Confirmseller,
  sellerNotConfirmed,
  ProductLanding,
  Variation,
}

class ProductLandingL10n {
  static final Map<String, Map<_LKeys, String>> _localizedValues = {
    L10nService.enUS.toString(): {
      _LKeys.CONFIRM: "CONFIRM",
      _LKeys.Description: "Description",
      _LKeys.Quantity: "Quantity",
      _LKeys.ADDTOCART: "ADD TO CART",
      _LKeys.BUYNOW: "BUY NOW",
      _LKeys.ProductReviews: "Product Reviews",
      _LKeys.SEEALL: "SEE ALL",
      _LKeys.NoReviews: "No Reviews",
      _LKeys.RelatedItems: "Related Items",
      _LKeys.NoProducts: "No Related Items",
      _LKeys.SaleCondition: "Sale Condition",
      _LKeys.Freeshipping: "Free shipping",
      _LKeys.Courierservice: "Courier service",
      _LKeys.ShippingMethod: "Shipping method",
      _LKeys.Sellerhandlingtime: "Seller handling time",
      _LKeys.AboutTheBrand: "About the brand",
      _LKeys.DeliveryInformation: "Delivery Information",
      _LKeys.AboutTheSeller: "About the seller",
      _LKeys.CONTACTSELLER: "CONTACT SELLER",
      _LKeys.Confirmseller: "Confirmed seller",
      _LKeys.sellerNotConfirmed: "Seller not confirmed",
      _LKeys.ProductLanding: "Product Landing",
      _LKeys.Variation: "Product Landing",
    },
    L10nService.ptZh.toString(): {
      _LKeys.CONFIRM: "确认",
      _LKeys.Description: "描述",
      _LKeys.Quantity: "数量",
      _LKeys.ADDTOCART: "添加到购物车",
      _LKeys.BUYNOW: "立即购买",
      _LKeys.ProductReviews: "产品评论",
      _LKeys.SEEALL: "产品评论",
      _LKeys.NoReviews: "暂无评论",
      _LKeys.RelatedItems: "相关项目",
      _LKeys.NoProducts: "没有产品",
      _LKeys.SaleCondition: "销售条件",
      _LKeys.Freeshipping: "免费送货",
      _LKeys.Courierservice: "免费送货",
      _LKeys.ShippingMethod: "邮寄方式",
      _LKeys.Sellerhandlingtime: "卖方处理时间",
      _LKeys.AboutTheBrand: "关于品牌",
      _LKeys.DeliveryInformation: "配送信息",
      _LKeys.AboutTheSeller: "关于卖方",
      _LKeys.CONTACTSELLER: "联络卖家",
      _LKeys.Confirmseller: "确认卖家",
      _LKeys.ProductLanding: "产品着陆",
      _LKeys.Variation: "变异",
    },
  };

  String get CONFIRM => _localizedValues[locale.toString()][_LKeys.CONFIRM];
  String get Variation => _localizedValues[locale.toString()][_LKeys.Variation];
  String get CONTACTSELLER =>
      _localizedValues[locale.toString()][_LKeys.CONTACTSELLER];
  String get Confirmseller =>
      _localizedValues[locale.toString()][_LKeys.Confirmseller];
  String get ProductLanding =>
      _localizedValues[locale.toString()][_LKeys.ProductLanding];
  String get sellerNotConfirmed =>
      _localizedValues[locale.toString()][_LKeys.sellerNotConfirmed];
  String get DeliveryInformation =>
      _localizedValues[locale.toString()][_LKeys.DeliveryInformation];
  String get Sellerhandlingtime =>
      _localizedValues[locale.toString()][_LKeys.CONFIRM];
  String get Quantity => _localizedValues[locale.toString()][_LKeys.Quantity];
  String get ADDTOCART => _localizedValues[locale.toString()][_LKeys.ADDTOCART];
  String get BUYNOW => _localizedValues[locale.toString()][_LKeys.BUYNOW];
  String get ProductReviews =>
      _localizedValues[locale.toString()][_LKeys.ProductReviews];
  String get seeAll => _localizedValues[locale.toString()][_LKeys.SEEALL];
  String get NoReviews => _localizedValues[locale.toString()][_LKeys.NoReviews];
  String get RelatedItems =>
      _localizedValues[locale.toString()][_LKeys.RelatedItems];
  String get NoProducts =>
      _localizedValues[locale.toString()][_LKeys.NoProducts];
  String get SaleCondition =>
      _localizedValues[locale.toString()][_LKeys.SaleCondition];
  String get Freeshipping =>
      _localizedValues[locale.toString()][_LKeys.Freeshipping];
  String get Courierservice =>
      _localizedValues[locale.toString()][_LKeys.Courierservice];
  String get ShippingMethod =>
      _localizedValues[locale.toString()][_LKeys.ShippingMethod];
  String get AboutTheBrand =>
      _localizedValues[locale.toString()][_LKeys.AboutTheBrand];
  String get AboutTheSeller =>
      _localizedValues[locale.toString()][_LKeys.AboutTheSeller];

  String get Description =>
      _localizedValues[locale.toString()][_LKeys.Description];

  final Locale locale;

  ProductLandingL10n(this.locale);

  static const LocalizationsDelegate<dynamic> delegate =
      _ProductLandingL10nDelegate();
}

class _ProductLandingL10nDelegate extends AL10nDelegate<ProductLandingL10n> {
  const _ProductLandingL10nDelegate();

  @override
  Future<ProductLandingL10n> load(Locale locale) =>
      SynchronousFuture<ProductLandingL10n>(ProductLandingL10n(locale));
}
