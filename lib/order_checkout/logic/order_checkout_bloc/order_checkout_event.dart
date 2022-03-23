part of 'order_checkout_bloc.dart';

@immutable
abstract class OrderCheckoutEvent {}

class OrderCheckoutScreenEvent extends OrderCheckoutEvent {}

class ViewAddressesEvent extends OrderCheckoutEvent {}

class DebitCardDetailsEvent extends OrderCheckoutEvent {}

class CheckoutEvent1 extends OrderCheckoutEvent {}

class ChooseAddressEvent extends OrderCheckoutEvent {
  final bool isBilling;
  final AddressOptions add;

  ChooseAddressEvent(this.isBilling, this.add);
}

class CreditCardCheckoutEvent extends OrderCheckoutEvent {}


class FinalizeCreditCardCheckout extends OrderCheckoutEvent {}
