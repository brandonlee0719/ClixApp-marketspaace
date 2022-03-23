part of 'order_checkout_bloc.dart';

@immutable
abstract class OrderCheckoutState {}

class OrderCheckoutInitial extends OrderCheckoutState {}

class Initial extends OrderCheckoutState {}

class AddressLoading extends OrderCheckoutState {}

class AddressLoadingSuccess extends OrderCheckoutState {}

class Loading extends OrderCheckoutState {}
class AwaitingAuthentication extends OrderCheckoutState{}

class Loaded extends OrderCheckoutState {}

class ViewAddressSuccessfully extends OrderCheckoutState {}

class ViewAddressFailed extends OrderCheckoutState {}

class DebitCardCheckoutSuccessfully extends OrderCheckoutState {}

class DebitCardCheckoutFailed extends OrderCheckoutState {}

class CheckoutOngoing extends OrderCheckoutState {}

class CheckoutFailed extends OrderCheckoutState {}

class CheckoutSuccess extends OrderCheckoutState {}

class SelectAddress extends OrderCheckoutState {}
