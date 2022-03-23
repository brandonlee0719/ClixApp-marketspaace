import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'investment_top_up_event.dart';
part 'investment_top_up_state.dart';

class InvestmentTopUpBloc extends Bloc<InvestmentTopUpEvent, InvestmentTopUpState> {
  InvestmentTopUpBloc(InvestmentTopUpState initialState) : super(initialState);

  @override
  Stream<InvestmentTopUpState> mapEventToState(
    InvestmentTopUpEvent event,
  ) async* {
    if (event is InvestmentTopUpEvent) {
      yield Loading();
      await Future.delayed(Duration(microseconds: 300));
      yield Loaded();
    }
  }
}
