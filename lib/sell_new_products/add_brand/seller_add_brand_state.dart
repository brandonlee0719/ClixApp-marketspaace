part of 'seller_add_brand_bloc.dart';

@immutable
abstract class SellerAddBrandState {}

class SellerAddBrandInitial extends SellerAddBrandState {}

class Initial extends SellerAddBrandState {}

class Loading extends SellerAddBrandState {}

class Loaded extends SellerAddBrandState {}

class BrandsLoading extends SellerAddBrandState {}

class BrandsLoaded extends SellerAddBrandState {}

class PickingImage extends SellerAddBrandState {}

class PickedImage extends SellerAddBrandState {}
