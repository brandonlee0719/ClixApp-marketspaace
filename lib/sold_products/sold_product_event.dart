import 'package:flutter/cupertino.dart';

@immutable
abstract class SoldProductEvent {}

class SoldProductScreenEvent extends SoldProductEvent {}

class SoldProductBuyerInfoEvent extends SoldProductEvent {}

class MarkItemShippedEvent extends SoldProductEvent {}
