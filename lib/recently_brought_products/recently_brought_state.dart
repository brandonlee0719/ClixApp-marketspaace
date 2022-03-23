import 'package:flutter/cupertino.dart';

@immutable
abstract class RecentlyBroughtState {}

class Initial extends RecentlyBroughtState {}

class Loading extends RecentlyBroughtState {}

class Loaded extends RecentlyBroughtState {}

class Failed extends RecentlyBroughtState {}

class OrderStatusInit extends RecentlyBroughtState {}

class OrderStatusSuccessful extends RecentlyBroughtState {}

class OrderStatusFailed extends RecentlyBroughtState {}
