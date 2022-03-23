import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';

@immutable
abstract class DashboardScreenState extends Equatable {
  const DashboardScreenState();
  @override
  // TODO: implement props
  List<Object> get props => [];
}

class Initial extends DashboardScreenState {}

class Loading extends DashboardScreenState {}

class Loaded extends DashboardScreenState {}

class FlashPromoFailed extends DashboardScreenState {}

class PromoLiked extends DashboardScreenState {}

class PromoLikedFailed extends DashboardScreenState {}

class ShowCategories extends DashboardScreenState {}

class HideCategories extends DashboardScreenState {}

class AddCategoriesSuccessful extends DashboardScreenState {}

class AddCategoriesFailed extends DashboardScreenState {}

// class LoadingMoreFlashProducts extends DashboardScreenState {}

// class LoadingMoreFlashProductsFailed extends DashboardScreenState {}

class CryptoRateLoadedSuccessfully extends DashboardScreenState {}

class CryptoRateLoadedFailed extends DashboardScreenState {}
