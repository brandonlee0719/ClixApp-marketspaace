import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:market_space/l10n/I10n.dart';
import 'package:market_space/services/l10n_services.dart';

enum _LKeys {
  profileSettings,
  emailAndPass,
  Address,
  AddNewAddress,
  receivingPayment,
  sendingPayment,
  notifications,
  privacy,
  helpCenter,
  email,
  edit,
  password,
  primary,
  remove,
  secondary,
  paypal,
  stripe,
  addReceivePayment,
  mastercard,
  addSendingPayment,
  logout,
  message,
  soldItems,
  feedback,
  orderUpdate,
  investmentUpdate,
  promotions,
  updateCurrencies,
}

class ProfileSettingL10n {
  static final Map<String, Map<_LKeys, String>> _localizedValues = {
    L10nService.enUS.toString(): {
      _LKeys.profileSettings: "PROFILE SETTINGS",
      _LKeys.emailAndPass: "Email and Password",
      _LKeys.Address: "Address",
      _LKeys.AddNewAddress: "Add new address",
      _LKeys.receivingPayment: "Buyer payment methods",
      _LKeys.sendingPayment: "Seller payment methods",
      _LKeys.notifications: "Notifications",
      _LKeys.privacy: "Privacy and security",
      _LKeys.helpCenter: "Help center",
      _LKeys.email: "EMAIL",
      _LKeys.edit: "EDIT",
      _LKeys.password: "PASSWORD",
      _LKeys.primary: "PRIMARY",
      _LKeys.remove: "REMOVE",
      _LKeys.secondary: "Secondary",
      _LKeys.paypal: "Paypal",
      _LKeys.stripe: "Stripe",
      _LKeys.addReceivePayment: "Add new receiving payment method",
      _LKeys.mastercard: "Mastercard",
      _LKeys.addSendingPayment: "Add new sending payment method",
      _LKeys.logout: "LOG OUT",
      _LKeys.message: "Messages",
      _LKeys.soldItems: "Sold Items",
      _LKeys.feedback: "Feedback's received ",
      _LKeys.orderUpdate: "Order updates",
      _LKeys.investmentUpdate: "Investment updates",
      _LKeys.promotions: "Promotions",
      _LKeys.updateCurrencies: "Update Currencies",
    },
    L10nService.ptZh.toString(): {
      _LKeys.profileSettings: "配置文件设置",
      _LKeys.emailAndPass: "邮箱和密码",
      _LKeys.Address: "地址",
      _LKeys.AddNewAddress: "添加新地址",
      _LKeys.receivingPayment: "买家付款方式",
      _LKeys.sendingPayment: "卖家付款方式",
      _LKeys.notifications: "通知事项",
      _LKeys.privacy: "隐私权与安全性",
      _LKeys.helpCenter: "帮助中心",
      _LKeys.email: "电子邮件",
      _LKeys.edit: "编辑",
      _LKeys.password: "密码",
      _LKeys.primary: "主",
      _LKeys.remove: "去掉",
      _LKeys.secondary: "次要的",
      _LKeys.paypal: "贝宝",
      _LKeys.stripe: "条纹",
      _LKeys.addReceivePayment: "添加新的收款方式",
      _LKeys.mastercard: "万事达",
      _LKeys.addSendingPayment: "添加新的发送付款方式",
      _LKeys.logout: "登出",
      _LKeys.message: "留言内容",
      _LKeys.soldItems: "已售商品",
      _LKeys.feedback: "收到反馈",
      _LKeys.orderUpdate: "订单更新",
      _LKeys.investmentUpdate: "投资更新",
      _LKeys.promotions: "促销活动",
      _LKeys.updateCurrencies: "更新货币",
    },
  };

  String get profileSettings =>
      _localizedValues[locale.toString()][_LKeys.profileSettings];
  String get emailAndPass =>
      _localizedValues[locale.toString()][_LKeys.emailAndPass];
  String get updateCurrencies =>
      _localizedValues[locale.toString()][_LKeys.updateCurrencies];
  String get Address => _localizedValues[locale.toString()][_LKeys.Address];
  String get AddNewAddress =>
      _localizedValues[locale.toString()][_LKeys.AddNewAddress];
  String get receivingPayment =>
      _localizedValues[locale.toString()][_LKeys.receivingPayment];
  String get sendingPayment =>
      _localizedValues[locale.toString()][_LKeys.sendingPayment];
  String get notifications =>
      _localizedValues[locale.toString()][_LKeys.notifications];
  String get privacy => _localizedValues[locale.toString()][_LKeys.privacy];
  String get helpCenter =>
      _localizedValues[locale.toString()][_LKeys.helpCenter];
  String get email => _localizedValues[locale.toString()][_LKeys.email];
  String get edit => _localizedValues[locale.toString()][_LKeys.edit];
  String get password => _localizedValues[locale.toString()][_LKeys.password];
  String get primary => _localizedValues[locale.toString()][_LKeys.primary];
  String get remove => _localizedValues[locale.toString()][_LKeys.remove];
  String get secondary => _localizedValues[locale.toString()][_LKeys.secondary];
  String get paypal => _localizedValues[locale.toString()][_LKeys.paypal];
  String get stripe => _localizedValues[locale.toString()][_LKeys.stripe];
  String get addReceivePayment =>
      _localizedValues[locale.toString()][_LKeys.addReceivePayment];
  String get mastercard =>
      _localizedValues[locale.toString()][_LKeys.mastercard];
  String get addSendingPayment =>
      _localizedValues[locale.toString()][_LKeys.addSendingPayment];
  String get logout => _localizedValues[locale.toString()][_LKeys.logout];
  String get message => _localizedValues[locale.toString()][_LKeys.message];
  String get soldItems => _localizedValues[locale.toString()][_LKeys.soldItems];
  String get feedback => _localizedValues[locale.toString()][_LKeys.feedback];
  String get orderUpdate =>
      _localizedValues[locale.toString()][_LKeys.orderUpdate];
  String get investmentUpdate =>
      _localizedValues[locale.toString()][_LKeys.investmentUpdate];
  String get promotions =>
      _localizedValues[locale.toString()][_LKeys.promotions];

  final Locale locale;

  ProfileSettingL10n(this.locale);

  static const LocalizationsDelegate<dynamic> delegate =
      _ProfileSettingL10nDelegate();
}

class _ProfileSettingL10nDelegate extends AL10nDelegate<ProfileSettingL10n> {
  const _ProfileSettingL10nDelegate();

  @override
  Future<ProfileSettingL10n> load(Locale locale) =>
      SynchronousFuture<ProfileSettingL10n>(ProfileSettingL10n(locale));
}
