import 'package:flutter/cupertino.dart';

@immutable
abstract class ProfileEvent {}

class ProfileScreenEvent extends ProfileEvent {}

class ProfileScreenOrderEvent extends ProfileEvent {}

class ProfileScreenActiveEvent extends ProfileEvent {}

class ProfileImagePickerEvent extends ProfileEvent {}

class ProfileImageCameraEvent extends ProfileEvent {}

class ProfileEditBioEvent extends ProfileEvent {}

class SetProfileURLEvent extends ProfileEvent {}

class ProfileBackgroundEvent extends ProfileEvent {}

class ProfileBackgroundChooseEvent extends ProfileEvent {}

class RecentlyBroughtEvent extends ProfileEvent {}
