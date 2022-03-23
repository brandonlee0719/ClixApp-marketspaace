part of 'seller_product_variation_bloc.dart';

@immutable
abstract class SellerProductVariationState {}

class SellerProductVariationInitial extends SellerProductVariationState {}

class Initial extends SellerProductVariationState {}

class Loading extends SellerProductVariationState {}

class Loaded extends SellerProductVariationState {}
