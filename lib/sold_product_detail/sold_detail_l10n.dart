import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:market_space/l10n/I10n.dart';
import 'package:market_space/services/l10n_services.dart';

enum _LKeys {
  CONFIRM,
  Quantity,
  pleseEnter,
  condition,
  Sale,
  confirmed,
  SOLD,
  PRODUCTS,
  OrderSuccessfullyCanceled,
  OrderCancelFailed,
  Hastheitembeenshipped,
  Trackingnumber,
  ShippingCompany,
  MARKITEMSHIPPED,
  Buyershippinginstructions,
  RaiseClaim,
  claimReasonCheck,
  ClaimAlreadyRaised,
  Extendpurchaseprotection,
  ExtendpurchaseprotectionCaps,
  Leavefeedbacktobuyer,
  aboutBuyer,
  leaveFeedback,
  Cancelorder,
  CancelorderCAPs,
  Software,
  Movies,
  Clothing,
}

class SoldDetailL10n {
  static final Map<String, Map<_LKeys, String>> _localizedValues = {
    L10nService.enUS.toString(): {
      _LKeys.CONFIRM: "CONFIRM",
      _LKeys.Quantity: "Quantity",
      _LKeys.pleseEnter: "Please enter",
      _LKeys.condition: "condition",
      _LKeys.Sale: "Sale",
      _LKeys.confirmed: "confirmed",
      _LKeys.SOLD: "SOLD",
      _LKeys.PRODUCTS: "PRODUCTS",
      _LKeys.OrderSuccessfullyCanceled: "Order Successfully Canceled",
      _LKeys.OrderCancelFailed: "Order Cancel Failed",
      _LKeys.Hastheitembeenshipped: "Has the item been shipped?",
      _LKeys.Trackingnumber: "Tracking number",
      _LKeys.ShippingCompany: "Shipping Company",
      _LKeys.MARKITEMSHIPPED: "MARK ITEM SHIPPED",
      _LKeys.Buyershippinginstructions: "Buyer shipping instructions",
      _LKeys.RaiseClaim: "Raise Claim",
      _LKeys.claimReasonCheck:
          "Here’s the detailed reason why I raise this claim",
      _LKeys.ClaimAlreadyRaised: "Claim Already Raised",
      _LKeys.Extendpurchaseprotection: "Extend purchase protection",
      _LKeys.ExtendpurchaseprotectionCaps: "EXTEND PURCHASE PROTECTION",
      _LKeys.Leavefeedbacktobuyer: "Leave a feedback to buyer",
      _LKeys.aboutBuyer: "What did you like (or not) about the buyer",
      _LKeys.leaveFeedback: "LEAVE FEEDBACK",
      _LKeys.Cancelorder: "Cancel order",
      _LKeys.CancelorderCAPs: "CANCEL ORDER",
      _LKeys.Software: "Software",
      _LKeys.Movies: "Movies",
      _LKeys.Clothing: "Clothing",
    },
    L10nService.ptZh.toString(): {
      _LKeys.CONFIRM: "确认",
      _LKeys.Quantity: "数量",
      _LKeys.pleseEnter: "请输入",
      _LKeys.condition: "健康）状况",
      _LKeys.Sale: "特卖",
      _LKeys.confirmed: "特卖",
      _LKeys.SOLD: "已售出",
      _LKeys.PRODUCTS: "产品展示",
      _LKeys.OrderSuccessfullyCanceled: "订单成功取消",
      _LKeys.OrderCancelFailed: "订单取消失败",
      _LKeys.Hastheitembeenshipped: "物品已经寄出了吗?",
      _LKeys.Trackingnumber: "追踪号码?",
      _LKeys.ShippingCompany: "航运公司",
      _LKeys.MARKITEMSHIPPED: "标记商品已发货",
      _LKeys.Buyershippinginstructions: "买家运输说明",
      _LKeys.RaiseClaim: "提出索赔",
      _LKeys.claimReasonCheck: "这是我提出这一主张的详细原因",
      _LKeys.ClaimAlreadyRaised: "已提出索赔",
      _LKeys.Extendpurchaseprotection: "已提出索赔",
      _LKeys.ExtendpurchaseprotectionCaps: "已提出索赔",
      _LKeys.Leavefeedbacktobuyer: "给买家留言",
      _LKeys.aboutBuyer: "您喜欢（或不喜欢）买家的什么",
      _LKeys.leaveFeedback: "留下反馈",
      _LKeys.Cancelorder: "取消订单",
      _LKeys.CancelorderCAPs: "取消订单",
      _LKeys.Software: "软件",
      _LKeys.Movies: "电影",
      _LKeys.Clothing: "服装",
    },
  };

  String get CONFIRM => _localizedValues[locale.toString()][_LKeys.CONFIRM];
  String get Quantity => _localizedValues[locale.toString()][_LKeys.Quantity];
  String get pleseEnter =>
      _localizedValues[locale.toString()][_LKeys.pleseEnter];
  String get condition => _localizedValues[locale.toString()][_LKeys.condition];
  String get Sale => _localizedValues[locale.toString()][_LKeys.Sale];
  String get confirmed => _localizedValues[locale.toString()][_LKeys.confirmed];
  String get SOLD => _localizedValues[locale.toString()][_LKeys.SOLD];
  String get PRODUCTS => _localizedValues[locale.toString()][_LKeys.PRODUCTS];
  String get OrderSuccessfullyCanceled =>
      _localizedValues[locale.toString()][_LKeys.OrderSuccessfullyCanceled];
  String get OrderCancelFailed =>
      _localizedValues[locale.toString()][_LKeys.OrderCancelFailed];
  String get Hastheitembeenshipped =>
      _localizedValues[locale.toString()][_LKeys.Hastheitembeenshipped];
  String get Trackingnumber =>
      _localizedValues[locale.toString()][_LKeys.Trackingnumber];
  String get ShippingCompany =>
      _localizedValues[locale.toString()][_LKeys.ShippingCompany];
  String get MARKITEMSHIPPED =>
      _localizedValues[locale.toString()][_LKeys.MARKITEMSHIPPED];
  String get Buyershippinginstructions =>
      _localizedValues[locale.toString()][_LKeys.Buyershippinginstructions];
  String get RaiseClaim =>
      _localizedValues[locale.toString()][_LKeys.RaiseClaim];
  String get claimReasonCheck =>
      _localizedValues[locale.toString()][_LKeys.claimReasonCheck];
  String get ClaimAlreadyRaised =>
      _localizedValues[locale.toString()][_LKeys.ClaimAlreadyRaised];
  String get Extendpurchaseprotection =>
      _localizedValues[locale.toString()][_LKeys.Extendpurchaseprotection];
  String get ExtendpurchaseprotectionCaps =>
      _localizedValues[locale.toString()][_LKeys.ExtendpurchaseprotectionCaps];
  String get Leavefeedbacktobuyer =>
      _localizedValues[locale.toString()][_LKeys.Leavefeedbacktobuyer];
  String get aboutBuyer =>
      _localizedValues[locale.toString()][_LKeys.aboutBuyer];
  String get leaveFeedback =>
      _localizedValues[locale.toString()][_LKeys.leaveFeedback];
  String get cancelOrder =>
      _localizedValues[locale.toString()][_LKeys.Cancelorder];
  String get CancelorderCAPs =>
      _localizedValues[locale.toString()][_LKeys.CancelorderCAPs];
  String get Software => _localizedValues[locale.toString()][_LKeys.Software];
  String get Movies => _localizedValues[locale.toString()][_LKeys.Movies];
  String get Clothing => _localizedValues[locale.toString()][_LKeys.Clothing];

  final Locale locale;

  SoldDetailL10n(this.locale);

  static const LocalizationsDelegate<dynamic> delegate =
      _SoldDetailL10nDelegate();
}

class _SoldDetailL10nDelegate extends AL10nDelegate<SoldDetailL10n> {
  const _SoldDetailL10nDelegate();

  @override
  Future<SoldDetailL10n> load(Locale locale) =>
      SynchronousFuture<SoldDetailL10n>(SoldDetailL10n(locale));
}
