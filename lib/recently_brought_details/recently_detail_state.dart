import 'package:flutter/cupertino.dart';

@immutable
abstract class RecentlyDetailState {}

class Initial extends RecentlyDetailState {}

class Loading extends RecentlyDetailState {}

class Loaded extends RecentlyDetailState {}

class OrderStatusInit extends RecentlyDetailState {}

class OrderStatusSuccessful extends RecentlyDetailState {}

class OrderStatusFailed extends RecentlyDetailState {}

class ConfirmItemReceptionInit extends RecentlyDetailState {}

class ConfirmItemReceptionSuccessful extends RecentlyDetailState {}

class ConfirmItemReceptionFailed extends RecentlyDetailState {}

class BuyerOptionsInit extends RecentlyDetailState {}

class BuyerOptionsSuccessful extends RecentlyDetailState {}

class BuyerOptionsFailed extends RecentlyDetailState {}

class LeaveSellerFeedbackInit extends RecentlyDetailState {}

class LeaveSellerFeedbackSuccessful extends RecentlyDetailState {}

class LeaveSellerFeedbackFailed extends RecentlyDetailState {}

class CancelBuyerOrderInit extends RecentlyDetailState {}

class CancelBuyerOrderSuccessful extends RecentlyDetailState {}

class CancelBuyerOrderFailed extends RecentlyDetailState {}
