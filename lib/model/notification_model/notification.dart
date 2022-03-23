class Notifications {
  int id;
  int _time;
  double btcEarned;
  double ethEarned;
  double usdcEarned;
  bool isRead;

  DateTime get time {
    return new DateTime.fromMillisecondsSinceEpoch(_time);
  }

  int get timeStamp => _time;

  Notifications.fromsql(dynamic json) {
    id = json['id'];
    if (json['time'].runtimeType == String) {
      _time = int.parse(json['time']);
    } else {
      _time = json['time'];
    }
    btcEarned = json["btcEarned"];
    ethEarned = json["ethEarned"];
    usdcEarned = json["usdcEarned"];
    if (json['is_read'].runtimeType == int) {
      if (json['is_read'] == 0) {
        isRead = false;
      } else {
        isRead = true;
      }
    } else {
      isRead = json["is_read"];
    }
  }

  Notifications.fromJson(dynamic json) {
    if (json['time'].runtimeType == String) {
      _time = int.parse(json['time']);
    } else {
      _time = json['time'];
    }
    btcEarned = json["BTCInterest"].toDouble();
    ethEarned = json["ETHInterest"].toDouble();
    usdcEarned = json["USDCInterest"].toDouble();
    if (json['is_read'].runtimeType == int) {
      if (json['is_read'] == 0) {
        isRead = false;
      } else {
        isRead = true;
      }
    } else {
      isRead = json["is_read"];
    }
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};

    if (id != null) {
      map['id'] = id;
    }
    map['time'] = _time.toString();
    map['btcEarned'] = btcEarned;
    map['ethEarned'] = ethEarned;
    map['usdcEarned'] = usdcEarned;
    map['is_read'] = isRead;

    return map;

    return map;
  }
}
