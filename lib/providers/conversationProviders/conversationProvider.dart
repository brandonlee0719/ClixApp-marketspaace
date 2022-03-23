import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:market_space/model/conversationModels/userModel.dart';
import 'package:market_space/providers/localDatabaseHelper.dart';

class ConversationProvider {
  LocalDataBaseHelper db = LocalDataBaseHelper();
  var userRf = FirebaseFirestore.instance.collection("users");
  final conversationReference = FirebaseFirestore.instance
      .collection("channels")
      .doc("chatChannel")
      .collection("conversations");

  Future<UserModel> getUser(String uid) async {
    UserModel model = await db.getUser(uid);
    if (model == null) {
      // print("can't find user from local db, load it from remote");
      var data = await userRf.doc(uid).get();
      Map map = data.data();
      map['uid'] = uid;
      model = UserModel.fromJson(map);
      db.insertUser(model);
    } else {
      // print("found model locally");
      // print(model.imgUrl);
    }
    // print(model.toJson());
    return model;
  }

  Future<Conversation> getConversation(String conversationId) async {
    Conversation conversation;
    conversation = await db.getConversation(conversationId);
    if (conversation != null) {
      // print('load from local!');
      // print(conversation.toJson());
      return conversation;
    }
    var conversationDoc = await conversationReference.doc(conversationId).get();
    String lastMessage = conversationDoc.data()["lastMessage"];
    String mediation = conversationDoc.data()["MediationOrder"];
    conversation = Conversation(
        conversationId, conversationDoc.data()["lastUpdateTime"], lastMessage,
        mediationOrder: mediation, numberOfUnread: 0);
    conversation.simpleParticipants =
        conversationDoc.data()['participants'].cast<String>();
    // print(conversation.toJson());
    db.insertConversation(conversation);
    return conversation;
  }
}
