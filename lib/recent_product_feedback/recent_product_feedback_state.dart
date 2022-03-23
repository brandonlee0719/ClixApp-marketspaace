part of 'recent_product_feedback_bloc.dart';

@immutable
abstract class RecentProductFeedbackState {}

class RecentProductFeedbackInitial extends RecentProductFeedbackState {}

class Initial extends RecentProductFeedbackState {}

class Loading extends RecentProductFeedbackState {}

class Loaded extends RecentProductFeedbackState {}

class Failed extends RecentProductFeedbackState {}
