import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:market_space/apis/firebaseManager.dart';
import 'package:market_space/common/constants.dart';
import 'package:market_space/repositories/auth/auth_repository.dart';

class AuthProvider {
  final FlutterSecureStorage _storage = Constants.singletonSecureStorage;

  final String _authTokenKey = 'AuthRepository.authToken';
  static final String _accessToken = 'access_token';
  static final String _tokenType = 'token_type';
  static final String _refreshToken = 'refresh_token';
  static final String _username = 'username';
  static final String _userInfo = 'user_info';
  static final String _email = 'email';
  static final String _name = 'name';
  static final String _phoneNumber = 'phone_number';
  static final String _password = 'password';
  static final String _providerId = 'providerId';
  static final String _anonymousToken = 'anonymousToken';
  static final String _signUpType = 'signUpType';
  static final String _deviceToken = 'deviceToken';
  static final String _userUID = 'userUID';
  static final String _profileImageUrl = 'profileImageUrl';
  static final String _categoriesAdded = 'categoriesAdded';
  static final String _bannerImages = 'bannerImages';
  static final String _bannerImagesDate = 'bannerImagesDate';
  static final String _language = 'language';
  static final String _interestingCategories = 'interestingCategories';
  static final String _prefferedCurrency = 'prefferedCurrency';
  static final String _cryptoCurrency = 'cryptoCurrency';
  static final String _favoriteItem = 'favoriteItem';
  static final String _country = 'country';
  static final String _bankDetails = 'bankDetails';
  static final String _passPhrase = 'passPhrase';
  static final String _vaultToken = 'vaultToken';
  static final String _vaultUsername = 'vaultUsername';
  static final String _vaultPassword = 'vaultPassword';
  static final String _cartProductList = 'cartProductList';
  static final String _fourDigit = 'fourDigit';
  static final String _otpConfirmed = 'otpConfirmed';

  Future<void> setOtpConfirmed(String success) async {
    await _storage.write(key: _otpConfirmed, value: success);
  }

  Future<String> getOtpConfirmed() async {
    return await _storage.read(key: _otpConfirmed);
  }

  Future<void> saveAuthToken(String token) async {
    await _storage.write(key: _accessToken, value: token);
  }

  Future<String> getUserFirebaseToken() async {
    return FirebaseManager.instance.getAuthToken();
  }

  Future<void> saveEmail(String email) async {
    await _storage.write(key: _email, value: email);
  }

  Future<String> getEmail() async {
    return await _storage.read(key: _email);
  }

  Future<void> saveName(String email) async {
    await _storage.write(key: _name, value: email);
  }

  Future<String> getName() async {
    return await _storage.read(key: _name);
  }

  Future<void> savePassword(String pass) async {
    await _storage.write(key: _password, value: pass);
  }

  Future<String> getPassword() async {
    return await _storage.read(key: _password);
  }

  Future<void> saveProviderId(String providerID) async {
    await _storage.write(key: _providerId, value: providerID);
  }

  Future<String> getProviderId() async {
    return await _storage.read(key: _providerId);
  }

  Future<void> saveAnonymousToken(String anonymousToken) async {
    await _storage.write(key: _anonymousToken, value: anonymousToken);
  }

  Future<String> getAnonymousToken() async {
    return await _storage.read(key: _anonymousToken);
  }

  Future<void> clearAll() async {
    await _storage.deleteAll();
  }

  Future<void> clear(String key) async {
    await _storage.delete(key: key);
  }

  Future<void> saveSignUpType(String type) async {
    await _storage.write(key: _signUpType, value: type);
  }

  Future<String> getSignUpType() async {
    return await _storage.read(key: _signUpType);
  }

  Future<void> saveProfileImage(String image) async {
    await _storage.write(key: _profileImageUrl, value: image);
  }

  Future<String> getProfileImage() async {
    return await _storage.read(key: _profileImageUrl);
  }

  Future<void> saveDeviceToken(String token) async {
    await _storage.write(key: _deviceToken, value: token);
  }

  Future<String> getDeviceToken() async {
    return await _storage.read(key: _deviceToken);
  }

  Future<void> saveUserUID(String providerID) async {
    await _storage.write(key: _userUID, value: providerID);
  }

  Future<String> getUserUID() async {
    return await _storage.read(key: _userUID);
  }

  Future<void> saveCategoryAdded(String providerID) async {
    await _storage.write(key: _categoriesAdded, value: providerID);
  }

  Future<String> getCategoryAdded() async {
    return await _storage.read(key: _categoriesAdded);
  }

  Future<void> saveBanner(value) async {
    await _storage.write(key: _bannerImages, value: jsonEncode(value));
  }

  Future<String> getBanner() async {
    return await _storage.read(key: _bannerImages);
  }

  Future<void> saveBannerDate(String value) async {
    await _storage.write(key: _bannerImagesDate, value: value);
  }

  Future<String> getBannerDate() async {
    return await _storage.read(key: _bannerImagesDate);
  }

  Future<void> saveLanguage(String value) async {
    await _storage.write(key: _language, value: value);
  }

  Future<String> getLanguage() async {
    return await _storage.read(key: _language);
  }

  Future<void> saveInterestingCategories(value) async {
    await _storage.write(key: _interestingCategories, value: jsonEncode(value));
  }

  Future<String> getInterestingCategories() async {
    // print(await _storage.read(key: _interestingCategories));
    return await _storage.read(key: _interestingCategories);
  }

  Future<void> savePrefferedCurrency(String value) async {
    await _storage.write(key: _prefferedCurrency, value: value);
  }

  Future<String> getPrefferedCurrency() async {
    return await _storage.read(key: _prefferedCurrency);
  }

  Future<void> saveCryptoCurrency(String value) async {
    await _storage.write(key: _cryptoCurrency, value: value);
  }

  Future<String> getCryptoCurrency() async {
    return await _storage.read(key: _cryptoCurrency);
  }

  Future<void> saveFavoriteProducts(value) async {
    await _storage.write(key: _favoriteItem, value: jsonEncode(value));
  }

  Future<String> getFavoriteProducts() async {
    final result = await _storage.read(key: _favoriteItem);
    return result ?? "[]";
  }

  Future<void> saveCountry(String value) async {
    await _storage.write(key: _country, value: value);
  }

  Future<String> getCountry() async {
    return await _storage.read(key: _country);
  }

  Future<void> saveBankDetails(value) async {
    await _storage.write(key: _bankDetails, value: jsonEncode(value));
  }

  Future<String> getBankDetails() async {
    return await _storage.read(key: _bankDetails);
  }

  Future<void> saveUserName(String value) async {
    await _storage.write(key: _username, value: value);
  }

  Future<String> getUserName() async {
    return await _storage.read(key: _username);
  }

  Future<void> savePassPhrase(String passPhrase) async {
    await _storage.write(key: _passPhrase, value: passPhrase);
  }

  Future<String> getPassPhrase() async {
    return await _storage.read(key: _passPhrase);
  }

  Future<void> saveVaultToken(String vaultToken) async {
    await _storage.write(key: _vaultToken, value: vaultToken);
  }

  Future<String> getVaultToken() async {
    return await _storage.read(key: _vaultToken);
  }

  Future<void> saveLastFourDigit(String digits) async {
    await _storage.write(key: _fourDigit, value: digits);
  }

  Future<void> deleteLastFourDigit() async {
    await _storage.delete(key: _fourDigit);
  }

  Future<String> getLastFourDigit() async {
    return await _storage.read(key: _fourDigit);
  }

  Future<void> saveVaultUsername(String vaultUsername) async {
    await _storage.write(key: _vaultUsername, value: vaultUsername);
  }

  Future<String> getVaultUsername() async {
    return await _storage.read(key: _vaultUsername);
  }

  Future<void> saveVaultPassword(String password) async {
    await _storage.write(key: _vaultPassword, value: password);
  }

  Future<String> getVaultPassword() async {
    return await _storage.read(key: _vaultPassword);
  }

  Future<void> addCartProducts(value) async {
    await _storage.write(key: _cartProductList, value: jsonEncode(value));
  }

  Future<void> deleteCartProducts(value) async {
    await _storage.delete(key: _cartProductList);
  }

  Future<String> getCartProducts() async {
    return await _storage.read(key: _cartProductList);
  }
}
