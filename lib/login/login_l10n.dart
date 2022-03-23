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
}

class LogInL10n {
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

  final Locale locale;

  LogInL10n(this.locale);

  static const LocalizationsDelegate<dynamic> delegate = _LogInL10nDelegate();
}

class _LogInL10nDelegate extends AL10nDelegate<LogInL10n> {
  const _LogInL10nDelegate();

  @override
  Future<LogInL10n> load(Locale locale) =>
      SynchronousFuture<LogInL10n>(LogInL10n(locale));
}
