part of 'receiving_payment_bloc.dart';

@immutable
abstract class ReceivingPaymentState {}

class ReceivingPaymentInitial extends ReceivingPaymentState {}

class Initial1 extends ReceivingPaymentState {}

class Loading extends ReceivingPaymentState {}

class Loaded1 extends ReceivingPaymentState {}

class Failure extends ReceivingPaymentState {}

class SaveBankDetails extends ReceivingPaymentState {}

class SaveBankDetailsFailure extends ReceivingPaymentState {}

class BankStatusSuccess extends ReceivingPaymentState {}

class BankStatusFailure extends ReceivingPaymentState {}

class PickFileSuccess extends ReceivingPaymentState {}

class PickFileFailure extends ReceivingPaymentState {}

class SaveDebitCardSuccess extends ReceivingPaymentState {}

class SaveDebitCardFailure extends ReceivingPaymentState {}

class SaveDebitCardServerSuccess extends ReceivingPaymentState {}

class SaveDebitCardServerFailure extends ReceivingPaymentState {}

class GetVaultSuccess extends ReceivingPaymentState {}

class GetVaultFailure extends ReceivingPaymentState {}

class RemoveVaultSuccess extends ReceivingPaymentState {}

class RemoveVaultFailure extends ReceivingPaymentState {}
