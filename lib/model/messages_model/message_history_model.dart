import 'package:flutter/cupertino.dart';

class MessageHistoryModel {
  List<HistoryChats> _chats;

  List<HistoryChats> get chats => _chats;

  MessageHistoryModel({
    List<HistoryChats> chats}){
    _chats = chats;
  }

  MessageHistoryModel.fromJson(dynamic json) {
    if (json["chats"] != null) {
      _chats = [];
      json["chats"].forEach((v) {
        _chats.add(HistoryChats.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    if (_chats != null) {
      map["chats"] = _chats.map((v) => v.toJson()).toList();
    }
    return map;
  }

}

class HistoryChats {
  String _groupID;
  List<Messages> _messages;
  List<UserDetails> _userDetails;

  String get groupID => _groupID;
  List<Messages> get messages => _messages;
  List<UserDetails> get userDetails => _userDetails;


  set messages(List<Messages> value) {
    _messages = value;
  }

  HistoryChats({
    String groupID,
    List<Messages> messages,
    List<UserDetails> userDetails}){
    _groupID = groupID;
    _messages = messages;
    _userDetails = userDetails;
  }

  HistoryChats.fromJson(dynamic json) {
    _groupID = json["groupID"];
    if (json["messages"] != null) {
      _messages = [];
      json["messages"].forEach((v) {
        _messages.add(Messages.fromJson(v));
      });
    }
    if (json["userDetails"] != null) {
      _userDetails = [];
      json["userDetails"].forEach((v) {
        _userDetails.add(UserDetails.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map["groupID"] = _groupID;
    if (_messages != null) {
      map["messages"] = _messages.map((v) => v.toJson()).toList();
    }
    if (_userDetails != null) {
      map["userDetails"] = _userDetails.map((v) => v.toJson()).toList();
    }
    return map;
  }

}

class UserDetails {
  String _imgURL;
  String _uid;

  String get imgURL => _imgURL;
  String get uid => _uid;

  UserDetails({
    String imgURL,
    String uid}){
    _imgURL = imgURL;
    _uid = uid;
  }

  UserDetails.fromJson(dynamic json) {
    _imgURL = json["imgURL"];
    _uid = json["uid"];
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map["imgURL"] = _imgURL;
    map["uid"] = _uid;
    return map;
  }

}

class Messages {
  String message;
  String _messageTime;
  String _messageUID;
  String _messageType;
  String conversationId;
  bool isSending = false;
  bool isRead = false;

  static List<String> messageCols = ["messageTable", "body", "date_updated", "author", "type", "conversationId", "isRead" ];

  String imgUrl;

  String get messageType => _messageType;

  set messageType(String value) {
    _messageType = value;
  }



  String get messageTime => _messageTime;
  String get messageUID => _messageUID;

  Messages({
    String message,
    String messageTime,
    String messageUID,
    String messageType,
    String conversationId,
  }){
    this.message = message;
    _messageTime = messageTime;
    _messageUID = messageUID;
    _messageType = messageType;
    this.conversationId = conversationId;

  }

  Messages.fromJson(dynamic json) {
    message = json["body"];
    _messageTime = json["date_updated"];
    _messageUID = json["author"];
    _messageType = json["type"];
    conversationId = json["conversationId"];
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map["body"] = message;
    map["date_updated"] = _messageTime;
    map["author"] = _messageUID;
    map["type"] = _messageType;
    map["conversationId"] = conversationId;
    return map;
  }

  @override
  String toString(){
    return toJson().toString();
  }

  set messageTime(String value) {
    _messageTime = value;
  }

  set messageUID(String value) {
    _messageUID = value;
  }

  bool compareTo(Messages message){

  }
}