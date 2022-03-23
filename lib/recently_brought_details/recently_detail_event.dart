import 'package:flutter/cupertino.dart';

@immutable
abstract class RecentlyDetailEvent {}

class RecentlyDetailScreenEvent extends RecentlyDetailEvent {}

class RecentlyOrderStatusEvent extends RecentlyDetailEvent {}

class ConfirmItemReceptionEvent extends RecentlyDetailEvent {}

class BuyerOptionsEvent extends RecentlyDetailEvent {}

class LeaveSellerFeedbackEvent extends RecentlyDetailEvent {}

class CancelBuyerOrderEvent extends RecentlyDetailEvent {}
