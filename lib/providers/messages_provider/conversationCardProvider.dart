import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:market_space/providers/api_provider.dart';

import 'messageProvider.dart';

class ConversationCardProvider {
  final String conversationId;
  String userId, name, url;
  String uid;

  MessageProvider2 provider = new MessageProvider2();
  AuthProvider auth = new AuthProvider();
  Stream<QuerySnapshot> lastMessageStream;

  DocumentReference userReference;
  CollectionReference conversationReference;

  ConversationCardProvider(this.conversationId) {
    // userReference = FirebaseFirestore.instance.collection('users').doc(userId);
    conversationReference = FirebaseFirestore.instance
        .collection('conversations')
        .doc(conversationId)
        .collection('messages');
  }

  // ignore: missing_return
  //to-do
  List<StreamController<String>> getUserDetials() {
    List<StreamController<String>> controllers =
        new List<StreamController<String>>();
    StreamController<String> nameController = new StreamController<String>();
    StreamController<String> photoCOntroller = new StreamController<String>();
    controllers = [nameController, photoCOntroller];

    _prepareControllers(controllers);

    return controllers;
  }

  Future<void> prepareID() async {
    uid = await auth.getUserUID();
    DocumentSnapshot document = await FirebaseFirestore.instance
        .collection('conversations')
        .doc(conversationId)
        .get();
    String id1 = document['uid1'];
    String id2 = document['uid2'];

    if (id1 == uid) {
      userId = id2;
    } else {
      userId = id1;
    }
  }

  Future<void> _prepareControllers(
      List<StreamController<String>> controllers) async {
    await prepareID();

    userReference =
        await FirebaseFirestore.instance.collection('users').doc(userId);
    userReference.snapshots().listen((value) {
      String name = value["displayName"];
      String url = value["profilePictureURL"];

      this.name = name;

      this.url = url;

      controllers[0].add(name);
      controllers[1].add(url);
    });
  }

  Future<void> prepareUnreadController(StreamController<int> controller) async {
    await prepareID();
    Stream<QuerySnapshot> stream =
        conversationReference.where('isRead', isEqualTo: [userId]).snapshots();
    // Stream<QuerySnapshot> stream2 = conversationReference.where('uid', isEqualTo: userId).where("isRead", arrayContains: uid).snapshots();
    stream.listen((value) {
      controller.add(value.docs.length);
    }
        //   (value1){
        // stream2.listen((value2) {
        //
        //   int int1 = value1.docs.length;
        //   int int2 = value2.docs.length;
        //   controller.add(int1-int2);
        //   // print("int1 is $int1");
        //   // print("int2 is $int2");
        //   // print("i receive this${int1-int2}");
        );
  }

  StreamController<int> getUnreadStream() {
    StreamController<int> controller = StreamController<int>();
    prepareUnreadController(controller);
    return controller;
  }

  StreamController<int> getLastUpdateTime() {
    StreamController<int> controller = StreamController<int>();
    lastMessageStream =
        conversationReference.orderBy('timeStamp').limitToLast(1).snapshots();

    lastMessageStream.listen((value) {
      if (value.docs.length > 0) {
        int stamp = value.docs[0]["timeStamp"];
        // print("我收到了新的时间戳 $stamp");
        controller.add(stamp);
      } else {
        controller.add(DateTime.now().millisecondsSinceEpoch);
      }
    });

    return controller;
  }

  StreamController<String> getLastMessage() {
    StreamController<String> controller = StreamController<String>();
    lastMessageStream.listen((value) async {
      String newMessage = " ";
      if (value.docs.length > 0) {
        String id = value.docs[0]["id"];
        newMessage = (await provider.fetchMessage(conversationId, id)).message;
      }
      controller.add(newMessage);
    });

    return controller;
  }

  ConversationModel getModel() {
    var details = getUserDetials();
    var name = details[0];
    var url = details[1];
    var lastReadTime = getLastUpdateTime();
    var lastMessage = getLastMessage();
    var numOfUnread = getUnreadStream();

    return ConversationModel(name, lastReadTime, lastMessage, numOfUnread, url);
  }
}

class ConversationModel {
  final StreamController<String> name;
  final StreamController<String> url;
  final StreamController<int> lastReadTime;
  final StreamController<String> lastMessage;
  final StreamController<int> numOfUnread;

  ConversationModel(this.name, this.lastReadTime, this.lastMessage,
      this.numOfUnread, this.url);
}
