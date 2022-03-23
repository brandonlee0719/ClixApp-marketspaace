import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'sale_condition_event.dart';
part 'sale_condition_state.dart';

class SaleConditionBloc extends Bloc<SaleConditionEvent, SaleConditionState> {
  SaleConditionBloc(Initial initial) : super(SaleConditionInitial());

  @override
  Stream<SaleConditionState> mapEventToState(
    SaleConditionEvent event,
  ) async* {
    // TODO: implement mapEventToState
  }
}
