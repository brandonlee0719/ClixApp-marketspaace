import 'package:market_space/model/address_model/address_model.dart';
import 'package:market_space/model/profile_settings/notification_settings_model.dart';
import 'package:market_space/order_checkout/model/update_address_model/update_address_model.dart';
import 'package:market_space/providers/profile_setting_provider/profile_setting_provider.dart';

class ProfileSettingRepository {
  final ProfileSettingProvider profileSettingProvider =
      ProfileSettingProvider();

  Future<void> logout() async{
    await profileSettingProvider.logout();
  }

  Future<int> updateEmail(String email, String newEmail) async {
    return await profileSettingProvider.updateEmail(email, newEmail);
  }

  Future<List<UpdateAddressModel>> viewAddresses() async {
    return await profileSettingProvider.viewAddresses();
  }

  Future<int> addNewAddress(UpdateAddressModel addressModel) async {
    return await profileSettingProvider.addNewAddress(addressModel);
  }

  Future<int> editAddress(UpdateAddressModel addressModel) async {
    return await profileSettingProvider.editAddress(addressModel);
  }

  Future<int> updatePassword(String password, String confirmPassword) async {
    return await profileSettingProvider.updatePassword(
        password, confirmPassword);
  }

  Future<NotificationSettingsModel> getNotificationSettings() async {
    return await profileSettingProvider.getNotificationSettings();
  }

  Future<String> updateNotificationSettings(
      String settingText, String data) async {
    return await profileSettingProvider.updateNotificationSettings(
        settingText, data);
  }
}
