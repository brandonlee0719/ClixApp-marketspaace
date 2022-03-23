part of 'cart_bloc.dart';

@immutable
abstract class CartState {}

class CartInitial extends CartState {}

class Initial extends CartState {}

class Loading extends CartState {}

class Loaded extends CartState {}

class Failed extends CartState {}

class ProductRemovedSuccessfully extends CartState {}

class ProductRemovedFailed extends CartState {}
