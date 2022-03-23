import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';

@immutable
abstract class GeneralInfoState extends Equatable {
  @override
  List<Object> get props => [];
}

class Initial extends GeneralInfoState {}

class Loading extends GeneralInfoState {}

class Loaded extends GeneralInfoState {}

class UserCreateInProgress extends GeneralInfoState {}

class Success extends GeneralInfoState {}

class Failed extends GeneralInfoState {}
