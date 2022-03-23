import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:market_space/l10n/I10n.dart';
import 'package:market_space/services/l10n_services.dart';

enum _LKeys {
  noLongerNeedItem,
  MistakenlyPurchased,
  Other,
  RecentlyBought,
  feedbackLeftSuccessful,
  OrderSuccessful,
  OrderCancelFailed,
  FILTERBY,
  lastMonth,
  receivedBySeller,
  parcelSent,
  delivered,
  OrderStatus,
  Delivered,
  ShippingCompany,
  TrackingNumber,
  confirmReception,
  OrderedWith,
  OrderedOverview,
  ShippingAddress,
  PaymentMethod,
  leaveSellerFeedback,
  likeBuyerCheck,
  LEAVEFEEDBACK,
  CancelOrder,
  whyRaiseClaim,
  cancelOrderCaps,
  NoProductsAvailable,
  OrderTotal,
  MOREOPTIONS
}

class RecentlyBoughtProductL10n {
  static final Map<String, Map<_LKeys, String>> _localizedValues = {
    L10nService.enUS.toString(): {
      _LKeys.noLongerNeedItem: "No longer need this item",
      _LKeys.MistakenlyPurchased: "Mistakenly Purchased",
      _LKeys.Other: "Other",
      _LKeys.RecentlyBought: "Recently Bought",
      _LKeys.feedbackLeftSuccessful: "Feedback left for seller",
      _LKeys.OrderSuccessful: "Order Successfully cancelled",
      _LKeys.OrderCancelFailed: "Order cancel failed",
      _LKeys.FILTERBY: "FILTER BY",
      _LKeys.lastMonth: "LAST 3 MONTHS",
      _LKeys.receivedBySeller: "Received by seller",
      _LKeys.parcelSent: "Parcel sent",
      _LKeys.delivered: "Delivered",
      _LKeys.OrderStatus: "Order Status",
      _LKeys.Delivered: "Delivered",
      _LKeys.ShippingCompany: "Shipping Company",
      _LKeys.TrackingNumber: "Tracking number",
      _LKeys.confirmReception: "CONFIRM RECEPTION OF ITEMS",
      _LKeys.OrderedWith: "Ordered With",
      _LKeys.OrderedOverview: "Ordered Overview",
      _LKeys.ShippingAddress: "Shipping address",
      _LKeys.PaymentMethod: "Payment Method",
      _LKeys.leaveSellerFeedback: "Leave a feedback to seller",
      _LKeys.likeBuyerCheck: "What did you like (or not) about the buyer",
      _LKeys.LEAVEFEEDBACK: "LEAVE FEEDBACK",
      _LKeys.CancelOrder: "Cancel order",
      _LKeys.whyRaiseClaim: "Here’s the detailed reason why I raise this claim",
      _LKeys.cancelOrderCaps: "CANCEL ORDER",
      _LKeys.NoProductsAvailable: "No products available",
      _LKeys.OrderTotal: "Order total",
      _LKeys.MOREOPTIONS: "MORE OPTIONS",
    },
    L10nService.ptZh.toString(): {
      _LKeys.noLongerNeedItem: "不再需要这个项目",
      _LKeys.MistakenlyPurchased: "错误购买",
      _LKeys.Other: "其他",
      _LKeys.RecentlyBought: "最近买的",
      _LKeys.feedbackLeftSuccessful: "给卖家的反馈意见",
      _LKeys.OrderSuccessful: "订单成功取消",
      _LKeys.OrderCancelFailed: "订单取消失败",
      _LKeys.FILTERBY: "过滤",
      _LKeys.lastMonth: "最近3个月",
      _LKeys.receivedBySeller: "卖方收到",
      _LKeys.parcelSent: "包裹已寄出",
      _LKeys.delivered: "已交付",
      _LKeys.OrderStatus: "订单状态",
      _LKeys.Delivered: "已交付",
      _LKeys.ShippingCompany: "航运公司",
      _LKeys.TrackingNumber: "追踪号码",
      _LKeys.confirmReception: "确认物品的接收",
      _LKeys.OrderedWith: "订购",
      _LKeys.OrderedOverview: "订购概述",
      _LKeys.ShippingAddress: "收件地址",
      _LKeys.PaymentMethod: "付款方法",
      _LKeys.leaveSellerFeedback: "给卖家留言",
      _LKeys.likeBuyerCheck: "您喜欢（或不喜欢）买家的什么",
      _LKeys.LEAVEFEEDBACK: "留下反馈",
      _LKeys.CancelOrder: "取消订单",
      _LKeys.cancelOrderCaps: "取消订单",
      _LKeys.whyRaiseClaim: "这是我提出这一主张的详细原因",
      _LKeys.NoProductsAvailable: "没有可用的产品",
      _LKeys.OrderTotal: "合计订单",
      _LKeys.MOREOPTIONS: "更多选择",
    },
  };

  String get noLongerNeedItem =>
      _localizedValues[locale.toString()][_LKeys.noLongerNeedItem];
  String get whyRaiseClaim =>
      _localizedValues[locale.toString()][_LKeys.whyRaiseClaim];
  String get NoProductsAvailable =>
      _localizedValues[locale.toString()][_LKeys.NoProductsAvailable];
  String get MOREOPTIONS =>
      _localizedValues[locale.toString()][_LKeys.MOREOPTIONS];
  String get OrderTotal =>
      _localizedValues[locale.toString()][_LKeys.OrderTotal];
  String get cancelOrderCaps =>
      _localizedValues[locale.toString()][_LKeys.cancelOrderCaps];
  String get confirmReception =>
      _localizedValues[locale.toString()][_LKeys.confirmReception];
  String get leaveSellerFeedback =>
      _localizedValues[locale.toString()][_LKeys.leaveSellerFeedback];
  String get likeBuyerCheck =>
      _localizedValues[locale.toString()][_LKeys.likeBuyerCheck];
  String get OrderedOverview =>
      _localizedValues[locale.toString()][_LKeys.OrderedOverview];
  String get PaymentMethod =>
      _localizedValues[locale.toString()][_LKeys.PaymentMethod];
  String get ShippingAddress =>
      _localizedValues[locale.toString()][_LKeys.ShippingAddress];
  String get OrderedWith =>
      _localizedValues[locale.toString()][_LKeys.OrderedWith];
  String get TrackingNumber =>
      _localizedValues[locale.toString()][_LKeys.TrackingNumber];
  String get MistakenlyPurchased =>
      _localizedValues[locale.toString()][_LKeys.MistakenlyPurchased];
  String get Other => _localizedValues[locale.toString()][_LKeys.Other];
  String get ShippingCompany =>
      _localizedValues[locale.toString()][_LKeys.ShippingCompany];
  String get RecentlyBought =>
      _localizedValues[locale.toString()][_LKeys.RecentlyBought];
  String get feedbackLeftSuccessful =>
      _localizedValues[locale.toString()][_LKeys.feedbackLeftSuccessful];
  String get OrderSuccessful =>
      _localizedValues[locale.toString()][_LKeys.OrderSuccessful];
  String get OrderCancelFailed =>
      _localizedValues[locale.toString()][_LKeys.OrderCancelFailed];
  String get FILTERBY => _localizedValues[locale.toString()][_LKeys.FILTERBY];
  String get lastMonth => _localizedValues[locale.toString()][_LKeys.lastMonth];
  String get receivedBySeller =>
      _localizedValues[locale.toString()][_LKeys.receivedBySeller];
  String get parcelSent =>
      _localizedValues[locale.toString()][_LKeys.parcelSent];
  String get delivered => _localizedValues[locale.toString()][_LKeys.delivered];
  String get OrderStatus =>
      _localizedValues[locale.toString()][_LKeys.OrderStatus];
  String get Delivered => _localizedValues[locale.toString()][_LKeys.Delivered];
  String get LEAVEFEEDBACK =>
      _localizedValues[locale.toString()][_LKeys.LEAVEFEEDBACK];
  String get CancelOrder =>
      _localizedValues[locale.toString()][_LKeys.CancelOrder];

  final Locale locale;

  RecentlyBoughtProductL10n(this.locale);

  static const LocalizationsDelegate<dynamic> delegate =
      _RecentlyBoughtProductL10nDelegate();
}

class _RecentlyBoughtProductL10nDelegate
    extends AL10nDelegate<RecentlyBoughtProductL10n> {
  const _RecentlyBoughtProductL10nDelegate();

  @override
  Future<RecentlyBoughtProductL10n> load(Locale locale) =>
      SynchronousFuture<RecentlyBoughtProductL10n>(
          RecentlyBoughtProductL10n(locale));
}
