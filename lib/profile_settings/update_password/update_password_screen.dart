import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:market_space/common/colors.dart';
import 'package:market_space/common/constants.dart';
import 'package:market_space/common/loading_progress.dart';
import 'package:market_space/common/raised_gradient_button.dart';
import 'package:market_space/common/toolbar.dart';
import 'package:market_space/profile_settings/update_password/update_password_bloc.dart';
import 'package:market_space/profile_settings/update_password/update_password_l10n.dart';
import 'package:market_space/responsive_layout/size_config.dart';

class UpdatePasswordScreen extends StatefulWidget {
  @override
  _UpdatePasswordScreenState createState() => _UpdatePasswordScreenState();
}

class _UpdatePasswordScreenState extends State<UpdatePasswordScreen> {
  final UpdatePasswordBloc _UpdatePasswordBloc = UpdatePasswordBloc(Initial());
  UpdatePasswordL10n _l10n = UpdatePasswordL10n(
      Locale.fromSubtags(languageCode: 'en', countryCode: 'US'));

  bool _isLoading = false;

  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _newEmailController = TextEditingController();
  final TextEditingController _confirmEmailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _usernameValid = false;
  bool _newEmailValid = false;
  bool _passwordVisible = true;
  bool _confirmPasswordVisible = true;
  bool _passwordValid = false;

  @override
  void initState() {
    // _UpdatePasswordBloc.add(UpdatePasswordScreenEvent());
    String pattern = r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[!@#\$&*~]).{6,}$';
    setState(() {
      if (Constants.language == null || Constants.language == "English") {
        _l10n = UpdatePasswordL10n(
            Locale.fromSubtags(languageCode: 'en', countryCode: 'US'));
      } else {
        _l10n = UpdatePasswordL10n(Locale.fromSubtags(languageCode: 'zh'));
      }
    });
    _usernameController.addListener(() {
      setState(() {
        _usernameValid = RegExp(
                r"^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?)*$")
            .hasMatch(_usernameController.text);
      });
    });
    _newEmailController.addListener(() {
      setState(() {
        _newEmailValid = RegExp(pattern).hasMatch(_newEmailController.text);
      });
    });
    _passwordController.addListener(() {
      setState(() {
        _passwordValid = RegExp(pattern).hasMatch(_passwordController.text);
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: Toolbar(
        title: _l10n.updatePassword,
      ),
      backgroundColor: AppColors.toolbarBlue,
      // key: _globalKey,
      // bottomNavigationBar: _bottomButtons(),
      resizeToAvoidBottomInset: false,
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        color: AppColors.white,
        child: BlocProvider(
          create: (_) => _UpdatePasswordBloc,
          child: BlocListener<UpdatePasswordBloc, UpdatePasswordState>(
              listener: (context, state) {
                if (state is Loading) {
                  setState(() {
                    _isLoading = true;
                  });
                }
                if (state is Loaded) {
                  _isLoading = false;
                }
                if (state is UpdatePasswordSuccessfully) {
                  setState(() {
                    _isLoading = false;
                  });
                  _showToast(_l10n.passUpdatedSuccessful);
                  Navigator.pop(context);
                }
                if (state is UpdatePasswordSuccessfully) {
                  setState(() {
                    _isLoading = false;
                  });
                  _showToast(_l10n.passUpdateFailed);
                }
              },
              child: _baseScreen()),
        ),
      ),
    );
  }

  Widget _baseScreen() {
    return Container(
        color: Colors.white,
        child: AbsorbPointer(
            absorbing: _isLoading,
            child: Stack(children: [
              if (_isLoading)
                BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 0.8, sigmaY: 0.8),
                    child: LoadingProgress(
                      color: Colors.deepOrangeAccent,
                    )),
              ListView(
                  shrinkWrap: true,
                  physics: BouncingScrollPhysics(),
                  children: [_UpdatePassword()])
            ])));
  }

  Widget _UpdatePassword() {
    return Container(
        child: ListView(
      shrinkWrap: true,
      children: [
        Container(
          height: SizeConfig.heightMultiplier * 6.276901004304161,
          margin: EdgeInsets.only(
              left: SizeConfig.widthMultiplier * 3.8888888888888884,
              right: SizeConfig.widthMultiplier * 3.8888888888888884,
              top: SizeConfig.heightMultiplier * 2.5107604017216643),
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
                  hintText: _l10n.EmailAddress,
                  labelText: _l10n.EmailAddress,
                  contentPadding: EdgeInsets.only(
                      left: SizeConfig.widthMultiplier * 3.8888888888888884),
                  suffixStyle: const TextStyle(color: AppColors.appBlue)),
            ),
          ),
        ),
        Container(
          margin: EdgeInsets.only(
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
              controller: _newEmailController,
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
                  hintText: '${_l10n.enterPass}.',
                  labelText: '${_l10n.enterPass}',
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
        Container(
          margin: EdgeInsets.only(
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
              obscureText: _confirmPasswordVisible,
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
                      _confirmPasswordVisible
                          ? Icons.visibility_off
                          : Icons.visibility,
                    ),
                    onPressed: () {
                      // Update the state i.e. toogle the state of passwordVisible variable
                      setState(() {
                        _confirmPasswordVisible = !_confirmPasswordVisible;
                      });
                    },
                  ),
                  border: new OutlineInputBorder(
                      borderSide: new BorderSide(color: Colors.grey.shade300),
                      borderRadius: BorderRadius.circular(10.0)),
                  hintText: '${_l10n.confirmPass}.',
                  labelText: '${_l10n.confirmPass}',
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
        GestureDetector(
          onTap: () {
            FocusScope.of(context).unfocus();
            if (!_usernameValid) {
              _showToast(_l10n.enterValidEmail);
            } else if (!_newEmailValid) {
              _showToast(Constants.password_validation);
            } else if (_passwordController.text != _newEmailController.text) {
              _showToast(_l10n.passAndConfirmPassMismatch);
            } else {
              _UpdatePasswordBloc.password = _usernameController.text;
              _UpdatePasswordBloc.confirmPassword = _newEmailController.text;
              _UpdatePasswordBloc.add(UpdatePasswordScreenEvent());
            }
          },
          child: Container(
            height: SizeConfig.heightMultiplier * 6.025824964131995,
            margin: EdgeInsets.only(
                top: SizeConfig.heightMultiplier * 2.5107604017216643,
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
                    _l10n.confirmNewPass,
                    style: GoogleFonts.inter(
                        color: AppColors.white,
                        fontWeight: FontWeight.w700,
                        fontSize: SizeConfig.textMultiplier * 1.757532281205165,
                        letterSpacing: 0.5,
                        textStyle: TextStyle(fontFamily: 'Roboto')),
                  )),
            ),
          ),
        ),
      ],
    ));
  }

  void _showToast(String msg) {
    Fluttertoast.showToast(
        msg: msg,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 1,
        backgroundColor: AppColors.appBlue,
        textColor: Colors.white,
        fontSize: SizeConfig.textMultiplier * 2.0086083213773316);
  }
}
