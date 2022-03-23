part of 'add_new_sending_bloc.dart';

@immutable
abstract class AddNewSendingState {}

class AddNewSendingInitial extends AddNewSendingState {}

class Loading extends AddNewSendingState {}

class Initial extends AddNewSendingState {}

class Loaded extends AddNewSendingState {}

class Failure extends AddNewSendingState {}

class SaveBankDetails extends AddNewSendingState {}

class SaveBankDetailsFailure extends AddNewSendingState {}

class BankStatusSuccess extends AddNewSendingState {}

class BankStatusFailure extends AddNewSendingState {}

class PickFileSuccess extends AddNewSendingState {}

class PickFileFailure extends AddNewSendingState {}

class BankAccountRemovedSuccess extends AddNewSendingState {}

class BankAccountRemovedFailure extends AddNewSendingState {}
