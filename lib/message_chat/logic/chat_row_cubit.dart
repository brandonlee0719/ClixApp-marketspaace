import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:market_space/message_chat/message_chat_route.dart';
import 'package:market_space/model/messages_model/message_history_model.dart';

import 'package:market_space/providers/api_provider.dart';
import 'package:market_space/providers/messages_provider/messageProvider.dart';

enum ChatRowState {
  initial,
  messageLoading,
  messageLoaded,
  messageLoadFail,
  messageSent,
  messageSending,
  messageSending2,
}

enum SendMessageState {
  initial,
  messageSending,
  messageSendingFail,
  messageSendingSuccess,
}

class SendMessageCubit extends Cubit<SendMessageState> {
  MessageProvider2 provider = new MessageProvider2();
  SendMessageCubit(SendMessageState state) : super(state);

  void sendMessage(String message, String conversationId,
      {String type = 'Text'}) async {
    emit(SendMessageState.messageSending);
    try {
      await provider.sendMessage(message, conversationId, type);
    } catch (e) {
      emit(SendMessageState.messageSendingFail);
    }
    emit(SendMessageState.messageSendingSuccess);
  }
}

class ChatRowCubit extends Cubit<ChatRowState> {
  final String conversationId;

  int originalLength;
  List<Messages> messageList = new List<Messages>();
  CollectionReference ref;
  MessageProvider2 provider = new MessageProvider2();
  AuthProvider auth = AuthProvider();
  List<String> messageIds = List();
  String uid;
  StreamSubscription sub;

  ChatRowCubit(this.conversationId) : super(ChatRowState.initial) {
    ref = FirebaseFirestore.instance
        .collection('conversations')
        .doc(conversationId)
        .collection('messages');
    _getChats(conversationId);
    // _getUnreadChat();
  }

  Stream<QuerySnapshot> stream;

  closeAll() {
    sub.cancel();
    stream = null;
  }

  @override
  Future<void> close() {
    // TODO: implement close
    stream = null;
    sub.cancel();
    return super.close();
  }

  void messageFromAnotherUser() {
    ref.add({
      "id": "IMe9280ac4e208419b8ec8a0cdef3096aa",
      "isRead": ["6HEUo5lh4RakJIXjT7IUR5XZO3e2"],
      "timeStamp": DateTime.now().millisecondsSinceEpoch,
      "uid": "6HEUo5lh4RakJIXjT7IUR5XZO3e2",
    });
  }

  Future<void> deleteAll() async {
    QuerySnapshot doc = await ref.get();
    for (QueryDocumentSnapshot d in doc.docs) {
      if (d["uid"] != uid) {
        ref.doc(d.id).delete();
      }
    }
  }

  void _setToRead(QueryDocumentSnapshot documentSnapshot) {
    List list = documentSnapshot['isRead'];
    list.add(uid);
    ref.doc(documentSnapshot.id).update({"isRead": list});
  }

  void _getMessageFromStream(QueryDocumentSnapshot document) {
    emit(ChatRowState.messageSending2);
    this.messageIds.add(document.id);
    Messages message = new Messages(
        messageUID: document['uid'],
        messageTime: document['timeStamp'].toString(),
        message: "Loading",
        messageType: 'Text');
    _setToRead(document);

    // message.isSending = true;
    messageList.add(message);

    int index = messageList.length - 1;
    _getChat(index, document, document['id']);
    emit(ChatRowState.messageSent);
  }

  void _getUnreadChat() async {
    String id = await auth.getUserUID();

    stream = ref.where('isRead', isEqualTo: [MessageChatRoute.id]).snapshots();
    sub = stream.listen((value) {
      for (QueryDocumentSnapshot doc in value.docs) {
        if (!this.messageIds.contains(doc.id)) {
          _getMessageFromStream(doc);
        }
      }
    });
  }

  Future<void> _getChats(conversationId) async {
    uid = await auth.getUserUID();
    emit(ChatRowState.messageLoading);
    QuerySnapshot chatMessages = await ref.orderBy('timeStamp').get();
    for (QueryDocumentSnapshot document in chatMessages.docs) {
      Messages message = new Messages(
          messageUID: document['uid'],
          messageTime: document['timeStamp'].toString(),
          message: "Loading",
          messageType: document['type']);
      if (!(document['isRead'] as List).contains(uid)) {
        _setToRead(document);
      }
      // message.isSending = true;
      messageList.add(message);

      int index = messageList.length - 1;
      if (document['type'] == "Text") {
        _getChat(index, document, document['id']);
      } else if (document['type'] == "Image") {
        message.imgUrl = document['imgUrl'];
      }
    }

    _getUnreadChat();
    emit(ChatRowState.messageLoaded);
  }

  void _getChat(
      index, QueryDocumentSnapshot document, String messageId1) async {
    String newMessage =
        "you will never see this, if you see this, the app should have some problem";
    try {
      newMessage = document["message"];
    } catch (_) {
      newMessage =
          (await provider.fetchMessage(conversationId, messageId1)).message;

      document.reference.update({"message": newMessage});
    } finally {
      messageList[index].message = newMessage;
    }

    emit(ChatRowState.messageLoaded);

    void _getChat(
        index, QueryDocumentSnapshot document, String messageId1) async {
      String newMessage =
          "you will never see this, if you see this, the app should have some problem";
      try {
        newMessage = document["message"];
      } catch (_) {
        newMessage =
            (await provider.fetchMessage(conversationId, messageId1)).message;

        document.reference.update({"message": newMessage});
      } finally {
        messageList[index].message = newMessage;
      }

      emit(ChatRowState.messageLoaded);
    }

    Future<void> sendMessage(String message1) async {
      // print("message sending....");
      emit(ChatRowState.messageSending);
      String uid = await auth.getUserUID();

      Messages message =
          new Messages(message: message1, messageType: 'Text', messageUID: uid);
      message.isSending = true;
      messageList.add(message);
      emit(ChatRowState.messageSent);
    }

    Future<void> sendImage(String message1) async {
      // print("message sending....");
      emit(ChatRowState.messageSending);
      String uid = await auth.getUserUID();

      Messages message = new Messages(
        message: message1,
        messageType: 'Image',
        messageUID: uid,
      );
      message.imgUrl = message1;
      message.isSending = true;
      messageList.add(message);
      emit(ChatRowState.messageSent);
    }
  }
}
