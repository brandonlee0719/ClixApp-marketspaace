import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:market_space/l10n/I10n.dart';
import 'package:market_space/services/l10n_services.dart';

enum _LKeys {
  RECENTPRODUCTFEEDBACK,
  NoReviews,
}

class RecentlyProductFeedbackL10n {
  static final Map<String, Map<_LKeys, String>> _localizedValues = {
    L10nService.enUS.toString(): {
      _LKeys.RECENTPRODUCTFEEDBACK: "RECENT PRODUCT FEEDBACK",
      _LKeys.NoReviews: "No Reviews",
    },
    L10nService.ptZh.toString(): {
      _LKeys.RECENTPRODUCTFEEDBACK: "最新产品反馈",
      _LKeys.NoReviews: "暂无评论",
    },
  };

  String get RECENTPRODUCTFEEDBACK =>
      _localizedValues[locale.toString()][_LKeys.RECENTPRODUCTFEEDBACK];
  String get NoReviews => _localizedValues[locale.toString()][_LKeys.NoReviews];

  final Locale locale;

  RecentlyProductFeedbackL10n(this.locale);

  static const LocalizationsDelegate<dynamic> delegate =
      _RecentlyProductFeedbackL10nDelegate();
}

class _RecentlyProductFeedbackL10nDelegate
    extends AL10nDelegate<RecentlyProductFeedbackL10n> {
  const _RecentlyProductFeedbackL10nDelegate();

  @override
  Future<RecentlyProductFeedbackL10n> load(Locale locale) =>
      SynchronousFuture<RecentlyProductFeedbackL10n>(
          RecentlyProductFeedbackL10n(locale));
}
