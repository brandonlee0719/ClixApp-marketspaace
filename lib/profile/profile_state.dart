import 'package:flutter/cupertino.dart';

@immutable
abstract class ProfileState {}

class Initial extends ProfileState {}

class Loading extends ProfileState {}

class Loaded extends ProfileState {}

class Failed extends ProfileState {}

class PickImage extends ProfileState {}

class ImagePicked extends ProfileState {}

class ImagePicFailed extends ProfileState {}

class EditBio extends ProfileState {}

class EditBioSuccessful extends ProfileState {}

class EditBioFailed extends ProfileState {}

class ProfileFailed extends ProfileState {}

class SetProfileURLState extends ProfileState {}

class SetProfileURLSuccessful extends ProfileState {}

class SetProfileURLFailed extends ProfileState {}

class SetBackgroundUrlSuccessful extends ProfileState {}

class SetBackgroundUrlFailed extends ProfileState {}
