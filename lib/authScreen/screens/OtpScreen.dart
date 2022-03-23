import 'dart:collection';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/rendering.dart';
import 'package:market_space/apis/localPassWordApi.dart';
import 'package:market_space/apis/navigationApi.dart';
import 'package:market_space/apis/smsAuthApi.dart';
import 'package:market_space/apis/userApi/shoppingCartManager.dart';
import 'package:market_space/authScreen/logic/password_cubit.dart';
import 'package:market_space/authScreen/screens/widgets/PINNumbers.dart';
import 'package:market_space/authScreen/screens/widgets/bioBoard.dart';
import 'package:market_space/common/colors.dart';
import 'package:market_space/forgotPasswordOtp/forgot_password_otp_bloc.dart';
import 'package:market_space/forgotPasswordOtp/forgot_password_otp_route.dart';
import 'package:market_space/interested_categories/interested_categories_route.dart';
import 'package:market_space/providers/algoliaCLient.dart';
import 'package:market_space/responsive_layout/size_config.dart';
import 'package:market_space/services/RouterServices.dart';
import 'package:provider/provider.dart';
import 'package:video_player/video_player.dart';
import 'package:market_space/authScreen/authApi.dart';

enum _ScreenState {
  authenticate,
  setPassword1,
  setPassword2,
  passwordMissMatch,
}

extension _ScreenStateExtension on _ScreenState {
  String getInstruction() {
    switch (this) {
      case _ScreenState.authenticate:
        return "Enter pin";
      case _ScreenState.setPassword1:
        return "Enter a new pin";
      case _ScreenState.setPassword2:
        return "Confirm pin";
      case _ScreenState.passwordMissMatch:
        return "Enter a new pin";
    }
  }
}

class OtpScreen extends StatefulWidget {
  OtpScreen({Key key}) : super(key: key) {
    // if(isSetting){
    //   state = _ScreenState.setPassword1;
    // }
    // else{
    //   state = _ScreenState.authenticate;
    // }
  }
  @override
  _OtpScreenState createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen> {
  bool isLoading = true;
  _ScreenState screenState;
  bool isSetting;
  bool hasPassword;

  var outlineInputBorder =
      OutlineInputBorder(borderRadius: BorderRadius.circular(100.0));
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    init();
    autoBiometric();
  }

  init() async {
    hasPassword = await LocalPasswordApi.hasPass();
    if (hasPassword) {
      setState(() {
        isLoading = false;
        screenState = _ScreenState.authenticate;
        isSetting = false;
      });
    } else {
      setState(() {
        isLoading = false;
        screenState = _ScreenState.setPassword1;
        isSetting = true;
      });
    }
    // print('screen state: ${screenState}');
  }

  autoBiometric() async {
    try {
      // // print(screenState;
      // Future.delayed(const Duration(milliseconds: 5000));
      // print('auto biometric: ${screenState}');
      if (await LocalPasswordApi.hasPass()) {
        bool hasBiometrics = await LocalAuthApi.hasBiometrics();
        if (hasBiometrics) {
          bool isAuth = await LocalAuthApi.authenticate();
          if (isAuth == null) {
            return;
          }
          if (isAuth) {
            Navigator.pop(context);
          }
        }
      }
    } on Exception {
      return;
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<PasswordCubit, PasswordState>(
      listener: (context, state) {
        if (state == PasswordState.firstPasswordSet) {
          setState(() {
            screenState = _ScreenState.setPassword2;
          });
        }
        if (state == PasswordState.passwordNotMatch) {
          setState(() {
            screenState = _ScreenState.passwordMissMatch;
          });
        }
        if (state == PasswordState.passWordSetSuccess) {
          Navigator.pop(context);
        }

        if (state == PasswordState.passWordRight) {
          Future.delayed(const Duration(milliseconds: 200), () {
            Navigator.pop(context);
          });
        }

        if (state == PasswordState.passWordWrong) {
          if (screenState == _ScreenState.authenticate) {
            Future.delayed(const Duration(milliseconds: 200), () {
              Provider.of<PasswordCubit>(context, listen: false).clear();
            });
          }
        }
      },
      child: Scaffold(
        backgroundColor: AppColors.white,
        body: isLoading
            ? Container()
            : SafeArea(
                child: Column(
                  children: <Widget>[
                    if (screenState == _ScreenState.setPassword2)
                      buildExitButton(),
                    buildMarketSpaceImage(),
                    Container(
                      height: 120,
                      alignment: Alignment(0, 0.5),
                      padding: EdgeInsets.symmetric(horizontal: 16.0),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          buildSecurityText(),
                          SizedBox(
                            height: 16,
                          ),
                          buildPinRow(),
                          SizedBox(
                            height: 16,
                          ),
                          if (screenState == _ScreenState.passwordMissMatch)
                            buildNotifyText(),
                        ],
                      ),
                    ),
                    buildNumberPad(),
                    if (isSetting)
                      Button(
                        onPressed: () => {
                          Provider.of<PasswordCubit>(context, listen: false)
                              .confirmPin()
                        },
                      ),
                  ],
                ),
              ),
      ),
    );
  }

  buildExitButton() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.all(6.0),
          child: MaterialButton(
            onPressed: () {
              Provider.of<PasswordCubit>(context, listen: false).goBack();
              setState(() {
                screenState = _ScreenState.setPassword1;
              });
            },
            height: 20.0,
            minWidth: 20.0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.zero,
            ),
            child: Icon(
              Icons.arrow_back_sharp,
              color: AppColors.app_orange,
            ),
          ),
        )
      ],
    );
  }

  buildMarketSpaceImage() {
    return Container(
      padding: EdgeInsets.only(top: SizeConfig.heightMultiplier * 0.5),
      child: Image.asset(
        'assets/mkt_space_logo.png',
        width: 170,
      ),
    );
  }

  buildNotifyText() {
    return Text(
      "pin mismatch please enter again",
      style: TextStyle(
        color: Colors.red,
        fontSize: 13.0,
        fontWeight: FontWeight.bold,
      ),
    );
  }

  buildSecurityText() {
    return Text(
      screenState.getInstruction(),
      style: TextStyle(
        color: Colors.black,
        fontSize: 13.0,
        fontWeight: FontWeight.bold,
      ),
    );
  }

  buildPinRow() {
    return Row(
      // mainAxisAlignment: MainAxisAlignment,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        PINNumber(
          outlineInputBorder: outlineInputBorder,
          index: 1,
        ),
        PINNumber(
          outlineInputBorder: outlineInputBorder,
          index: 2,
        ),
        PINNumber(
          outlineInputBorder: outlineInputBorder,
          index: 3,
        ),
        PINNumber(
          outlineInputBorder: outlineInputBorder,
          index: 4,
        ),
      ],
    );
  }

  buildNumberPad() {
    return Expanded(
      child: Container(
        alignment: Alignment.bottomCenter,
        child: Padding(
          padding: const EdgeInsets.only(bottom: 20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  KeyBoardNumber(
                    n: 1,
                  ),
                  KeyBoardNumber(
                    n: 2,
                  ),
                  KeyBoardNumber(
                    n: 3,
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  KeyBoardNumber(
                    n: 4,
                  ),
                  KeyBoardNumber(
                    n: 5,
                  ),
                  KeyBoardNumber(
                    n: 6,
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  KeyBoardNumber(
                    n: 7,
                  ),
                  KeyBoardNumber(
                    n: 8,
                  ),
                  KeyBoardNumber(
                    n: 9,
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  if (!isSetting)
                    Container(
                      height: 60,
                      width: 60,
                      child: MaterialButton(
                        padding: EdgeInsets.all(8),
                        onPressed: () {
                          SmsAuthApi.sendSms(
                              (verificationId) => {
                                    ForgotPasswordOtpBloc.verificationId =
                                        verificationId
                                  },
                              "+61403208237");
                          ForgotPassOtpRoute.isForget = true;
                          ForgotPassOtpRoute.isForgetPIN = true;
                          NavigationApi.navigateTo("toOTPScreen");
                        },
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(60.0)),
                        height: 90,
                        child: Text(
                          "Forgot?",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: AppColors.bitcoin_orange,
                            fontWeight: FontWeight.w400,
                            fontSize:
                                MediaQuery.of(context).textScaleFactor * 12,
                          ),
                        ),
                      ),
                    ),
                  if (isSetting)
                    Container(
                      width: 60,
                      height: 60,
                    ),
                  KeyBoardNumber(
                    n: 0,
                  ),
                  if (isSetting)
                    Container(
                      height: 60,
                      width: 60,
                      child: MaterialButton(
                        padding: EdgeInsets.all(8),
                        onPressed: () {
                          Provider.of<PasswordCubit>(context, listen: false)
                              .deletePin();
                        },
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(60.0)),
                        height: 90,
                        child: Icon(
                          Icons.backspace_outlined,
                          color: AppColors.app_orange,
                        ),
                      ),
                    ),
                  if (!isSetting) BioBoard(),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class KeyBoardNumber extends StatelessWidget {
  final int n;
  final Function onPressed;

  const KeyBoardNumber({Key key, this.n, this.onPressed}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 60,
      height: 60,
      alignment: Alignment.center,
      child: MaterialButton(
        padding: EdgeInsets.all(8),
        onPressed: () {
          Provider.of<PasswordCubit>(context, listen: false)
              .setPin(n.toString());
          // Navigator.pop(context);
        },
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(60.0)),
        height: 90,
        child: Text(
          "$n",
          textAlign: TextAlign.center,
          style: TextStyle(
            color: AppColors.bitcoin_orange,
            fontWeight: FontWeight.bold,
            fontSize: MediaQuery.of(context).textScaleFactor * 26,
          ),
        ),
      ),
    );
  }
}

class Button extends StatelessWidget {
  final Function() onPressed;

  const Button({Key key, this.onPressed}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        height: 50,
        margin: EdgeInsets.only(left: 20, right: 20, bottom: 30),
        decoration: BoxDecoration(
            // border: Border.all(color: AppColors.appBlue),
            borderRadius: BorderRadius.circular(10),
            gradient: LinearGradient(colors: [
              AppColors.gradient_button_light,
              AppColors.gradient_button_dark
            ])),
        child: Align(
          alignment: Alignment.center,
          child: Builder(builder: (BuildContext context) {
            return Container(
              child: Text(
                "Confirm",
                style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 0.5,
                    color: Colors.white),
              ),
            );
          }),
        ),
      ),
    );
  }
}

class ValueHandler {
  final String handlerName;
  bool isLocked = false;

  ValueHandler(this.handlerName);
}

class TestWidget extends StatefulWidget {
  @override
  _State createState() => _State();
}

class _State extends State<TestWidget> {
  String _chars =
      'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1234567890';
  Random _rdn = Random();
  Queue<String> numberQue = new Queue<String>();

  var ref = FirebaseFirestore.instance.collection("channels").doc("channel1");

  Future<void> addValue(String value) async {
    await Future.delayed(Duration(seconds: 5));
    numberQue.add(value);
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      body: Center(
          child: Column(
        children: [
          Container(
            height: 200,
          ),
          StreamBuilder<DocumentSnapshot>(
              stream: ref.snapshots(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return Text("lalala");
                }
                return Text("heiheihei");
              }),
          Container(
              margin: EdgeInsets.all(5),
              child: FlatButton(
                onPressed: () {
                  // ref.update({
                  //   "document": getRandomString(5)
                  // });
                  Navigator.pop(context);
                },
                child: Text("lalala"),
                color: Colors.blueAccent,
                textColor: Colors.white,
              )),
        ],
      )),
    );
  }

  String getRandomString(int length) => String.fromCharCodes(Iterable.generate(
      length, (_) => _chars.codeUnitAt(_rdn.nextInt(_chars.length))));
}
