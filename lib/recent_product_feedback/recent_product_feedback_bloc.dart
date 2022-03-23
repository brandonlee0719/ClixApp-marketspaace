import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:market_space/model/recent_product_feedback/recent_product_feedback.dart';
import 'package:market_space/repositories/product_detail_repository/product_detail_repository.dart';
import 'package:meta/meta.dart';

part 'recent_product_feedback_event.dart';
part 'recent_product_feedback_state.dart';

class RecentProductFeedbackBloc
    extends Bloc<RecentProductFeedbackEvent, RecentProductFeedbackState> {
  RecentProductFeedbackBloc(RecentProductFeedbackState initialState)
      : super(initialState);

  final ProductDetailRepository _productDetailRepository =
      ProductDetailRepository();
  int productNum, feedbackId;
  List<RecentFeedback> recentFeedbackList;

  @override
  Stream<RecentProductFeedbackState> mapEventToState(
    RecentProductFeedbackEvent event,
  ) async* {
    if (event is RecentProductFeedbackScreenEvent) {
      yield Loading();
      recentFeedbackList = await _getRecentFeedback();
      if (recentFeedbackList != null) {
        yield Loaded();
      } else {
        yield Failed();
      }
    }
  }

  Future<List<RecentFeedback>> _getRecentFeedback() async {
    return _productDetailRepository.getRecentFeedback(productNum, feedbackId);
  }
}
