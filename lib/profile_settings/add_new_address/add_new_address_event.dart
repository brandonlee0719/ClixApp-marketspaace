part of 'add_new_address_bloc.dart';

@immutable
abstract class AddNewAddressEvent {}

class AddNewAddressScreenEvent extends AddNewAddressEvent {}

class AddNewAddressButtonEvent extends AddNewAddressEvent {}

class EditAddressButtonEvent extends AddNewAddressEvent {}
// class AddNewAddressEvent extends AddNewAddressEvent {}
