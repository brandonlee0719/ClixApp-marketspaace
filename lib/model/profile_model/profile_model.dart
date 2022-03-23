class ProfileModel {
  String _backgroundPictureURL;
  String _bio;
  String _displayName;
  String _profilePictureURL;
  int _verificationStatus;
  double _currentRating;
  int _numRaters;

  int get numRaters => _numRaters;

  double get currentRating => _currentRating;

  String get backgroundPictureURL => _backgroundPictureURL;
  String get bio => _bio;
  String get displayName => _displayName;
  String get profilePictureURL => _profilePictureURL;
  int get verificationStatus => _verificationStatus;

  ProfileModel(
      {String backgroundPictureURL,
      String bio,
      String displayName,
      String profilePictureURL,
      int verificationStatus,
      double currentRating,
      int numRaters}) {
    _backgroundPictureURL = backgroundPictureURL;
    _bio = bio;
    _displayName = displayName;
    _profilePictureURL = profilePictureURL;
    _verificationStatus = verificationStatus;
    _currentRating = currentRating;
    _numRaters = numRaters;
  }

  ProfileModel.fromJson(dynamic json) {
    _backgroundPictureURL = json["backgroundPictureURL"];
    _bio = json["bio"];
    _displayName = json["displayName"];
    _profilePictureURL = json["profilePictureURL"];

    //bit lazy essentially if there is currentRating it means we are loading seller data so this data will also come through as it
    //is part of seller data
    if (json.containsKey('currentRating')) {
      _verificationStatus = json["verificationStatus"];
      _currentRating = double.parse(json["currentRating"].toString());
      _numRaters = json["numRaters"];
    }
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map["backgroundPictureURL"] = _backgroundPictureURL;
    map["bio"] = _bio;
    map["displayName"] = _displayName;
    map["profilePictureURL"] = _profilePictureURL;
    map["verificationStatus"] = _verificationStatus;
    map["currentRating"] = _currentRating;
    map["numRaters"] = _numRaters;
    return map;
  }
}
