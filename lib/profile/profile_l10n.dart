import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:market_space/l10n/I10n.dart';
import 'package:market_space/services/l10n_services.dart';

enum _LKeys {
  sellerProfile,
  buyerProfile,
  about,
  needHelp,
  visit,
  activeProducts,
  seeAll,
  noActiveProducts,
  overAllRating,
  noSoldItems,
  noRecentProducts,
  noFeedback,
  RecentlyFeedbackReceived,
  SoldItems,
  RecentlyFeedbackGiven,
  RecentlyBought,
  profileEditSuccessful,
  editProfileFailed,
  backgroundImageSuccessful,
  backgroundImageFailed,
  ItemsBought,
  Revenuetodata,
  Investmentearnings,
  to,
  reviews,
  outOf
}

class ProfileL10n {
  static final Map<String, Map<_LKeys, String>> _localizedValues = {
    L10nService.enUS.toString(): {
      _LKeys.sellerProfile: "Seller profile",
      _LKeys.buyerProfile: "Buyer profile",
      _LKeys.about: "About",
      _LKeys.needHelp: "Need help?",
      _LKeys.visit: "VISIT OUR HELP CENTER",
      _LKeys.activeProducts: "My active products",
      _LKeys.seeAll: "SEE ALL",
      _LKeys.noActiveProducts: "No active products available !!",
      _LKeys.overAllRating: "Overall Rating",
      _LKeys.noSoldItems: "No sold items!",
      _LKeys.noRecentProducts: "No recent products available !!",
      _LKeys.noFeedback: "No feedback's!!",
      _LKeys.RecentlyFeedbackReceived: "Recent Feedback Received",
      _LKeys.SoldItems: "Sold Items",
      _LKeys.RecentlyFeedbackGiven: "Recent Feedback Given",
      _LKeys.RecentlyBought: "Recently Bought",
      _LKeys.profileEditSuccessful: "profile edit successfully",
      _LKeys.editProfileFailed: "edit profile failed",
      _LKeys.backgroundImageSuccessful: "Background image set successfully",
      _LKeys.backgroundImageFailed: "Background image set failed",
      _LKeys.ItemsBought: "Items Bought",
      _LKeys.Revenuetodata: "Revenue to data",
      _LKeys.Investmentearnings: "Investment earnings",
      _LKeys.to: "to",
      _LKeys.reviews: "reviews",
      _LKeys.outOf: "out of",
    },
    L10nService.ptZh.toString(): {
      _LKeys.buyerProfile: "买家资料",
      _LKeys.sellerProfile: "卖家资料",
      _LKeys.about: "关于",
      _LKeys.needHelp: "需要帮忙？",
      _LKeys.visit: "访问我们的帮助中心",
      _LKeys.activeProducts: "我的活跃产品",
      _LKeys.seeAll: "看到所有",
      _LKeys.noActiveProducts: "没有有效的产品！",
      _LKeys.overAllRating: "整体评价",
      _LKeys.noSoldItems: "没有出售的物品！",
      _LKeys.noRecentProducts: "没有可用的最新产品！",
      _LKeys.noFeedback: "没有反馈！",
      _LKeys.RecentlyFeedbackReceived: "最近收到反！",
      _LKeys.SoldItems: "已售商品！",
      _LKeys.RecentlyFeedbackGiven: "最近反馈",
      _LKeys.RecentlyBought: "最近买的",
      _LKeys.profileEditSuccessful: "个人资料编辑成功",
      _LKeys.editProfileFailed: "编辑个人资料失败",
      _LKeys.backgroundImageSuccessful: "成功设置背景图片",
      _LKeys.backgroundImageFailed: "背景图片设置失败",
      _LKeys.ItemsBought: "购买物品",
      _LKeys.Revenuetodata: "数据收入",
      _LKeys.Investmentearnings: "投资收益",
      _LKeys.to: "至",
      _LKeys.reviews: "评论",
      _LKeys.outOf: "评在......之外论",
    },
  };

  String get sellerProfile =>
      _localizedValues[locale.toString()][_LKeys.sellerProfile];
  String get reviews => _localizedValues[locale.toString()][_LKeys.reviews];
  String get outOf => _localizedValues[locale.toString()][_LKeys.outOf];
  String get SoldItems => _localizedValues[locale.toString()][_LKeys.SoldItems];
  String get RecentlyFeedbackGiven =>
      _localizedValues[locale.toString()][_LKeys.RecentlyFeedbackGiven];
  String get RecentlyFeedbackReceived =>
      _localizedValues[locale.toString()][_LKeys.RecentlyFeedbackReceived];
  String get buyerProfile =>
      _localizedValues[locale.toString()][_LKeys.buyerProfile];
  String get about => _localizedValues[locale.toString()][_LKeys.about];
  String get needHelp => _localizedValues[locale.toString()][_LKeys.needHelp];
  String get visit => _localizedValues[locale.toString()][_LKeys.visit];
  String get activeProducts =>
      _localizedValues[locale.toString()][_LKeys.activeProducts];
  String get seeAll => _localizedValues[locale.toString()][_LKeys.seeAll];
  String get noActiveProducts =>
      _localizedValues[locale.toString()][_LKeys.noActiveProducts];
  String get overAllRating =>
      _localizedValues[locale.toString()][_LKeys.overAllRating];
  String get noSoldItems =>
      _localizedValues[locale.toString()][_LKeys.noSoldItems];
  String get noRecentProducts =>
      _localizedValues[locale.toString()][_LKeys.noRecentProducts];
  String get noFeedback =>
      _localizedValues[locale.toString()][_LKeys.noFeedback];
  String get RecentlyBought =>
      _localizedValues[locale.toString()][_LKeys.RecentlyBought];
  String get profileEditSuccessful =>
      _localizedValues[locale.toString()][_LKeys.profileEditSuccessful];
  String get editProfileFailed =>
      _localizedValues[locale.toString()][_LKeys.editProfileFailed];
  String get backgroundImageSuccessful =>
      _localizedValues[locale.toString()][_LKeys.backgroundImageSuccessful];
  String get backgroundImageFailed =>
      _localizedValues[locale.toString()][_LKeys.backgroundImageFailed];
  String get ItemsBought =>
      _localizedValues[locale.toString()][_LKeys.ItemsBought];
  String get Revenuetodata =>
      _localizedValues[locale.toString()][_LKeys.Revenuetodata];
  String get Investmentearnings =>
      _localizedValues[locale.toString()][_LKeys.Investmentearnings];
  String get to => _localizedValues[locale.toString()][_LKeys.to];

  final Locale locale;

  ProfileL10n(this.locale);

  static const LocalizationsDelegate<dynamic> delegate = _ProfileL10nDelegate();
}

class _ProfileL10nDelegate extends AL10nDelegate<ProfileL10n> {
  const _ProfileL10nDelegate();

  @override
  Future<ProfileL10n> load(Locale locale) =>
      SynchronousFuture<ProfileL10n>(ProfileL10n(locale));
}
