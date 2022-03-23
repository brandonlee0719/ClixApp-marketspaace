part of 'product_image_bloc.dart';

@immutable
abstract class ProductImageState {}

class Initial extends ProductImageState {}

class Loading extends ProductImageState {}

class Loaded extends ProductImageState {}
