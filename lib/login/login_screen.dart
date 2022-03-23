import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:local_auth/local_auth.dart';
import 'package:market_space/common/colors.dart';
import 'package:market_space/common/common_widgets.dart';
import 'package:market_space/common/constants.dart';
import 'package:market_space/common/loading_progress.dart';
import 'package:market_space/dashboard/products/fav_products/favourite_products_bloc.dart';
import 'package:market_space/forgotPassword/forgot_pass_route.dart';
import 'package:market_space/login/login_l10n.dart';
import 'package:market_space/responsive_layout/size_config.dart';
import 'package:market_space/routes/HomeScreenRoute.dart';
import 'package:market_space/services/RouterServices.dart';
import 'package:market_space/signup/general_info_route.dart';

import 'login_screen_bloc.dart';
import 'login_screen_events.dart';
import 'login_screen_states.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final LoginScreenBloc _LoginScreenBloc = LoginScreenBloc(Initial());
  LogInL10n _l10n =
      LogInL10n(Locale.fromSubtags(languageCode: 'en', countryCode: 'US'));
  bool _isLoading = false;
  final _globalKey = GlobalKey<ScaffoldState>();
  final TextEditingController _passwordController = TextEditingController();
  final FocusNode _passwordFocus = FocusNode();
  bool _passwordVisible = true;
  bool _passwordInvalid = true;
  final TextEditingController _usernameController = TextEditingController();
  bool _usernameValid = false;
  GlobalKey _keycontinue = GlobalKey();

  // Biometric
  bool _canCheckBiometrics;
  List<BiometricType> _availableBiometrics;
  String _authorized = 'Not Authorized';
  bool _isAuthenticated = false;
  final LocalAuthentication auth = LocalAuthentication();

  @override
  void initState() {
    super.initState();
    // _LoginScreenBloc.add(NavigateToHomeScreenEvent());
    // _LoginScreenBloc.add(CheckLoginBioMetricAvaiable());
    _usernameController.addListener(() {
      setState(() {
        _usernameValid = RegExp(
                r"^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?)*$")
            .hasMatch(_usernameController.text);
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _globalKey,
      resizeToAvoidBottomInset: false,
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        color: AppColors.toolbarBlue,
        child: BlocProvider(
          create: (_) => _LoginScreenBloc,
          child: BlocListener<LoginScreenBloc, LoginScreenState>(
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
              if (state is BiometricChecking) {
                setState(() {
                  _isLoading = true;
                });
              }
              if (state is BiometricChecked) {
                setState(() {
                  _isLoading = false;
                  _canCheckBiometrics = _LoginScreenBloc.canCheckBiometrics;
                  if (_canCheckBiometrics) {
                    _availableBiometrics = _LoginScreenBloc.availableBiometrics;
                  }
                });
              }
              if (state is BiometricAuthorized) {
                setState(() {
                  _isAuthenticated = _LoginScreenBloc.isAuthorized;
                  if (_isAuthenticated) {
                    // RouterService.appRouter.navigateTo(HomeScreenRoute.buildPath());
                  }
                });
              }
              if (state is BiometricAuthorizationFailed) {
                final snackBar = SnackBar(
                  duration: Duration(seconds: 100),
                  content: Text('Biometric authorization failed.'),
                  action: SnackBarAction(
                    label: 'retry',
                    onPressed: () {
                      _LoginScreenBloc.add(LaunchBiometric());
                      _globalKey.currentState.hideCurrentSnackBar();
                    },
                  ),
                );
                _globalKey.currentState.showSnackBar(snackBar);
              }
              if (state is SignInFirebaseState) {
                setState(() {
                  _isLoading = true;
                });
              }
              if (state is SignInFirebaseSuccessfully) {
                setState(() {
                  _isLoading = false;
                  context
                      .read<FavouriteProductsBloc>()
                      .add(LoadFavouriteProducts());
                  RouterService.appRouter
                      .navigateTo(HomeScreenRoute.buildPath());
                });
              }
              if (state is SignInFirebaseFailure) {
                setState(() {
                  _isLoading = false;
                });
                final snackBar = SnackBar(
                  duration: Duration(seconds: 3),
                  content: Text('Login Failed.'),
                );
                _globalKey.currentState.showSnackBar(snackBar);
              }
              if (state is LanguageChangesSuccessfully) {
                setState(() {
                  if (Constants.language == null ||
                      Constants.language == "English") {
                    _l10n = LogInL10n(Locale.fromSubtags(
                        languageCode: 'en', countryCode: 'US'));
                  } else {
                    _l10n = LogInL10n(Locale.fromSubtags(languageCode: 'zh'));
                  }
                });
              }
            },
            child: _loginScreen(),
          ),
        ),
      ),
    );
  }

  Widget _loginScreen() {
    return Container(
      color: Colors.white,
      child: AbsorbPointer(
        absorbing: _isLoading,
        child: Stack(
          children: [
            Align(
              alignment: Alignment.bottomLeft,
              child: _bottomImage(),
            ),
            _loginForm(),
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

  Widget _loginForm() {
    return Center(
        child: Column(
      children: <Widget>[
        Container(
          child: Hero(
            tag: "splash_hero",
            child: Row(
              children: [
                Container(
                  margin: EdgeInsets.only(
                      top: 80, left: MediaQuery.of(context).size.width * 0.35),
                  height: SizeConfig.heightMultiplier * 12.177187948350072,
                  width: SizeConfig.widthMultiplier * 33.05555555555555,
                  child: Image.asset(
                    'assets/images/mkt_space_logo.png',
                    fit: BoxFit.fill,
                  ),
                ),
                Spacer(),
                // if (Constants.language == null ||
                //     Constants.language == "English")
                //   GestureDetector(
                //     onTap: () {
                //       setState(() {
                //         _LoginScreenBloc.lang = "chinese";
                //         Constants.language = "chinese";
                //         _LoginScreenBloc.add(ChangeLanguageEvent());
                //       });
                //     },
                //     child: Container(
                //       margin: EdgeInsets.only(
                //           top: SizeConfig.heightMultiplier * 16.319942611190818,
                //           right:
                //               SizeConfig.widthMultiplier * 4.861111111111111),
                //       child: Text(
                //         '中文',
                //         style: GoogleFonts.inter(
                //           color: AppColors.toolbarBlue,
                //           fontWeight: FontWeight.w700,
                //           fontSize:
                //               SizeConfig.textMultiplier * 2.0086083213773316,
                //           letterSpacing: 0.25,
                //         ),
                //       ),
                //     ),
                //   ),
                // if (Constants.language == "chinese")
                //   GestureDetector(
                //     onTap: () {
                //       setState(() {
                //         _LoginScreenBloc.lang = "English";
                //         Constants.language = "English";
                //         _LoginScreenBloc.add(ChangeLanguageEvent());
                //       });
                //     },
                //     child: Container(
                //       margin: EdgeInsets.only(
                //           top: SizeConfig.heightMultiplier * 16.319942611190818,
                //           right:
                //               SizeConfig.widthMultiplier * 4.861111111111111),
                //       child: Text(
                //         'EN',
                //         style: GoogleFonts.inter(
                //           color: AppColors.toolbarBlue,
                //           fontWeight: FontWeight.w700,
                //           fontSize:
                //               SizeConfig.textMultiplier * 2.0086083213773316,
                //           letterSpacing: 0.25,
                //         ),
                //       ),
                //     ),
                //   ),
              ],
            ),
          ),
        ),
        _loginFormTextInputs()
      ],
    ));
  }

  Widget _loginFormTextInputs() {
    return Form(
        child: Padding(
      padding: EdgeInsets.symmetric(
        horizontal: SizeConfig.widthMultiplier * 3.8888888888888884,
      ),
      child: Column(children: [
        yHeight3,
        Container(
          child: Theme(
            data: ThemeData(
              primaryColor: AppColors.appBlue,
              primaryColorDark: AppColors.appBlue,
            ),
            child: TextField(
              style: GoogleFonts.inter(
                color: AppColors.text_field_color,
                fontWeight: FontWeight.w400,
                fontSize: SizeConfig.textMultiplier * 1.757532281205165,
                letterSpacing: 0.25,
              ),
              controller: _usernameController,
              decoration: new InputDecoration(
                  border: new OutlineInputBorder(
                      borderSide:
                          new BorderSide(color: AppColors.text_field_color),
                      borderRadius: BorderRadius.circular(10.0)),
                  hintText: _l10n.emailHint,
                  labelText: _l10n.email,
                  contentPadding: EdgeInsets.only(
                      left: SizeConfig.widthMultiplier * 3.8888888888888884),
                  suffixStyle: const TextStyle(color: AppColors.appBlue)),
            ),
          ),
        ),
        yHeight3,
        Container(
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
                color: AppColors.text_field_color,
                fontWeight: FontWeight.w400,
                fontSize: SizeConfig.textMultiplier * 1.757532281205165,
                letterSpacing: 0.25,
              ),
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
                      borderSide: new BorderSide(color: Colors.grey.shade300),
                      borderRadius: BorderRadius.circular(10.0)),
                  hintText: _l10n.enterPasswordHint,
                  labelText: _l10n.password,
                  contentPadding: EdgeInsets.only(
                      left: SizeConfig.widthMultiplier * 3.8888888888888884),
                  suffixStyle: GoogleFonts.inter(
                    color: AppColors.appBlue,
                    fontWeight: FontWeight.w400,
                    fontSize: SizeConfig.textMultiplier * 1.757532281205165,
                    letterSpacing: 0.25,
                  )),
            ),
          ),
        ),
        yHeight2,
        InkWell(
          onTap: () {
            RouterService.appRouter.navigateTo(ForgotPassRoute.buildPath());
          },
          child: Container(
            child: Text(
              _l10n.forgotPassword,
              style: GoogleFonts.inter(
                color: Color.fromRGBO(0, 0, 0, 0.65),
                fontWeight: FontWeight.w400,
                fontSize: SizeConfig.textMultiplier * 1.757532281205165,
                letterSpacing: 0.25,
              ),
            ),
          ),
        ),
        yHeight3,
        Row(
          children: [
            Expanded(
              child: btnGradient(_l10n.login, () {
                FocusScope.of(context).unfocus();
                _validateUsername(_usernameController.text);
                if (_usernameValid && !_passwordInvalid) {
                  _LoginScreenBloc.email = _usernameController.text;
                  _LoginScreenBloc.pass = _passwordController.text;
                  _LoginScreenBloc.add(SignInFirebaseEvent());
                }
                if (validatePassword(_passwordController.text)) {
                  setState(() {
                    _passwordInvalid = false;
                  });
                } else {
                  _passwordInvalid = true;
                  _showSnackBar(Constants.password_validation);
                }
              }),
            ),
          ],
        ),
        yHeight2,
        Container(
          width: MediaQuery.of(context).size.width,
          height: SizeConfig.heightMultiplier * 6.025824964131995,
          child: FlatButton(
              color: Colors.white,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                  side: BorderSide(color: AppColors.appBlue)),
              child: Padding(
                  padding: EdgeInsets.fromLTRB(
                      SizeConfig.heightMultiplier * 0.8,
                      SizeConfig.heightMultiplier * 0.8,
                      SizeConfig.heightMultiplier * 0.8,
                      SizeConfig.heightMultiplier * 0.8),
                  child: Text(
                    _l10n.createAccount,
                    style: GoogleFonts.inter(
                        color: AppColors.appBlue,
                        fontWeight: FontWeight.bold,
                        fontSize: SizeConfig.textMultiplier * 1.757532281205165,
                        letterSpacing: 0.5,
                        textStyle: TextStyle(fontFamily: 'Roboto')),
                  )),
              onPressed: () {
                FocusScope.of(context).unfocus();
                RouterService.appRouter
                    .navigateTo(GeneralInfoRoute.buildPath());
              }),
        ),
        // Container(
        //   margin: EdgeInsets.only(top: SizeConfig.heightMultiplier * 1.0043041606886658, left: SizeConfig.widthMultiplier * 3.8888888888888884, right: SizeConfig.widthMultiplier * 3.8888888888888884),
        //   child: Row(
        //     crossAxisAlignment: CrossAxisAlignment.center,
        //     mainAxisAlignment: MainAxisAlignment.center,
        //     children: [
        //       _googleBtn(),
        //       Container(
        //           margin: EdgeInsets.only(
        //             left: SizeConfig.widthMultiplier * 3.8888888888888884,
        //           ),
        //           child: _appleBtn()),
        //     ],
        //   ),
        // )
      ]),
    ));
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
          top: SizeConfig.heightMultiplier * 23.852223816355814,
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

  bool validatePassword(String value) {
    String pattern = r'(?=.*?[a-z])(?=.*?[0-9])';
    RegExp regExp = new RegExp(pattern);
    return regExp.hasMatch(value);
  }

  bool _validateUsername(String value) {
    if (!_usernameValid) {
      // setState(() {
      //   _usernameInvalid = true;
      // });
      _showSnackBar("Please enter valid username.");
      return false;
    } else {
      // setState(() {
      //   _usernameInvalid = false;
      // });
      return true;
    }
  }

  _showSnackBar(String snackText) {
    final snackBar = SnackBar(
      content: Text(snackText),
    );
    _globalKey.currentState.showSnackBar(snackBar);
  }

  Widget _googleBtn() {
    return ButtonTheme(
      height: SizeConfig.heightMultiplier * 3.7661406025824964,
      child: FlatButton.icon(
        onPressed: () {
          _LoginScreenBloc.add(SignInGoogleEvent());
        },
        icon: Image.asset(
          "assets/images/google.png",
          width: SizeConfig.widthMultiplier * 4.861111111111111,
          height: SizeConfig.heightMultiplier * 2.5107604017216643,
        ),
        label: Text('google'),
        textColor: Colors.black,
        color: AppColors.lightgrey,
        padding: EdgeInsets.symmetric(horizontal: 4, vertical: 2),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
      ),
    );
  }

  Widget _appleBtn() {
    return ButtonTheme(
      height: SizeConfig.heightMultiplier * 3.7661406025824964,
      child: FlatButton.icon(
        onPressed: () {},
        icon: Image.asset(
          "assets/images/apple_icon.png",
          width: SizeConfig.widthMultiplier * 4.861111111111111,
          height: SizeConfig.heightMultiplier * 2.5107604017216643,
        ),
        label: Text('Apple Id'),
        textColor: Colors.white,
        color: Colors.black,
        padding: EdgeInsets.symmetric(
            horizontal:
                SizeConfig.widthMultiplier * 0.97222222222222205343364197530867,
            vertical: SizeConfig.heightMultiplier *
                0.25107604017216645006062053193745),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
      ),
    );
  }
}
