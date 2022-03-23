import 'package:flutter/cupertino.dart';

@immutable
abstract class RecentlyBroughtEvent {}

class RecentlyBroughtScreenEvent extends RecentlyBroughtEvent {}

class RecentlyOrderStatusEvent extends RecentlyBroughtEvent {}
