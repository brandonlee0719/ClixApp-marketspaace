part of 'message_chat_bloc.dart';

@immutable
abstract class MessageChatState {}

class MessageChatInitial extends MessageChatState {}

class Initial extends MessageChatState {}

class Loading extends MessageChatState {}

class Loaded extends MessageChatState {}

class Failed extends MessageChatState {}

class MessageSendSuccessfully extends MessageChatState {}

class MessageSendFailed extends MessageChatState {}

class PickImageSuccessful extends MessageChatState {}

class PickImageFailed extends MessageChatState {}

class CameraPickImageSuccessful extends MessageChatState {}

class CameraPickImageFailed extends MessageChatState {}
