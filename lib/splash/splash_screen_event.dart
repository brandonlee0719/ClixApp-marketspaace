import 'package:flutter/cupertino.dart';

@immutable
abstract class SplashScreenEvent {}

class NavigateToHomeScreenEvent extends SplashScreenEvent {}

class NavigateToNotificationEvent extends SplashScreenEvent {}

class CheckLoginBioMetricAvaiable extends SplashScreenEvent {}

class LaunchBiometric extends SplashScreenEvent {}
