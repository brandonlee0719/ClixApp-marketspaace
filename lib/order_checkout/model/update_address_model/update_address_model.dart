class UpdateAddressModel {
  String _country;
  String _postcode;
  String _state;
  String _phoneNumber;
  String _streetAddress;
  String _streetAddressTwo;
  String _suburb;
  String _firstName;
  String _lastName;

  String get suburb => _suburb;

  set suburb(String value) {
    _suburb = value;
  }

  int _addressNum;

  int get addressNum => _addressNum;

  set addressNum(int value) {
    _addressNum = value;
  }

  set country(String value) {
    _country = value;
  }

  String _instructions;

  String get country => _country;
  String get postcode => _postcode;
  String get state => _state;
  String get phoneNumber => _phoneNumber;
  String get streetAddress => _streetAddress;
  String get streetAddressTwo => _streetAddressTwo;
  String get instructions => _instructions;
  String get firstName => _firstName;
  String get lastName => _lastName;

  UpdateAddressModel({
    String country,
    String postcode,
    String state,
    String phoneNumber,
    String streetAddress,
    String streetAddressTwo,
    String suburb,
    int addressNum,
    String instructions,
    String firstName,
    String lastName,
  }) {
    _country = country;
    _postcode = postcode;
    _state = state;
    _phoneNumber = phoneNumber;
    _streetAddress = streetAddress;
    _streetAddressTwo = streetAddressTwo;
    _instructions = instructions;
    _addressNum = addressNum;
    _suburb = suburb;
    _firstName = firstName;
    _lastName = lastName;
  }

  UpdateAddressModel.fromJson(dynamic json) {
    _country = json["country"];
    _postcode = json["postcode"];
    _state = json["state"];
    _phoneNumber = json["phoneNumber"];
    _streetAddress = json["streetAddress"];
    _streetAddressTwo = json["streetAddressTwo"];
    _instructions = json["instructions"];
    _addressNum = json["addressNum"];
    _suburb = json["suburb"];
    _firstName = json["firstName"];
    _lastName = json["lastName"];
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map["country"] = _country;
    map["postcode"] = _postcode;
    map["state"] = _state;
    map["phoneNumber"] = _phoneNumber;
    map["streetAddress"] = _streetAddress;
    map["streetAddressTwo"] = _streetAddressTwo;
    map["instructions"] = _instructions;
    map["addressNum"] = _addressNum;
    map["suburb"] = _suburb;
    map["firstName"] = _firstName;
    map["lastName"] = _lastName;
    return map;
  }

  set postcode(String value) {
    _postcode = value;
  }

  set state(String value) {
    _state = value;
  }

  set phoneNumber(String value) {
    _phoneNumber = value;
  }

  set streetAddress(String value) {
    _streetAddress = value;
  }

  set streetAddressTwo(String value) {
    _streetAddressTwo = value;
  }

  set instructions(String value) {
    _instructions = value;
  }

  set lastName(String value) {
    _lastName = value;
  }

  set firstName(String value) {
    _firstName = value;
  }
}
