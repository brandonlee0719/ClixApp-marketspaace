import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:market_space/model/category/categories_model_new.dart';
import 'package:market_space/model/dashboard_filter_model/dashboard_filter_model.dart';
import 'package:market_space/providers/auth/auth_provider.dart';

class AuthRepository {
  final AuthProvider _authProvider = AuthProvider();

  Future<String> getEmail() async {
    return await _authProvider.getEmail();
  }

  Future<void> saveLastFourDigit(String digits) async {
    await _authProvider.saveLastFourDigit(digits);
  }

  Future<String> getLastFourDigit() async {
    return await _authProvider.getLastFourDigit();
  }

  Future<void> deleteLastFourDigit() async {
    await _authProvider.deleteLastFourDigit();
  }

  Future<void> saveEmail(String email) async {
    return await _authProvider.saveEmail(email);
  }

  Future<String> getName() async {
    return await _authProvider.getName();
  }

  Future<void> saveName(String email) async {
    return await _authProvider.saveName(email);
  }

  Future<String> getPassword() async {
    return await _authProvider.getPassword();
  }

  Future<void> savePassword(String pass) async {
    return await _authProvider.savePassword(pass);
  }

  Future<void> saveUserFirebaseToken(String token) async {
    return await _authProvider.saveAuthToken(token);
  }

  Future<String> getUserFirebaseToken() async {
    return await _authProvider.getUserFirebaseToken();
  }

  Future<void> saveAuthCredential(String token, String providerID) async {
    await _authProvider.saveAnonymousToken(token);
    return await _authProvider.saveAuthToken(token);
  }

  Future<String> getProviderIds() async {
    return await _authProvider.getProviderId();
  }

  Future<String> getAnonymousToken() async {
    return await _authProvider.getAnonymousToken();
  }

  Future<void> saveSignUpAs(String signUpFrom) async {
    return await _authProvider.saveSignUpType(signUpFrom);
  }

  Future<String> getSignUpType() async {
    return await _authProvider.getSignUpType();
  }

  Future<void> saveProfileImage(String signUpFrom) async {
    return await _authProvider.saveProfileImage(signUpFrom);
  }

  Future<String> getProfileImage() async {
    return await _authProvider.getProfileImage();
  }

  Future<void> clearAll() async {
    await _authProvider.clearAll();
  }

  Future<void> saveDeviceToken(String token) async {
    return await _authProvider.saveDeviceToken(token);
  }

  Future<String> getDeviceToken() async {
    return await _authProvider.getDeviceToken();
  }

  Future<void> saveUserUid(String token) async {
    return await _authProvider.saveUserUID(token);
  }

  Future<String> getUserId() async {
    return await _authProvider.getUserUID();
  }

  Future<void> saveCategoryAdded(String added) async {
    return await _authProvider.saveCategoryAdded(added);
  }

  Future<String> getCategoryAdded() async {
    return await _authProvider.getCategoryAdded();
  }

  Future<CategoriesModel> loadCategoriesFormJson(
      {Map<String, String> body}) async {
    String jsonString =
        await rootBundle.loadString('assets/jsons/categories.json');
    final jsonResponse = json.decode(jsonString);
    return CategoriesModel.fromJson(jsonResponse);
  }

  // Load Dashboard Filters From Json
  Future<DashboardFilterModel> loadDashFiltersFormJson() async {
    String jsonString =
        await rootBundle.loadString('assets/jsons/dash_filters.json');
    final jsonResponse = json.decode(jsonString);
    DashboardFilterModel filter = DashboardFilterModel.fromJson(jsonResponse);
    return filter;
  }

  Future<void> saveBanner(value) async {
    return await _authProvider.saveBanner(value);
  }

  Future<String> getBanner() async {
    return await _authProvider.getBanner();
  }

  // Future<ImageBanner> getBanners() async {
  //   return await _authProvider.getBanner();
  // }

  Future<void> saveBannerDate(String date) async {
    return await _authProvider.saveBannerDate(date);
  }

  Future<String> getBannerDate() async {
    return await _authProvider.getBannerDate();
  }

  Future<void> saveLanguage(String lang) async {
    return await _authProvider.saveLanguage(lang);
  }

  Future<String> getLanguage() async {
    return await _authProvider.getLanguage();
  }

  Future<void> saveInterestingCategories(value) async {
    return await _authProvider.saveInterestingCategories(value);
  }

  Future<String> getInterestingCategories() async {
    return await _authProvider.getInterestingCategories();
  }

//
  Future<void> savePrefferedCurrency(String currency) async {
    return await _authProvider.savePrefferedCurrency(currency);
  }

  Future<String> getPrefferedCurrency() async {
    return await _authProvider.getPrefferedCurrency();
  }

  Future<void> saveCryptoCurrency(String currency) async {
    return await _authProvider.saveCryptoCurrency(currency);
  }

  Future<String> getCryptoCurrency() async {
    return await _authProvider.getCryptoCurrency();
  }

  Future<void> saveFavoriteProducts(value) async {
    return await _authProvider.saveFavoriteProducts(value);
  }

  Future<String> getFavoriteProducts() async {
    return await _authProvider.getFavoriteProducts();
  }

  Future<void> saveCountry(String country) async {
    return await _authProvider.saveCountry(country);
  }

  Future<void> setOtpConfirmed(String success) async {
    return await _authProvider.setOtpConfirmed(success);
  }

  Future<String> getOtpConfirmed() async {
    return await _authProvider.getOtpConfirmed(); 
  }

  Future<String> getCountry() async {
    return await _authProvider.getCountry();
  }

  Future<void> saveBankDetails(value) async {
    return await _authProvider.saveBankDetails(value);
  }

  Future<String> getBankDetails() async {
    return await _authProvider.getBankDetails();
  }

  Future<void> saveUserName(String country) async {
    return await _authProvider.saveUserName(country);
  }

  Future<String> getUserName() async {
    return await _authProvider.getUserName();
  }

  Future<void> savePassPhrase(String passPhrase) async {
    return await _authProvider.savePassPhrase(passPhrase);
  }

  Future<String> getPassPhrase() async {
    return await _authProvider.getPassPhrase();
  }

  Future<void> saveVaultToken(String vaultToken) async {
    return await _authProvider.saveVaultToken(vaultToken);
  }

  Future<String> getVaultToken() async {
    return await _authProvider.getVaultToken();
  }

  Future<void> saveVaultUsername(String username) async {
    return await _authProvider.saveVaultUsername(username);
  }

  Future<String> getVaultUsername() async {
    return await _authProvider.getVaultUsername();
  }

  Future<void> saveVaultPassword(String password) async {
    return await _authProvider.saveVaultPassword(password);
  }

  Future<String> getVaultPassword() async {
    return await _authProvider.getVaultPassword();
  }

  Future<void> addCartProducts(value) async {
    return await _authProvider.addCartProducts(value);
  }

  Future<void> deleteCartProducts(value) async {
    return await _authProvider.deleteCartProducts(value);
  }

  Future<String> getCartProducts() async {
    return await _authProvider.getCartProducts();
  }
}
