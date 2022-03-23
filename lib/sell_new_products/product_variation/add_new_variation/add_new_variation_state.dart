part of 'add_new_variation_bloc.dart';

@immutable
abstract class AddNewVariationState {}

class AddNewVariationInitial extends AddNewVariationState {}

class Initial extends AddNewVariationState {}

class Loading extends AddNewVariationState {}

class Loaded extends AddNewVariationState {}
