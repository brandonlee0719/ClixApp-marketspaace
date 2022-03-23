class RecentProductFeedback {
  List<RecentFeedback> _results;

  List<RecentFeedback> get results => _results;

  RecentProductFeedback({List<RecentFeedback> results}) {
    _results = results;
  }

  RecentProductFeedback.fromJson(dynamic json) {
    if (json["results"] != null) {
      _results = [];
      json["results"].forEach((v) {
        _results.add(RecentFeedback.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    if (_results != null) {
      map["results"] = _results.map((v) => v.toJson()).toList();
    }
    return map;
  }
}

class RecentFeedback {
  String _buyerComment;
  String _buyerDisplayName;
  int _buyerRating;
  int _feedbackID;

  String get buyerComment => _buyerComment;
  String get buyerDisplayName => _buyerDisplayName;
  int get buyerRating => _buyerRating;
  int get feedbackID => _feedbackID;

  RecentFeedback(
      {String buyerComment,
      String buyerDisplayName,
      int buyerRating,
      int feedbackID}) {
    _buyerComment = buyerComment;
    _buyerDisplayName = buyerDisplayName;
    _buyerRating = buyerRating;
    _feedbackID = feedbackID;
  }

  RecentFeedback.fromJson(dynamic json) {
    _buyerComment = json["buyerComment"];
    _buyerDisplayName = json["buyerDisplayName"];
    _buyerRating = json["buyerRating"];
    _feedbackID = json["feedbackID"];
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map["buyerComment"] = _buyerComment;
    map["buyerDisplayName"] = _buyerDisplayName;
    map["buyerRating"] = _buyerRating;
    map["feedbackID"] = _feedbackID;
    return map;
  }
}
