part of 'profile_setting_bloc.dart';

@immutable
abstract class ProfileSettingState {}

class ProfileSettingInitial extends ProfileSettingState {}

class Initial extends ProfileSettingState {}

class Loading extends ProfileSettingState {}

class Loaded extends ProfileSettingState {}

class LogoutSuccessfully extends ProfileSettingState {}

class LogoutFailed extends ProfileSettingState {}

class AddressLoadedSuccessfully extends ProfileSettingState {}

class AddressLoadingFailed extends ProfileSettingState {}

class NotificationSettingsFailed extends ProfileSettingState {}

class NotificationSettingsUpdated extends ProfileSettingState {}

class NotificationSettingsUpdationFailed extends ProfileSettingState {}

class CurrencyUpdatedSuccessfully extends ProfileSettingState {}

class CurrencyUpdationFailed extends ProfileSettingState {}
