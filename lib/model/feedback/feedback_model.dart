class FeedbackModel {
  List<Results> _results;

  List<Results> get results => _results;

  FeedbackModel({List<Results> results}) {
    _results = results;
  }

  FeedbackModel.fromJson(dynamic json) {
    if (json["results"] != null) {
      _results = [];
      json["results"].forEach((v) {
        _results.add(Results.fromJson(v));
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

class Results {
  String _buyerComment;
  String _buyerDisplayName;
  String _buyerProfileURL;
  int _buyerRating;
  int _feedbackID;
  String _productTitle;

  String get buyerComment => _buyerComment;
  String get buyerDisplayName => _buyerDisplayName;
  String get buyerProfileURL => _buyerProfileURL;
  int get buyerRating => _buyerRating;
  int get feedbackID => _feedbackID;
  String get productTitle => _productTitle;

  Results(
      {String buyerComment,
      String buyerDisplayName,
      String buyerProfileURL,
      int buyerRating,
      int feedbackID,
      String productTitle}) {
    _buyerComment = buyerComment;
    _buyerDisplayName = buyerDisplayName;
    _buyerProfileURL = buyerProfileURL;
    _buyerRating = buyerRating;
    _feedbackID = feedbackID;
    _productTitle = productTitle;
  }

  Results.fromJson(dynamic json) {
    _buyerComment = json["buyerComment"];
    _buyerDisplayName = json["buyerDisplayName"];
    _buyerProfileURL = json["buyerProfileURL"];
    _buyerRating = json["buyerRating"];
    _feedbackID = json["feedbackID"];
    _productTitle = json["productTitle"];
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map["buyerComment"] = _buyerComment;
    map["buyerDisplayName"] = _buyerDisplayName;
    map["buyerProfileURL"] = _buyerProfileURL;
    map["buyerRating"] = _buyerRating;
    map["feedbackID"] = _feedbackID;
    map["productTitle"] = _productTitle;
    return map;
  }
}
