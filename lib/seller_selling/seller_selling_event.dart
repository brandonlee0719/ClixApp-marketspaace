part of 'seller_selling_bloc.dart';

@immutable
abstract class SellerSellingEvent {}

class SellerSellingScreenEvent extends SellerSellingEvent {}

class SellNewProductsCameraEvent extends SellerSellingEvent {}

class SellNewProductsImageEvent extends SellerSellingEvent {}
