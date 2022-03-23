part of 'sell_new_products_bloc.dart';

@immutable
abstract class SellNewProductsState {}

class SellNewProductsInitial extends SellNewProductsState {}

class Initial extends SellNewProductsState {}

class Loading extends SellNewProductsState {}

class Loaded extends SellNewProductsState {}

class ConfirmSellItemSuccessful extends SellNewProductsState {}

class ConfirmSellItemFailed extends SellNewProductsState {}

class ConfirmSellItemUploading extends SellNewProductsState {}

class FileUploadSuccessful extends SellNewProductsState {}

class FileUploadFailed extends SellNewProductsState {}

class CameraUploadSuccessful extends SellNewProductsState {}

class CameraUploadFailed extends SellNewProductsState {}
