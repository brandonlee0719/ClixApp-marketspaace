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
import 'package:market_space/profile_settings/editEmail/edit_email_l10n.dart';
import 'package:market_space/responsive_layout/size_config.dart';

import 'edit_email_bloc.dart';

class EditEmailScreen extends StatefulWidget {
  @override
  _EditEmailScreenState createState() => _EditEmailScreenState();
}

class _EditEmailScreenState extends State<EditEmailScreen> {
  final EditEmailBloc _editEmailBloc = EditEmailBloc(Initial());
  bool _isLoading = false;
  EditEmailL10n _l10n =
      EditEmailL10n(Locale.fromSubtags(languageCode: 'en', countryCode: 'US'));

  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _newEmailController = TextEditingController();
  final TextEditingController _confirmEmailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _usernameValid = false;
  bool _newEmailValid = false;
  bool _passwordVisible = true;
  bool _passwordValid = false;

  @override
  void initState() {
    _editEmailBloc.add(EditEmailScreenEvent());
    String pattern = r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[!@#\$&*~]).{6,}$';

    _usernameController.addListener(() {
      setState(() {
        _usernameValid = RegExp(
                r"^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?)*$")
            .hasMatch(_usernameController.text);
      });
    });
    _newEmailController.addListener(() {
      setState(() {
        _newEmailValid = RegExp(
                r"^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?)*$")
            .hasMatch(_newEmailController.text);
      });
    });
    _passwordController.addListener(() {
      setState(() {
        _passwordValid = RegExp(pattern).hasMatch(_passwordController.text);
      });
    });

    setState(() {
      if (Constants.language == null || Constants.language == "English") {
        _l10n = EditEmailL10n(
            Locale.fromSubtags(languageCode: 'en', countryCode: 'US'));
      } else {
        _l10n = EditEmailL10n(Locale.fromSubtags(languageCode: 'zh'));
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: Toolbar(
        title: 'EDIT EMAIL',
      ),
      backgroundColor: AppColors.toolbarBlue,
      // key: _globalKey,
      // bottomNavigationBar: _bottomButtons(),
      resizeToAvoidBottomInset: false,
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        color: AppColors.toolbarBlue,
        child: BlocProvider(
          create: (_) => _editEmailBloc,
          child: BlocListener<EditEmailBloc, EditEmailState>(
              listener: (context, state) {
                if (state is Loading) {
                  setState(() {
                    _isLoading = true;
                  });
                }
                if (state is Loaded) {
                  _isLoading = false;
                }
                if (state is EmailUpdatedSuccessfully) {
                  setState(() {
                    _isLoading = false;
                  });
                  _showToast("Email updated successfully");
                  Navigator.pop(context, "${_newEmailController.text}");
                }
                if (state is EmailUpdatedFailed) {
                  setState(() {
                    _isLoading = false;
                  });
                  _showToast('Email update failed');
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
                  children: [_editEmail()])
            ])));
  }

  Widget _editEmail() {
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
                  hintText: '${_l10n.email} ${_l10n.address}',
                  labelText: '${_l10n.email} ${_l10n.address}',
                  contentPadding: EdgeInsets.only(
                      left: SizeConfig.widthMultiplier * 3.8888888888888884),
                  suffixStyle: const TextStyle(color: AppColors.appBlue)),
            ),
          ),
        ),
        Container(
          height: SizeConfig.heightMultiplier * 6.276901004304161,
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
              style: GoogleFonts.inter(
                color: AppColors.text_field_color,
                fontWeight: FontWeight.w400,
                fontSize: SizeConfig.textMultiplier * 1.757532281205165,
                letterSpacing: 0.25,
              ),
              controller: _newEmailController,
              decoration: new InputDecoration(
                  border: new OutlineInputBorder(
                      borderSide:
                          new BorderSide(color: AppColors.text_field_color),
                      borderRadius: BorderRadius.circular(10.0)),
                  hintText: '${_l10n.newE} ${_l10n.email} ${_l10n.address}',
                  labelText: '${_l10n.newE} ${_l10n.email} ${_l10n.address}',
                  contentPadding: EdgeInsets.only(
                      left: SizeConfig.widthMultiplier * 3.8888888888888884),
                  suffixStyle: const TextStyle(color: AppColors.appBlue)),
            ),
          ),
        ),
        Container(
          height: SizeConfig.heightMultiplier * 6.276901004304161,
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
              style: GoogleFonts.inter(
                color: AppColors.text_field_color,
                fontWeight: FontWeight.w400,
                fontSize: SizeConfig.textMultiplier * 1.757532281205165,
                letterSpacing: 0.25,
              ),
              controller: _confirmEmailController,
              decoration: new InputDecoration(
                  border: new OutlineInputBorder(
                      borderSide:
                          new BorderSide(color: AppColors.text_field_color),
                      borderRadius: BorderRadius.circular(10.0)),
                  hintText:
                      '${_l10n.confirm} ${_l10n.newE} ${_l10n.email} ${_l10n.address}',
                  labelText:
                      '${_l10n.confirm} ${_l10n.newE} ${_l10n.email} ${_l10n.address}',
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
                  hintText: '${_l10n.enter} ${_l10n.password}.',
                  labelText: '${_l10n.enter} ${_l10n.password}',
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
              _showToast("Please enter valid email");
            } else if (!_newEmailValid) {
              _showToast("Please enter valid new email");
            } else if (_confirmEmailController.text !=
                _newEmailController.text) {
              _showToast("New email and confirm email address does not match");
            } else if (!_passwordValid) {
              _showToast(Constants.password_validation);
            } else {
              _editEmailBloc.email = _usernameController.text;
              _editEmailBloc.newEmail = _newEmailController.text;
              _editEmailBloc.add(UpdateEmailEvent());
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
                    '${_l10n.confirm} ${_l10n.newE} ${_l10n.email} ${_l10n.address}',
                    style: GoogleFonts.roboto(
                      color: AppColors.white,
                      fontWeight: FontWeight.w700,
                      fontSize: SizeConfig.textMultiplier * 1.757532281205165,
                      letterSpacing: 0.5,
                    ),
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
