class MessagesModel {
  List<Chats> _chats;

  List<Chats> get chats => _chats;

  MessagesModel({List<Chats> chats}) {
    _chats = chats;
  }

  MessagesModel.fromJson(dynamic json) {
    if (json["chats"] != null) {
      _chats = [];
      json["chats"].forEach((v) {
        _chats.add(Chats.fromJson(v));
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

class Conversation {
  // String lastMessageTime = "28-03-2021 18:33:33";
  String id;
}

class Chats {
  String _groupID;
  String _lastMsgContent;
  String _lastMsgTime;
  String _lastUserUID;
  String _lastMsgType;

  String get lastMsgType => _lastMsgType;
  String _opened;
  List<UserDetails> _userDetails;

  String get groupID => _groupID;
  String get lastMsgContent => _lastMsgContent;
  String get lastMsgTime => _lastMsgTime;
  String get lastUserUID => _lastUserUID;
  String get opened => _opened;
  List<UserDetails> get userDetails => _userDetails;

  Chats(
      {String groupID,
      String lastMsgContent,
      String lastMsgTime,
      String lastUserUID,
      String opened,
      String lastMsgType,
      List<UserDetails> userDetails}) {
    _groupID = groupID;
    _lastMsgContent = lastMsgContent;
    _lastMsgTime = lastMsgTime;
    _lastUserUID = lastUserUID;
    _opened = opened;
    _userDetails = userDetails;
    _lastMsgType = lastMsgType;
  }

  Chats.fromJson(dynamic json) {
    _groupID = json["groupID"];
    _lastMsgContent = json["lastMsgContent"];
    _lastMsgTime = json["lastMsgTime"];
    _lastUserUID = json["lastUserUID"];
    _opened = json["opened"];
    _lastMsgType = json["lastMsgType"];
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
    map["lastMsgContent"] = _lastMsgContent;
    map["lastMsgTime"] = _lastMsgTime;
    map["lastUserUID"] = _lastUserUID;
    map["opened"] = _opened;
    map["lastMsgType"] = _lastMsgType;
    if (_userDetails != null) {
      map["userDetails"] = _userDetails.map((v) => v.toJson()).toList();
    }
    return map;
  }
}

class UserDetails {
  String _imgURL;
  String _uid;
  String _displayName;

  String get displayName => _displayName;

  String get imgURL => _imgURL;
  String get uid => _uid;

  UserDetails({String imgURL, String uid, String displayName}) {
    _imgURL = imgURL;
    _uid = uid;
    _displayName = displayName;
  }

  UserDetails.fromJson(dynamic json) {
    _imgURL = json["imgURL"];
    _uid = json["uid"];
    _displayName = json["displayName"];
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map["imgURL"] = _imgURL;
    map["uid"] = _uid;
    map["displayName"] = _displayName;
    return map;
  }
}
