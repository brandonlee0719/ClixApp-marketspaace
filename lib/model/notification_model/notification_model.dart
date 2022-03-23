import 'notification.dart';

class NotificationModel {
  List<Notifications> _notifications;

  List<Notifications> get notifications => _notifications;

  NotificationModel({List<Notifications> notifications}) {
    _notifications = notifications;
  }

  NotificationModel.fromJson(dynamic json) {
    if (json["allNotifications"] != null) {
      _notifications = [];
      json["allNotifications"].forEach((v) {
        _notifications.add(Notifications.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    if (_notifications != null) {
      map["allNotifications"] = _notifications.map((v) => v.toJson()).toList();
    }
    return map;
  }
}
