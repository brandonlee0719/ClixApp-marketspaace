import 'dart:ffi';
import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:market_space/apis/firebaseManager.dart';
import 'package:market_space/apis/smsAuthApi.dart';
import 'package:market_space/changePassword/change_password_route.dart';
import 'package:market_space/changePassword/change_password_screen.dart';
import 'package:market_space/common/colors.dart';
import 'package:market_space/common/constants.dart';
import 'package:market_space/common/loading_progress.dart';
import 'package:market_space/common/raised_gradient_button.dart';
import 'package:market_space/forgotPassword/widgets/zombieWidgets.dart';
import 'package:market_space/interested_categories/interested_categories_route.dart';
import 'package:market_space/login/login_screen.dart';
import 'package:market_space/providers/localDatabaseHelper.dart';
import 'package:market_space/services/RouterServices.dart';
import 'package:otp_text_field/otp_text_field.dart';
import 'package:otp_text_field/otp_field.dart';
import 'package:otp_text_field/style.dart';
import 'package:otp_text_field/style.dart';
import 'package:market_space/responsive_layout/size_config.dart';
import 'package:market_space/repositories/auth/auth_repository.dart';

import 'forgot_password_otp_bloc.dart';
import 'forgot_password_otp_events.dart';
import 'forgot_password_otp_route.dart';
import 'forgot_password_otp_state.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

class ForgotPasswordOtpScreen extends StatefulWidget {
  String param;
  String varID;
  ForgotPasswordOtpScreen(
    this.param, {
    this.varID,
  }) {
    // print(this.param);
  }

  @override
  _ForgotPasswordOtpScreenState createState() =>
      _ForgotPasswordOtpScreenState();
}

class _ForgotPasswordOtpScreenState extends State<ForgotPasswordOtpScreen> {
  final ForgotPasswordOtpBloc _ForgotPasswordOtpBloc =
      ForgotPasswordOtpBloc(Initial());
  final _globalKey = GlobalKey<ScaffoldState>();

  bool _isLoading = true;
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  OtpFieldController otpController = OtpFieldController();
  final FocusNode _passwordFocus = FocusNode();
  bool _passwordVisible = true;
  bool _passwordInvalid = true;
  bool _email = true;
  bool _emailValid = false;

  @override
  void initState() {
    // success();
    super.initState();
    _ForgotPasswordOtpBloc.add(NavigateToLoginScreenEvent());

    _emailController.addListener(() {
      setState(() {
        _emailValid = RegExp(
                r"^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?)*$")
            .hasMatch(_emailController.text);
      });
    });
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
            create: (_) => _ForgotPasswordOtpBloc,
            child: BlocListener<ForgotPasswordOtpBloc, ForgotPasswordOtpState>(
              listener: (context, state) {
                if (state is Loading) {
                  setState(() {
                    _isLoading = true;
                  });
                }
                if (state is Loaded) {
                  setState(() {
                    _isLoading = false;
                  });
                }
              },
              child: _ForgotPasswordOtpScreen(),
            ),
          ),
        ));
  }

  Widget _ForgotPasswordOtpScreen() {
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
            Align(
              alignment: Alignment.bottomLeft,
              child: _bottomImage(),
            ),
            if (_isLoading)
              BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 0.8, sigmaY: 0.8),
                  child: LoadingProgress(
                    color: Colors.deepOrangeAccent,
                  )),
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
                Image.asset(
                  'assets/images/forgot_pass_top.png',
                  fit: BoxFit.fill,
                ),
                Container(
                  alignment: Alignment.center,
                  margin: EdgeInsets.only(
                      top: SizeConfig.heightMultiplier * 6.922166427546629,
                      left: SizeConfig.widthMultiplier * 17.256944444444443,
                      right: SizeConfig.widthMultiplier * 14.097222222222221),
                  child: Container(
                    child: Text(
                      'Verify your phone number',
                      style: GoogleFonts.lato(
                        fontWeight: FontWeight.w900,
                        fontSize: SizeConfig.textMultiplier * 2.887374461979914,
                        color: AppColors.app_txt_color,
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(
                      left: SizeConfig.widthMultiplier * 3.8888888888888884,
                      right: SizeConfig.widthMultiplier * 3.8888888888888884,
                      top: SizeConfig.heightMultiplier * 8.159971305595409),
                  child: Text(
                    'Please enter the 6 digit code sent to your mobile phone',
                    style: GoogleFonts.lato(
                      fontWeight: FontWeight.bold,
                      fontSize: SizeConfig.textMultiplier * 1.757532281205165,
                      color: AppColors.sub_text,
                      letterSpacing: 0.1,
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(
                      left: SizeConfig.widthMultiplier * 4.8055555555555545,
                      right: SizeConfig.widthMultiplier * 3.548611111111111,
                      top: SizeConfig.heightMultiplier * 3.0129124820659974),
                  // child: PinCodeTextField(

                  // )

                  child: Flexible(
                    child: OTPTextField(
                      controller: otpController,
                      length: 6,
                      // textFieldAlignment: MainAxisAlignment.spaceAround,
                      fieldWidth: 50,
                      fieldStyle: FieldStyle.underline,
                      style: GoogleFonts.lato(
                        fontWeight: FontWeight.w900,
                        fontSize:
                            SizeConfig.textMultiplier * 3.7661406025824964,
                        color: AppColors.app_txt_color,
                        letterSpacing: 0.25,
                      ),
                      onCompleted: (pin) {
                        ChangePasswordRoute.otp = pin;
                        setState(() {
                          otpController.setValue(pin[0], 0);
                          otpController.setValue(pin[1], 1);
                          otpController.setValue(pin[2], 2);
                          otpController.setValue(pin[3], 3);
                          otpController.setValue(pin[4], 4);
                          otpController.setValue(pin[5], 5);
                        });
                        // print("Completed: " + pin);
                      },
                      onChanged: (pin) {
                        ChangePasswordRoute.otp = pin;
                        setState(() {
                          otpController.setValue(pin[0], 0);
                          otpController.setValue(pin[1], 1);
                          otpController.setValue(pin[2], 2);
                          otpController.setValue(pin[3], 3);
                          otpController.setValue(pin[4], 4);
                          otpController.setValue(pin[5], 5);
                        });
                      },
                    ),
                  ),
                ),
                Container(
                  width: MediaQuery.of(context).size.width,
                  height: SizeConfig.heightMultiplier * 6.025824964131995,
                  margin: EdgeInsets.only(
                      top: SizeConfig.heightMultiplier * 3.51506456241033,
                      left: SizeConfig.widthMultiplier * 3.8888888888888884,
                      right: SizeConfig.widthMultiplier * 3.8888888888888884),
                  child: RaisedGradientButton(
                    gradient: LinearGradient(
                      colors: <Color>[
                        AppColors.gradient_button_light,
                        AppColors.gradient_button_dark,
                      ],
                    ),
                    child: Padding(
                        padding: EdgeInsets.fromLTRB(143, 16, 144, 16),
                        child: Text(
                          'NEXT',
                          style: GoogleFonts.lato(
                              fontSize:
                                  SizeConfig.textMultiplier * 1.757532281205165,
                              fontWeight: FontWeight.w700,
                              color: AppColors.white,
                              letterSpacing: 0.5),
                        )),
                    onPressed: () async {
                      FocusScope.of(context).unfocus();
                      if (widget.param == "phoneNumberForget") {
                        SmsAuthApi.signIn(
                          ChangePasswordRoute.otp,
                          widget.varID,
                          onAuthFail: fail,
                          onAuthSuccess: success,
                        );
                      } else if (widget.param == "emailForget") {
                        //to-do: wait niva to fix the bug
                      } else {
                        SmsAuthApi().auth(
                          ChangePasswordRoute.otp,
                          widget.varID,
                          onAuthFail: fail,
                          onAuthSuccess: success,
                        );
                      }
                    },
                  ),
                ),
              ],
            ))),
      ],
    );
  }

  void success() async {
    // print('is this the one??');
    _ForgotPasswordOtpBloc.add(OtpConfirmedEvent());
    if (widget.param == "phoneNumberForget") {
      RouterService.appRouter.navigateTo(ChangePasswordRoute.buildPath());
    } else {
      // print('does this get fired too early');
      // print("widget param: ${widget.param}");
      await RouterService.appRouter.navigateTo('/BiometricsAuth/1');
      await FirebaseManager.instance.signIn();
      await LocalDataBaseHelper().initializeDatabase();
      _isLoading = false;
      Constants.isLogin = true;
      RouterService.appRouter.navigateTo(InterestedCategoriesRoute.buildPath());
    }
  }

  void fail() {
    // print("fail");
    final snackBar = SnackBar(
      content: Text('your code is invalid!.'),
    );

    _globalKey.currentState.showSnackBar(snackBar);
  }

  Widget _bottomImage() {
    return Stack(
      children: [
        Image.asset(
          'assets/images/login_bottom_blue.png',
          width: double.infinity,
          fit: BoxFit.cover,
        ),
        Positioned(
          left: SizeConfig.widthMultiplier * -4.861111111111111,
          top: SizeConfig.heightMultiplier * 15.064562410329986,
          child: Image.asset(
            'assets/images/cld_image.png',
            width: SizeConfig.widthMultiplier * 19.444444444444443,
            height: SizeConfig.heightMultiplier * 10.043041606886657,
          ),
        ),
        Positioned(
          right: SizeConfig.widthMultiplier * 0.0,
          top: SizeConfig.heightMultiplier * 21.969153515064562,
          child: Image.asset(
            'assets/images/cloud_right.png',
            width: SizeConfig.widthMultiplier * 19.444444444444443,
            height: SizeConfig.heightMultiplier * 10.043041606886657,
          ),
        ),
        Positioned(
          left: SizeConfig.widthMultiplier * 29.166666666666664,
          top: SizeConfig.heightMultiplier * 13.809182209469155,
          child: Image.asset(
            'assets/images/rocket.png',
          ),
        ),
        Positioned(
          left: SizeConfig.widthMultiplier * 29.166666666666664,
          top: SizeConfig.heightMultiplier * 13.809182209469155,
          child: Image.asset(
            'assets/images/rocket_shade.png',
          ),
        ),
        Positioned(
          left: SizeConfig.widthMultiplier * 0.0,
          top: SizeConfig.heightMultiplier * 19.4583931133429,
          child: Image.asset(
            'assets/images/rocket_dust1.png',
          ),
        ),
        Positioned(
          left: SizeConfig.widthMultiplier * -2.4305555555555554,
          top: SizeConfig.heightMultiplier * 19.4583931133429,
          child: Image.asset(
            'assets/images/rocket_dust.png',
          ),
        ),
        Positioned(
          left: SizeConfig.widthMultiplier * 24.305555555555554,
          top: SizeConfig.heightMultiplier * 16.319942611190818,
          child: Image.asset(
            'assets/images/left_wing.png',
          ),
        ),
        Positioned(
          left: SizeConfig.widthMultiplier * 24.305555555555554,
          top: SizeConfig.heightMultiplier * 16.319942611190818,
          child: Image.asset(
            'assets/images/left_wing_shade.png',
          ),
        ),
        Positioned(
          left: SizeConfig.widthMultiplier * 32.08333333333333,
          top: SizeConfig.heightMultiplier * 19.4583931133429,
          child: Image.asset(
            'assets/images/right_wing.png',
          ),
        ),
        Positioned(
          left: SizeConfig.widthMultiplier * 41.31944444444444,
          top: SizeConfig.heightMultiplier * 15.064562410329986,
          child: Image.asset(
            'assets/images/rocket_window.png',
          ),
        ),
      ],
    );
  }
}
