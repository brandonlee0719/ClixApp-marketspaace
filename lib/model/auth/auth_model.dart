import 'package:json_annotation/json_annotation.dart';

class AuthModel {
  @JsonKey(name: 'access_token')
  String accessToken;

  @JsonKey(name: 'expires_in')
  int expiresIn;

  @JsonKey(name: 'token_type')
  String tokenType;

  String scope;

  @JsonKey(name: 'refresh_token')
  String refreshToken;
}
