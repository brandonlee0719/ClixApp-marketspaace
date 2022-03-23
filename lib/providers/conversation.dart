part of 'localDatabaseHelper.dart';

class Conversation {
  final String messageTable = "messageTable";
  String conversationId;
  List<UserModel> participants = [];
  List<String> simpleParticipants;
  String mediationOrder;
  ValueNotifier<int> numOfUnread;
  String lastUpdateTime;
  bool isOpened = false;
  List<Messages> messages = <Messages>[];
  ValueNotifier<int> messageLengthNotifier = ValueNotifier<int>(0);
  Stream<QuerySnapshot> conversationSnapshot;
  String lastMessage = "I am fine thank you";
  StreamSubscription subscription;
  ConversationApi api = ConversationApi();
  String _conversationName;
  String _conversationCover;

  get conversationName {
    if (_conversationName != null) {
      return _conversationName;
    }
    loadNameAndCover();
    return _conversationName;
  }

  get conversationCover {
    if (_conversationCover != null) {
      return _conversationCover;
    }
    loadNameAndCover();
    return _conversationCover;
  }

  loadNameAndCover() {
    if (this.mediationOrder == null) {
      String id = () {
        String myId = FirebaseManager.instance.getUID();
        for (String id in this.simpleParticipants) {
          if (id != myId) {
            return id;
          }
        }
        return "";
      }();

      ChatManager manager = locator.get<ChatManager>();
      UserModel model = manager.userMap[id];
      _conversationCover = model.imgUrl;
      _conversationName = model.name;
      return;
    }
    _conversationCover =
        "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTNq-fhMeQRIAFfcfgPFaQDO8yTQ_SOW1-6raA_0HgiiKDJTV0TkDiojPT98h40g8T4FAk&usqp=CAU";
    _conversationName = "Mediation with order$mediationOrder";
  }

  Conversation(this.conversationId, this.lastUpdateTime, this.lastMessage,
      {this.participants, this.mediationOrder, int numberOfUnread}) {
    // print("creating conversation");
    // print(numberOfUnread);
    this.numOfUnread = ValueNotifier<int>(numberOfUnread);
    participants = <UserModel>[];
  }

  void dispose() {
    subscription.cancel();
  }

  void resume() {
    // subscription.resume();
    subscribeToConversation();
  }

  Future<void> subscribeToConversation() async {
    conversationSnapshot = await ConversationApi().getSnapshot(conversationId);
    subscription = conversationSnapshot.listen((event) async {
      // print("triggered");
      if (event.size > 0) {
        subscription.pause();
        List<Messages> messages = await api.markAsRead(conversationId);
        addMessages(messages);
        subscription.resume();
      }
    });
    this.numOfUnread.value = 0;
  }

  void addMessages(List<Messages> list) {
    list.sort((b, a) => a.messageTime.compareTo(b.messageTime));
    list.addAll(this.messages);
    this.messages = list;
    this.messageLengthNotifier.value = this.messages.length;
  }

  UserModel getMe() {
    String myUID = FirebaseManager.instance.getUID();
    return locator.get<ChatManager>().userMap[myUID];
  }

  UserModel getOther(String uid) {
    return locator.get<ChatManager>().userMap[uid];
  }

  List<String> getParticipantStrings() {
    String myUID = FirebaseManager.instance.getUID();
    List<String> newList = List.from(simpleParticipants);
    newList.remove(myUID);
    return newList;
  }

  Future<void> sendMessages(String content, String type,
      {isAdmin = false, isMediation = false}) async {
    Messages message = await ConversationApi().sendMessage(
        getParticipantStrings(), content, conversationId, type,
        isAdmin: isAdmin, isMediation: this.mediationOrder != null);
    // this.messages.add(message);
    // print(message);

    List<Messages> list = [message];
    list.addAll(this.messages);
    this.messages = list;
    this.messageLengthNotifier.value = messageLengthNotifier.value + 1;
    this.lastMessage = message.messageType.toLowerCase() == "image"
        ? "image"
        : message.message;
    this.lastUpdateTime = message.messageTime;
    locator.get<ChatManager>().updateConversation(this);
    locator.get<ChatManager>().orderConversation();
  }

  Future<void> getMessages(int offSet, {Function() onComplete}) async {
    Database db = await LocalDataBaseHelper().database;
    int limit = 6;

    if (offSet == 0) {
      limit = 10;
    }

    // Query the table for all The Dogs.
    final List<Map<String, dynamic>> maps = await db.query(messageTable,
        orderBy: 'date_updated DESC',
        limit: limit,
        where: "conversationId = ?",
        whereArgs: [conversationId],
        offset: offSet);

    messages.addAll(List.generate(maps.length, (i) {
      Messages message = Messages.fromJson(maps[i]);
      return message;
    }));

    messageLengthNotifier.value = messageLengthNotifier.value + maps.length;
    onComplete();
  }

  static List<String> conversationTableName = [
    "conversationTable",
    "conversationId",
    "participant",
    "lastUpdateTime",
    "lastMessages",
    "numOfUnread"
  ];

  static Conversation fromJson(Map map) {
    Conversation conversation = Conversation(
      map["conversationId"],
      map["lastUpdateTime"],
      map["lastMessage"],
      numberOfUnread: map[conversationTableName[5]],
      mediationOrder: map["MediationOrder"] ?? null,
    );
    conversation.simpleParticipants = map['participant'].split("/");

    return conversation;
  }

  Map<String, dynamic> toJson() {
    return {
      "conversationId": conversationId,
      "participant": simpleParticipants.join('/'),
      "lastUpdateTime": lastUpdateTime,
      "lastMessage": lastMessage,
      conversationTableName[5]: this.numOfUnread.value,
      "MediationOrder": this.mediationOrder,

      // "hasMediation": this.isMediation
    };
  }

  static String parseTime(DateTime time) {
    DateFormat format;
    DateTime now = DateTime.now();
    DateTime localTime = time.toLocal();

    var localNow = now.toLocal();
    if (localTime.year == localNow.year &&
        localTime.month == localNow.month &&
        localTime.day == localNow.day) {
      format = DateFormat("kk:mm");
    } else {
      format = DateFormat("yyyy/MM/dd kk:mm");
    }
    return format.format(localTime);
  }

  List<String> getParticipants() {
    return this.participants.map((e) => e.uid).toList();
  }

  Future<void> loadParticipants() async {
    ChatManager manager = locator.get<ChatManager>();
    await () async {
      // print("this is participants");
      // print(participants);
      await manager.getUserFromData(simpleParticipants);
      for (String id in simpleParticipants) {
        participants.add(manager.userMap[id]);
      }
    }();
  }

  String getChatName() {
    if (this.mediationOrder != null) {
      return "Mediation chat ${this.mediationOrder}";
    }
    return () {
      ChatManager manager = locator.get<ChatManager>();
      String myUid = FirebaseManager.instance.getUID();
      for (var id in simpleParticipants) {
        if (id != myUid) {
          return "chat with ${manager.userMap[id].name}";
        }
      }
    }();
  }

  int compareTo(Conversation conversation) {
    if (int.parse(this.lastUpdateTime) >
        int.parse(conversation.lastUpdateTime)) {
      return 1;
    }
    return -1;
  }
}
