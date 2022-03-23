part of 'cart_bloc.dart';

@immutable
abstract class CartEvent {}

class CartScreenEvent extends CartEvent {}

class RemoveCartEvent extends CartEvent {
  int count;
  RemoveCartEvent(this.count);
}
