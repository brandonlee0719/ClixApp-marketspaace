import 'package:flutter/cupertino.dart';

@immutable
abstract class ProductLandingState {}

class Initial extends ProductLandingState {}

class Loading extends ProductLandingState {}

class Loaded extends ProductLandingState {}

class Failed extends ProductLandingState {}

class SellerDataLoaded extends ProductLandingState {}

class SellerDataFailed extends ProductLandingState {}

class RelatedItemsLoaded extends ProductLandingState {}

class RelatedItemsFailed extends ProductLandingState {}

class ShippingCalculatedSuccessfully extends ProductLandingState {}

class ShippingCalculationFailed extends ProductLandingState {}

class ProductLiked extends ProductLandingState {}

class ProductLikedFailed extends ProductLandingState {}

class ProductDisliked extends ProductLandingState {}

class ProductDislikedFailed extends ProductLandingState {}

class ItemAddedToCartSuccessfully extends ProductLandingState {}

class ItemRemovedFromCartSuccessfully extends ProductLandingState {}

class ItemAddedToCartFailed extends ProductLandingState {}
