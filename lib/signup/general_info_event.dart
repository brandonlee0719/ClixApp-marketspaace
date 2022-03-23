import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';

@immutable
abstract class GeneralInfoEvent extends Equatable {
  const GeneralInfoEvent();
}

class NavigateToHomeScreenEvent extends GeneralInfoEvent {
  @override
  List<Object> get props => throw UnimplementedError();
}

class CreateUserEvent extends GeneralInfoEvent {
  const CreateUserEvent();

  @override
  List<Object> get props => [];
}
