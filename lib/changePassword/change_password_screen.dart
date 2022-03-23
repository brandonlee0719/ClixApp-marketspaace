import 'dart:ffi';
import 'dart:ui';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:market_space/changePassword/change_password_route.dart';
import 'package:market_space/common/colors.dart';
import 'package:market_space/common/constants.dart';
import 'package:market_space/common/loading_progress.dart';
import 'package:market_space/common/raised_gradient_button.dart';
import 'package:market_space/login/login_route.dart';
import 'package:market_space/login/login_screen.dart';
import 'package:market_space/services/RouterServices.dart';
import 'package:market_space/responsive_layout/size_config.dart';

import 'change_password_bloc.dart';
import 'change_password_events.dart';
import 'change_password_l10n.dart';
import 'change_password_state.dart';

class ChangePasswordScreen extends StatefulWidget {
  @override
  _ChangePasswordScreenState createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  final ChangePasswordBloc _ChangePasswordBloc = ChangePasswordBloc(Initial());
  ChangePasswordL10n _l10n = ChangePasswordL10n(
      Locale.fromSubtags(languageCode: 'en', countryCode: 'US'));

  final _globalKey = GlobalKey<ScaffoldState>();

  bool _isLoading = true;
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final FocusNode _passwordFocus = FocusNode();
  bool _passwordVisible = true;
  bool _confirmpasswordVisible = true;
  bool _passwordInvalid = false;
  bool _confirmpasswordInvalid = true;
  bool _policyCheck = false;
  bool _mailCheck = false;
  bool _nextButtonEnable = false;

  @override
  void initState() {
    super.initState();
    _ChangePasswordBloc.add(NavigateToLoginScreenEvent());

    setState(() {
      if (Constants.language == null || Constants.language == "English") {
        _l10n = ChangePasswordL10n(
            Locale.fromSubtags(languageCode: 'en', countryCode: 'US'));
      } else {
        _l10n = ChangePasswordL10n(Locale.fromSubtags(languageCode: 'zh'));
      }
    });
    _passwordController.addListener(() {
      setState(() {
        _passwordInvalid =
            RegExp(r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[!@#\$&*~]).{6,}$')
                .hasMatch(_passwordController.text);
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
        color: Colors.white,
        child: BlocProvider(
          create: (_) => _ChangePasswordBloc,
          child: BlocListener<ChangePasswordBloc, ChangePasswordState>(
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
              if (state is ValidateOTP) {
                setState(() {
                  _isLoading = true;
                });
              }
              if (state is OtpValidationSuccessful) {
                _isLoading = false;
                RouterService.appRouter.navigateTo(LogInRoute.buildPath());
              }
              if (state is OtpValidationFailure) {
                setState(() {
                  _isLoading = false;
                });
                final snackBar = SnackBar(
                  content: Text(
                      _ChangePasswordBloc?.status ?? "Otp validation failed"),
                );
                _globalKey.currentState.showSnackBar(snackBar);
              }
            },
            child: _ChangePasswordScreen(),
          ),
        ),
      ),
    );
  }

  Widget _ChangePasswordScreen() {
    return Container(
      // color: Colors.white,
      child: AbsorbPointer(
        absorbing: _isLoading,
        child: Stack(
          children: [
            if (_isLoading)
              BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 0.8, sigmaY: 0.8),
                  child: LoadingProgress(
                    color: Colors.deepOrangeAccent,
                  )),
            Align(
              alignment: Alignment.bottomLeft,
              child: _bottomImage(),
            ),
            _forgotPass(),
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
          // color: Colors.white,
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
                    _l10n.ForgottenPassword,
                    style: GoogleFonts.inter(
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
                    right: SizeConfig.widthMultiplier * 40.83333333333333,
                    top: SizeConfig.heightMultiplier * 4.017216642754663),
                child: Text(
                  _l10n.Enteryourpassword,
                  style: GoogleFonts.inter(
                      fontWeight: FontWeight.w700,
                      fontSize: SizeConfig.textMultiplier * 1.757532281205165,
                      color: AppColors.sub_text,
                      letterSpacing: 0.1),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(
                    left: SizeConfig.widthMultiplier * 3.8888888888888884,
                    right: SizeConfig.widthMultiplier * 3.8888888888888884,
                    top: SizeConfig.heightMultiplier * 1.5064562410329987),
                child: Theme(
                  data: ThemeData(
                    primaryColor: AppColors.appBlue,
                    primaryColorDark: AppColors.appBlue,
                  ),
                  child: TextField(
                    keyboardType: TextInputType.text,
                    controller: _passwordController,
                    obscureText: _passwordVisible,
                    style: GoogleFonts.inter(
                        fontWeight: FontWeight.w400,
                        fontSize: SizeConfig.textMultiplier * 1.757532281205165,
                        color: AppColors.text_field_color,
                        letterSpacing: 0.25),
                    decoration: new InputDecoration(
                        suffixIcon: IconButton(
                          icon: Icon(
                            // Based on passwordVisible state choose the icon
                            _passwordVisible
                                ? Icons.visibility_off
                                : Icons.visibility,
                          ),
                          onPressed: () {
                            // Update the state i.e. toogle the state of passwordVisible variable
                            setState(() {
                              _passwordVisible = !_passwordVisible;
                            });
                          },
                        ),
                        border: new OutlineInputBorder(
                            borderSide: new BorderSide(
                                color: AppColors.text_field_container),
                            borderRadius: BorderRadius.circular(10.0)),
                        hintText: '${_l10n.Pleaseenteryourpassword}.',
                        labelText: _l10n.NewPassword,
                        contentPadding: EdgeInsets.only(
                            left: SizeConfig.widthMultiplier *
                                3.8888888888888884),
                        suffixStyle: const TextStyle(color: AppColors.appBlue)),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(
                    left: SizeConfig.widthMultiplier * 3.8888888888888884,
                    right: SizeConfig.widthMultiplier * 3.8888888888888884,
                    top: SizeConfig.heightMultiplier * 1.5064562410329987),
                child: Theme(
                  data: ThemeData(
                    primaryColor: AppColors.appBlue,
                    primaryColorDark: AppColors.appBlue,
                  ),
                  child: TextField(
                    keyboardType: TextInputType.text,
                    controller: _confirmPasswordController,
                    obscureText: _confirmpasswordVisible,
                    style: GoogleFonts.inter(
                        fontWeight: FontWeight.w400,
                        fontSize: SizeConfig.textMultiplier * 1.757532281205165,
                        color: AppColors.text_field_color,
                        letterSpacing: 0.25),
                    decoration: new InputDecoration(
                        suffixIcon: IconButton(
                          icon: Icon(
                            // Based on passwordVisible state choose the icon
                            _confirmpasswordVisible
                                ? Icons.visibility_off
                                : Icons.visibility,
                          ),
                          onPressed: () {
                            // Update the state i.e. toogle the state of passwordVisible variable
                            setState(() {
                              _confirmpasswordVisible =
                                  !_confirmpasswordVisible;
                            });
                          },
                        ),
                        border: new OutlineInputBorder(
                            borderSide: new BorderSide(
                                color: AppColors.text_field_container),
                            borderRadius: BorderRadius.circular(10.0)),
                        hintText: '${_l10n.Pleaseenterabovepassword}.',
                        labelText: _l10n.ConfirmNewPassword,
                        contentPadding: EdgeInsets.only(
                            left: SizeConfig.widthMultiplier *
                                3.8888888888888884),
                        suffixStyle: const TextStyle(color: AppColors.appBlue)),
                  ),
                ),
              ),
              Container(
                width: SizeConfig.widthMultiplier * 79.72222222222221,
                height: SizeConfig.heightMultiplier * 6.025824964131995,
                margin: EdgeInsets.only(
                    top: SizeConfig.heightMultiplier * 3.0129124820659974,
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
                      padding: EdgeInsets.fromLTRB(5, 10, 5, 10),
                      child: Text(
                        _l10n.CONFIRMNEWPASSWORD,
                        style: GoogleFonts.inter(
                            fontSize:
                                SizeConfig.textMultiplier * 1.757532281205165,
                            fontWeight: FontWeight.w700,
                            color: AppColors.white,
                            letterSpacing: 0.5),
                      )),
                  onPressed: () {
                    FocusScope.of(context).unfocus();
                    if (_passwordInvalid) {
                      setState(() {
                        if (_passwordController.text ==
                            _confirmPasswordController.text) {
                          _confirmpasswordInvalid = false;
                          // print('passwordInvalid  $_passwordInvalid');

                          _validatePassword();
                        } else {
                          _confirmpasswordInvalid = true;
                          // print('passwordInvalid  $_passwordInvalid');
                          _validatePassword();
                        }
                      });
                    } else {
                      setState(() {
                        final snackBar = SnackBar(
                          content: Text(
                              "Password Invalid, At least 1 capital letter, at least 1 small letter, at least 1 special character, at least 6 and characters flutter"),
                        );

                        // Find the Scaffold in the widget tree and use
                        // it to show a SnackBar.
                        _globalKey.currentState.showSnackBar(snackBar);
                      });
                    }
                  },
                ),
              ),
            ],
          )),
        ),
      ],
    );
  }

  Future<void> _updatePassword(String pass) async {
    // print(FirebaseAuth.instance.currentUser.email);
    await FirebaseAuth.instance.currentUser
        .updatePassword(_passwordController.text);
    RouterService.appRouter.navigateTo(LogInRoute.buildPath());
  }

  _validatePassword() {
    if (!_confirmpasswordInvalid) {
      // print('_confirmpasswordInvalid  $_confirmpasswordInvalid');
      _updatePassword(_confirmPasswordController.text);
    } else {
      // print('_confirmpasswordInvalid  $_confirmpasswordInvalid');

      final snackBar = SnackBar(
        content: Text('Password and confirm password do not match.'),
      );

      _globalKey.currentState.showSnackBar(snackBar);
    }
  }

  Widget _bottomImage() {
    return Container(
      color: Colors.white,
      child: Stack(
        children: [
          Image.asset(
            'assets/images/login_bottom_blue.png',
            width: MediaQuery.of(context).size.width,
            fit: BoxFit.fill,
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
      ),
    );
  }
}
