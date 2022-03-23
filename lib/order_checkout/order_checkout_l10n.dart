import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:market_space/l10n/I10n.dart';
import 'package:market_space/services/l10n_services.dart';

enum _LKeys {
  TimeLeft,
  checkout,
  selectShipping,
  selectPayment,
  confirmPaymentMethod,
  confirmOrder,
  addNewAddress,
  shipping,
  payment,
  reviewOrder,
  completed,
  addNewPaymentMethod,
  billingAddress,
  sameAsShippingAddress,
  addBillingAddress,
  AddGiftCode,
  EnterCode,
  expires,
  MyWallet,
  OrderedReview,
  ShippingAddress,
  edit,
  paymentMethod,
  OrderSummary,
  orderOnWay,
  checkEmail,
  standardShipping,
  gotMail,
  checkMailOrderSummary,
}

class OrderCheckoutL10n {
  static final Map<String, Map<_LKeys, String>> _localizedValues = {
    L10nService.enUS.toString(): {
      _LKeys.TimeLeft: "Time left",
      _LKeys.checkout: "Checkout",
      _LKeys.selectShipping: "Select a shipping address",
      _LKeys.selectPayment: "Select a payment method",
      _LKeys.confirmPaymentMethod: "CONFIRM PAYMENT METHOD",
      _LKeys.confirmOrder: "COMPLETE ORDER",
      _LKeys.addNewAddress: "Add new address",
      _LKeys.shipping: "Shipping",
      _LKeys.payment: "Payment",
      _LKeys.reviewOrder: "Review",
      _LKeys.completed: "Completed",
      _LKeys.addNewPaymentMethod: "Add new payment method",
      _LKeys.billingAddress: "Billing address",
      _LKeys.sameAsShippingAddress: "Same as shipping address",
      _LKeys.addBillingAddress: "Add different billing address",
      _LKeys.AddGiftCode: "Add gift code",
      _LKeys.EnterCode: "Enter Code",
      _LKeys.expires: "Expires",
      _LKeys.MyWallet: "My Wallet",
      _LKeys.OrderedReview: "Ordered Review",
      _LKeys.ShippingAddress: "Shipping address",
      _LKeys.edit: "EDIT",
      _LKeys.paymentMethod: "Payment Method",
      _LKeys.OrderSummary: "Order Summary",
      _LKeys.orderOnWay: "Your order is officially on it's way",
      _LKeys.checkEmail: "Check your emails for the complete summary",
      _LKeys.standardShipping: "Standard 3 days shipping",
      _LKeys.gotMail: "You’ve got mail",
      _LKeys.checkMailOrderSummary:
          "Check your emails or your order summary to download your digital product",
    },
    L10nService.ptZh.toString(): {
      _LKeys.TimeLeft: "剩下的时间",
      _LKeys.checkout: "退房",
      _LKeys.selectShipping: "选择一个送货地址",
      _LKeys.selectPayment: "选择付款方式",
      _LKeys.confirmPaymentMethod: "确认付款方式",
      _LKeys.confirmOrder: "完成订单",
      _LKeys.addNewAddress: "添加新地址",
      _LKeys.shipping: "船运",
      _LKeys.payment: "支付",
      _LKeys.reviewOrder: "查看订单",
      _LKeys.completed: "完全的",
      _LKeys.addNewPaymentMethod: "添加新的付款方式",
      _LKeys.billingAddress: "帐单地址",
      _LKeys.sameAsShippingAddress: "跟邮寄地址一样",
      _LKeys.addBillingAddress: "添加其他帐单地址",
      _LKeys.AddGiftCode: "添加礼品代码",
      _LKeys.EnterCode: "输入验证码",
      _LKeys.expires: "过期时间",
      _LKeys.MyWallet: "我的钱包",
      _LKeys.OrderedReview: "订单审查",
      _LKeys.ShippingAddress: "收件地址",
      _LKeys.edit: "编辑",
      _LKeys.paymentMethod: "付款方法",
      _LKeys.OrderSummary: "订单摘要",
      _LKeys.orderOnWay: "您的订单已正式开始",
      _LKeys.checkEmail: "检查您的电子邮件以获取完整摘要",
      _LKeys.standardShipping: "标准3天出货",
      _LKeys.gotMail: "你有邮件",
      _LKeys.checkMailOrderSummary: "检查您的电子邮件或订单摘要以下载数字产品",
    },
  };

  String get TimeLeft => _localizedValues[locale.toString()][_LKeys.TimeLeft];
  String get checkout => _localizedValues[locale.toString()][_LKeys.checkout];
  String get selectShipping =>
      _localizedValues[locale.toString()][_LKeys.selectShipping];
  String get selectPayment =>
      _localizedValues[locale.toString()][_LKeys.selectPayment];
  String get confirmPaymentMethod =>
      _localizedValues[locale.toString()][_LKeys.confirmPaymentMethod];
  String get confirmOrder =>
      _localizedValues[locale.toString()][_LKeys.confirmOrder];
  String get addNewAddress =>
      _localizedValues[locale.toString()][_LKeys.addNewAddress];
  String get shipping => _localizedValues[locale.toString()][_LKeys.shipping];
  String get payment => _localizedValues[locale.toString()][_LKeys.payment];
  String get reviewOrder =>
      _localizedValues[locale.toString()][_LKeys.reviewOrder];
  String get completed => _localizedValues[locale.toString()][_LKeys.completed];
  String get addNewPaymentMethod =>
      _localizedValues[locale.toString()][_LKeys.addNewPaymentMethod];
  String get billingAddress =>
      _localizedValues[locale.toString()][_LKeys.billingAddress];
  String get sameAsShippingAddress =>
      _localizedValues[locale.toString()][_LKeys.sameAsShippingAddress];
  String get addBillingAddress =>
      _localizedValues[locale.toString()][_LKeys.addBillingAddress];
  String get AddGiftCode =>
      _localizedValues[locale.toString()][_LKeys.AddGiftCode];
  String get EnterCode => _localizedValues[locale.toString()][_LKeys.EnterCode];
  String get expires => _localizedValues[locale.toString()][_LKeys.expires];
  String get MyWallet => _localizedValues[locale.toString()][_LKeys.MyWallet];
  String get OrderedReview =>
      _localizedValues[locale.toString()][_LKeys.OrderedReview];
  String get ShippingAddress =>
      _localizedValues[locale.toString()][_LKeys.ShippingAddress];
  String get edit => _localizedValues[locale.toString()][_LKeys.edit];
  String get paymentMethod =>
      _localizedValues[locale.toString()][_LKeys.paymentMethod];
  String get OrderSummary =>
      _localizedValues[locale.toString()][_LKeys.OrderSummary];
  String get orderOnWay =>
      _localizedValues[locale.toString()][_LKeys.orderOnWay];
  String get checkEmail =>
      _localizedValues[locale.toString()][_LKeys.checkEmail];
  String get standardShipping =>
      _localizedValues[locale.toString()][_LKeys.standardShipping];
  String get gotMail => _localizedValues[locale.toString()][_LKeys.gotMail];
  String get checkMailOrderSummary =>
      _localizedValues[locale.toString()][_LKeys.checkMailOrderSummary];

  final Locale locale;

  OrderCheckoutL10n(this.locale);

  static const LocalizationsDelegate<dynamic> delegate =
      _OrderCheckoutL10nDelegate();
}

class _OrderCheckoutL10nDelegate extends AL10nDelegate<OrderCheckoutL10n> {
  const _OrderCheckoutL10nDelegate();

  @override
  Future<OrderCheckoutL10n> load(Locale locale) =>
      SynchronousFuture<OrderCheckoutL10n>(OrderCheckoutL10n(locale));
}
