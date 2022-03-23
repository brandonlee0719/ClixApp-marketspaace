part of 'sell_new_products_bloc.dart';

@immutable
abstract class SellNewProductsEvent {}

class SellNewProductsScreenEvent extends SellNewProductsEvent {}

class ConfirmSellItemEvent extends SellNewProductsEvent {}

class UploadFileEvent extends SellNewProductsEvent {}

class AddFromCameraEvent extends SellNewProductsEvent {}
