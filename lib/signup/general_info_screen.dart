import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:market_space/apis/navigationApi.dart';
import 'package:market_space/apis/userApi/UserApi.dart';
import 'package:market_space/common/colors.dart';
import 'package:market_space/common/constants.dart';
import 'package:market_space/common/loading_progress.dart';
import 'package:market_space/common/raised_gradient_button.dart';
import 'package:market_space/dashboard/dashboard_screen.dart';
import 'package:market_space/login/login_screen.dart';
import 'package:market_space/main.dart';
import 'package:market_space/model/model.dart';
import 'package:market_space/repositories/repository.dart';
import 'package:market_space/routes/HomeScreenRoute.dart';
import 'package:market_space/interested_categories/interested_categories_route.dart';
import 'package:market_space/services/RouterServices.dart';
import 'package:market_space/signup/general_info_bloc.dart';
import 'package:market_space/signup/sign_up_l10n.dart';
import 'package:market_space/responsive_layout/size_config.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'dart:math';

import 'general_info_event.dart';
import 'general_info_state.dart';

class GeneralInfoScreen extends StatefulWidget {
  @override
  _GeneralInfoScreenState createState() => _GeneralInfoScreenState();
}

class _GeneralInfoScreenState extends State<GeneralInfoScreen> {
  final GeneralInfoBloc _GeneralInfoBloc1 = GeneralInfoBloc(Initial());
  final _globalKey = GlobalKey<ScaffoldState>();
  final _actionKey = GlobalKey<ScaffoldState>();
  final _countryKey = GlobalKey<ScaffoldState>();
  final _prefferedCurrencyKey = GlobalKey<ScaffoldState>();
  bool _isLoading = true;
  bool _isSame = true;
  PageController _pageController = PageController(initialPage: 0);
  int slideIndex = 0;
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _cryptoCurrencyController =
      TextEditingController();
  final TextEditingController _prefferedCurrencyController =
      TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  final TextEditingController _countryController = TextEditingController();

  bool _passwordVisible = true;
  bool _confirmpasswordVisible = true;
  bool _passwordInvalid = false;
  bool _confirmpasswordInvalid = true;
  bool _policyCheck = false;
  bool _mailCheck = false;
  bool _nextButtonEnable = false;
  bool _passChecks = true;
  bool _confirmPassLengthMet = true;

  final FocusNode _focusNode = FocusNode();

  OverlayEntry _overlayEntry;

  final LayerLink _layerLink = LayerLink();

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _confirmEmailController = TextEditingController();
  final TextEditingController _dobController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  bool _emailValid = false;

// Date picker
  DateTime selectedDate = DateTime.now();

  List<String> _prefferedCurrency = [
    "Australian Dollar",
    "Chinese Yuan",
  ];

  List<String> _cryptoCurrency = ["Bitcoin", "Ethereum", "USDC"];
  List<String> _countryList = ["Australia"];

  String _selectedItem;
  String _deviceTokenID;
  String _countryValue;
  String _prefferedCurrencyValue;
  String _prefferedCryptoValue;
  String _phone;
  String _editedPhone;
  String _fiatPair;
  String _cryptoPair;
  SignUpL10n _l10n = SignUpL10n(Locale.fromSubtags(languageCode: 'zh'));
  bool _dropdownShown = false;

  @override
  void initState() {
    super.initState();

    _GeneralInfoBloc1.add(NavigateToHomeScreenEvent());
    _countryController.text = "Australia";
    _emailController.addListener(() {
      setState(() {
        _emailValid = RegExp(
                r"^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?)*$")
            .hasMatch(_emailController.text);
        if (_confirmEmailController.text != null &&
            _confirmEmailController.text != "" &&
            _confirmEmailController.text == _emailController.text) {
          _isSame = true;
          _globalKey.currentState.hideCurrentSnackBar();
        }
      });
    });
    _passwordController.addListener(() {
      setState(() {
        _passwordInvalid = RegExp(r'(?=.*?[a-z])(?=.*?[0-9])')
            .hasMatch(_passwordController.text);
        if (_confirmPasswordController.text != null &&
            _confirmPasswordController.text != "" &&
            _confirmPasswordController.text == _passwordController.text) {
          _isSame = true;
          _globalKey.currentState.hideCurrentSnackBar();
        }
      });
    });

    // _focusNode.addListener(() {
    //   if (_focusNode.hasFocus) {
    //     this._overlayEntry = this._createCryptoDropdown();
    //     Overlay.of(context).insert(this._overlayEntry);
    //   } else {
    //     this._overlayEntry.remove();
    //   }
    // });
    super.initState();
  }

  List<DropdownMenuItem<String>> buildDropDownMenuItems(List listItems) {
    List<DropdownMenuItem<String>> items = List();
    for (String listItem in listItems) {
      items.add(
        DropdownMenuItem(
          child: listItem != "CRYPTOCURRENCY"
              ? Text(listItem)
              : Container(
                  child: Text(
                    listItem,
                    style: GoogleFonts.inter(color: AppColors.toolbarBlue),
                  ),
                ),
          value: listItem,
        ),
      );
    }
    return items;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _globalKey,
      resizeToAvoidBottomInset: false,
      backgroundColor: AppColors.white,
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        color: AppColors.white,
        child: BlocProvider(
          create: (_) => _GeneralInfoBloc1,
          child: BlocListener<GeneralInfoBloc, GeneralInfoState>(
              listener: (context, state) {
                if (state is Loading) {
                  setState(() {
                    _isLoading = true;
                  });
                }
                if (state is Loaded) {
                  // NavigationApi.navigateTo("toOTPScreen",
                  //     param: "signUp", varID: "2");

                  setState(() {
                    _isLoading = false;
                    if (Constants.language == null ||
                        Constants.language == "English") {
                      _l10n = SignUpL10n(Locale.fromSubtags(
                          languageCode: 'en', countryCode: 'US'));
                    } else {
                      _l10n =
                          SignUpL10n(Locale.fromSubtags(languageCode: 'zh'));
                    }
                    _deviceTokenID = _GeneralInfoBloc1.deviceTokenID;
                  });
                }
                if (state is Success) {
                  NavigationApi.navigateTo("toOTPScreen",
                      param: "signUp", varID: _GeneralInfoBloc1.varId);
                }
                if (state is Failed) {
                  if (GeneralInfoBloc.signUpToast == null) {
                    _showSnackBar('Failure');
                  } else {
                    _showSnackBar('Failure, ${GeneralInfoBloc.signUpToast}');
                  }
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
      child: Stack(
        children: [
          Align(
            alignment: Alignment.topLeft,
            child: GestureDetector(
              onTap: () {
                if (slideIndex == 0)
                  Navigator.pop(context);
                else if (slideIndex == 1)
                  _pageController.jumpToPage(0);
                else if (slideIndex == 2) _pageController.jumpToPage(1);
              },
              child: Container(
                margin: EdgeInsets.only(
                    left: SizeConfig.widthMultiplier * 3.5005555555555554,
                    top: SizeConfig.heightMultiplier * 5.7661406025824964),
                child: SvgPicture.asset(
                  'assets/images/Back_button.svg',
                  width: SizeConfig.widthMultiplier * 6.861111111111111,
                  height: SizeConfig.heightMultiplier * 4.5107604017216643,
                  color: AppColors.toolbarBlue,
                ),
              ),
            ),
          ),
          Align(
            alignment: Alignment.bottomLeft,
            child: _bottomImage(),
          ),
          _mainScreen(),
          Container(
            margin: EdgeInsets.only(
                top: SizeConfig.heightMultiplier * 23.852223816355814),
            child: PageView(
              physics: NeverScrollableScrollPhysics(),
              controller: _pageController,
              onPageChanged: (index) {
                setState(() {
                  slideIndex = index;
                });
              },
              children: [_screen1(), _screen2(), _screen3()],
            ),
          ),
          Positioned(
            top: MediaQuery.of(context).size.height * 0.72,
            child: _bottomSheet(true),
          ),
          if (_isLoading)
            BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 0.8, sigmaY: 0.8),
                child: LoadingProgress(
                  color: Colors.deepOrangeAccent,
                )),
        ],
      ),
    );
  }

  Widget _mainScreen() {
    return Column(
      // shrinkWrap: true,
      children: [
        Center(
          child: Container(
            child: _topText(),
          ),
        )
      ],
    );
  }

  Widget _topText() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          alignment: Alignment.center,
          margin: EdgeInsets.only(
              top: SizeConfig.heightMultiplier * 12.930416068866572,
              left: SizeConfig.widthMultiplier * 19.687499999999996,
              right: SizeConfig.widthMultiplier * 16.527777777777775),
          child: Container(
            child: Text(_l10n.createAccount,
                style: GoogleFonts.inter(
                    fontWeight: FontWeight.w900,
                    fontSize: SizeConfig.textMultiplier * 2.887374461979914)),
          ),
        ),
        Padding(
          padding: EdgeInsets.only(
              left: SizeConfig.widthMultiplier * 4.131944444444444,
              top: SizeConfig.heightMultiplier * 4.017216642754663),
          child: slideIndex == 2
              ? Text(
                  _l10n.passHeading,
                  style: GoogleFonts.inter(
                      fontWeight: FontWeight.w700,
                      fontSize: SizeConfig.textMultiplier * 1.757532281205165,
                      letterSpacing: 0.1,
                      color: AppColors.app_txt_color),
                )
              : Text(
                  '${_l10n.generalInfo}(${(slideIndex + 1)}/2)',
                  style: GoogleFonts.inter(
                      fontWeight: FontWeight.w700,
                      fontSize: SizeConfig.textMultiplier * 1.757532281205165,
                      letterSpacing: 0.1,
                      color: AppColors.app_txt_color),
                ),
        ),
      ],
    );
  }

  Widget _screen1() {
    return Center(
        child: Column(children: <Widget>[
      Padding(
          padding: EdgeInsets.only(
              left: SizeConfig.widthMultiplier * 3.8888888888888884,
              right: SizeConfig.widthMultiplier * 3.8888888888888884,
              top: SizeConfig.heightMultiplier * 0.6276901004304161),
          child: Theme(
            data: ThemeData(
              primaryColor: AppColors.toolbarBlue,
              primaryColorDark: AppColors.toolbarBlue,
            ),
            child: TextField(
              keyboardType: TextInputType.text,
              controller: _nameController,
              style: GoogleFonts.inter(
                  fontWeight: FontWeight.w400,
                  fontSize: SizeConfig.textMultiplier * 1.757532281205165,
                  letterSpacing: 0.1,
                  color: AppColors.app_txt_color),
              decoration: InputDecoration(
                  border: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey.shade300),
                      borderRadius: BorderRadius.circular(10.0)),
                  hintText: _l10n.firstNameHint,
                  labelText: _l10n.firstName,
                  contentPadding: EdgeInsets.only(
                      left: SizeConfig.widthMultiplier * 3.8888888888888884),
                  suffixStyle: const TextStyle(color: AppColors.toolbarBlue)),
            ),
          )),
      Padding(
          padding: EdgeInsets.only(
              left: SizeConfig.widthMultiplier * 3.8888888888888884,
              right: SizeConfig.widthMultiplier * 3.8888888888888884,
              top: SizeConfig.heightMultiplier * 1.5064562410329987),
          child: Theme(
            data: ThemeData(
              primaryColor: AppColors.toolbarBlue,
              primaryColorDark: AppColors.toolbarBlue,
            ),
            child: TextField(
              onEditingComplete: () {
                if (_emailController.text == _confirmEmailController.text) {
                  _isSame = true;
                  _globalKey.currentState.hideCurrentSnackBar();
                  // FocusScope.of(context).unfocus();
                  // _pageController.jumpToPage(1);
                } else if (_emailController.text !=
                        _confirmEmailController.text &&
                    _confirmEmailController.text != "" &&
                    _confirmEmailController.text != null) {
                  setState(() {
                    _isSame = false;
                    _showSnackBar("Email address not the same");
                  });
                }
                FocusScope.of(context).unfocus();
              },
              keyboardType: TextInputType.text,
              controller: _usernameController,
              style: GoogleFonts.inter(
                  fontWeight: FontWeight.w400,
                  fontSize: SizeConfig.textMultiplier * 1.757532281205165,
                  letterSpacing: 0.1,
                  color: AppColors.app_txt_color),
              decoration: InputDecoration(
                  border: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey.shade300),
                      borderRadius: BorderRadius.circular(10.0)),
                  hintText: _l10n.lastNameHint,
                  labelText: _l10n.lastName,
                  contentPadding: EdgeInsets.only(
                      left: SizeConfig.widthMultiplier * 3.8888888888888884),
                  suffixStyle: const TextStyle(color: AppColors.toolbarBlue)),
            ),
          )),
      Padding(
          padding: EdgeInsets.only(
              left: SizeConfig.widthMultiplier * 3.8888888888888884,
              right: SizeConfig.widthMultiplier * 3.8888888888888884,
              top: SizeConfig.heightMultiplier * 1.5064562410329987),
          child: Theme(
            data: ThemeData(
                primaryColor: AppColors.toolbarBlue,
                primaryColorDark: AppColors.toolbarBlue,
                hintColor: _isSame
                    ? Colors.black.withOpacity(0.6)
                    : AppColors.red_text),
            child: TextField(
              keyboardType: TextInputType.text,
              controller: _emailController,
              style: GoogleFonts.inter(
                  fontWeight: FontWeight.w400,
                  fontSize: SizeConfig.textMultiplier * 1.757532281205165,
                  letterSpacing: 0.1,
                  color: AppColors.app_txt_color),
              decoration: InputDecoration(
                  border: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey.shade300),
                      borderRadius: BorderRadius.circular(10.0)),
                  hintText: _l10n.emailAddHint,
                  labelText: _l10n.emailAddress,
                  contentPadding: EdgeInsets.only(
                      left: SizeConfig.widthMultiplier * 3.8888888888888884),
                  suffixStyle: const TextStyle(color: AppColors.toolbarBlue)),
            ),
          )),
      Padding(
          padding: EdgeInsets.only(
              left: SizeConfig.widthMultiplier * 3.8888888888888884,
              right: SizeConfig.widthMultiplier * 3.8888888888888884,
              top: SizeConfig.heightMultiplier * 1.5064562410329987),
          child: Theme(
            data: ThemeData(
                primaryColor: AppColors.toolbarBlue,
                primaryColorDark: AppColors.toolbarBlue,
                hintColor: _isSame
                    ? Colors.black.withOpacity(0.6)
                    : AppColors.red_text),
            child: TextField(
              // validator: (value) {
              //   if (_emailController.text != _confirmEmailController.text) {
              //     _isSame = true;
              //   }
              // },

              onEditingComplete: () {
                if (_emailController.text == _confirmEmailController.text) {
                  _isSame = true;
                  _globalKey.currentState.hideCurrentSnackBar();
                  // FocusScope.of(context).unfocus();
                  // _pageController.jumpToPage(1);
                } else {
                  setState(() {
                    _isSame = false;
                    _showSnackBar("Email address not the same");
                  });
                }
                FocusScope.of(context).unfocus();
              },
              keyboardType: TextInputType.text,
              controller: _confirmEmailController,
              style: GoogleFonts.inter(
                  fontWeight: FontWeight.w400,
                  fontSize: SizeConfig.textMultiplier * 1.757532281205165,
                  letterSpacing: 0.1,
                  color: AppColors.app_txt_color),
              decoration: InputDecoration(
                  hoverColor: AppColors.app_txt_color,
                  border: OutlineInputBorder(
                      borderSide: BorderSide(color: AppColors.app_txt_color),
                      borderRadius: BorderRadius.circular(10.0)),
                  hintText: _l10n.confirmEmailAddHint,
                  labelText: _l10n.confirmEmailAdd,
                  contentPadding: EdgeInsets.only(
                      left: SizeConfig.widthMultiplier * 3.8888888888888884),
                  suffixStyle: const TextStyle(color: AppColors.toolbarBlue)),
            ),
          )),
      Container(
        width: MediaQuery.of(context).size.width,
        height: SizeConfig.heightMultiplier * 6.025824964131995,
        margin: EdgeInsets.only(
            top: SizeConfig.heightMultiplier * 2.5107604017216643,
            left: SizeConfig.widthMultiplier * 3.8888888888888884,
            right: SizeConfig.widthMultiplier * 3.8888888888888884,
            bottom: SizeConfig.heightMultiplier * 2.0086083213773316),
        child: RaisedGradientButton(
          gradient: LinearGradient(
            colors: <Color>[
              AppColors.nextButtonPrimary,
              AppColors.nextButtonSecondary,
            ],
          ),
          child: Padding(
              padding: EdgeInsets.fromLTRB(5, 10, 5, 10),
              child: Text(
                _l10n.next,
                style: GoogleFonts.inter(
                    fontWeight: FontWeight.w700,
                    fontSize: SizeConfig.textMultiplier * 1.757532281205165,
                    letterSpacing: 0.5,
                    color: AppColors.white),
              )),
          onPressed: () async {
            if (_emailController.text == _confirmEmailController.text &&
                _emailController.text != "" &&
                _emailController.text != _l10n.emailAddress &&
                _confirmEmailController.text != "" &&
                _confirmEmailController.text != _l10n.confirmEmailAdd &&
                _nameController.text != "" &&
                _nameController.text != _l10n.firstName &&
                _usernameController.text != "" &&
                _usernameController.text != _l10n.lastName &&
                _emailValid) {
              _isSame = true;
              _globalKey.currentState.hideCurrentSnackBar();
              FocusScope.of(context).unfocus();
              _nextButtonEnable = true;
              bool validEmail = await UserApi.emailExist(_emailController.text);
              if (!validEmail) {
                _showSnackBar("email already exist!");
              } else {
                _pageController.jumpToPage(1);
              }
            } else if (_nameController.text == "" ||
                _nameController.text == _l10n.firstName) {
              _showSnackBar("Please enter name");
            } else if (_usernameController.text == "" ||
                _usernameController.text == _l10n.lastName) {
              _showSnackBar("Please enter last name");
            } else if (_emailController.text == "" ||
                _emailController.text == _l10n.emailAddress ||
                _confirmEmailController.text == "" ||
                _confirmEmailController.text == _l10n.confirmEmailAdd) {
              _showSnackBar("Please enter email details");
            } else if (_emailController.text != _confirmEmailController.text) {
              setState(() {
                _isSame = false;
                _showSnackBar("Email address not the same");
              });
            } else if (!_emailValid) {
              _showSnackBar("Invalid email!");
            }
          },
        ),
      ),
    ]));
  }

  String _getRandomNumberString() {
    // It will generate 6 digit random Number.
    // from 0 to 999999
    var rnd = new Random();
    var next = rnd.nextDouble() * 1000000;
    while (next < 100000) {
      next *= 10;
    }
    return next.toInt().toString();
  }

  Widget _screen2() {
    return Center(
        child: Column(
      children: <Widget>[
        // Padding(
        //   padding: EdgeInsets.only(
        //       left: SizeConfig.widthMultiplier * 3.8888888888888884,
        //       right: SizeConfig.widthMultiplier * 3.8888888888888884,
        //       top: SizeConfig.heightMultiplier * 0.6276901004304161),
        //   child: Theme(
        //     data: ThemeData(
        //       primaryColor: AppColors.toolbarBlue,
        //       primaryColorDark: AppColors.toolbarBlue,
        //     ),
        //     child: TextField(
        //       onTap: () => FocusScope.of(context).requestFocus(new FocusNode()),
        //       controller: _dobController,
        //       keyboardType: TextInputType.text,
        //       showCursor: false,
        //       readOnly: true,
        //       style: GoogleFonts.inter(
        //           fontWeight: FontWeight.w400,
        //           fontSize: SizeConfig.textMultiplier * 1.757532281205165,
        //           letterSpacing: 0.1,
        //           color: AppColors.app_txt_color),
        //       decoration: InputDecoration(
        //         suffixIcon: GestureDetector(
        //             onTap: () => _selectDate(context),
        //             child: Icon(
        //               Icons.date_range,
        //             )),
        //         border: OutlineInputBorder(
        //             borderSide: BorderSide(color: Colors.grey.shade300),
        //             borderRadius: BorderRadius.circular(10.0)),
        //         hintText: _l10n.DOBHint,
        //         labelText: _l10n.DOB,
        //         contentPadding: EdgeInsets.only(
        //             left: SizeConfig.widthMultiplier * 3.8888888888888884),
        //         suffixStyle: const TextStyle(color: AppColors.toolbarBlue),
        //       ),
        //     ),
        //   ),
        // ),
        Padding(
            padding: EdgeInsets.only(
                left: SizeConfig.widthMultiplier * 3.8888888888888884,
                right: SizeConfig.widthMultiplier * 2.8888888888888884,
                top: SizeConfig.heightMultiplier * 1.5064562410329987),
            child: Theme(
              data: ThemeData(
                  primaryColor: AppColors.appBlue,
                  primaryColorDark: AppColors.appBlue,
                  hintColor: AppColors.darkgrey),
              child: Container(
                width: MediaQuery.of(context).size.width,
                // padding: EdgeInsets.symmetric(horizontal: 126),
                decoration: BoxDecoration(
                    // suffixIcon: Icon(Icons.keyboard_arrow_down),
                    border: Border.all(
                        color: AppColors.text_field_container, width: 1),
                    borderRadius: BorderRadius.circular(10.0))

                // BorderSide(color: AppColors.text_field_container),
                //     borderRadius: BorderRadius.circular(10.0)),
                // contentPadding: EdgeInsets.only(
                //     left: SizeConfig.widthMultiplier * 3.8888888888888884),
                // hintText: 'Australia',
                // suffixStyle:
                //     const TextStyle(color: AppColors.text_field_container)),
                ,
                child: ButtonTheme(
                  alignedDropdown: true,
                  child: DropdownButton(
                    onTap: () =>
                        FocusScope.of(context).requestFocus(new FocusNode()),
                    hint: Text("Country",
                        style: TextStyle(color: Colors.black.withOpacity(0.6))),
                    icon: Icon(
                      Icons.keyboard_arrow_down,
                      color: AppColors.darkgrey500,
                    ),
                    style: _countryValue == null
                        ? GoogleFonts.inter(
                            fontWeight: FontWeight.w400,
                            fontSize:
                                SizeConfig.textMultiplier * 1.757532281205165,
                            letterSpacing: 0.1,
                            color: AppColors.darkgrey)
                        : GoogleFonts.inter(
                            fontWeight: FontWeight.w400,
                            fontSize:
                                SizeConfig.textMultiplier * 1.757532281205165,
                            letterSpacing: 0.1,
                            color: AppColors.app_txt_color),
                    underline: SizedBox(),
                    value: _countryValue,
                    items: _countryList.map((valueItem) {
                      return DropdownMenuItem(
                          value: valueItem, child: Text(valueItem));
                    }).toList(),
                    isExpanded: true,
                    onChanged: (value) {
                      setState(() {
                        _countryValue = value;
                        // print('country value: ${_countryValue}');
                        // print('value value: ${value}');
                      });
                    },
                  ),
                ),
              ),
              // child: TextField(
              //   keyboardType: TextInputType.phone,
              //   key: _countryKey,
              //   controller: _countryController,
              //   readOnly: true,
              //   showCursor: false,
              //   onTap: () {
              //     setState(() {
              //       this._overlayEntry = this._createOverlayEntry(
              //           _countryList, _countryKey, _countryController);
              //       Overlay.of(context).insert(this._overlayEntry);
              //     });
              //   },
              //   style: GoogleFonts.inter(
              //       fontWeight: FontWeight.w400,
              //       fontSize: SizeConfig.textMultiplier * 1.757532281205165,
              //       letterSpacing: 0.1,
              //       color: AppColors.app_txt_color),
              // decoration: InputDecoration(
              //     suffixIcon: Icon(Icons.keyboard_arrow_down),
              //     border: OutlineInputBorder(
              //         borderSide:
              //             BorderSide(color: AppColors.text_field_container),
              //         borderRadius: BorderRadius.circular(10.0)),
              //     contentPadding: EdgeInsets.only(
              //         left: SizeConfig.widthMultiplier * 3.8888888888888884),
              //     hintText: 'Australia',
              //     suffixStyle:
              //         const TextStyle(color: AppColors.text_field_container)),
              // ),
            )),
        Row(
          children: [
            Container(
              width: SizeConfig.widthMultiplier * 20,
              child: Padding(
                  padding: EdgeInsets.only(
                      left: SizeConfig.widthMultiplier * 3.8888888888888884,
                      // right: SizeConfig.widthMultiplier * 30,
                      top: SizeConfig.heightMultiplier * 1.5064562410329987),
                  child: Theme(
                    data: ThemeData(
                      primaryColor: AppColors.toolbarBlue,
                      primaryColorDark: AppColors.toolbarBlue,
                    ),
                    child: TextField(
                      enabled: false,
                      // keyboardType: TextInputType.phone,
                      // controller: _phoneController,
                      // buildCounter: (BuildContext context,
                      //         {int currentLength,
                      //         int maxLength,
                      //         bool isFocused}) =>
                      //     null,
                      // maxLength: 10,
                      style: GoogleFonts.inter(
                          fontWeight: FontWeight.w400,
                          fontSize:
                              SizeConfig.textMultiplier * 1.757532281205165,
                          letterSpacing: 0.1,
                          color: AppColors.app_txt_color),
                      decoration: InputDecoration(
                          border: OutlineInputBorder(
                              borderSide:
                                  BorderSide(color: Colors.grey.shade300),
                              borderRadius: BorderRadius.circular(10.0)),
                          hintText: _l10n.phoneNumberHint,
                          labelText: _countryValue == null ||
                                  _countryValue == "Australia"
                              ? "+61"
                              : "+86",
                          labelStyle: TextStyle(
                              fontWeight: FontWeight.w400,
                              fontSize:
                                  SizeConfig.textMultiplier * 1.757532281205165,
                              letterSpacing: 0.1,
                              color: Colors.black.withOpacity(0.6)),
                          contentPadding: EdgeInsets.only(
                              left: SizeConfig.widthMultiplier *
                                  3.8888888888888884),
                          suffixStyle:
                              const TextStyle(color: AppColors.toolbarBlue)),
                    ),
                  )),
            ),
            Container(
              width: SizeConfig.widthMultiplier * 76,
              child: Padding(
                  padding: EdgeInsets.only(
                      left: SizeConfig.widthMultiplier * 1.5,
                      // right: SizeConfig.widthMultiplier * 17.8888888888888884,
                      top: SizeConfig.heightMultiplier * 1.5064562410329987),
                  child: Theme(
                    data: ThemeData(
                      primaryColor: AppColors.toolbarBlue,
                      primaryColorDark: AppColors.toolbarBlue,
                    ),
                    child: TextField(
                      keyboardType: TextInputType.phone,
                      controller: _phoneController,
                      buildCounter: (BuildContext context,
                              {int currentLength,
                              int maxLength,
                              bool isFocused}) =>
                          null,
                      maxLength: 10,
                      style: GoogleFonts.inter(
                          fontWeight: FontWeight.w400,
                          fontSize:
                              SizeConfig.textMultiplier * 1.757532281205165,
                          letterSpacing: 0.1,
                          color: AppColors.app_txt_color),
                      decoration: InputDecoration(
                          border: OutlineInputBorder(
                              borderSide:
                                  BorderSide(color: Colors.grey.shade300),
                              borderRadius: BorderRadius.circular(10.0)),
                          hintText: _l10n.phoneNumberHint,
                          labelText: _l10n.phoneNumber,
                          contentPadding: EdgeInsets.only(
                              left: SizeConfig.widthMultiplier *
                                  3.8888888888888884),
                          suffixStyle:
                              const TextStyle(color: AppColors.toolbarBlue)),
                    ),
                  )),
            ),
          ],
        ),

        // Padding(
        //     padding: EdgeInsets.only(
        //         left: SizeConfig.widthMultiplier * 3.8888888888888884,
        //         right: SizeConfig.widthMultiplier * 3.8888888888888884,
        //         top: SizeConfig.heightMultiplier * 1.5064562410329987),
        //     child: Theme(
        //         data: ThemeData(
        //             primaryColor: AppColors.appBlue,
        //             primaryColorDark: AppColors.appBlue,
        //             hintColor: AppColors.darkgrey),
        //         child: Container(
        //           width: MediaQuery.of(context).size.width,
        //           // padding: EdgeInsets.symmetric(horizontal: 126),
        //           decoration: BoxDecoration(
        //               // suffixIcon: Icon(Icons.keyboard_arrow_down),
        //               border: Border.all(
        //                   color: AppColors.text_field_container, width: 1),
        //               borderRadius: BorderRadius.circular(10.0)),
        //           child: ButtonTheme(
        //             alignedDropdown: true,
        //             child: DropdownButton(
        //               onTap: () =>
        //                   FocusScope.of(context).requestFocus(new FocusNode()),
        //               hint: Text("Preferred cryptocurrency",
        //                   style:
        //                       TextStyle(color: Colors.black.withOpacity(0.6))),
        //               icon: Icon(
        //                 Icons.keyboard_arrow_down,
        //                 color: AppColors.darkgrey500,
        //               ),
        //               style: _countryValue == null
        //                   ? GoogleFonts.inter(
        //                       fontWeight: FontWeight.w400,
        //                       fontSize:
        //                           SizeConfig.textMultiplier * 1.757532281205165,
        //                       letterSpacing: 0.1,
        //                       color: AppColors.darkgrey)
        //                   : GoogleFonts.inter(
        //                       fontWeight: FontWeight.w400,
        //                       fontSize:
        //                           SizeConfig.textMultiplier * 1.757532281205165,
        //                       letterSpacing: 0.1,
        //                       color: AppColors.app_txt_color),
        //               underline: SizedBox(),
        //               value: _prefferedCryptoValue,
        //               items: _cryptoCurrency.map((valueItem) {
        //                 return DropdownMenuItem(
        //                     value: valueItem, child: Text(valueItem));
        //               }).toList(),
        //               isExpanded: true,
        //               onChanged: (value) {
        //                 setState(() {
        //                   _prefferedCryptoValue = value;
        //                   // print('country value: ${_countryValue}');
        //                   // print('value value: ${value}');
        //                 });
        //               },
        //             ),
        //           ),
        //         ))),
        // Padding(
        //     padding: EdgeInsets.only(
        //         left: SizeConfig.widthMultiplier * 3.8888888888888884,
        //         right: SizeConfig.widthMultiplier * 3.8888888888888884,
        //         top: SizeConfig.heightMultiplier * 1.5064562410329987),
        //     child: Theme(
        //         data: ThemeData(
        //             primaryColor: AppColors.appBlue,
        //             primaryColorDark: AppColors.appBlue,
        //             hintColor: AppColors.darkgrey),
        //         child: Container(
        //           width: MediaQuery.of(context).size.width,
        //           // padding: EdgeInsets.symmetric(horizontal: 126),
        //           decoration: BoxDecoration(
        //               // suffixIcon: Icon(Icons.keyboard_arrow_down),
        //               border: Border.all(
        //                   color: AppColors.text_field_container, width: 1),
        //               borderRadius: BorderRadius.circular(10.0)),
        //           child: ButtonTheme(
        //             alignedDropdown: true,
        //             child: DropdownButton(
        //               onTap: () =>
        //                   FocusScope.of(context).requestFocus(new FocusNode()),
        //               hint: Text("Preferred currency",
        //                   style:
        //                       TextStyle(color: Colors.black.withOpacity(0.6))),
        //               icon: Icon(
        //                 Icons.keyboard_arrow_down,
        //                 color: AppColors.darkgrey500,
        //               ),
        //               style: _countryValue == null
        //                   ? GoogleFonts.inter(
        //                       fontWeight: FontWeight.w400,
        //                       fontSize:
        //                           SizeConfig.textMultiplier * 1.757532281205165,
        //                       letterSpacing: 0.1,
        //                       color: AppColors.darkgrey)
        //                   : GoogleFonts.inter(
        //                       fontWeight: FontWeight.w400,
        //                       fontSize:
        //                           SizeConfig.textMultiplier * 1.757532281205165,
        //                       letterSpacing: 0.1,
        //                       color: AppColors.app_txt_color),
        //               underline: SizedBox(),
        //               value: _prefferedCurrencyValue,
        //               items: _prefferedCurrency.map((valueItem) {
        //                 return DropdownMenuItem(
        //                     value: valueItem, child: Text(valueItem));
        //               }).toList(),
        //               isExpanded: true,
        //               onChanged: (value) {
        //                 setState(() {
        //                   _prefferedCurrencyValue = value;
        //                   // print('country value: ${_countryValue}');
        //                   // print('value value: ${value}');
        //                 });
        //               },
        //             ),
        //           ),
        //         ))),

        /*Padding(
            padding: EdgeInsets.only(left: SizeConfig.widthMultiplier * 3.8888888888888884, right: SizeConfig.widthMultiplier * 3.8888888888888884, top: SizeConfig.heightMultiplier * 1.5064562410329987),
            child: Theme(
              data: ThemeData(
                primaryColor: AppColors.toolbarBlue,
                primaryColorDark: AppColors.toolbarBlue,
              ),
              child: Container(
                height: SizeConfig.heightMultiplier * 6.025824964131995,
                width: MediaQuery.of(context).size.width,
                padding: const EdgeInsets.only(left: SizeConfig.widthMultiplier * 2.4305555555555554, right: SizeConfig.widthMultiplier * 2.4305555555555554),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10.0),
                    border: Border.all(color: AppColors.text_field_container)),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton(
                      value: _selectedItem,
                      items: _dropdownMenuItems,
                      isExpanded: true,
                      isDense: true,
                      icon: Icon(Icons.keyboard_arrow_down),
                      onChanged: (value) {
                        setState(() {
                          if(value == "CRYPTOCURRENCY"){
                            value = "BTC";
                          }else {
                            _selectedItem = value;
                          }
                        });
                      }),
                ),
              ),
            )),*/

        Padding(
          padding: EdgeInsets.only(
              left: SizeConfig.widthMultiplier * 3.8888888888888884,
              right: SizeConfig.widthMultiplier * 3.8888888888888884,
              top: SizeConfig.heightMultiplier * 1.6276901004304161),
          child: Theme(
            data: ThemeData(
                primaryColor: AppColors.toolbarBlue,
                primaryColorDark: AppColors.toolbarBlue,
                hintColor: _isSame && _passChecks
                    ? AppColors.darkgrey
                    : AppColors.red_text),
            child: TextField(
              keyboardType: TextInputType.text,
              controller: _passwordController,
              obscureText: _passwordVisible,
              onEditingComplete: () {
                if (_passwordController.text ==
                    _confirmPasswordController.text) {
                  setState(() {
                    _isSame = true;
                    _nextButtonEnable = true;
                    _globalKey.currentState.hideCurrentSnackBar();
                  });
                  // FocusScope.of(context).unfocus();
                  // _pageController.jumpToPage(1);
                } else if (_confirmPasswordController.text != null &&
                    _confirmPasswordController.text != "" &&
                    _passwordController.text !=
                        _confirmPasswordController.text) {
                  setState(() {
                    _isSame = false;
                    // print('is same validation ${_isSame}');
                    _showSnackBar(Constants.password_match_validation);
                  });
                }

                if (!_passwordInvalid) {
                  setState(() {
                    _passChecks = false;
                    _showSnackBar(Constants.password_validation);
                  });
                } else {
                  setState(() {
                    _passChecks = true;
                    _nextButtonEnable = true;
                    _globalKey.currentState.hideCurrentSnackBar();

                    if (_passwordController.text.length < 6) {
                      setState(() {
                        _passChecks = false;
                        _showSnackBar("Password must be 6 characters minimum");
                      });
                    } else {
                      setState(() {
                        _passChecks = true;
                        _nextButtonEnable = true;
                      });
                    }
                  });
                }

                FocusScope.of(context).unfocus();
              },
              style: GoogleFonts.inter(
                fontWeight: FontWeight.w400,
                fontSize: SizeConfig.textMultiplier * 1.757532281205165,
                letterSpacing: 0.1,
                color: AppColors.text_field_color,
              ),
              buildCounter: (BuildContext context,
                      {int currentLength, int maxLength, bool isFocused}) =>
                  null,
              decoration: InputDecoration(
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
                  border: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey.shade300),
                      borderRadius: BorderRadius.circular(10.0)),
                  hintText: _l10n.enterPasswordHint,
                  labelText: _l10n.password,
                  contentPadding: EdgeInsets.only(
                      left: SizeConfig.widthMultiplier * 3.8888888888888884),
                  suffixStyle: const TextStyle(color: AppColors.toolbarBlue)),
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
                primaryColor: AppColors.toolbarBlue,
                primaryColorDark: AppColors.toolbarBlue,
                hintColor: _isSame && _confirmPassLengthMet
                    ? AppColors.darkgrey
                    : AppColors.red_text),
            child: TextFormField(
              onFieldSubmitted: (String value) {
                if (_passwordController.text ==
                    _confirmPasswordController.text) {
                  setState(() {
                    _isSame = true;
                    _globalKey.currentState.hideCurrentSnackBar();
                  });
                  // FocusScope.of(context).unfocus();
                  // _pageController.jumpToPage(1);
                } else if (_passwordController.text !=
                        _confirmPasswordController.text &&
                    _confirmPasswordController.text != null &&
                    _confirmPasswordController.text != "") {
                  setState(() {
                    _isSame = false;
                    // print('is same validation ${_isSame}');
                    _showSnackBar(Constants.password_match_validation);
                  });
                }

                // if (!_passwordInvalid) {
                //   setState(() {
                //     _isSame = false;
                //     _showSnackBar(Constants.password_validation);
                //   });
                // } else {
                //   setState(() {
                //     _isSame = true;
                //     _globalKey.currentState.hideCurrentSnackBar();
                //   });
                // }

                if (_confirmPasswordController.text.length < 6) {
                  setState(() {
                    _confirmPassLengthMet = false;
                    _showSnackBar(
                        "Confirmed password must be 6 characters minimum");
                  });
                } else {
                  setState(() {
                    _confirmPassLengthMet = true;
                  });
                }

                FocusScope.of(context).unfocus();
              },
              keyboardType: TextInputType.text,
              controller: _confirmPasswordController,
              obscureText: _confirmpasswordVisible,
              style: GoogleFonts.inter(
                  fontWeight: FontWeight.w400,
                  fontSize: SizeConfig.textMultiplier * 1.757532281205165,
                  letterSpacing: 0.1,
                  color: AppColors.text_field_color),
              buildCounter: (BuildContext context,
                      {int currentLength, int maxLength, bool isFocused}) =>
                  null,
              decoration: InputDecoration(
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
                        _confirmpasswordVisible = !_confirmpasswordVisible;
                      });
                    },
                  ),
                  border: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey.shade300),
                      borderRadius: BorderRadius.circular(10.0)),
                  hintText: _l10n.enterPasswordHint,
                  labelText: 'Confirm password',
                  contentPadding: EdgeInsets.only(
                      left: SizeConfig.widthMultiplier * 3.8888888888888884),
                  suffixStyle: const TextStyle(color: AppColors.toolbarBlue)),
            ),
          ),
        ),
        // Row(
        //   mainAxisAlignment: MainAxisAlignment.start,
        //   mainAxisSize: MainAxisSize.min,
        //   children: [
        //     if (_policyCheck)
        //       GestureDetector(
        //         onTap: () {
        //           setState(() {
        //             _policyCheck = false;
        //             _nextButtonEnable = false;
        //           });
        //         },
        //         child: Container(
        //           width: SizeConfig.widthMultiplier * 4.374999999999999,
        //           height: SizeConfig.heightMultiplier * 2.259684361549498,
        //           margin: EdgeInsets.only(
        //               left: SizeConfig.widthMultiplier * 4.861111111111111,
        //               top: SizeConfig.heightMultiplier * 2.887374461979914),
        //           decoration: BoxDecoration(
        //               border: Border.all(
        //                   color: AppColors.appBlue,
        //                   width:
        //                       SizeConfig.widthMultiplier * 0.24305555555555552),
        //               borderRadius: BorderRadius.circular(3)),
        //           child: Icon(
        //             Icons.check,
        //             color: AppColors.appBlue,
        //             size: 16,
        //           ),
        //         ),
        //       ),
        //     if (!_policyCheck)
        //       GestureDetector(
        //         onTap: () {
        //           setState(() {
        //             _policyCheck = true;
        //             _nextButtonEnable = true;
        //           });
        //         },
        //         child: Container(
        //           width: SizeConfig.widthMultiplier * 4.374999999999999,
        //           height: SizeConfig.heightMultiplier * 2.259684361549498,
        //           margin: EdgeInsets.only(
        //               left: SizeConfig.widthMultiplier * 4.861111111111111,
        //               top: SizeConfig.heightMultiplier * 2.887374461979914),
        //           decoration: BoxDecoration(
        //               border: Border.all(
        //                   color: AppColors.appBlue,
        //                   width:
        //                       SizeConfig.widthMultiplier * 0.24305555555555552),
        //               borderRadius: BorderRadius.circular(3)),
        //         ),
        //       ),
        //     Flexible(
        //       child: Container(
        //           margin: EdgeInsets.only(
        //               left: SizeConfig.widthMultiplier * 2.9166666666666665,
        //               right: SizeConfig.widthMultiplier * 3.159722222222222,
        //               top: SizeConfig.heightMultiplier * 2.887374461979914),
        //           child: Text(_l10n.termConditionText,
        //               style: GoogleFonts.inter(
        //                   fontSize:
        //                       SizeConfig.textMultiplier * 1.5064562410329987,
        //                   fontWeight: FontWeight.w400,
        //                   letterSpacing: 0.4))),
        //     ),
        //   ],
        // ),
        // Row(
        //   mainAxisAlignment: MainAxisAlignment.start,
        //   mainAxisSize: MainAxisSize.min,
        //   children: [
        //     if (_mailCheck)
        //       GestureDetector(
        //         onTap: () {
        //           setState(() {
        //             _mailCheck = false;
        //           });
        //         },
        //         child: Container(
        //           width: SizeConfig.widthMultiplier * 4.374999999999999,
        //           height: SizeConfig.heightMultiplier * 2.259684361549498,
        //           margin: EdgeInsets.only(
        //               left: SizeConfig.widthMultiplier * 4.861111111111111,
        //               top: SizeConfig.heightMultiplier * 1.129842180774749),
        //           decoration: BoxDecoration(
        //               border: Border.all(
        //                   color: AppColors.appBlue,
        //                   width:
        //                       SizeConfig.widthMultiplier * 0.24305555555555552),
        //               borderRadius: BorderRadius.circular(3)),
        //           child: Icon(
        //             Icons.check,
        //             color: AppColors.appBlue,
        //             size: 16,
        //           ),
        //         ),
        //       ),
        //     if (!_mailCheck)
        //       GestureDetector(
        //         onTap: () {
        //           setState(() {
        //             _mailCheck = true;
        //           });
        //         },
        //         child: Container(
        //           width: SizeConfig.widthMultiplier * 4.374999999999999,
        //           height: SizeConfig.heightMultiplier * 2.259684361549498,
        //           margin: EdgeInsets.only(
        //               left: SizeConfig.widthMultiplier * 4.861111111111111,
        //               top: SizeConfig.heightMultiplier * 1.129842180774749),
        //           decoration: BoxDecoration(
        //               border: Border.all(
        //                   color: AppColors.appBlue,
        //                   width:
        //                       SizeConfig.widthMultiplier * 0.24305555555555552),
        //               borderRadius: BorderRadius.circular(3)),
        //         ),
        //       ),
        //     Flexible(
        //       child: Container(
        //           margin: EdgeInsets.only(
        //               left: SizeConfig.widthMultiplier * 2.9166666666666665,
        //               right: SizeConfig.widthMultiplier * 3.159722222222222,
        //               top: SizeConfig.heightMultiplier * 1.3809182209469155),
        //           child: Text(_l10n.emailText,
        //               style: GoogleFonts.inter(
        //                   fontSize:
        //                       SizeConfig.textMultiplier * 1.5064562410329987,
        //                   fontWeight: FontWeight.w400,
        //                   letterSpacing: 0.4))),
        //     ),
        //   ],
        // ),
        Container(
          width: MediaQuery.of(context).size.width,
          height: SizeConfig.heightMultiplier * 6.025824964131995,
          margin: EdgeInsets.only(
              top: SizeConfig.heightMultiplier * 3.389526542324247,
              left: SizeConfig.widthMultiplier * 3.8888888888888884,
              right: SizeConfig.widthMultiplier * 3.8888888888888884),
          child: RaisedGradientButton(
              gradient: _nextButtonEnable
                  ? LinearGradient(
                      colors: <Color>[
                        AppColors.gradient_button_light,
                        AppColors.gradient_button_dark,
                      ],
                    )
                  : LinearGradient(
                      colors: <Color>[
                        Colors.grey.shade200,
                        Colors.grey.shade200
                      ],
                    ),
              child: Padding(
                  padding: EdgeInsets.fromLTRB(5, 10, 5, 10),
                  child: Text(
                    'CREATE MY ACCOUNT',
                    style: GoogleFonts.inter(
                        fontSize: SizeConfig.textMultiplier * 1.757532281205165,
                        fontWeight: FontWeight.w700,
                        color: _nextButtonEnable
                            ? AppColors.white
                            : AppColors.text_field_container,
                        letterSpacing: 0.5,
                        textStyle: TextStyle(fontFamily: 'Roboto')),
                  )),
              onPressed: () {
                if (_nextButtonEnable) {
                  FocusScope.of(context).unfocus();

                  setState(() {
                    _isSame = true;
                    _globalKey.currentState.hideCurrentSnackBar();
                  });

                  // if (_prefferedCryptoValue == null ||
                  //     _prefferedCryptoValue == "Preferred cryptocurrency") {
                  //   _showSnackBar(Constants.currency_selection_validation);
                  // } else if (_prefferedCurrencyValue == null ||
                  //     _prefferedCurrencyValue == "Preferred currency") {
                  //   _showSnackBar("Select preferred currency");
                  // }
                  if (_countryValue == null) {
                    _showSnackBar("Please select country");
                  } else {
                    _phone = _phoneController.text;
                    _editedPhone = _countryValue == "Australia"
                        ? _phone.startsWith('0')
                            ? _phone.replaceFirst(RegExp(r'^0+'), "+61")
                            : "+61${_phone}"
                        : "+86${_phone}";

                    if (_countryValue == "Australia") {
                      _fiatPair = "AUD";
                    } else if (_countryValue == "China") {
                      _fiatPair = "CNY";
                    }
                    // if (_prefferedCurrencyValue == "Australian Dollar") {
                    //   _fiatPair = "AUD";
                    // } else if (_prefferedCurrencyValue == "Chinese Yuan") {
                    //   _fiatPair = "CNY";
                    // }
                    _cryptoPair = "BTC";
                    // if (_prefferedCryptoValue == "Bitcoin") {
                    //   _cryptoPair = "BTC";
                    // } else if (_prefferedCryptoValue == "Ethereum") {
                    //   _cryptoPair = "ETH";
                    // } else if (_prefferedCryptoValue == "USDC") {
                    //   _cryptoPair = "USDC";
                    // }

                    if (!_passwordInvalid) {
                      setState(() {
                        _isSame = false;
                      });

                      _showSnackBar(Constants.password_validation);
                    } else if (_passwordController.text !=
                        _confirmPasswordController.text) {
                      _isSame = false;
                      _showSnackBar(Constants.password_match_validation);
                    } else {
                      SignUpRequest request = SignUpRequest();
                      request.email = _emailController.text;
                      request.firstName = _nameController.text;
                      request.lastName = _usernameController.text;
                      request.communications = "$_mailCheck";
                      request.phoneNumber = _editedPhone;
                      request.displayName = _nameController.text +
                          " " +
                          _usernameController.text +
                          " " +
                          _getRandomNumberString();
                      // request.dateOfBirth = _dobController.text;
                      request.deviceIDToken = _GeneralInfoBloc1.deviceTokenID;
                      // request.password = _passwordController.text;
                      // request.confirmPass = _confirmPasswordController.text;
                      request.policies = "$_policyCheck";
                      request.prefFiat = _fiatPair;
                      request.prefCrypto = _cryptoPair;
                      request.country = _countryValue;
                      _GeneralInfoBloc1.signUpRequest = request;
                      _GeneralInfoBloc1.email = _emailController.text;
                      _GeneralInfoBloc1.pass = _passwordController.text;
                      _GeneralInfoBloc1.country = _countryValue;
                      // _GeneralInfoBloc1.country = _countryController.text;
                      _GeneralInfoBloc1.add(CreateUserEvent());
                    }
                  }
                }
              }),
          // Container(
          //   width: MediaQuery.of(context).size.width,
          //   height: SizeConfig.heightMultiplier * 6.025824964131995,
          //   margin: EdgeInsets.only(
          //       top: SizeConfig.heightMultiplier * 2.5107604017216643,
          //       left: SizeConfig.widthMultiplier * 3.8888888888888884,
          //       right: SizeConfig.widthMultiplier * 3.8888888888888884),
          //   child: RaisedGradientButton(
          //       gradient: LinearGradient(
          //         colors: <Color>[
          //           AppColors.nextButtonPrimary,
          //           AppColors.nextButtonSecondary,
          //         ],
          //       ),
          //       child: Text(
          //         _l10n.next,
          //         style: GoogleFonts.inter(
          //             fontWeight: FontWeight.w700,
          //             fontSize: SizeConfig.textMultiplier * 1.757532281205165,
          //             letterSpacing: 0.1,
          //             color: AppColors.white,
          //             textStyle: TextStyle(fontFamily: 'Roboto')),
          //       ),
          //       onPressed: () {
          //         if (_prefferedCryptoValue == null ||
          //             _prefferedCryptoValue == "Preferred cryptocurrency") {
          //           _showSnackBar(Constants.currency_selection_validation);
          //         } else if (_prefferedCurrencyValue == null ||
          //             _prefferedCurrencyValue == "Preferred currency") {
          //           _showSnackBar("Select preferred currency");
          //         } else if (_countryValue == null) {
          //           _showSnackBar("Please select country");
          //         } else {
          //           _phone = _phoneController.text;
          //           _editedPhone = _countryValue == "Australia"
          //               ? _phone.startsWith('0')
          //                   ? _phone.replaceFirst(RegExp(r'^0+'), "+61")
          //                   : "+61${_phone}"
          //               : "+86${_phone}";

          //           if (_countryValue == "Australia") {
          //             _fiatPair = "AUD";
          //           } else if (_countryValue == "China") {
          //             _fiatPair = "CNY";
          //           }
          //           // if (_prefferedCurrencyValue == "Australian Dollar") {
          //           //   _fiatPair = "AUD";
          //           // } else if (_prefferedCurrencyValue == "Chinese Yuan") {
          //           //   _fiatPair = "CNY";
          //           // }
          //           _cryptoPair = "BTC";
          //           // if (_prefferedCryptoValue == "Bitcoin") {
          //           //   _cryptoPair = "BTC";
          //           // } else if (_prefferedCryptoValue == "Ethereum") {
          //           //   _cryptoPair = "ETH";
          //           // } else if (_prefferedCryptoValue == "USDC") {
          //           //   _cryptoPair = "USDC";
          //           // }
          //           FocusScope.of(context).unfocus();
          //           _pageController.jumpToPage(2);
          //         }
          //       }),
          // ),
        )
      ],
    ));
  }

  Widget _screen3() {
    // print("confirm pass: ${_confirmPasswordController.text}");
    return Center(
        child: Column(children: <Widget>[
      // Padding(
      //   padding: EdgeInsets.only(
      //       left: SizeConfig.widthMultiplier * 3.8888888888888884,
      //       right: SizeConfig.widthMultiplier * 3.8888888888888884,
      //       top: SizeConfig.heightMultiplier * 0.6276901004304161),
      //   child: Theme(
      //     data: ThemeData(
      //         primaryColor: AppColors.toolbarBlue,
      //         primaryColorDark: AppColors.toolbarBlue,
      //         hintColor: _isSame && _passChecks
      //             ? AppColors.darkgrey
      //             : AppColors.red_text),
      //     child: TextField(
      //       keyboardType: TextInputType.text,
      //       controller: _passwordController,
      //       obscureText: _passwordVisible,
      //       onEditingComplete: () {
      //         if (_passwordController.text == _confirmPasswordController.text) {
      //           setState(() {
      //             _isSame = true;
      //             _globalKey.currentState.hideCurrentSnackBar();
      //           });
      //           // FocusScope.of(context).unfocus();
      //           // _pageController.jumpToPage(1);
      //         } else if (_confirmPasswordController.text != null &&
      //             _confirmPasswordController.text != "" &&
      //             _passwordController.text != _confirmPasswordController.text) {
      //           setState(() {
      //             _isSame = false;
      //             // print('is same validation ${_isSame}');
      //             _showSnackBar(Constants.password_match_validation);
      //           });
      //         }

      //         if (!_passwordInvalid) {
      //           setState(() {
      //             _passChecks = false;
      //             _showSnackBar(Constants.password_validation);
      //           });
      //         } else {
      //           setState(() {
      //             _passChecks = true;
      //             _globalKey.currentState.hideCurrentSnackBar();

      //             if (_passwordController.text.length < 6) {
      //               setState(() {
      //                 _passChecks = false;
      //                 _showSnackBar("Password must be 6 characters minimum");
      //               });
      //             } else {
      //               setState(() {
      //                 _passChecks = true;
      //               });
      //             }
      //           });
      //         }

      //         FocusScope.of(context).unfocus();
      //       },
      //       style: GoogleFonts.inter(
      //         fontWeight: FontWeight.w400,
      //         fontSize: SizeConfig.textMultiplier * 1.757532281205165,
      //         letterSpacing: 0.1,
      //         color: AppColors.text_field_color,
      //       ),
      //       buildCounter: (BuildContext context,
      //               {int currentLength, int maxLength, bool isFocused}) =>
      //           null,
      //       decoration: InputDecoration(
      //           suffixIcon: IconButton(
      //             icon: Icon(
      //               // Based on passwordVisible state choose the icon
      //               _passwordVisible ? Icons.visibility_off : Icons.visibility,
      //             ),
      //             onPressed: () {
      //               // Update the state i.e. toogle the state of passwordVisible variable
      //               setState(() {
      //                 _passwordVisible = !_passwordVisible;
      //               });
      //             },
      //           ),
      //           border: OutlineInputBorder(
      //               borderSide: BorderSide(color: Colors.grey.shade300),
      //               borderRadius: BorderRadius.circular(10.0)),
      //           hintText: _l10n.enterPasswordHint,
      //           labelText: _l10n.password,
      //           contentPadding: EdgeInsets.only(
      //               left: SizeConfig.widthMultiplier * 3.8888888888888884),
      //           suffixStyle: const TextStyle(color: AppColors.toolbarBlue)),
      //     ),
      //   ),
      // ),
      // Padding(
      //   padding: EdgeInsets.only(
      //       left: SizeConfig.widthMultiplier * 3.8888888888888884,
      //       right: SizeConfig.widthMultiplier * 3.8888888888888884,
      //       top: SizeConfig.heightMultiplier * 1.5064562410329987),
      //   child: Theme(
      //     data: ThemeData(
      //         primaryColor: AppColors.toolbarBlue,
      //         primaryColorDark: AppColors.toolbarBlue,
      //         hintColor: _isSame && _confirmPassLengthMet
      //             ? AppColors.darkgrey
      //             : AppColors.red_text),
      //     child: TextFormField(
      //       onFieldSubmitted: (String value) {
      //         if (_passwordController.text == _confirmPasswordController.text) {
      //           setState(() {
      //             _isSame = true;
      //             _globalKey.currentState.hideCurrentSnackBar();
      //           });
      //           // FocusScope.of(context).unfocus();
      //           // _pageController.jumpToPage(1);
      //         } else if (_passwordController.text !=
      //                 _confirmPasswordController.text &&
      //             _confirmPasswordController.text != null &&
      //             _confirmPasswordController.text != "") {
      //           setState(() {
      //             _isSame = false;
      //             // print('is same validation ${_isSame}');
      //             _showSnackBar(Constants.password_match_validation);
      //           });
      //         }

      //         // if (!_passwordInvalid) {
      //         //   setState(() {
      //         //     _isSame = false;
      //         //     _showSnackBar(Constants.password_validation);
      //         //   });
      //         // } else {
      //         //   setState(() {
      //         //     _isSame = true;
      //         //     _globalKey.currentState.hideCurrentSnackBar();
      //         //   });
      //         // }

      //         if (_confirmPasswordController.text.length < 6) {
      //           setState(() {
      //             _confirmPassLengthMet = false;
      //             _showSnackBar(
      //                 "Confirmed password must be 6 characters minimum");
      //           });
      //         } else {
      //           setState(() {
      //             _confirmPassLengthMet = true;
      //           });
      //         }

      //         FocusScope.of(context).unfocus();
      //       },
      //       keyboardType: TextInputType.text,
      //       controller: _confirmPasswordController,
      //       obscureText: _confirmpasswordVisible,
      //       style: GoogleFonts.inter(
      //           fontWeight: FontWeight.w400,
      //           fontSize: SizeConfig.textMultiplier * 1.757532281205165,
      //           letterSpacing: 0.1,
      //           color: AppColors.text_field_color),
      //       buildCounter: (BuildContext context,
      //               {int currentLength, int maxLength, bool isFocused}) =>
      //           null,
      //       decoration: InputDecoration(
      //           suffixIcon: IconButton(
      //             icon: Icon(
      //               // Based on passwordVisible state choose the icon
      //               _confirmpasswordVisible
      //                   ? Icons.visibility_off
      //                   : Icons.visibility,
      //             ),
      //             onPressed: () {
      //               // Update the state i.e. toogle the state of passwordVisible variable
      //               setState(() {
      //                 _confirmpasswordVisible = !_confirmpasswordVisible;
      //               });
      //             },
      //           ),
      //           border: OutlineInputBorder(
      //               borderSide: BorderSide(color: Colors.grey.shade300),
      //               borderRadius: BorderRadius.circular(10.0)),
      //           hintText: _l10n.enterPasswordHint,
      //           labelText: 'Confirm password',
      //           contentPadding: EdgeInsets.only(
      //               left: SizeConfig.widthMultiplier * 3.8888888888888884),
      //           suffixStyle: const TextStyle(color: AppColors.toolbarBlue)),
      //     ),
      //   ),
      // ),
      // Row(
      //   mainAxisAlignment: MainAxisAlignment.start,
      //   mainAxisSize: MainAxisSize.min,
      //   children: [
      //     if (_policyCheck)
      //       GestureDetector(
      //         onTap: () {
      //           setState(() {
      //             _policyCheck = false;
      //             _nextButtonEnable = false;
      //           });
      //         },
      //         child: Container(
      //           width: SizeConfig.widthMultiplier * 4.374999999999999,
      //           height: SizeConfig.heightMultiplier * 2.259684361549498,
      //           margin: EdgeInsets.only(
      //               left: SizeConfig.widthMultiplier * 4.861111111111111,
      //               top: SizeConfig.heightMultiplier * 2.887374461979914),
      //           decoration: BoxDecoration(
      //               border: Border.all(
      //                   color: AppColors.appBlue,
      //                   width:
      //                       SizeConfig.widthMultiplier * 0.24305555555555552),
      //               borderRadius: BorderRadius.circular(3)),
      //           child: Icon(
      //             Icons.check,
      //             color: AppColors.appBlue,
      //             size: 16,
      //           ),
      //         ),
      //       ),
      //     if (!_policyCheck)
      //       GestureDetector(
      //         onTap: () {
      //           setState(() {
      //             _policyCheck = true;
      //             _nextButtonEnable = true;
      //           });
      //         },
      //         child: Container(
      //           width: SizeConfig.widthMultiplier * 4.374999999999999,
      //           height: SizeConfig.heightMultiplier * 2.259684361549498,
      //           margin: EdgeInsets.only(
      //               left: SizeConfig.widthMultiplier * 4.861111111111111,
      //               top: SizeConfig.heightMultiplier * 2.887374461979914),
      //           decoration: BoxDecoration(
      //               border: Border.all(
      //                   color: AppColors.appBlue,
      //                   width:
      //                       SizeConfig.widthMultiplier * 0.24305555555555552),
      //               borderRadius: BorderRadius.circular(3)),
      //         ),
      //       ),
      //     Flexible(
      //       child: Container(
      //           margin: EdgeInsets.only(
      //               left: SizeConfig.widthMultiplier * 2.9166666666666665,
      //               right: SizeConfig.widthMultiplier * 3.159722222222222,
      //               top: SizeConfig.heightMultiplier * 2.887374461979914),
      //           child: Text(_l10n.termConditionText,
      //               style: GoogleFonts.inter(
      //                   fontSize:
      //                       SizeConfig.textMultiplier * 1.5064562410329987,
      //                   fontWeight: FontWeight.w400,
      //                   letterSpacing: 0.4))),
      //     ),
      //   ],
      // ),
      // Row(
      //   mainAxisAlignment: MainAxisAlignment.start,
      //   mainAxisSize: MainAxisSize.min,
      //   children: [
      //     if (_mailCheck)
      //       GestureDetector(
      //         onTap: () {
      //           setState(() {
      //             _mailCheck = false;
      //           });
      //         },
      //         child: Container(
      //           width: SizeConfig.widthMultiplier * 4.374999999999999,
      //           height: SizeConfig.heightMultiplier * 2.259684361549498,
      //           margin: EdgeInsets.only(
      //               left: SizeConfig.widthMultiplier * 4.861111111111111,
      //               top: SizeConfig.heightMultiplier * 1.129842180774749),
      //           decoration: BoxDecoration(
      //               border: Border.all(
      //                   color: AppColors.appBlue,
      //                   width:
      //                       SizeConfig.widthMultiplier * 0.24305555555555552),
      //               borderRadius: BorderRadius.circular(3)),
      //           child: Icon(
      //             Icons.check,
      //             color: AppColors.appBlue,
      //             size: 16,
      //           ),
      //         ),
      //       ),
      //     if (!_mailCheck)
      //       GestureDetector(
      //         onTap: () {
      //           setState(() {
      //             _mailCheck = true;
      //           });
      //         },
      //         child: Container(
      //           width: SizeConfig.widthMultiplier * 4.374999999999999,
      //           height: SizeConfig.heightMultiplier * 2.259684361549498,
      //           margin: EdgeInsets.only(
      //               left: SizeConfig.widthMultiplier * 4.861111111111111,
      //               top: SizeConfig.heightMultiplier * 1.129842180774749),
      //           decoration: BoxDecoration(
      //               border: Border.all(
      //                   color: AppColors.appBlue,
      //                   width:
      //                       SizeConfig.widthMultiplier * 0.24305555555555552),
      //               borderRadius: BorderRadius.circular(3)),
      //         ),
      //       ),
      //     Flexible(
      //       child: Container(
      //           margin: EdgeInsets.only(
      //               left: SizeConfig.widthMultiplier * 2.9166666666666665,
      //               right: SizeConfig.widthMultiplier * 3.159722222222222,
      //               top: SizeConfig.heightMultiplier * 1.3809182209469155),
      //           child: Text(_l10n.emailText,
      //               style: GoogleFonts.inter(
      //                   fontSize:
      //                       SizeConfig.textMultiplier * 1.5064562410329987,
      //                   fontWeight: FontWeight.w400,
      //                   letterSpacing: 0.4))),
      //     ),
      //   ],
      // ),
      // Container(
      //   width: MediaQuery.of(context).size.width,
      //   height: SizeConfig.heightMultiplier * 6.025824964131995,
      //   margin: EdgeInsets.only(
      //       top: SizeConfig.heightMultiplier * 3.389526542324247,
      //       left: SizeConfig.widthMultiplier * 3.8888888888888884,
      //       right: SizeConfig.widthMultiplier * 3.8888888888888884),
      //   child: RaisedGradientButton(
      //       gradient: _nextButtonEnable
      //           ? LinearGradient(
      //               colors: <Color>[
      //                 AppColors.gradient_button_light,
      //                 AppColors.gradient_button_dark,
      //               ],
      //             )
      //           : LinearGradient(
      //               colors: <Color>[Colors.grey.shade200, Colors.grey.shade200],
      //             ),
      //       child: Padding(
      //           padding: EdgeInsets.fromLTRB(5, 10, 5, 10),
      //           child: Text(
      //             'CREATE MY ACCOUNT',
      //             style: GoogleFonts.inter(
      //                 fontSize: SizeConfig.textMultiplier * 1.757532281205165,
      //                 fontWeight: FontWeight.w700,
      //                 color: _nextButtonEnable
      //                     ? AppColors.white
      //                     : AppColors.text_field_container,
      //                 letterSpacing: 0.5,
      //                 textStyle: TextStyle(fontFamily: 'Roboto')),
      //           )),
      //       onPressed: () {
      //         if (_nextButtonEnable) {
      //           FocusScope.of(context).unfocus();

      //           setState(() {
      //             _isSame = true;
      //             _globalKey.currentState.hideCurrentSnackBar();
      //           });

      //           if (!_passwordInvalid) {
      //             setState(() {
      //               _isSame = false;
      //             });

      //             _showSnackBar(Constants.password_validation);
      //           } else if (_passwordController.text !=
      //               _confirmPasswordController.text) {
      //             _isSame = false;
      //             _showSnackBar(Constants.password_match_validation);
      //           } else {
      //             SignUpRequest request = SignUpRequest();
      //             request.email = _emailController.text;
      //             request.firstName = _nameController.text;
      //             request.lastName = _usernameController.text;
      //             request.communications = "$_mailCheck";
      //             request.phoneNumber = _editedPhone;
      //             request.displayName =
      //                 _nameController.text + " " + _usernameController.text;
      //             // request.dateOfBirth = _dobController.text;
      //             request.deviceIDToken = _GeneralInfoBloc1.deviceTokenID;
      //             // request.password = _passwordController.text;
      //             // request.confirmPass = _confirmPasswordController.text;
      //             request.policies = "$_policyCheck";
      //             request.prefFiat = _fiatPair;
      //             request.prefCrypto = _cryptoPair;
      //             request.country = _countryValue;
      //             _GeneralInfoBloc1.signUpRequest = request;
      //             _GeneralInfoBloc1.email = _emailController.text;
      //             _GeneralInfoBloc1.pass = _passwordController.text;
      //             _GeneralInfoBloc1.country = _countryValue;
      //             // _GeneralInfoBloc1.country = _countryController.text;
      //             _GeneralInfoBloc1.add(CreateUserEvent());
      //           }
      //         }
      //       }),
    ]));
  }

  Widget _bottomImage() {
    return Stack(
      children: [
        Image.asset(
          'assets/images/login_bottom_blue.png',
          fit: BoxFit.cover,
          width: double.infinity,
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

  Widget _bottomSheet(bool isCurrentPage) {
    return AnimatedContainer(
      margin: EdgeInsets.only(
          bottom: SizeConfig.heightMultiplier * 25.107604017216644,
          // top: SizeConfig.heightMultiplier * 2.0086083213773316,
          // right: SizeConfig.widthMultiplier * 5.729166666666664,
          left: SizeConfig.widthMultiplier * 44.729166666666664),
      duration: Duration(milliseconds: 500),
      child: Center(
        child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
          for (int i = 0; i < 2; i++)
            i == slideIndex
                ? _bottomSheetContainer(true)
                : _bottomSheetContainer(false),
        ]),
      ),
    );
  }

  Widget _bottomSheetContainer(bool isCurrentPage) {
    return Container(
      margin: EdgeInsets.only(
          left: SizeConfig.widthMultiplier * 1.9444444444444442),
      height: isCurrentPage ? 8 : 8,
      width: isCurrentPage ? 8 : 8,
      decoration: BoxDecoration(
          color: isCurrentPage ? Color(0xff034AA6) : Color(0xffD4D4D4),
          shape: BoxShape.circle),
    );
  }

  _selectDate(BuildContext context) async {
    final ThemeData theme = Theme.of(context);
    assert(theme.platform != null);
    switch (theme.platform) {
      case TargetPlatform.android:
      case TargetPlatform.fuchsia:
      case TargetPlatform.linux:
      case TargetPlatform.windows:
        return buildMaterialDatePicker(context);
      case TargetPlatform.iOS:
      case TargetPlatform.macOS:
        return buildCupertinoDatePicker(context);
    }
  }

  /// This builds material date picker in Android
  buildMaterialDatePicker(BuildContext context) async {
    final DateTime picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(1900),
      lastDate: DateTime(2025),
      builder: (context, child) {
        return Theme(
          data: ThemeData.light(),
          child: child,
        );
      },
    );
    if (picked != null && picked != selectedDate)
      setState(() {
        selectedDate = picked;
        final f = DateFormat('dd-MMM-yyyy');

        _dobController.text = f.format(selectedDate).toString();
      });
  }

  /// This builds cupertion date picker in iOS
  buildCupertinoDatePicker(BuildContext context) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext builder) {
          return Container(
            height: MediaQuery.of(context).copyWith().size.height / 3,
            color: AppColors.lightgrey,
            child: CupertinoDatePicker(
              mode: CupertinoDatePickerMode.date,
              onDateTimeChanged: (picked) {
                if (picked != null && picked != selectedDate)
                  setState(() {
                    selectedDate = picked;
                    final f = DateFormat('dd-MMM-yyyy');
                    _dobController.text = f.format(selectedDate).toString();
                  });
              },
              initialDateTime: selectedDate,
              minimumYear: 1900,
              maximumYear: 2025,
            ),
          );
        });
  }

  _showSnackBar(String snackText) {
    final snackBar = SnackBar(
      content: Text(snackText),
    );
    _globalKey.currentState.showSnackBar(snackBar);
  }

  OverlayEntry _createOverlayEntry(List<String> _dropdownList,
      GlobalKey<ScaffoldState> actionKey, TextEditingController controller) {
    RenderBox renderBox =
        actionKey.currentContext?.findRenderObject(); //EDIT THIS LINE
    var size = renderBox.size;
    var height = renderBox.size.height;
    var width = renderBox.size.width;

    var offset = renderBox.localToGlobal(Offset.zero);
    var xPosition = offset.dx;
    var yPosition = offset.dy;
    // print('xPosition $xPosition');
    // print('yPosition $yPosition');

    return OverlayEntry(
      builder: (context) => Positioned(
          left: xPosition,
          width: width,
          top: yPosition,
          child: Container(
              height: SizeConfig.heightMultiplier * 22.59684361549498,
              child: Material(
                elevation: 5,
                borderRadius: BorderRadius.circular(10.0),
                child: Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                          color: AppColors.appBlue,
                          width: SizeConfig.widthMultiplier *
                              0.24305555555555552)),
                  child: ListView(
                    shrinkWrap: true,
                    padding: EdgeInsets.zero,
                    children: _dropdownList
                        .map((value) => InkWell(
                              onTap: () {
                                setState(() {
                                  _overlayEntry.remove();
                                  controller.text = value;
                                });
                              },
                              child: value == _dropdownList[0]
                                  ? ListTile(
                                      title: Text(
                                        value,
                                        style: GoogleFonts.inter(
                                            color: AppColors.catTextColor,
                                            fontSize:
                                                SizeConfig.textMultiplier *
                                                    1.757532281205165),
                                      ),
                                      trailing: Icon(Icons.keyboard_arrow_down),
                                    )
                                  : ListTile(
                                      title: Text(
                                        value,
                                        style: GoogleFonts.inter(
                                            color: AppColors.catTextColor,
                                            fontSize:
                                                SizeConfig.textMultiplier *
                                                    1.757532281205165),
                                      ),
                                    ),
                            ))
                        .toList(),
                  ),
                ),
              ))),
    );
  }
}
