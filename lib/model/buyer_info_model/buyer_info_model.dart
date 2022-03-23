class BuyerInfoModel {
  String _buyerBio;
  String _buyerDisplayName;
  String _buyerProfileURL;
  String _country;
  String _firstName;
  String _instructions;
  String _lastName;
  String _postcode;
  String _state;
  String _streetAddress;
  String _suburb;

  String get buyerBio => _buyerBio;
  String get buyerDisplayName => _buyerDisplayName;
  String get buyerProfileURL => _buyerProfileURL;
  String get country => _country;
  String get firstName => _firstName;
  String get instructions => _instructions;
  String get lastName => _lastName;
  String get postcode => _postcode;
  String get state => _state;
  String get streetAddress => _streetAddress;
  String get suburb => _suburb;

  BuyerInfoModel(
      {String buyerBio,
      String buyerDisplayName,
      String buyerProfileURL,
      String country,
      String firstName,
      String instructions,
      String lastName,
      String postcode,
      String state,
      String streetAddress,
      String suburb}) {
    _buyerBio = buyerBio;
    _buyerDisplayName = buyerDisplayName;
    _buyerProfileURL = buyerProfileURL;
    _country = country;
    _firstName = firstName;
    _instructions = instructions;
    _lastName = lastName;
    _postcode = postcode;
    _state = state;
    _streetAddress = streetAddress;
    _suburb = suburb;
  }

  BuyerInfoModel.fromJson(dynamic json) {
    _buyerBio = json["buyerBio"];
    _buyerDisplayName = json["buyerDisplayName"];
    _buyerProfileURL = json["buyerProfileURL"];
    _country = json["country"];
    _firstName = json["firstName"];
    _instructions = json["instructions"];
    _lastName = json["lastName"];
    _postcode = json["postcode"];
    _state = json["state"];
    _streetAddress = json["streetAddress"];
    _suburb = json["suburb"];
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map["buyerBio"] = _buyerBio;
    map["buyerDisplayName"] = _buyerDisplayName;
    map["buyerProfileURL"] = _buyerProfileURL;
    map["country"] = _country;
    map["firstName"] = _firstName;
    map["instructions"] = _instructions;
    map["lastName"] = _lastName;
    map["postcode"] = _postcode;
    map["state"] = _state;
    map["streetAddress"] = _streetAddress;
    map["suburb"] = _suburb;
    return map;
  }
}
