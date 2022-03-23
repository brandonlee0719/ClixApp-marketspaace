import 'package:flutter_bloc/flutter_bloc.dart';
import 'forgot_password_otp_events.dart';
import 'forgot_password_otp_state.dart';
import 'package:market_space/repositories/auth/auth_repository.dart';

class ForgotPasswordOtpBloc
    extends Bloc<ForgotPasswordOtpEvents, ForgotPasswordOtpState> {
  ForgotPasswordOtpBloc(ForgotPasswordOtpState initialState)
      : super(initialState);
  static String verificationId;
  static String forget;
  final AuthRepository _authRepository = AuthRepository();

  @override
  ForgotPasswordOtpState get initialState => Initial();

  @override
  Stream<ForgotPasswordOtpState> mapEventToState(
    ForgotPasswordOtpEvents event,
  ) async* {
    if (event is NavigateToLoginScreenEvent) {
      yield Loading();

      yield Loaded(); // In this state we can load the HOME PAGE
    }
    if (event is OtpConfirmedEvent) {
      yield Confirming();
      _authRepository.setOtpConfirmed('true');
      yield Confirmed();
    }
  }
}
