import 'package:flutter/cupertino.dart';

@immutable
abstract class SoldProductState {}

class Initial extends SoldProductState {}

class Loading extends SoldProductState {}

class Loaded extends SoldProductState {}

class Failed extends SoldProductState {}

class BuyerInfoLoaded extends SoldProductState {}

class BuyerInfoFailed extends SoldProductState {}

class MarkItemShippedSuccessfully extends SoldProductState {}

class MarkItemShippedFailed extends SoldProductState {}
