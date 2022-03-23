part of 'sale_condition_bloc.dart';

@immutable
abstract class SaleConditionState {}

class SaleConditionInitial extends SaleConditionState {}

class Initial extends SaleConditionState {}

class Loading extends SaleConditionState {}

class Loaded extends SaleConditionState {}
