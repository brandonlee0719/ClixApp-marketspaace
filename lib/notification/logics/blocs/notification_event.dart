part of 'notification_bloc.dart';

@immutable
abstract class NotificationEvent {}
class NotificationScreenEvent extends NotificationEvent{}
class LoadMoreNotification extends NotificationEvent{
  LoadMoreNotification();
}
class LoadNotification  extends NotificationEvent {}

class Done extends NotificationEvent{}
