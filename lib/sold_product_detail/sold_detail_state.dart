import 'package:flutter/cupertino.dart';

@immutable
abstract class SoldDetailState {}

class Initial extends SoldDetailState {}

class Loading extends SoldDetailState {}

class Loaded extends SoldDetailState {}

class Failed extends SoldDetailState {}

class TrackingUpdated extends SoldDetailState {}

class TrackingFailed extends SoldDetailState {}

class CancelOrderSuccessful extends SoldDetailState {}

class CancelOrderFailed extends SoldDetailState {}

class ProtectionExtendedSuccessful extends SoldDetailState {}

class ProtectionExtensionFailed extends SoldDetailState {}

class MarkItemShippedSuccessfully extends SoldDetailState {}

class MarkItemShippedFailed extends SoldDetailState {}

class SellerOptionsSuccessfully extends SoldDetailState {}

class SellerOptionsFailed extends SoldDetailState {}

class ClaimRaisedSuccessfully extends SoldDetailState {}

class ClaimRaisingFailed extends SoldDetailState {}

class FeedbackSuccessfullySent extends SoldDetailState {}

class FeedbackSendingFailed extends SoldDetailState {}
