import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:market_space/apis/navigationApi.dart';
import 'package:market_space/apis/smsAuthApi.dart';
import 'package:market_space/apis/userApi/UserApi.dart';
import 'package:market_space/apis/validatorApi.dart';
import 'package:market_space/common/colors.dart';
import 'package:market_space/forgotPassword/widgets/zombieWidgets.dart';
import 'package:market_space/forgotPasswordOtp/forgot_password_otp_bloc.dart';
import 'package:market_space/forgotPasswordOtp/forgot_password_otp_route.dart';
import 'package:market_space/representation/buttons.dart';
import 'package:market_space/representation/headers.dart';
import 'package:market_space/representation/inputBox.dart';
import 'package:market_space/representation/titles.dart';
import 'package:market_space/responsive_layout/size_config.dart';
import 'forgot_password_bloc.dart';
import 'forgot_password_states.dart';
import 'package:sms_autofill/sms_autofill.dart';

class ForgotPasswordScreen extends StatefulWidget {
  @override
  _ForgotPasswordScreenState createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  // ignore: non_constant_identifier_names, close_sinks
  final ForgotPasswordBloc _ForgotPasswordBloc = ForgotPasswordBloc(Initial());
  final _globalKey = GlobalKey<ScaffoldState>();

  bool _isLoading = false;
  final TextEditingController _phoneNumberController = TextEditingController();
  bool _emailValid = false;
  VarType type;
  bool isClickable = true;
  var verification;

  @override
  void initState() {
    super.initState();
    _phoneNumberController.addListener(() {
      setState(() {
        type = ValidatorApi().validate(_phoneNumberController.text);
        // print(type);
      });
    });
    // UserApi.phoneExist("+61403208200");
    // UserApi.phoneExist("+61403208238");
    // UserApi.emailExist("duanxinhuan1@gmail.com");
    // UserApi.emailExist("duanxinhuan1@gmail.co");
    // UserApi.getOTPFromEmail(() => {// print("check email success")},
    //     () => {// print("check email fail")}, "kim@southKorea.com");

    // UserApi.getOTPFromEmail(() => {// print("check email success")},
    //     () => {// print("check email fail")}, "duanxinhuan25@163.com");
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: _globalKey,
        resizeToAvoidBottomInset: false,
        backgroundColor: AppColors.toolbarBlue,
        body: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          color: Colors.blue,
          child: BlocProvider(
            create: (_) => _ForgotPasswordBloc,
            child: BlocListener<ForgotPasswordBloc, ForgotPasswordState>(
              listener: (context, state) {},
              child: _forgotPasswordScreen(),
            ),
          ),
        ));
  }

  Widget _forgotPasswordScreen() {
    return Container(
      child: AbsorbPointer(
        absorbing: _isLoading,
        child: Stack(
          children: [
            _forgotPass(),
            Align(
              alignment: Alignment.topLeft,
              child: ZombieQuitButton(
                onPressed: () => {Navigator.pop(context)},
              ),
            ),
            if (_isLoading) ZombieLoading(),
            Align(
              alignment: Alignment.bottomLeft,
              child: ZombieRocket(),
            )
          ],
        ),
      ),
    );
  }

  Widget _forgotPass() {
    return ListView(
      children: <Widget>[
        Container(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(color: Colors.white),
            child: Center(
                child: ListView(
              children: <Widget>[
                ZombieCloudWidget(),
                TitleBuilder().build(TitleSection(
                    TitleSectionType.simpleTitle, "Forget password")),
                HeadersBuilder().build(HeadersSection(HeadersType.inputHeader,
                    "What is the phone number or email address associated with your acount")),
                Padding(
                    padding: EdgeInsets.only(
                        left: SizeConfig.widthMultiplier * 3.8888888888888884,
                        right: SizeConfig.widthMultiplier * 3.8888888888888884,
                        top: SizeConfig.heightMultiplier * 2.0086083213773316),
                    child: Theme(
                      data: ThemeData(
                        primaryColor: Colors.blue,
                        primaryColorDark: Colors.blue.shade700,
                      ),
                      child: InputBuilder().build(InputSection(
                        InputSectionType.inputBox,
                        "Enter phone number",
                        "Example: +61407288366",
                        _phoneNumberController,
                      )),
                    )),
                ButtonBuilder().build(ButtonSection(
                    ButtonSectionType.confirmButton,
                    "Next",
                    () => {
                          if (isClickable) {navigateToOTP()}
                        })),
              ],
            ))),
      ],
    );
  }

  void callSelfFunction(String funcName) {
    if (funcName == "navigateToOTP") {
      navigateToOTP();
    }
  }

  Future<void> navigateToOTP() async {
    isClickable = false;
    // print(isClickable);
    if (type == VarType.phoneNumber) {
      _ForgotPasswordBloc.email = _phoneNumberController.text;

      ForgotPasswordOtpBloc.verificationId = null;
      try {
        await SmsAuthApi.sendSms(
          (verificationId) => {onCodeSent(verificationId)},
          _phoneNumberController.text,
          isForget: true,
        );
        ForgotPassOtpRoute.isForget = true;

        // _ForgotPasswordBloc.add(GeneratePasswordEvent());
      } catch (e) {
        // print(e.toString());
        isClickable = true;
        final snackBar = SnackBar(
          content: Text('your phone number is not exist.'),
        );

        _globalKey.currentState.showSnackBar(snackBar);
      }
    } else if (type == VarType.email) {
      isClickable = false;
      UserApi.getOTPFromEmail(
          () => {NavigationApi.navigateTo("toOTPScreen", param: "emailForget")},
          () => {showSnack("Email address doesn't exist!")},
          _phoneNumberController.text);
    } else {
      isClickable = true;
      showSnack('Enter valid Phone number or email address.');
    }
  }

  void showSnack(String s) {
    final snackBar = SnackBar(
      content: Text(s),
    );

    _globalKey.currentState.showSnackBar(snackBar);
  }

  void onCodeSent(String verificationId) {
    // print("code sent");
    // print(verificationId);
    verification = verificationId;
    NavigationApi.navigateTo("toOTPScreen",
        param: "phoneNumberForget", varID: verification);
  }
}
