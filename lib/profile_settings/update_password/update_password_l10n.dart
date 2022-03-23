import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:market_space/l10n/I10n.dart';
import 'package:market_space/services/l10n_services.dart';

enum _LKeys {
  updatePassword,
  passUpdatedSuccessful,
  passUpdateFailed,
  EmailAddress,
  enterPass,
  confirmPass,
  enterValidEmail,
  passAndConfirmPassMismatch,
  confirmNewPass
}

class UpdatePasswordL10n {
  static final Map<String, Map<_LKeys, String>> _localizedValues = {
    L10nService.enUS.toString(): {
      _LKeys.updatePassword: "Edit Password",
      _LKeys.passUpdatedSuccessful: "Password updated successfully",
      _LKeys.passUpdateFailed: "Password update failed",
      _LKeys.EmailAddress: "Email Address",
      _LKeys.enterPass: "New password",
      _LKeys.confirmPass: "Confirm password",
      _LKeys.enterValidEmail: "Please enter valid email",
      _LKeys.passAndConfirmPassMismatch:
          "Password and confirm password does not match",
      _LKeys.confirmNewPass: "CONFIRM NEW PASSWORD",
    },
    L10nService.ptZh.toString(): {
      _LKeys.updatePassword: "编辑密码",
      _LKeys.passUpdatedSuccessful: "密码更新成功",
      _LKeys.passUpdateFailed: "密码更新失败",
      _LKeys.EmailAddress: "电子邮件地址",
      _LKeys.enterPass: "输入密码",
      _LKeys.confirmPass: "确认密码",
      _LKeys.enterValidEmail: "请输入有效的电子邮件",
      _LKeys.passAndConfirmPassMismatch: "密码和确认密码不匹配",
      _LKeys.confirmNewPass: "确认新密码",
    },
  };

  String get updatePassword =>
      _localizedValues[locale.toString()][_LKeys.updatePassword];
  String get passUpdatedSuccessful =>
      _localizedValues[locale.toString()][_LKeys.passUpdatedSuccessful];
  String get passUpdateFailed =>
      _localizedValues[locale.toString()][_LKeys.passUpdateFailed];
  String get EmailAddress =>
      _localizedValues[locale.toString()][_LKeys.EmailAddress];
  String get enterPass => _localizedValues[locale.toString()][_LKeys.enterPass];
  String get confirmPass =>
      _localizedValues[locale.toString()][_LKeys.confirmPass];
  String get enterValidEmail =>
      _localizedValues[locale.toString()][_LKeys.enterValidEmail];
  String get passAndConfirmPassMismatch =>
      _localizedValues[locale.toString()][_LKeys.passAndConfirmPassMismatch];
  String get confirmNewPass =>
      _localizedValues[locale.toString()][_LKeys.confirmNewPass];

  final Locale locale;

  UpdatePasswordL10n(this.locale);

  static const LocalizationsDelegate<dynamic> delegate =
      _UpdatePasswordL10nDelegate();
}

class _UpdatePasswordL10nDelegate extends AL10nDelegate<UpdatePasswordL10n> {
  const _UpdatePasswordL10nDelegate();

  @override
  Future<UpdatePasswordL10n> load(Locale locale) =>
      SynchronousFuture<UpdatePasswordL10n>(UpdatePasswordL10n(locale));
}
