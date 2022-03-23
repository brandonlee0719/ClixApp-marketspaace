import 'package:market_space/providers/forgotPassword/forgotPasswordOTPGenProvider.dart';

class ForgotPasswordRepository {
  final forgotPassProvider = ForgotPasswordOtpGenProvider();

  Future<String> validateOtp(
      String email, String pass, String confirmPass, String otp) {
    return forgotPassProvider.validateOTP(email, pass, confirmPass, otp);
  }

  Future<String> genrateOtp(String email) {
    return forgotPassProvider.getOTPFromEmail(email);
  }
}
