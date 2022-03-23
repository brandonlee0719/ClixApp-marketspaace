import 'package:market_space/model/messages_model/message_history_model.dart';
import 'package:market_space/model/messages_model/messages_model.dart';
import 'package:market_space/providers/messages_provider/messages_provider.dart';

class MessagesRepository {
  MessagesProvider _messagesProvider = MessagesProvider();

  Future<List<Chats>> getChats(String dateTime) async {
    return await _messagesProvider.getChats(dateTime);
  }

  Future<List<HistoryChats>> getMessages(String dateTime) async {
    return await _messagesProvider.getHistoryChats(dateTime);
  }

  Future<int> sendMessage(String dateTime, String groupId, String message,
      String messageType) async {
    return await _messagesProvider.sendMessage(
        groupId, message, dateTime, messageType);
  }

  Future<int> markChatRead(
    String groupId,
  ) async {
    return await _messagesProvider.markChatRead(groupId);
  }
}
