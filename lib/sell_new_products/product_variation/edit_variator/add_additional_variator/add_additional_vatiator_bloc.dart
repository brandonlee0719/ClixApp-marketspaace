import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'add_additional_vatiator_event.dart';
part 'add_additional_vatiator_state.dart';

class AddAdditionalVatiatorBloc
    extends Bloc<AddAdditionalVatiatorEvent, AddAdditionalVatiatorState> {
  AddAdditionalVatiatorBloc(Initial initial)
      : super(AddAdditionalVatiatorInitial());

  @override
  Stream<AddAdditionalVatiatorState> mapEventToState(
    AddAdditionalVatiatorEvent event,
  ) async* {
    // TODO: implement mapEventToState
  }
}
