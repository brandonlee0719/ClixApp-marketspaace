import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:market_space/apis/firebaseManager.dart';
import 'package:market_space/model/conversationModels/userModel.dart';
import 'package:market_space/model/messages_model/message_history_model.dart';
import 'package:market_space/providers/localDatabaseHelper.dart';
import 'package:market_space/services/locator.dart';
import 'package:market_space/services/pathService.dart';
import 'package:meta/meta.dart';
import 'chatManager.dart';

// this is like a a state that listen to a lot of state, and also it is a state that a lot of state listen to\
// the best practice is that it should be having a addListener function, however it is a pity that i don't implement that
// if you want to work similer stuffs, plz make sure that this has a listener functions, especially when
// on locator singleton service is responsible for several UI changes.
// of course, the notifier is good, but it can't encapsulate the display logic at the best practice.
class ConversationApi {
  final conversationReference = FirebaseFirestore.instance
      .collection("channels")
      .doc("chatChannel")
      .collection("conversations");
  final chatChannel =
      FirebaseFirestore.instance.collection("channels").doc("chatChannel");
  final chatManager = locator.get<ChatManager>();
  LocalDataBaseHelper helper = LocalDataBaseHelper();

  // Future<void> _createUndeliveredConversation(
  //     String uid, String conversationId) async {
  //   final collection = chatChannel.collection('undelivered');
  //   collection.add({
  //     "to": uid,
  //     "conversation": conversationId,
  //   });
  // }

  Future<Stream<QuerySnapshot>> getSnapshot(String conversationId) async {
    final String myUid = await chatManager.uid;
    return conversationReference
        .doc(conversationId)
        .collection('messages')
        .where("to", arrayContains: myUid)
        .snapshots();
  }

  Future<List<Messages>> markAsRead(String conversationId) async {
    List<Messages> messages = List<Messages>();
    final String myUid = await chatManager.uid;
    var documents = await conversationReference
        .doc(conversationId)
        .collection('messages')
        .where("to", arrayContains: myUid)
        .get();
    var docs = documents.docs;

    WriteBatch batch = FirebaseFirestore.instance.batch();
    for (var document in docs) {
      Messages message = Messages(
          message: document["body"],
          messageTime: document["date_updated"],
          messageUID: document["author"],
          messageType: document["type"],
          conversationId: conversationId);
      messages.add(message);
      helper.insertMessage(message);
      // print("read once");
      batch.update(document.reference, {
        "to": FieldValue.arrayRemove([myUid]),
      });
    }
    await batch.commit();
    return messages;
  }

  Future<void> sendMe(String message) async {
    String myuid = await chatManager.uid;
    await conversationReference
        .doc("3qw4lafUgNkRohCY3aTD")
        .collection("messages")
        .add({
      "body": message,
      "date_updated": DateTime.now().millisecondsSinceEpoch.toString(),
      "author": "rPLMag2bJpefZdsmldQ04sKb82U2",
      "type": "Text",
      "to": [myuid],
      "isRead": [],
    });
  }

  Future<Messages> sendMessage(List<String> uids, String messageContent,
      String conversationId, String type,
      {@required bool isMediation, isAdmin = false}) async {
    String myUid = await chatManager.uid;
    if (isAdmin) {
      myUid = "admin";
    }

    Messages message = Messages(
      message: messageContent,
      messageTime: DateTime.now().millisecondsSinceEpoch.toString(),
      messageUID: myUid,
      messageType: type,
      conversationId: conversationId,
    );

    await conversationReference.doc(conversationId).update({
      "lastUpdateTime": DateTime.now().millisecondsSinceEpoch.toString(),
      "lastMessage": message.message,
    });

    await conversationReference.doc(conversationId).collection("messages").add({
      "body": message.message,
      "date_updated": message.messageTime,
      "author": message.messageUID,
      "type": message.messageType,
      "to": isMediation ? [...uids, 'admin'] : [...uids],
      "isRead": [myUid],
    });

    PathService.conversationUnsentPath.getPath().add({
      "body": message.message,
      "date_updated": message.messageTime,
      "conversationId": conversationId,
      "to": isMediation ? [...uids, 'admin'] : [...uids],
    });

    helper.insertMessage(message);

    return message;
  }

  Future<Conversation> _createConversation(uid, userName,
      {isMediation = false}) async {
    String myUid = await chatManager.uid;
    String time = DateTime.now().millisecondsSinceEpoch.toString();

    var result = await conversationReference.add({
      "lastUpdateTime": time,
      "participants": [uid, FirebaseManager.instance.getUID()],
      "lastMessage": "A conversation has been created, try to say something!",
      if (isMediation) "needsMediation": true,
    });

    UserModel participant =
        UserModel(uid, userName, getUserProfileImage(userName, false), null);
    Conversation conversation = Conversation(result.id, time, " ");
    conversation.simpleParticipants = [uid, FirebaseManager.instance.getUID()];
    conversation.lastMessage = "";
    // _createUndeliveredConversation(uid, result.id);
    helper.insertConversation(conversation);
    await conversation.loadParticipants();

    // chatManager.conversationLength.value += 1;
    return conversation;
  }

  Future<Conversation> getConversationFromFire(String conversationId) async {
    var conversationDoc = await conversationReference.doc(conversationId).get();
    // print(conversationDoc.data());
    String myUid = await chatManager.uid;
    UserModel user;
    for (String id in conversationDoc['participants']) {
      if (id != myUid) {
        user = await _getUser(id);
      }
    }

    return Conversation(
        conversationId, DateTime.now().millisecondsSinceEpoch.toString(), " ",
        participants: [user]);
  }

  Future<UserModel> _getUser(String uid) async {
    var user =
        await FirebaseFirestore.instance.collection('users').doc(uid).get();
    String name = user.data()["displayName"];
    return UserModel(uid, name, 'assets/images/seller_img.png', null);
  }

  Future<Conversation> chatTo(String uid, String userName,
      {isMediation = false}) async {
    ChatManager manager = locator.get<ChatManager>();
    Conversation conversation = await _findExistingConversation(uid);
    if (conversation != null) {
      // if (isMediation) {
      //   await sendMessage(
      //       [uid],
      //       "A claim has been declined, and the admin has been included",
      //       conversation.conversationId,
      //       "product");
      //   await conversationReference.doc(conversation.conversationId).update({
      //     "needs mediation": true,
      //   });
      // }
      manager.sink.add(manager.conversations);
      return conversation;
    }
    conversation =
        await _createConversation(uid, userName, isMediation: isMediation);
    chatManager.conversations.add(conversation);
    manager.sink.add(manager.conversations);
    // if (isMediation) {
    //   await sendMessage(
    //       [uid],
    //       "A claim has been declined, and the admin has been included",
    //       conversation.conversationId,
    //       "product");
    // }
    return conversation;
  }

  Future<Conversation> _findExistingConversation(String uid) async {
    for (var conversation in chatManager.conversations) {
      if (conversation.participants.contains(uid) &&
          conversation.mediationOrder == null) {
        return conversation;
      }
    }
    return null;
  }

  String getUserProfileImage(String uid, bool isMe) {
    if (isMe) {
      return 'assets/images/profile_pic.png';
    }
    return 'assets/images/seller_img.png';
  }
}
