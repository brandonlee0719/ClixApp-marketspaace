import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'edit_variator_event.dart';
part 'edit_variator_state.dart';

class EditVariatorBloc extends Bloc<EditVariatorEvent, EditVariatorState> {
  EditVariatorBloc(Initial initial) : super(EditVariatorInitial());

  @override
  Stream<EditVariatorState> mapEventToState(
    EditVariatorEvent event,
  ) async* {
    // TODO: implement mapEventToState
  }
}
