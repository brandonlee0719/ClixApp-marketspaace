part of 'profile_setting_bloc.dart';

@immutable
abstract class ProfileSettingEvent {}

class ProfileSettingScreenEvent extends ProfileSettingEvent {}

class LogoutEvent extends ProfileSettingEvent {}

class ViewAddressesEvent extends ProfileSettingEvent {}

class AddNewAddressEvent extends ProfileSettingEvent {}

class UpdateNotificationSettingsEvent extends ProfileSettingEvent {}

class UpdateCurrencyEvent extends ProfileSettingEvent {}
