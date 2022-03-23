part of 'edit_email_bloc.dart';

@immutable
abstract class EditEmailState {}

class EditEmailInitial extends EditEmailState {}

class Initial extends EditEmailState {}

class Loading extends EditEmailState {}

class Loaded extends EditEmailState {}

class EmailUpdatedSuccessfully extends EditEmailState {}

class EmailUpdatedFailed extends EditEmailState {}
