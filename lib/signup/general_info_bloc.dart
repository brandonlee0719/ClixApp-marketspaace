import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:market_space/apis/smsAuthApi.dart';
import 'package:market_space/common/constants.dart';
import 'package:market_space/forgotPassword/forgot_password_bloc.dart';
import 'package:market_space/forgotPasswordOtp/forgot_password_otp_bloc.dart';
import 'package:market_space/forgotPasswordOtp/forgot_password_otp_route.dart';
import 'package:market_space/model/model.dart';
import 'package:market_space/repositories/repository.dart';
import 'package:market_space/signup/general_info_event.dart';
import 'package:market_space/signup/general_info_state.dart';

class GeneralInfoBloc extends Bloc<GeneralInfoEvent, GeneralInfoState> {
  final CreateUserRepository createUserRepository = CreateUserRepository();
  User user;

  GeneralInfoBloc(GeneralInfoState initialState) : super(initialState);

  SignUpRequest signUpRequest;
  String email, pass, deviceTokenID, toastText;
  AuthRepository _authRepository = AuthRepository();
  static String signUpToast;
  String country;
  String varId;

  @override
  GeneralInfoState get initialState => Initial();

  @override
  Stream<GeneralInfoState> mapEventToState(
    GeneralInfoEvent event,
  ) async* {
    if (event is NavigateToHomeScreenEvent) {
      yield Loading();
      deviceTokenID = await _authRepository.getDeviceToken();
      yield Loaded(); // In this state we can load the HOME PAGE
    }

    if (event is SuccessEvent) {
      yield Success();
    }
    if (event is CreateUserEvent) {
      yield Loading();
      user = await _createUserUsingFirebase();
      if (user != null && user != "") {
        int statusCode = await createUser();
        yield UserCreateInProgress();
        if (statusCode == 200) {
          Constants.country = country;
          await _authRepository.saveCountry(country);
          await SmsAuthApi.sendSms(
              (verificationId) =>
                  {varId = verificationId, this.add(SuccessEvent())},
              signUpRequest.phoneNumber);
          yield Loaded();

          // In this state we can load the HOME PAGE
        }
        if (statusCode != 200) {
          yield Loaded();
          await SmsAuthApi.sendSms(
              (verificationId) =>
                  {ForgotPasswordOtpBloc.verificationId = verificationId},
              signUpRequest.phoneNumber);
          yield Failed();
        }
      } else {
        yield Failed();
      }
    }
  }

  yieldSuccess(String id) async* {
    varId = id;
  }

  Future<User> _createUserUsingFirebase() async {
    // String email = signUpRequest.email;
    // String pass = signUpRequest.password;
    user = await createUserRepository.createUserFirebase(email, pass);
    return user;
  }

  Future<int> createUser() async {
    int statusCode = await createUserRepository.createUser(signUpRequest);
    return statusCode;
  }
}

class SuccessEvent extends GeneralInfoEvent {
  @override
  // TODO: implement props
  List<Object> get props => throw UnimplementedError();
}
