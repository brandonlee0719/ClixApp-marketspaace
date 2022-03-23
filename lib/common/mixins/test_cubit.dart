import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'test_state.dart';

enum WrongInputState{
  wrongState,
  normalState
}

class WrongInputCubit extends Cubit<WrongInputState> {
  WrongInputCubit() : super(WrongInputState.normalState);

  void notifyWrongInput(){
    emit(WrongInputState.wrongState);
    emit(WrongInputState.normalState);
  }
}
