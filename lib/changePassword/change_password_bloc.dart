import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:market_space/repositories/auth/auth_repository.dart';
import 'package:market_space/repositories/forgotPassword/forgotPasswordRepository.dart';

import 'change_password_events.dart';
import 'change_password_state.dart';

class ChangePasswordBloc
    extends Bloc<ChangePasswordEvents, ChangePasswordState> {
  ChangePasswordBloc(ChangePasswordState initialState) : super(initialState);
  final forgotPassRepo = ForgotPasswordRepository();
  String email, pass, otp, confirmPass, status;

  @override
  ChangePasswordState get initialState => Initial();

  @override
  Stream<ChangePasswordState> mapEventToState(
    ChangePasswordEvents event,
  ) async* {
    if (event is NavigateToLoginScreenEvent) {
      yield Loading();
      await Future.delayed(Duration(
          seconds: 1)); // This is to simulate that above checking process
      yield Loaded(); // In this state we can load the HOME PAGE
    }
    if (event is ValidateOTPEvent) {
      yield ValidateOTP();
      status = await validateOtp();
      if (status != null && status.toLowerCase() == "otp sent successfully") {
        yield OtpValidationSuccessful();
      } else {
        yield OtpValidationFailure();
      }
    }
  }

  Future<String> validateOtp() async {
    return await forgotPassRepo.validateOtp(email, pass, confirmPass, otp);
  }
}
