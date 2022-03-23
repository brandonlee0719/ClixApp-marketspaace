part of 'feedback_bloc.dart';

@immutable
abstract class FeedbackState {}

class FeedbackInitial extends FeedbackState {}

class Initial extends FeedbackState {}

class Loading extends FeedbackState {}

class Loaded extends FeedbackState {}

class Failed extends FeedbackState {}
