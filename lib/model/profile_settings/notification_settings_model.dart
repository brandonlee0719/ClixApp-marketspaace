class NotificationSettingsModel {
  bool _messages;
  bool _soldItems;
  bool _feedbacksReceived;
  bool _orderUpdates;
  bool _investmentUpdates;

  set messages(bool value) {
    _messages = value;
  }

  bool _promotions;

  bool get messages => _messages;
  bool get soldItems => _soldItems;
  bool get feedbacksReceived => _feedbacksReceived;
  bool get orderUpdates => _orderUpdates;
  bool get investmentUpdates => _investmentUpdates;
  bool get promotions => _promotions;

  NotificationSettingsModel(
      {bool messages,
      bool soldItems,
      bool feedbacksReceived,
      bool orderUpdates,
      bool investmentUpdates,
      bool promotions}) {
    _messages = messages;
    _soldItems = soldItems;
    _feedbacksReceived = feedbacksReceived;
    _orderUpdates = orderUpdates;
    _investmentUpdates = investmentUpdates;
    _promotions = promotions;
  }

  NotificationSettingsModel.fromJson(dynamic json) {
    _messages = json["messages"];
    _soldItems = json["soldItems"];
    _feedbacksReceived = json["feedbacksReceived"];
    _orderUpdates = json["orderUpdates"];
    _investmentUpdates = json["investmentUpdates"];
    _promotions = json["promotions"];
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map["messages"] = _messages;
    map["soldItems"] = _soldItems;
    map["feedbacksReceived"] = _feedbacksReceived;
    map["orderUpdates"] = _orderUpdates;
    map["investmentUpdates"] = _investmentUpdates;
    map["promotions"] = _promotions;
    return map;
  }

  set soldItems(bool value) {
    _soldItems = value;
  }

  set feedbacksReceived(bool value) {
    _feedbacksReceived = value;
  }

  set orderUpdates(bool value) {
    _orderUpdates = value;
  }

  set investmentUpdates(bool value) {
    _investmentUpdates = value;
  }

  set promotions(bool value) {
    _promotions = value;
  }
}
