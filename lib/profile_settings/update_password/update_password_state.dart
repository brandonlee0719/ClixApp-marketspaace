part of 'update_password_bloc.dart';

@immutable
abstract class UpdatePasswordState {}

class UpdatePasswordInitial extends UpdatePasswordState {}

class Initial extends UpdatePasswordInitial {}

class Loading extends UpdatePasswordInitial {}

class Loaded extends UpdatePasswordInitial {}

class UpdatePasswordSuccessfully extends UpdatePasswordInitial {}

class UpdatePasswordFailed extends UpdatePasswordInitial {}
