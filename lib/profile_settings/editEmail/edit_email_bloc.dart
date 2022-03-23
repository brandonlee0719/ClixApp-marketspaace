import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:market_space/repositories/profile_setting_repository/profile_setting_repository.dart';
import 'package:meta/meta.dart';

part 'edit_email_event.dart';
part 'edit_email_state.dart';

class EditEmailBloc extends Bloc<EditEmailEvent, EditEmailState> {
  EditEmailBloc(EditEmailState initialState) : super(initialState);
  ProfileSettingRepository _profileSettingRepository =
      ProfileSettingRepository();
  String email, newEmail;

  @override
  EditEmailState get initialState => Initial();
  @override
  Stream<EditEmailState> mapEventToState(
    EditEmailEvent event,
  ) async* {
    if (event is EditEmailScreenEvent) {
      yield Loading();
      await Future.delayed(Duration(microseconds: 200));
      yield Loaded();
    }
    if (event is UpdateEmailEvent) {
      yield Loading();
      int status = await _updateEmail();
      if (status == 200) {
        yield EmailUpdatedSuccessfully();
      } else {
        yield EmailUpdatedFailed();
      }
    }
  }

  Future<int> _updateEmail() async {
    return _profileSettingRepository.updateEmail(email, newEmail);
  }
}
