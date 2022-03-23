part of 'message_chat_bloc.dart';

@immutable
abstract class MessageChatEvent {}

class MessageChatScreenEvent extends MessageChatEvent {}

class MessageSendEvent extends MessageChatEvent {}

class PickImageEvent extends MessageChatEvent {}

class CameraImageEvent extends MessageChatEvent {}
