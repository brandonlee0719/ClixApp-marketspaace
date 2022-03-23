import 'package:equatable/equatable.dart';

class SignUpRequest extends Equatable {
  String _firstName;
  String _lastName;
  String _displayName;
  String _email;
  // String _password;
  // String _confirmPass;
  // String _dateOfBirth;
  String _deviceIDToken;
  String _prefCrypto;
  String _country;

  String get country => _country;

  set country(String value) {
    _country = value;
  }

  String get prefCrypto => _prefCrypto;

  set prefCrypto(String value) {
    _prefCrypto = value;
  }

  String _prefFiat;

  set deviceIDToken(String value) {
    _deviceIDToken = value;
  }

  String get deviceIDToken => _deviceIDToken;

  set firstName(String value) {
    _firstName = value;
  }

  String _phoneNumber;
  String _policies;
  String _communications;

  String get firstName => _firstName;
  String get lastName => _lastName;
  String get displayName => _displayName;
  String get email => _email;
  // String get password => _password;
  // String get confirmPass => _confirmPass;
  // String get dateOfBirth => _dateOfBirth;
  String get phoneNumber => _phoneNumber;
  String get policies => _policies;
  String get communications => _communications;

  SignUpRequest(
      {String firstName,
      String lastName,
      String displayName,
      String email,
      String password,
      String confirmPass,
      // String dateOfBirth,
      String phoneNumber,
      String policies,
      String communications,
      String deviceIDToken,
      String prefFiat,
      String prefCrypto,
      String country}) {
    _country = country;
    _firstName = firstName;
    _lastName = lastName;
    _displayName = displayName;
    _email = email;
    _deviceIDToken = deviceIDToken;
    // _password = password;
    // _confirmPass = confirmPass;
    // _dateOfBirth = dateOfBirth;
    _phoneNumber = phoneNumber;
    _policies = policies;
    _communications = communications;
    _prefCrypto = prefCrypto;
    _prefFiat = prefFiat;
  }

  SignUpRequest.fromJson(dynamic json) {
    _country = json["country"];
    _firstName = json["firstName"];
    _lastName = json["lastName"];
    _displayName = json["displayName"];
    _email = json["email"];
    // _password = json["password"];
    // _confirmPass = json["confirmPass"];
    // _dateOfBirth = json["dateOfBirth"];
    _phoneNumber = json["phoneNumber"];
    _policies = json["policies"];
    _deviceIDToken = json["deviceIDToken"];
    _prefCrypto = json["prefCrypto"];
    _communications = json["communications"];
    _prefFiat = json["prefFiat"];
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map["country"] = _country;
    map["firstName"] = _firstName;
    map["lastName"] = _lastName;
    map["displayName"] = _displayName;
    map["email"] = _email;
    // map["password"] = _password;
    // map["confirmPass"] = _confirmPass;
    // map["dateOfBirth"] = _dateOfBirth;
    map["phoneNumber"] = _phoneNumber;
    map["policies"] = _policies;
    map["communications"] = _communications;
    map["deviceIDToken"] = _deviceIDToken;
    map["prefCrypto"] = _prefCrypto;
    map["prefFiat"] = _prefFiat;
    return map;
  }

  @override
  List<Object> get props => throw UnimplementedError();

  set lastName(String value) {
    _lastName = value;
  }

  set displayName(String value) {
    _displayName = value;
  }

  set email(String value) {
    _email = value;
  }

  // set password(String value) {
  //   // _password = value;
  // }

  // set confirmPass(String value) {
  //   // _confirmPass = value;
  // }

  // set dateOfBirth(String value) {
  //   _dateOfBirth = value;
  // }

  set phoneNumber(String value) {
    _phoneNumber = value;
  }

  set policies(String value) {
    _policies = value;
  }

  set communications(String value) {
    _communications = value;
  }

  String get prefFiat => _prefFiat;

  set prefFiat(String value) {
    _prefFiat = value;
  }
}
