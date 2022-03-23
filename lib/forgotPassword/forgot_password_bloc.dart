import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:market_space/forgotPassword/forgot_password_events.dart';
import 'package:market_space/forgotPassword/forgot_password_states.dart';
import 'package:market_space/repositories/forgotPassword/forgotPasswordRepository.dart';

class ForgotPasswordBloc
    extends Bloc<ForgotPasswordEvents, ForgotPasswordState> {
  ForgotPasswordBloc(ForgotPasswordState initialState) : super(initialState);

  final _forgotPassOtp = ForgotPasswordRepository();
  String email;
  String status;
  @override
  ForgotPasswordState get initialState => Initial();

  @override
  Stream<ForgotPasswordState> mapEventToState(
    ForgotPasswordEvents event,
  ) async* {
    if (event is NavigateToLoginScreenEvent) {
      yield Loading();
      await Future.delayed(Duration(
          seconds: 1)); // This is to simulate that above checking process
      yield Loaded(); // In this state we can load the HOME PAGE
    }
    if (event is GeneratePasswordEvent) {
      yield GenrateOTP();
      status = await generateOtp(email);
      if (status.toLowerCase() == "otp sent successfully") {
        yield OTPGenratedSuccessfully();
      } else {
        yield OTPGenrationFailure();
      }
    }
  }

  Future<String> generateOtp(String email) {
    return _forgotPassOtp.genrateOtp(email);
  }
}
