part of 'notification_bloc.dart';

@immutable
abstract class NotificationState {}

class NotificationInitial extends NotificationState {}

class Initial extends NotificationState {}

class Loading extends NotificationState {}

class Loaded extends NotificationState {}

class Failed extends NotificationState {}

class NoMoreNotification extends NotificationState {}
