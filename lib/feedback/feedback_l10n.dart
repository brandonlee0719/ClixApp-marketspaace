import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:market_space/l10n/I10n.dart';
import 'package:market_space/services/l10n_services.dart';

enum _LKeys { Feedback, to }

class FeedbackL10n {
  static final Map<String, Map<_LKeys, String>> _localizedValues = {
    L10nService.enUS.toString(): {
      _LKeys.Feedback: "Feedback",
      _LKeys.to: "to",
    },
    L10nService.ptZh.toString(): {
      _LKeys.Feedback: "反馈",
      _LKeys.to: "至",
    },
  };

  String get Feedback => _localizedValues[locale.toString()][_LKeys.Feedback];
  String get to => _localizedValues[locale.toString()][_LKeys.to];

  final Locale locale;

  FeedbackL10n(this.locale);

  static const LocalizationsDelegate<dynamic> delegate =
      _FeedbackL10nDelegate();
}

class _FeedbackL10nDelegate extends AL10nDelegate<FeedbackL10n> {
  const _FeedbackL10nDelegate();

  @override
  Future<FeedbackL10n> load(Locale locale) =>
      SynchronousFuture<FeedbackL10n>(FeedbackL10n(locale));
}
