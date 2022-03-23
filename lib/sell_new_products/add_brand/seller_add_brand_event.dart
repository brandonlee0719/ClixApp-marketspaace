part of 'seller_add_brand_bloc.dart';

@immutable
abstract class SellerAddBrandEvent {}

class SellerAddBrandScreenEvent extends SellerAddBrandEvent {}

class LoadAvailableBrands extends SellerAddBrandEvent {}

class PickImage extends SellerAddBrandEvent {}
