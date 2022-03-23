import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:market_space/model/feedback/buyer_feedback_model.dart';
import 'package:market_space/model/feedback/feedback_model.dart';
import 'package:market_space/repositories/profile_repository/profile_repository.dart';
import 'package:meta/meta.dart';

import 'feedback_route.dart';

part 'feedback_event.dart';

part 'feedback_state.dart';

class FeedbackBloc extends Bloc<FeedbackEvent, FeedbackState> {
  FeedbackBloc(FeedbackState initialState) : super(initialState);
  final ProfileRepository _profileRepository = ProfileRepository();
  int feedbackId = 0;

  Stream<List<Results>> get feedbackStream =>
      _profileRepository.profileProvider.feedbackStream;
  Stream<List<BuyerFeedback>> get feedbackBuyerStream =>
      _profileRepository.profileProvider.feedbackBuyerStream;

  @override
  Stream<FeedbackState> mapEventToState(
    FeedbackEvent event,
  ) async* {
    if (event is FeedbackScreenEvent) {
      yield Initial();
      int status;
      if (FeedbackRoute.isSeller) {
        status = await _getSellerFeedback();
      } else {
        status = await _getBuyerFeedback();
      }
      if (status == 200) {
        yield Loaded();
      } else {
        yield Failed();
      }
    }
  }

  Future<int> _getSellerFeedback() async {
    return _profileRepository.getFeedback(feedbackId, true);
  }

  Future<int> _getBuyerFeedback() async {
    return _profileRepository.getFeedback(feedbackId, false);
  }
}
