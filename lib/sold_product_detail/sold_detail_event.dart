import 'package:flutter/cupertino.dart';

@immutable
abstract class SoldDetailEvent {}

class SoldDetailScreenEvent extends SoldDetailEvent {}

class UpdateSellerTrackingEvent extends SoldDetailEvent {}

class CancelOrderEvent extends SoldDetailEvent {}

class ExtendProtectionEvent extends SoldDetailEvent {}

class MarkItemShippedEvent extends SoldDetailEvent {}

class RaiseClaimEvent extends SoldDetailEvent {}

class FeedbackSendingEvent extends SoldDetailEvent {}
