part of 'investment_top_up_bloc.dart';

@immutable
abstract class InvestmentTopUpState {}

class InvestmentTopUpInitial extends InvestmentTopUpState {}
class Initial extends InvestmentTopUpState {}

class Loading extends InvestmentTopUpState {}

class Loaded extends InvestmentTopUpState {}