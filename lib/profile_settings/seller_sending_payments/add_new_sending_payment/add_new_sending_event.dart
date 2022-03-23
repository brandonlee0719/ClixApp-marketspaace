part of 'add_new_sending_bloc.dart';

@immutable
abstract class AddNewSendingEvent {}

class AddNewSendingScreenEvent extends AddNewSendingEvent {}

class SaveBankDetailsEvent extends AddNewSendingEvent {}

class BankStatusEvent extends AddNewSendingEvent {}

class PickFileEvent extends AddNewSendingEvent {}

class RemoveBankAccountEvent extends AddNewSendingEvent {}
