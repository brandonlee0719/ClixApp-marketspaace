class BuyerFeedbackModel {
  List<BuyerFeedback> _results;

  List<BuyerFeedback> get results => _results;

  BuyerFeedbackModel({List<BuyerFeedback> results}) {
    _results = results;
  }

  BuyerFeedbackModel.fromJson(dynamic json) {
    if (json["results"] != null) {
      _results = [];
      json["results"].forEach((v) {
        _results.add(BuyerFeedback.fromJson(v));
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

class BuyerFeedback {
  String _sellerComment;
  String _sellerDisplayName;
  String _sellerProfileURL;
  int _sellerRating;
  int _feedbackID;
  String _productTitle;

  String get sellerComment => _sellerComment;
  String get sellerDisplayName => _sellerDisplayName;
  String get sellerProfileURL => _sellerProfileURL;
  int get sellerRating => _sellerRating;
  int get feedbackID => _feedbackID;
  String get productTitle => _productTitle;

  BuyerFeedback(
      {String sellerComment,
      String sellerDisplayName,
      String sellerProfileURL,
      int sellerRating,
      int feedbackID,
      String productTitle}) {
    _sellerComment = sellerComment;
    _sellerDisplayName = sellerDisplayName;
    _sellerProfileURL = sellerProfileURL;
    _sellerRating = sellerRating;
    _feedbackID = feedbackID;
    _productTitle = productTitle;
  }

  BuyerFeedback.fromJson(dynamic json) {
    _sellerComment = json["sellerComment"];
    _sellerDisplayName = json["sellerDisplayName"];
    _sellerProfileURL = json["sellerProfileURL"];
    _sellerRating = json["sellerRating"];
    _feedbackID = json["feedbackID"];
    _productTitle = json["productTitle"];
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map["sellerComment"] = _sellerComment;
    map["sellerDisplayName"] = _sellerDisplayName;
    map["sellerProfileURL"] = _sellerProfileURL;
    map["sellerRating"] = _sellerRating;
    map["feedbackID"] = _feedbackID;
    map["productTitle"] = _productTitle;
    return map;
  }
}
