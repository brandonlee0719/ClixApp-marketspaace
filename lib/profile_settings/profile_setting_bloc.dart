import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:market_space/model/address_model/address_model.dart';
import 'package:market_space/model/profile_settings/notification_settings_model.dart';
import 'package:market_space/order_checkout/model/update_address_model/update_address_model.dart';

import 'package:market_space/repositories/auth/auth_repository.dart';
import 'package:market_space/repositories/profile_setting_repository/profile_setting_repository.dart';
import 'package:meta/meta.dart';

part 'profile_setting_event.dart';
part 'profile_setting_state.dart';

class ProfileSettingBloc
    extends Bloc<ProfileSettingEvent, ProfileSettingState> {
  ProfileSettingBloc(ProfileSettingState initialState) : super(initialState);
  final ProfileSettingRepository _profileSettingRepository =
      ProfileSettingRepository();

  Stream<List<UpdateAddressModel>> get addressesStream =>
      _profileSettingRepository.profileSettingProvider.addressStream;
  List<UpdateAddressModel> addressList;
  NotificationSettingsModel notificationSettingStatus;
  String notificationStatus, settingText, settingData;
  AuthRepository _authRepository = AuthRepository();
  String cryptoCurrency, prefCurrency;

  @override
  ProfileSettingState get initialState => Initial();

  @override
  Stream<ProfileSettingState> mapEventToState(
    ProfileSettingEvent event,
  ) async* {
    if (event is ProfileSettingScreenEvent) {
      yield Loading();
      notificationSettingStatus = await _getNotificationSettings();
      if (notificationSettingStatus != null) {
        yield Loaded();
      } else {
        yield NotificationSettingsFailed();
      }
    }
    if (event is LogoutEvent) {
      await _profileSettingRepository.logout();
      yield LogoutSuccessfully();
    }
    if (event is ViewAddressesEvent) {
      addressList = await _viewAddresses();
      if (addressList != null && addressList.isNotEmpty) {
        yield AddressLoadedSuccessfully();
      } else {
        yield AddressLoadingFailed();
      }
    }

    if (event is UpdateNotificationSettingsEvent) {
      notificationStatus = await _updateNotificationSettings();
      if (notificationStatus != null) {
        yield NotificationSettingsUpdated();
      } else {
        yield NotificationSettingsUpdationFailed();
      }
    }
    if (event is UpdateCurrencyEvent) {
      _authRepository.saveCryptoCurrency(cryptoCurrency);
      _authRepository.savePrefferedCurrency(prefCurrency);
      yield CurrencyUpdatedSuccessfully();
    }
  }

  Future<List<UpdateAddressModel>> _viewAddresses() async {
    return await _profileSettingRepository.viewAddresses();
  }

  Future<NotificationSettingsModel> _getNotificationSettings() async {
    return await _profileSettingRepository.getNotificationSettings();
  }

  Future<String> _updateNotificationSettings() async {
    return await _profileSettingRepository.updateNotificationSettings(
        settingText, settingData);
  }
}
