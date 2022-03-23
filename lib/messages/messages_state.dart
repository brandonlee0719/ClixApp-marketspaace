part of 'messages_bloc.dart';

@immutable
abstract class MessagesState {}

class MessagesInitial extends MessagesState {}

class Initial extends MessagesState {}

class Loading extends MessagesState {}

class Loaded extends MessagesState {}

class Failed extends MessagesState {}
