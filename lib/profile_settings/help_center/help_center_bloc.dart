import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'help_center_event.dart';
part 'help_center_state.dart';

class HelpCenterBloc extends Bloc<HelpCenterEvent, HelpCenterState> {
  HelpCenterBloc(HelpCenterState initialState) : super(initialState);

  @override
  HelpCenterState get initialState => Initial();
  @override
  Stream<HelpCenterState> mapEventToState(
    HelpCenterEvent event,
  ) async* {
    if (event is HelpCenterScreenEvent) {
      yield Loading();
      await Future.delayed(Duration(microseconds: 200));
      yield Loaded();
    }
  }
}
