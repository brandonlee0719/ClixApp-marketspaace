import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:market_space/l10n/I10n.dart';
import 'package:market_space/services/l10n_services.dart';

enum _LKeys {
  continueWithoutLogin,
  forgotPassword,
  enterPasswordHint,
  password,
  login,
  createAccount,
  email,
  emailHint,
  generalInfo,
  passHeading,
  firstNameHint,
  firstName,
  lastNameHint,
  lastName,
  emailAddHint,
  emailAddress,
  confirmEmailAddHint,
  confirmEmailAdd,
  next,
  DOBHint,
  DOB,
  phoneNumberHint,
  phoneNumber,
  confirmPass,
  termConditionText,
  emailText,
}

class SignUpL10n {
  static final Map<String, Map<_LKeys, String>> _localizedValues = {
    L10nService.enUS.toString(): {
      _LKeys.continueWithoutLogin: "Continue without login",
      _LKeys.forgotPassword: "Forgot password?",
      _LKeys.enterPasswordHint: "Please enter your password.",
      _LKeys.password: "Password",
      _LKeys.login: "Login",
      _LKeys.createAccount: "Create An Account",
      _LKeys.email: "Email",
      _LKeys.emailHint: "Please enter your email.",
      _LKeys.generalInfo: "General info",
      _LKeys.passHeading: "Enter your desired password",
      _LKeys.firstNameHint: "Please enter your first name.",
      _LKeys.firstName: "First name",
      _LKeys.lastNameHint: "Please enter your last name.",
      _LKeys.lastName: "Last name",
      _LKeys.emailAddHint: "Please enter your email address.",
      _LKeys.emailAddress: "Email address",
      _LKeys.confirmEmailAddHint: "Please enter above email.",
      _LKeys.confirmEmailAdd: "Confirm email address",
      _LKeys.next: "NEXT",
      _LKeys.DOBHint: "Please enter your date of birth.",
      _LKeys.DOB: "Date of birth",
      _LKeys.phoneNumberHint: "Please enter your phone number.",
      _LKeys.phoneNumber: "Phone number",
      _LKeys.confirmPass: "Confirm password",
      _LKeys.termConditionText:
          "By checking this box I agree to Marketspaace’s terms and fee policy.",
      _LKeys.emailText:
          "By checking this box I allow MarketSpaace's to send me information and newsletter via email.",
    },
    L10nService.ptZh.toString(): {
      _LKeys.continueWithoutLogin: "继续而不登录",
      _LKeys.forgotPassword: "忘记密码",
      _LKeys.enterPasswordHint: "请输入您的密码。",
      _LKeys.password: "密码",
      _LKeys.login: "登录",
      _LKeys.createAccount: "创建帐号",
      _LKeys.email: "电子邮件",
      _LKeys.emailHint: "请输入您的电子邮件。",
      _LKeys.generalInfo: "基本信息",
      _LKeys.passHeading: "输入您想要的密码",
      _LKeys.firstNameHint: "请输入您的名字。",
      _LKeys.firstName: "名字",
      _LKeys.lastNameHint: "请输入您的姓氏。",
      _LKeys.lastName: "姓",
      _LKeys.emailAddHint: "请输入您的电子邮件地址。",
      _LKeys.emailAddress: "电子邮件地址",
      _LKeys.confirmEmailAddHint: "请输入以上电子邮件。",
      _LKeys.confirmEmailAdd: "确认电邮地址",
      _LKeys.next: "下一个",
      _LKeys.DOBHint: "请输入你的生日。",
      _LKeys.DOB: "出生日期",
      _LKeys.phoneNumberHint: "请输入您的电话号码。",
      _LKeys.phoneNumber: "电话号码",
      _LKeys.confirmPass: "确认密码",
      _LKeys.termConditionText: "选中此框，即表示我同意Marketspaace的条款和费用政策",
      _LKeys.emailText: "通过选中此框，我允许MarketSpaace通过电子邮件向我发送信息和新闻通讯。",
    },
  };

  String get continueWithoutLogin =>
      _localizedValues[locale.toString()][_LKeys.continueWithoutLogin];
  String get forgotPassword =>
      _localizedValues[locale.toString()][_LKeys.forgotPassword];
  String get enterPasswordHint =>
      _localizedValues[locale.toString()][_LKeys.enterPasswordHint];
  String get password => _localizedValues[locale.toString()][_LKeys.password];
  String get login => _localizedValues[locale.toString()][_LKeys.login];
  String get createAccount =>
      _localizedValues[locale.toString()][_LKeys.createAccount];
  String get email => _localizedValues[locale.toString()][_LKeys.email];
  String get emailHint => _localizedValues[locale.toString()][_LKeys.emailHint];
  String get generalInfo =>
      _localizedValues[locale.toString()][_LKeys.generalInfo];
  String get passHeading =>
      _localizedValues[locale.toString()][_LKeys.passHeading];
  String get firstNameHint =>
      _localizedValues[locale.toString()][_LKeys.firstNameHint];
  String get firstName => _localizedValues[locale.toString()][_LKeys.firstName];
  String get lastNameHint =>
      _localizedValues[locale.toString()][_LKeys.lastNameHint];
  String get lastName => _localizedValues[locale.toString()][_LKeys.lastName];
  String get emailAddHint =>
      _localizedValues[locale.toString()][_LKeys.emailAddHint];
  String get emailAddress =>
      _localizedValues[locale.toString()][_LKeys.emailAddress];
  String get confirmEmailAddHint =>
      _localizedValues[locale.toString()][_LKeys.confirmEmailAddHint];
  String get confirmEmailAdd =>
      _localizedValues[locale.toString()][_LKeys.confirmEmailAdd];
  String get next => _localizedValues[locale.toString()][_LKeys.next];
  String get DOBHint => _localizedValues[locale.toString()][_LKeys.DOBHint];
  String get DOB => _localizedValues[locale.toString()][_LKeys.DOB];
  String get phoneNumberHint =>
      _localizedValues[locale.toString()][_LKeys.phoneNumberHint];
  String get phoneNumber =>
      _localizedValues[locale.toString()][_LKeys.phoneNumber];
  String get confirmPass =>
      _localizedValues[locale.toString()][_LKeys.confirmPass];
  String get termConditionText =>
      _localizedValues[locale.toString()][_LKeys.termConditionText];
  String get emailText => _localizedValues[locale.toString()][_LKeys.emailText];

  final Locale locale;

  SignUpL10n(this.locale);

  static const LocalizationsDelegate<dynamic> delegate = _LogInL10nDelegate();
}

class _LogInL10nDelegate extends AL10nDelegate<SignUpL10n> {
  const _LogInL10nDelegate();

  @override
  Future<SignUpL10n> load(Locale locale) =>
      SynchronousFuture<SignUpL10n>(SignUpL10n(locale));
}
