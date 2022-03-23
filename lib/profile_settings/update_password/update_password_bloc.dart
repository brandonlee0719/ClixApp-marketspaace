import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:market_space/repositories/profile_setting_repository/profile_setting_repository.dart';
import 'package:meta/meta.dart';

part 'update_password_event.dart';
part 'update_password_state.dart';

class UpdatePasswordBloc
    extends Bloc<UpdatePasswordEvent, UpdatePasswordState> {
  UpdatePasswordBloc(UpdatePasswordState initialState) : super(initialState);
  ProfileSettingRepository _profileSettingRepository =
      ProfileSettingRepository();

  String password, confirmPassword;

  @override
  Stream<UpdatePasswordState> mapEventToState(
    UpdatePasswordEvent event,
  ) async* {
    if (event is UpdatePasswordScreenEvent) {
      yield Loading();
      await Future.delayed(Duration(microseconds: 200));
      yield Loaded();
    }
    if (event is UpdatePasswordScreenEvent) {
      yield Loading();
      int status = await _updatePassword();
      if (status == 200) {
        yield UpdatePasswordSuccessfully();
      } else {
        yield UpdatePasswordFailed();
      }
    }
  }

  Future<int> _updatePassword() async {
    return _profileSettingRepository.updatePassword(password, confirmPassword);
  }
}
