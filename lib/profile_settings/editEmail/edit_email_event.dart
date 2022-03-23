part of 'edit_email_bloc.dart';

@immutable
abstract class EditEmailEvent {}

class EditEmailScreenEvent extends EditEmailEvent {}

class UpdateEmailEvent extends EditEmailEvent {}
