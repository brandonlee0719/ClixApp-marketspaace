import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:market_space/l10n/I10n.dart';
import 'package:market_space/services/l10n_services.dart';

enum _LKeys {
  CONFIRM,
  ForgottenPassword,
  Enteryourpassword,
  Pleaseenteryourpassword,
  NewPassword,
  Pleaseenterabovepassword,
  ConfirmNewPassword,
  policy,
  infoAndNews,
  CONFIRMNEWPASSWORD,
  addressAssociated,
  pleaseEmailAddress,
  EMailAddress,
  next,
}

class ForgotPasswordL10n {
  static final Map<String, Map<_LKeys, String>> _localizedValues = {
    L10nService.enUS.toString(): {
      _LKeys.CONFIRM: "CONFIRM",
      _LKeys.ForgottenPassword: "Forgotten Password",
      _LKeys.Enteryourpassword: "Enter your new password",
      _LKeys.Pleaseenteryourpassword: "Please enter your password",
      _LKeys.NewPassword: "New Password",
      _LKeys.Pleaseenterabovepassword: "Please enter above password",
      _LKeys.ConfirmNewPassword: "Confirm New Password",
      _LKeys.policy:
          "By checking this box I agree to Marketspaace’s terms and fee policy",
      _LKeys.infoAndNews:
          "By checking this box I allow MarketSpaace's to send me information and newsletter via email",
      _LKeys.CONFIRMNEWPASSWORD: "CONFIRM NEW PASSWORD",
      _LKeys.addressAssociated:
          "What is the address associated with your account",
      _LKeys.pleaseEmailAddress: "Please enter your email address",
      _LKeys.EMailAddress: "E-Mail Address",
      _LKeys.next: "NEXT",
    },
    L10nService.ptZh.toString(): {
      _LKeys.CONFIRM: "确认",
      _LKeys.ForgottenPassword: "忘记密码",
      _LKeys.Enteryourpassword: "输入新密码",
      _LKeys.Pleaseenteryourpassword: "请输入您的密码",
      _LKeys.NewPassword: "新密码",
      _LKeys.Pleaseenterabovepassword: "请输入以上密码",
      _LKeys.ConfirmNewPassword: "确认新密码",
      _LKeys.policy: "选中此框，即表示我同意Marketspaace的条款和费用政策",
      _LKeys.infoAndNews: "通过选中此框，我允许MarketSpaace通过电子邮件向我发送信息和新闻通讯",
      _LKeys.CONFIRMNEWPASSWORD: "确认新密码",
      _LKeys.addressAssociated: "与您的帐户关联的地址是什么",
      _LKeys.pleaseEmailAddress: "请输入您的电子邮件地址",
      _LKeys.EMailAddress: "电子邮件地址",
      _LKeys.next: "下一个",
    },
  };

  String get CONFIRM => _localizedValues[locale.toString()][_LKeys.CONFIRM];
  String get next => _localizedValues[locale.toString()][_LKeys.next];
  String get ForgottenPassword =>
      _localizedValues[locale.toString()][_LKeys.ForgottenPassword];
  String get Enteryourpassword =>
      _localizedValues[locale.toString()][_LKeys.Enteryourpassword];
  String get addressAssociated =>
      _localizedValues[locale.toString()][_LKeys.addressAssociated];
  String get Pleaseenteryourpassword =>
      _localizedValues[locale.toString()][_LKeys.Pleaseenteryourpassword];
  String get NewPassword =>
      _localizedValues[locale.toString()][_LKeys.NewPassword];
  String get Pleaseenterabovepassword =>
      _localizedValues[locale.toString()][_LKeys.Pleaseenterabovepassword];
  String get ConfirmNewPassword =>
      _localizedValues[locale.toString()][_LKeys.ConfirmNewPassword];
  String get policy => _localizedValues[locale.toString()][_LKeys.policy];
  String get infoAndNews =>
      _localizedValues[locale.toString()][_LKeys.infoAndNews];
  String get CONFIRMNEWPASSWORD =>
      _localizedValues[locale.toString()][_LKeys.CONFIRMNEWPASSWORD];
  String get pleaseEmailAddress =>
      _localizedValues[locale.toString()][_LKeys.pleaseEmailAddress];
  String get EMailAddress =>
      _localizedValues[locale.toString()][_LKeys.EMailAddress];

  final Locale locale;

  ForgotPasswordL10n(this.locale);

  static const LocalizationsDelegate<dynamic> delegate =
      _ForgotPasswordL10nDelegate();
}

class _ForgotPasswordL10nDelegate extends AL10nDelegate<ForgotPasswordL10n> {
  const _ForgotPasswordL10nDelegate();

  @override
  Future<ForgotPasswordL10n> load(Locale locale) =>
      SynchronousFuture<ForgotPasswordL10n>(ForgotPasswordL10n(locale));
}
