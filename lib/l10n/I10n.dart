import 'package:flutter/material.dart';
import 'package:market_space/services/l10n_services.dart';

abstract class AL10nDelegate<T> extends LocalizationsDelegate<T> {
  const AL10nDelegate();

  @override
  bool isSupported(Locale locale) => L10nService.isSupported(locale);

  @override
  bool shouldReload(LocalizationsDelegate<T> old) => false;
}
