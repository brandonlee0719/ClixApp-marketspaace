import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dio/dio.dart';
import 'package:market_space/model/messages_model/message_history_model.dart';
import 'package:market_space/providers/api_provider.dart';

part 'messageProviderExtension.dart';

//this is the twillo message package that work with twillo
class MessageProvider2 {
  _MessagePackage package = _MessagePackage();
  _FireConversation fireConversation = _FireConversation();
  final auth = AuthProvider();

  Future<String> createrConversation(uid2) async {
    String uid1 = await auth.getUserUID();
    final String id = await package.createConversation();
    await fireConversation.createConversation(id, uid1, uid2);
    await package._addParticipants(uid1, id);
    await package._addParticipants(uid2, id);
    return id;
  }

  Future<void> sendMessage(
      String message, String conversationId, String type) async {
    String uid1 = await auth.getUserUID();
    String id = await package.sendMessage(message, uid1, conversationId);
    fireConversation.sendMessage(id, conversationId, uid1, type, message);
  }

  Future<Messages> fetchMessage(String conversationId, String messageId) async {
    Messages msg = await package.getMessage(conversationId, messageId);
    return msg;
  }
}

class _MessagePackage {
  final _name = "AC75fce873215a5aed5d6014847fb1803a";
  final _password = "c6ac6db3f6db0812e9d149c546c251f3";
  final _baseUrl = 'https://conversations.twilio.com/v1';
  Dio _dio = Dio();
  String _getBasicAuth() {
    return 'Basic ' + base64Encode(utf8.encode('$_name:$_password'));
  }

  Future<Response> _get(String url) async {
    var basicAuth = _getBasicAuth();
    _dio.options.headers["Authorization"] = basicAuth;
    final Response response = await _dio.get(url,
        options: Options(
          followRedirects: false,
          contentType: Headers.formUrlEncodedContentType,
          validateStatus: (status) {
            return status <= 500;
          },
        ));
    return response;
  }

  Future<Response> _post(String url, {dynamic data}) async {
    var basicAuth = _getBasicAuth();
    _dio.options.headers["Authorization"] = basicAuth;
    final Response response = await _dio.post(
      url,
      options: Options(
        followRedirects: false,
        contentType: Headers.formUrlEncodedContentType,
        validateStatus: (status) {
          return status <= 500;
        },
      ),
      data: data,
    );
    return response;
  }

  Future<Messages> getMessage(String conversationId, String messageId) async {
    String url =
        _baseUrl + "/Conversations/$conversationId/Messages/$messageId";
    Response response = await _get(url);
    // print("wocaonimalegebi");
    if (response.statusCode >= 300) {
      throw ConversationException("message error");
    }
    return Messages.fromJson(response.data);
  }

  Future<String> createConversation() async {
    final url = _baseUrl + "/Conversations";

    // final String uid1 = await auth.getUserUID();
    final Response res = await _post(url);
    if (res.statusCode > 250) {
      // print(res.statusCode);
      throw ConversationException("chat room create fail!");
    }
    // print("sid is:" + res.data['sid']);
    return res.data['sid'];
  }

  Future<void> _addParticipants(uid, conversationId) async {
    final url = _baseUrl + "/Conversations/$conversationId/Participants";
    final Response res = await _post(url, data: {
      "Identity": uid,
    });
    if (res.statusCode > 250) {
      // print(res.statusCode);
      throw ConversationException("add participants wrong!");
    }
  }

  Future<String> sendMessage(
      String message, String uid, String conversationId) async {
    String url = _baseUrl + '/Conversations/$conversationId/Messages';
    final Response res = await _post(url, data: {
      "Author": uid,
      "Body": message,
    });

    if (res.statusCode > 250) {
      // print(res.statusCode);
      // print(res.data);
      throw ConversationException("Message sending error!");
    }
    // print(res.data.toString());

    return res.data["sid"];
  }

  // String _getIdentity(String uid1, String uid2){
  //   if(uid1.compareTo(uid2) == 1){
  //     return "${uid1}_$uid2";
  //   }
  //   return "${uid2}_$uid1";
  // }

}

//this is firebase conversation class that work with conversation
class _FireConversation {
  final CollectionReference _userRef =
      FirebaseFirestore.instance.collection('users');
  final CollectionReference _conversationRef =
      FirebaseFirestore.instance.collection('conversations');
  final auth = AuthProvider();

  Future<void> _addUserConversation(uid, conversationId) async {
    final CollectionReference userConversationRef =
        _userRef.doc(uid).collection('conversations');
    userConversationRef.add({'id': conversationId});
  }

  Future<void> _addConversation(conversationId, uid1, uid2) async {
    _conversationRef.doc(conversationId).set({'uid1': uid1, 'uid2': uid2});
  }

  Future<void> createConversation(conversationId, uid1, uid2) async {
    _addConversation(conversationId, uid1, uid2);
    _addUserConversation(uid1, conversationId);
    _addUserConversation(uid2, conversationId);
  }

  void sendMessage(String id, String conversationId, String uid, String type,
      String message) async {
    _conversationRef.doc(conversationId).collection('messages').add({
      "id": id,
      "uid": uid,
      "isRead": [uid],
      "timeStamp": DateTime.now().millisecondsSinceEpoch,
      "type": type,
      "imgUrl": message,
    });
  }
}

class ConversationException implements Exception {
  final String cause;
  ConversationException(this.cause);
}
