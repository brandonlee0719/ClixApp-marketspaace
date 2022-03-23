class StatusModel {
  String _status;

  String get status => _status;

  StatusModel({String status}) {
    _status = status;
  }

  StatusModel.fromJson(dynamic json) {
    _status = json["Status"];
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map["Status"] = _status;
    return map;
  }
}
