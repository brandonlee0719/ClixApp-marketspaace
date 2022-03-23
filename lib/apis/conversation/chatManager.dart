import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:market_space/model/conversationModels/userModel.dart';
import 'package:market_space/providers/conversationProviders/conversationProvider.dart';
import 'package:market_space/providers/localDatabaseHelper.dart';
import 'package:market_space/repositories/auth/auth_repository.dart';
import 'package:market_space/services/pathService.dart';
import 'package:rxdart/rxdart.dart';
import '../firebaseManager.dart';

class ChatManager {
  final String userTableName = "userTable";
  final String conversationTable = "conversationTable";
  final String messageTable = "messageTable";
  LocalDataBaseHelper helper = LocalDataBaseHelper();
  ValueNotifier<int> lastChatUpdateTime = ValueNotifier<int>(0);
  Map<String, UserModel> userMap = Map<String, UserModel>();
  List<Conversation> conversations = <Conversation>[];
  ValueNotifier<int> conversationLength = ValueNotifier(0);
  StreamSubscription unSentStream;
  ConversationProvider provider = ConversationProvider();
  // ignore: close_sinks
  BehaviorSubject<List<Conversation>> sink =
      BehaviorSubject<List<Conversation>>();

  String _uid;

  bool isMe(String userId) {
    return userId == this._uid;
  }

  // void dispose(){
  //   unSentStream.cancel();
  // }

  Conversation findConversation(String id) {
    for (var conversation in this.conversations) {
      if (conversation.conversationId == id) {
        return conversation;
      }
    }
    return null;
  }

  Future<String> get uid async {
    if (_uid == null) {
      _uid = await AuthRepository().getUserId();
      return _uid;
    }
    return _uid;
  }

  Future<void> getUsers() async {
    var db = await LocalDataBaseHelper().database;
    var results = await db.query(
      userTableName,
    );

    for (var result in results) {
      userMap[result["uid"]] = UserModel.fromJson(result);
    }
  }

  Future<void> getConversations() async {
    var db = await LocalDataBaseHelper().database;
    final results = await db.query(conversationTable);

    for (var result in results) {
      // print("watch result");
      // print(result);
      conversations.add(Conversation.fromJson(result));
      // print(conversations.first.numOfUnread.value);
    }
    this.conversationLength.value = conversations.length;
    this.orderConversation();
    // print("The length of conversation is ${conversations.length}");

    this.sink.add(conversations);
  }

  Future<void> listenToChatChannel() async {
    // print("Listening to chat channel");
    String uid = FirebaseManager().getUID();
    // print("Listening to unsent messages");
    await _listenToUnsent(uid);
  }

  Future<void> _listenToUnsent(String myUid) async {
    this.unSentStream = PathService.conversationUnsentPath
        .getPath()
        .where("to", arrayContains: myUid)
        .snapshots()
        .listen((event) async {
      // print("event detected");
      if (event.docs.length > 0) {
        unSentStream.cancel();
        WriteBatch batch = FirebaseFirestore.instance.batch();
        await Future.delayed(Duration(seconds: 3));
        // print("loading conversations...");
        // print(event.docs.length);
        for (var data in event.docs) {
          // print(data.data());
          // await getUserFromData(data["to"]);

          await addConversation(
              data["conversationId"], data["body"], data["date_updated"]);

          batch.update(data.reference, {
            "to": FieldValue.arrayRemove([myUid]),
          });
        }

        // for(var data in event.docs){
        //   // print('once');
        //   String conversationId = data["conversationId"];
        //   Conversation conversation = findConversation(conversationId);
        //   if(conversation == null){
        //     await addConversation(data["conversationId"]);
        //   }
        //   conversation = findConversation(conversationId);
        //   if(conversation!=null){
        //
        //     // print('once2');
        //     if(conversation.numOfUnread.value == null){
        //       conversation.numOfUnread = ValueNotifier<int>(0);
        //     }
        //     conversation.numOfUnread.value++;
        //     conversation.lastMessage = data["body"];
        //     conversation.lastUpdateTime = data["date_updated"];
        //     await this.updateConversation(conversation);
        //     batch.update(data.reference,
        //         {
        //           "to": FieldValue.arrayRemove([myUid]),
        //         }
        //         );
        //   }
        //
        //
        // }
        // this.orderConversation();

        await batch.commit();
        _listenToUnsent(myUid);
      }
    });
  }

  getUserFromData(List list) async {
    for (var i in list) {
      if (userMap.containsKey(i)) {
        // print("in the map jump!");
        continue;
      } else {
        UserModel model = await provider.getUser(i);
        this.userMap[model.uid] = model;
      }
    }
  }

  Future<void> addConversation(
      String id, String body, String updateTime) async {
    for (var conversation in conversations) {
      if (conversation.conversationId == id) {
        // print('Found');
        conversation.numOfUnread.value += 1;
        conversation.lastMessage = body;
        conversation.lastUpdateTime = updateTime;
        this.orderConversation();

        await this.updateConversation(conversation);
        // print(conversations);
        // print("add to sink!");
        sink.add(conversations);
        return;
      }
    }

    Conversation conversation = await provider.getConversation(id);
    await conversation.loadParticipants();
    conversations.add(conversation);
    conversation.numOfUnread.value += 1;
    conversation.lastMessage = body;
    conversation.lastUpdateTime = updateTime;

    this.orderConversation();
    // print(conversations);
    // print("add to sink!");
    sink.add(conversations);
    await this.updateConversation(conversation);
  }

  Future<void> updateConversation(Conversation conversation) async {
    var db = await LocalDataBaseHelper().database;
    await db.update("conversationTable", conversation.toJson(),
        where: "conversationId=?",
        whereArgs: ['${conversation.conversationId}']);
  }

  void orderConversation() {
    conversations.sort((b, a) => a.compareTo(b));
    sink.add(conversations);
    // this.lastChatUpdateTime.value = DateTime.now().millisecondsSinceEpoch;
  }
}
