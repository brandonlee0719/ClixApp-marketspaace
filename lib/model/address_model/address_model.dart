import 'package:market_space/order_checkout/model/update_address_model/update_address_model.dart';

class AddressModel {
  List<UpdateAddressModel> _addresses;

  List<UpdateAddressModel> get addresses => _addresses;

  AddressModel({List<UpdateAddressModel> addresses}) {
    _addresses = addresses;
  }

  AddressModel.fromJson(dynamic json) {
    if (json["addresses"] != null) {
      _addresses = [];
      json["addresses"].forEach((v) {
        _addresses.add(UpdateAddressModel.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    if (_addresses != null) {
      map["addresses"] = _addresses.map((v) => v.toJson()).toList();
    }
    return map;
  }
}

class Addresses {
  int _addressNum;
  String _country;
  String _instructions;
  String _phoneNumber;
  String _postcode;
  String _state;
  String _streetAddress;
  String _suburb;

  int get addressNum => _addressNum;
  String get country => _country;
  String get instructions => _instructions;
  String get phoneNumber => _phoneNumber;
  String get postcode => _postcode;
  String get state => _state;
  String get streetAddress => _streetAddress;
  String get suburb => _suburb;

  Addresses(
      {int addressNum,
      String country,
      String instructions,
      String phoneNumber,
      String postcode,
      String state,
      String streetAddress,
      String suburb}) {
    _addressNum = addressNum;
    _country = country;
    _instructions = instructions;
    _phoneNumber = phoneNumber;
    _postcode = postcode;
    _state = state;
    _streetAddress = streetAddress;
    _suburb = suburb;
  }

  Addresses.fromJson(dynamic json) {
    _addressNum = json["addressNum"];
    _country = json["country"];
    _instructions = json["instructions"];
    _phoneNumber = json["phoneNumber"];
    _postcode = json["postcode"].toString();
    _state = json["state"];
    _streetAddress = json["streetAddress"];
    _suburb = json["suburb"];
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map["addressNum"] = _addressNum;
    map["country"] = _country;
    map["instructions"] = _instructions;
    map["phoneNumber"] = _phoneNumber;
    map["postcode"] = _postcode;
    map["state"] = _state;
    map["streetAddress"] = _streetAddress;
    map["suburb"] = _suburb;
    return map;
  }
}
