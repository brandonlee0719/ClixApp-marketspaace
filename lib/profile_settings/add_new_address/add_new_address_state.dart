part of 'add_new_address_bloc.dart';

@immutable
abstract class AddNewAddressState {}

class AddNewAddressInitial extends AddNewAddressState {}

class Initial extends AddNewAddressState {}

class Loading extends AddNewAddressState {}

class Loaded extends AddNewAddressState {}

class AddNewAddressSuccessfully extends AddNewAddressState {}

class AddNewAddressFailed extends AddNewAddressState {}

class EditAddressSuccessfully extends AddNewAddressState {}

class EditAddressFailed extends AddNewAddressState {}
