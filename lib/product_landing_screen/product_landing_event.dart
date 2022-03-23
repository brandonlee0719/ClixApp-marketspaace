import 'package:flutter/cupertino.dart';

@immutable
abstract class ProductLandingEvent {}

class ProductLandingScreenEvent extends ProductLandingEvent {}

// class ProductLikeEvent extends ProductLandingEvent {}

// class ProductDisLikeEvent extends ProductLandingEvent {}

class SellerDataEvent extends ProductLandingEvent {}

class LoadMoreRelatedEvent extends ProductLandingEvent {}

class CalculateShippingEvent extends ProductLandingEvent {}

class AddToCartEvent extends ProductLandingEvent {}

class RemoveFromCartEvent extends ProductLandingEvent {}