part of 'receiving_payment_bloc.dart';

@immutable
abstract class ReceivingPaymentEvent {}

class ReceivingPaymentScreenEvent extends ReceivingPaymentEvent {}

class SaveBankDetailsEvent extends ReceivingPaymentEvent {}

class BankStatusEvent extends ReceivingPaymentEvent {}

class PickFileEvent extends ReceivingPaymentEvent {}

class SaveDebitEvent extends ReceivingPaymentEvent {}

class GetBasicCredentialsEvent extends ReceivingPaymentEvent {}

class SaveDebitCardServerEvent extends ReceivingPaymentEvent {}

class SaveOtherDebitDetailsEvent extends ReceivingPaymentEvent {}

class RemoveDebitDetailsEvent extends ReceivingPaymentEvent {}
