import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:market_space/common/colors.dart';
import 'package:market_space/common/constants.dart';
import 'package:market_space/common/loading_progress.dart';
import 'package:market_space/common/toolbar.dart';
import 'package:market_space/login/login_route.dart';
import 'package:market_space/main.dart';
import 'package:market_space/model/address_model/address_model.dart';
import 'package:market_space/model/profile_settings/notification_settings_model.dart';
import 'package:market_space/order_checkout/model/update_address_model/update_address_model.dart';
import 'package:market_space/profile_settings/editEmail/edit_email_route.dart';
import 'package:market_space/profile_settings/profile_setting_bloc.dart';
import 'package:market_space/profile_settings/profile_setting_l10n.dart';
import 'package:market_space/profile_settings/profile_setting_route.dart';
import 'package:market_space/profile_settings/receiving_payment/receiving_payment_route.dart';
import 'package:market_space/profile_settings/seller_sending_payments/add_new_sending_payment/add_new_sending_route.dart';
import 'package:market_space/profile_settings/update_password/update_password_route.dart';
import 'package:market_space/repositories/auth/auth_repository.dart';
import 'package:market_space/services/RouterServices.dart';
import 'package:market_space/responsive_layout/size_config.dart';

import 'add_new_address/add_new_address_route.dart';
import 'help_center/help_center_route.dart';

class ProfileSettingScreen extends StatefulWidget {
  @override
  _ProfileSettingScreenState createState() => _ProfileSettingScreenState();
}

class _ProfileSettingScreenState extends State<ProfileSettingScreen> {
  final ProfileSettingBloc _profileSettingBloc = ProfileSettingBloc(Initial());
  ProfileSettingL10n _l10n = ProfileSettingL10n(
      Locale.fromSubtags(languageCode: 'en', countryCode: 'US'));

  bool _isLoading = false;
  bool _logoutLoading = false;
  bool _addressLoading = false;
  final TextEditingController _passwordController = TextEditingController();

  final TextEditingController _emailController = TextEditingController();
  bool _expandEmail = false;
  bool _expandAddress = false;
  bool _receivingPay = false;
  bool _sendingPay = false;
  List<UpdateAddressModel> addressList = List();
  String _emailText;
  AuthRepository _authRepository = AuthRepository();
  var router;
  bool _messagesSwitch = false;
  bool _soldItemSwitch = false;
  bool _feedbackReceivedSwitch = false;
  bool _orderSwitch = false;
  bool _investmentSwitch = false;
  bool _promotionSwitch = false;
  bool _notificationExpand = false;
  bool _currencyExpanded = false;

  final TextEditingController _cryptoCurrencyController =
      TextEditingController();
  final TextEditingController _prefferedCurrencyController =
      TextEditingController();

  final _actionKey = GlobalKey<ScaffoldState>();
  final _prefferedCurrencyKey = GlobalKey<ScaffoldState>();
  OverlayEntry _overlayEntry;
  List<String> _prefferedCurrency = [
    "Australian Dollar",
    "Chinese Yuan",
  ];

  List<String> _cryptoCurrency = ["Bitcoin", "Ethereum", "USDC"];

  @override
  void initState() {
    setState(() {
      _getEmail();
    });
    _profileSettingBloc.add(ProfileSettingScreenEvent());
    _profileSettingBloc.add(ViewAddressesEvent());
    setState(() {
      if (Constants.language == null || Constants.language == "English") {
        _l10n = ProfileSettingL10n(
            Locale.fromSubtags(languageCode: 'en', countryCode: 'US'));
      } else {
        _l10n = ProfileSettingL10n(Locale.fromSubtags(languageCode: 'zh'));
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: Toolbar(
        title: _l10n.profileSettings,
      ),
      backgroundColor: AppColors.toolbarBlue,
      // key: _globalKey,
      bottomNavigationBar: _bottomButtons(),
      resizeToAvoidBottomInset: false,
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        color: AppColors.white,
        child: BlocProvider(
          create: (_) => _profileSettingBloc,
          child: BlocListener<ProfileSettingBloc, ProfileSettingState>(
              listener: (context, state) {
                // if (state is Loading) {
                //   setState(() {
                //     _isLoading = true;
                //   });
                // }
                if (state is Loaded) {
                  setState(() {
                    _soldItemSwitch =
                        _profileSettingBloc.notificationSettingStatus.soldItems;

                    _messagesSwitch =
                        _profileSettingBloc.notificationSettingStatus.messages;

                    _feedbackReceivedSwitch = _profileSettingBloc
                        .notificationSettingStatus.feedbacksReceived;

                    _investmentSwitch = _profileSettingBloc
                        .notificationSettingStatus.investmentUpdates;

                    _orderSwitch = _profileSettingBloc
                        .notificationSettingStatus.orderUpdates;

                    _promotionSwitch = _profileSettingBloc
                        .notificationSettingStatus.promotions;
                    _isLoading = false;
                  });
                }
                if (state is LogoutSuccessfully) {
                  RouterService.appRouter.navigateTo(LogInRoute.buildPath());
                }

                if (state is AddressLoadedSuccessfully) {
                  setState(() {
                    _addressLoading = false;
                    addressList = _profileSettingBloc.addressList;
                  });
                }

                if (state is NotificationSettingsUpdated) {
                  _showToast("Settings updated");
                }
                if (state is NotificationSettingsUpdationFailed) {
                  _showToast("Settings updating failed");
                }

                if (state is CurrencyUpdatedSuccessfully) {
                  _showToast('Currencies updated');
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
        child: Stack(
          children: [
            if (_isLoading)
              BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 0.8, sigmaY: 0.8),
                  child: LoadingProgress(
                    color: Colors.deepOrangeAccent,
                  )),
            ListView(
                shrinkWrap: true,
                physics: BouncingScrollPhysics(),
                children: [
                  Container(
                    margin: EdgeInsets.only(
                        left: SizeConfig.widthMultiplier * 2.9166666666666665,
                        top: SizeConfig.heightMultiplier * 2.5107604017216643),
                    child: ListTile(
                        title: Column(
                      children: [
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              if (_expandEmail) {
                                _expandEmail = false;
                              } else
                                _expandEmail = true;
                            });
                          },
                          child: Row(
                            children: [
                              Text(
                                _l10n.emailAndPass,
                                style: GoogleFonts.inter(
                                    fontWeight: FontWeight.w400,
                                    fontSize: SizeConfig.textMultiplier *
                                        2.0086083213773316,
                                    letterSpacing: 0.5,
                                    color: AppColors.catTextColor),
                              ),
                              Container(
                                margin: EdgeInsets.only(
                                    left: SizeConfig.widthMultiplier *
                                        1.9444444444444442),
                                child: _expandEmail
                                    ? Image.asset(
                                        'assets/images/chevron_bottom.png',
                                        height: SizeConfig.heightMultiplier *
                                            0.6276901004304161,
                                        width: SizeConfig.widthMultiplier *
                                            1.9444444444444442,
                                      )
                                    : Image.asset(
                                        'assets/images/chevron_right.png',
                                        height: SizeConfig.heightMultiplier *
                                            1.0043041606886658,
                                        width: SizeConfig.widthMultiplier *
                                            1.2152777777777777,
                                      ),
                              )
                            ],
                          ),
                        ),
                        if (_expandEmail) _email(),
                        if (_expandEmail) _password(),
                        Container(
                          margin: EdgeInsets.only(
                              top: SizeConfig.heightMultiplier *
                                  2.0086083213773316),
                          height:
                              SizeConfig.heightMultiplier * 0.12553802008608322,
                          decoration:
                              BoxDecoration(color: AppColors.list_separator),
                        )
                      ],
                    )),
                  ),
                  Container(
                    margin: EdgeInsets.only(
                        left: SizeConfig.widthMultiplier * 2.9166666666666665,
                        top: SizeConfig.heightMultiplier * 2.0086083213773316),
                    child: ListTile(
                        title: Column(
                      children: [
                        GestureDetector(
                            onTap: () {
                              setState(() {
                                if (_expandAddress) {
                                  _expandAddress = false;
                                } else
                                  _expandAddress = true;
                              });
                            },
                            child: Row(
                              children: [
                                Text(
                                  _l10n.Address,
                                  style: GoogleFonts.inter(
                                      fontWeight: FontWeight.w400,
                                      fontSize: SizeConfig.textMultiplier *
                                          2.0086083213773316,
                                      letterSpacing: 0.5,
                                      color: AppColors.catTextColor),
                                ),
                                Container(
                                  margin: EdgeInsets.only(
                                      left: SizeConfig.widthMultiplier *
                                          1.9444444444444442),
                                  child: _expandAddress
                                      ? Image.asset(
                                          'assets/images/chevron_bottom.png',
                                          height: SizeConfig.heightMultiplier *
                                              0.6276901004304161,
                                          width: SizeConfig.widthMultiplier *
                                              1.9444444444444442,
                                        )
                                      : Image.asset(
                                          'assets/images/chevron_right.png',
                                          height: SizeConfig.heightMultiplier *
                                              1.0043041606886658,
                                          width: SizeConfig.widthMultiplier *
                                              1.2152777777777777,
                                        ),
                                )
                              ],
                            )),
                        if (_expandAddress)
                          _address(
                              addressList?.length != 0 ? addressList[0] : null),
                        if (addressList.length > 1 && _expandAddress)
                          _secondaryAddress(addressList[1]),
                        if (_expandAddress)
                          GestureDetector(
                            onTap: () {
//                                  if (ProfileSettingRoute.updateAddressModel.addressNum == 0 ||
//                                      ProfileSettingRoute.updateAddressModel.addressNum == 1 ||
//                                      ProfileSettingRoute.updateAddressModel.addressNum == 2){
//                                    var addressNum = ProfileSettingRoute.updateAddressModel.addressNum;
//                                    var firstName = ProfileSettingRoute.updateAddressModel.firstName;
//                                    var lastName = ProfileSettingRoute.
//                                    ProfileSettingRoute.updateAddressModel = null;
//                                    ProfileSettingRoute.updateAddressModel.addressNum = address_num;
//                                  }
//
//                                  else {
                              ProfileSettingRoute.updateAddressModel = null;
//                                  }

                              RouterService.appRouter
                                  .navigateTo(AddNewAddressRoute.buildPath());
                            },
                            child: Container(
                                margin: EdgeInsets.only(
                                    top: SizeConfig.heightMultiplier *
                                        2.0086083213773316),
                                height: SizeConfig.heightMultiplier *
                                    6.276901004304161,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    border:
                                        Border.all(color: AppColors.appBlue)),
                                child: Row(
                                  children: [
                                    Container(
                                      width: SizeConfig.widthMultiplier *
                                          5.833333333333333,
                                      height: SizeConfig.heightMultiplier *
                                          3.0129124820659974,
                                      margin: EdgeInsets.only(
                                          top: SizeConfig.heightMultiplier *
                                              1.2553802008608321,
                                          left: SizeConfig.widthMultiplier *
                                              3.645833333333333,
                                          bottom: SizeConfig.heightMultiplier *
                                              1.2553802008608321),
                                      child: Icon(
                                        Icons.add,
                                        color: AppColors.appBlue,
                                        size: 14,
                                      ),
                                    ),
                                    Container(
                                        margin: EdgeInsets.only(
                                            top: SizeConfig.heightMultiplier *
                                                1.5064562410329987,
                                            left: SizeConfig.widthMultiplier *
                                                2.6736111111111107,
                                            bottom:
                                                SizeConfig.heightMultiplier *
                                                    1.5064562410329987),
                                        child: Text(
                                          _l10n.AddNewAddress,
                                          style: GoogleFonts.inter(
                                              fontSize:
                                                  SizeConfig.textMultiplier *
                                                      1.757532281205165,
                                              fontWeight: FontWeight.w400,
                                              color: AppColors.appBlue,
                                              letterSpacing: 0.25,
                                              textStyle: TextStyle(
                                                  fontFamily: 'Roboto')),
                                        )),
                                  ],
                                )),
                          ),
                        Container(
                          margin: EdgeInsets.only(
                              top: SizeConfig.heightMultiplier *
                                  2.0086083213773316),
                          height:
                              SizeConfig.heightMultiplier * 0.12553802008608322,
                          decoration:
                              BoxDecoration(color: AppColors.list_separator),
                        )
                      ],
                    )),
                  ),
                  Container(
                    margin: EdgeInsets.only(
                        left: SizeConfig.widthMultiplier * 2.9166666666666665,
                        top: SizeConfig.heightMultiplier * 2.0086083213773316),
                    child: ListTile(
                        title: Column(
                      children: [
                        GestureDetector(
                            onTap: () {
                              setState(() {
                                RouterService.appRouter
                                    .navigateTo(AddNewSendingRoute.buildPath());
                              });
                            },
                            child: Row(
                              children: [
                                Text(
                                  _l10n.sendingPayment,
                                  style: GoogleFonts.inter(
                                      fontWeight: FontWeight.w400,
                                      fontSize: SizeConfig.textMultiplier *
                                          2.0086083213773316,
                                      letterSpacing: 0.5,
                                      color: AppColors.catTextColor),
                                ),
                                Container(
                                  margin: EdgeInsets.only(
                                      left: SizeConfig.widthMultiplier *
                                          1.9444444444444442),
                                  child: Image.asset(
                                    'assets/images/chevron_right.png',
                                    height: SizeConfig.heightMultiplier *
                                        1.0043041606886658,
                                    width: SizeConfig.widthMultiplier *
                                        1.2152777777777777,
                                  ),
                                )
                              ],
                            )),
                        Container(
                          margin: EdgeInsets.only(
                              top: SizeConfig.heightMultiplier *
                                  2.0086083213773316),
                          height:
                              SizeConfig.heightMultiplier * 0.12553802008608322,
                          decoration:
                              BoxDecoration(color: AppColors.list_separator),
                        )
                      ],
                    )),
                  ),
                  Container(
                    margin: EdgeInsets.only(
                        left: SizeConfig.widthMultiplier * 2.9166666666666665,
                        top: SizeConfig.heightMultiplier * 2.0086083213773316),
                    child: ListTile(
                        title: Column(
                      children: [
                        GestureDetector(
                            onTap: () {
                              setState(() {
                                // ReceivingPaymentRoute.isReceive = true;
                                RouterService.appRouter.navigateTo(
                                    ReceivingPaymentRoute.buildPath());
                              });
                            },
                            child: Row(
                              children: [
                                Text(
                                  _l10n.receivingPayment,
                                  style: GoogleFonts.inter(
                                      fontWeight: FontWeight.w400,
                                      fontSize: SizeConfig.textMultiplier *
                                          2.0086083213773316,
                                      letterSpacing: 0.5,
                                      color: AppColors.catTextColor),
                                ),
                                Container(
                                  margin: EdgeInsets.only(
                                      left: SizeConfig.widthMultiplier *
                                          1.9444444444444442),
                                  child: Image.asset(
                                    'assets/images/chevron_right.png',
                                    height: SizeConfig.heightMultiplier *
                                        1.0043041606886658,
                                    width: SizeConfig.widthMultiplier *
                                        1.2152777777777777,
                                  ),
                                )
                              ],
                            )),
                        // if (_receivingPay) _receivingPayment(),
                        Container(
                          margin: EdgeInsets.only(
                              top: SizeConfig.heightMultiplier *
                                  2.0086083213773316),
                          height:
                              SizeConfig.heightMultiplier * 0.12553802008608322,
                          decoration:
                              BoxDecoration(color: AppColors.list_separator),
                        )
                      ],
                    )),
                  ),
                  // GestureDetector(
                  //   onTap: () {
                  //     setState(() {
                  //       if (_notificationExpand) {
                  //         _notificationExpand = false;
                  //       } else {
                  //         _notificationExpand = true;
                  //       }
                  //     });
                  //   },
                  //   child: Container(
                  //     margin: EdgeInsets.only(
                  //         left: SizeConfig.widthMultiplier * 2.9166666666666665,
                  //         top:
                  //             SizeConfig.heightMultiplier * 2.0086083213773316),
                  //     child: ListTile(
                  //         title: Column(
                  //       children: [
                  //         Row(
                  //           children: [
                  //             Text(
                  //               _l10n.notifications,
                  //               style: GoogleFonts.inter(
                  //                   fontWeight: FontWeight.w400,
                  //                   fontSize: SizeConfig.textMultiplier *
                  //                       2.0086083213773316,
                  //                   letterSpacing: 0.5,
                  //                   color: AppColors.catTextColor),
                  //             ),
                  //             Container(
                  //               margin: EdgeInsets.only(
                  //                   left: SizeConfig.widthMultiplier *
                  //                       1.9444444444444442,
                  //                   top: SizeConfig.heightMultiplier *
                  //                       0.37661406025824967),
                  //               child: _notificationExpand
                  //                   ? Image.asset(
                  //                       'assets/images/chevron_bottom.png',
                  //                       height: SizeConfig.heightMultiplier *
                  //                           0.6276901004304161,
                  //                       width: SizeConfig.widthMultiplier *
                  //                           1.9444444444444442,
                  //                     )
                  //                   : Image.asset(
                  //                       'assets/images/chevron_right.png',
                  //                       height: SizeConfig.heightMultiplier *
                  //                           1.0043041606886658,
                  //                       width: SizeConfig.widthMultiplier *
                  //                           1.2152777777777777,
                  //                     ),
                  //             )
                  //           ],
                  //         ),
                  //         if (_notificationExpand) _notificationSwitches(),
                  //         Container(
                  //           margin: EdgeInsets.only(
                  //               top: SizeConfig.heightMultiplier *
                  //                   2.0086083213773316),
                  //           height: SizeConfig.heightMultiplier *
                  //               0.12553802008608322,
                  //           decoration:
                  //               BoxDecoration(color: AppColors.list_separator),
                  //         )
                  //       ],
                  //     )),
                  //   ),
                  // ),
                  // Container(
                  //   margin: EdgeInsets.only(
                  //       left: SizeConfig.widthMultiplier * 2.9166666666666665,
                  //       top: SizeConfig.heightMultiplier * 2.0086083213773316),
                  //   child: ListTile(
                  //       title: Column(
                  //     children: [
                  //       Row(
                  //         children: [
                  //           Text(
                  //             _l10n.privacy,
                  //             style: GoogleFonts.inter(
                  //                 fontWeight: FontWeight.w400,
                  //                 fontSize: SizeConfig.textMultiplier *
                  //                     2.0086083213773316,
                  //                 letterSpacing: 0.5,
                  //                 color: AppColors.catTextColor),
                  //           ),
                  //           Container(
                  //             margin: EdgeInsets.only(
                  //                 left: SizeConfig.widthMultiplier *
                  //                     1.9444444444444442),
                  //             child: Image.asset(
                  //               'assets/images/chevron_right.png',
                  //               height: SizeConfig.heightMultiplier *
                  //                   1.0043041606886658,
                  //               width: SizeConfig.widthMultiplier *
                  //                   1.2152777777777777,
                  //             ),
                  //           )
                  //         ],
                  //       ),
                  //       Container(
                  //         margin: EdgeInsets.only(
                  //             top: SizeConfig.heightMultiplier *
                  //                 2.0086083213773316),
                  //         height:
                  //             SizeConfig.heightMultiplier * 0.12553802008608322,
                  //         decoration:
                  //             BoxDecoration(color: AppColors.list_separator),
                  //       )
                  //     ],
                  //   )),
                  // ),
                  // GestureDetector(
                  //     onTap: () {
                  //       setState(() {
                  //         if (_currencyExpanded) {
                  //           _currencyExpanded = false;
                  //         } else {
                  //           _currencyExpanded = true;
                  //         }
                  //       });
                  //     },
                  //     child: Container(
                  //       margin: EdgeInsets.only(
                  //           left:
                  //               SizeConfig.widthMultiplier * 2.9166666666666665,
                  //           top: SizeConfig.heightMultiplier *
                  //               2.0086083213773316),
                  //       child: ListTile(
                  //           title: Column(
                  //         children: [
                  //           Row(
                  //             children: [
                  //               Text(
                  //                 _l10n.updateCurrencies,
                  //                 style: GoogleFonts.inter(
                  //                     fontWeight: FontWeight.w400,
                  //                     fontSize: SizeConfig.textMultiplier *
                  //                         2.0086083213773316,
                  //                     letterSpacing: 0.5,
                  //                     color: AppColors.catTextColor),
                  //               ),
                  //               Container(
                  //                 margin: EdgeInsets.only(
                  //                     left: SizeConfig.widthMultiplier *
                  //                         1.9444444444444442),
                  //                 child: _currencyExpanded
                  //                     ? Image.asset(
                  //                         'assets/images/chevron_bottom.png',
                  //                         height: SizeConfig.heightMultiplier *
                  //                             0.6276901004304161,
                  //                         width: SizeConfig.widthMultiplier *
                  //                             1.9444444444444442,
                  //                       )
                  //                     : Image.asset(
                  //                         'assets/images/chevron_right.png',
                  //                         height: SizeConfig.heightMultiplier *
                  //                             1.0043041606886658,
                  //                         width: SizeConfig.widthMultiplier *
                  //                             1.2152777777777777,
                  //                       ),
                  //               )
                  //             ],
                  //           ),
                  //           if (_currencyExpanded) _currencyListContainer(),
                  //           Container(
                  //             margin: EdgeInsets.only(
                  //                 top: SizeConfig.heightMultiplier *
                  //                     2.0086083213773316),
                  //             height: SizeConfig.heightMultiplier *
                  //                 0.12553802008608322,
                  //             decoration: BoxDecoration(
                  //                 color: AppColors.list_separator),
                  //           )
                  //         ],
                  //       )),
                  //     )),
                  // Container(
                  //   margin: EdgeInsets.only(
                  //       left: SizeConfig.widthMultiplier * 2.9166666666666665,
                  //       top: SizeConfig.heightMultiplier * 2.0086083213773316),
                  //   child: GestureDetector(
                  //     onTap: () => RouterService.appRouter
                  //         .navigateTo(HelpCenterRoute.buildPath()),
                  //     child: ListTile(
                  //         title: Column(
                  //       children: [
                  //         Row(
                  //           children: [
                  //             Text(
                  //               _l10n.helpCenter,
                  //               style: GoogleFonts.inter(
                  //                   fontWeight: FontWeight.w400,
                  //                   fontSize: SizeConfig.textMultiplier *
                  //                       2.0086083213773316,
                  //                   letterSpacing: 0.5,
                  //                   color: AppColors.catTextColor),
                  //             ),
                  //           ],
                  //         ),
                  //         Container(
                  //           margin: EdgeInsets.only(
                  //               top: SizeConfig.heightMultiplier *
                  //                   2.0086083213773316),
                  //           height: SizeConfig.heightMultiplier *
                  //               0.12553802008608322,
                  //           decoration:
                  //               BoxDecoration(color: AppColors.list_separator),
                  //         )
                  //       ],
                  //     )),
                  //   ),
                  // ),
                ]),
          ],
        ),
      ),
    );
  }

  Widget _email() {
    return Container(
      margin: EdgeInsets.only(
          top: SizeConfig.heightMultiplier * 1.5064562410329987),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(
          children: [
            Text(_l10n.email,
                style: GoogleFonts.inter(
                    fontSize: SizeConfig.textMultiplier * 1.2553802008608321,
                    fontWeight: FontWeight.w400,
                    color: AppColors.text_field_container)),
            Spacer(),
            GestureDetector(
              onTap: () {
                setState(() {
                  Navigator.pushNamed(context, EditEmailRoute.buildPath())
                      .then((value) => {
                            if (value != null)
                              {
                                setState(() {
                                  _emailText = value;
                                  // print(value);
                                })
                              }
                          });
                });
              },
              child: Container(
                height: SizeConfig.heightMultiplier * 2.5107604017216643,
                alignment: Alignment.center,
                margin: EdgeInsets.only(
                  right: SizeConfig.widthMultiplier * 3.8888888888888884,
                ),
                padding: EdgeInsets.only(
                    left: SizeConfig.widthMultiplier * 1.9444444444444442,
                    right: SizeConfig.widthMultiplier * 1.9444444444444442,
                    top: SizeConfig.heightMultiplier * 0.25107604017216645,
                    bottom: SizeConfig.heightMultiplier * 0.25107604017216645),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                        color: AppColors.seeAllText,
                        width:
                            SizeConfig.widthMultiplier * 0.24305555555555552),
                    color: AppColors.seeAllBack),
                child: Text(
                  _l10n.edit,
                  style: TextStyle(
                    color: AppColors.seeAllText,
                    fontSize: SizeConfig.textMultiplier * 1.2553802008608321,
                  ),
                ),
              ),
            ),
          ],
        ),
        Text(_emailText == null ? 'Example@example.com' : _emailText,
            style: GoogleFonts.inter(
                fontSize: SizeConfig.textMultiplier * 1.757532281205165,
                fontWeight: FontWeight.w700,
                letterSpacing: 0.1,
                color: AppColors.app_txt_color)),
      ]),
    );
  }

  Widget _password() {
    return Container(
      margin: EdgeInsets.only(
          top: SizeConfig.heightMultiplier * 1.5064562410329987),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(
          children: [
            Text(_l10n.password,
                style: GoogleFonts.inter(
                    fontSize: SizeConfig.textMultiplier * 1.2553802008608321,
                    fontWeight: FontWeight.w400,
                    color: AppColors.text_field_container)),
            Spacer(),
            GestureDetector(
              onTap: () {
                RouterService.appRouter
                    .navigateTo(UpdatePasswordRoute.buildPath());
              },
              child: Container(
                height: SizeConfig.heightMultiplier * 2.5107604017216643,
                alignment: Alignment.center,
                margin: EdgeInsets.only(
                  right: SizeConfig.widthMultiplier * 3.8888888888888884,
                ),
                padding: EdgeInsets.only(
                    left: SizeConfig.widthMultiplier * 1.9444444444444442,
                    right: SizeConfig.widthMultiplier * 1.9444444444444442,
                    top: SizeConfig.heightMultiplier * 0.25107604017216645,
                    bottom: SizeConfig.heightMultiplier * 0.25107604017216645),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                        color: AppColors.seeAllText,
                        width:
                            SizeConfig.widthMultiplier * 0.24305555555555552),
                    color: AppColors.seeAllBack),
                child: Text(
                  _l10n.edit,
                  style: TextStyle(
                    color: AppColors.seeAllText,
                    fontSize: SizeConfig.textMultiplier * 1.2553802008608321,
                  ),
                ),
              ),
            ),
          ],
        ),
        Text('*******************',
            style: GoogleFonts.inter(
                fontSize: SizeConfig.textMultiplier * 1.757532281205165,
                fontWeight: FontWeight.w700,
                letterSpacing: 0.1,
                color: AppColors.app_txt_color)),
      ]),
    );
  }

  Widget _address(UpdateAddressModel addresses) {
    return _addressLoading
        ? Container(
            child: Lottie.asset('assets/loader/list_loader.json'),
          )
        : Container(
            margin: EdgeInsets.only(
                top: SizeConfig.heightMultiplier * 1.5064562410329987),
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Row(
                children: [
                  Text(_l10n.primary,
                      style: GoogleFonts.inter(
                          fontSize:
                              SizeConfig.textMultiplier * 1.2553802008608321,
                          fontWeight: FontWeight.w400,
                          color: AppColors.text_field_container)),
                  Spacer(),
                  GestureDetector(
                    onTap: () {
                      UpdateAddressModel updateModel = UpdateAddressModel();
                      updateModel.streetAddress = addresses.streetAddress;
                      updateModel.streetAddressTwo = addresses.suburb;
                      updateModel.phoneNumber = addresses.phoneNumber;
                      updateModel.country = addresses.country;
                      updateModel.state = addresses.state;
                      updateModel.instructions = addresses.instructions;
                      updateModel.postcode = addresses.postcode.toString();
                      updateModel.addressNum = addresses.addressNum;
                      updateModel.suburb = addresses.suburb;
                      ProfileSettingRoute.updateAddressModel = updateModel;
                      RouterService.appRouter
                          .navigateTo(AddNewAddressRoute.buildPath());
                    },
                    child: Container(
                      height: SizeConfig.heightMultiplier * 2.5107604017216643,
                      alignment: Alignment.center,
                      margin: EdgeInsets.only(
                        right: SizeConfig.widthMultiplier * 1.9444444444444442,
                      ),
                      padding: EdgeInsets.only(
                          left: SizeConfig.widthMultiplier * 1.9444444444444442,
                          right:
                              SizeConfig.widthMultiplier * 1.9444444444444442,
                          top:
                              SizeConfig.heightMultiplier * 0.25107604017216645,
                          bottom: SizeConfig.heightMultiplier *
                              0.25107604017216645),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(
                              color: AppColors.seeAllText,
                              width: SizeConfig.widthMultiplier *
                                  0.24305555555555552),
                          color: AppColors.seeAllBack),
                      child: Text(
                        _l10n.edit,
                        style: TextStyle(
                          color: AppColors.seeAllText,
                          fontSize:
                              SizeConfig.textMultiplier * 1.2553802008608321,
                        ),
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {},
                    child: Container(
                      height: SizeConfig.heightMultiplier * 2.5107604017216643,
                      alignment: Alignment.center,
                      margin: EdgeInsets.only(
                        right: SizeConfig.widthMultiplier * 3.8888888888888884,
                      ),
                      padding: EdgeInsets.only(
                          left: SizeConfig.widthMultiplier * 1.9444444444444442,
                          right:
                              SizeConfig.widthMultiplier * 1.9444444444444442,
                          top:
                              SizeConfig.heightMultiplier * 0.25107604017216645,
                          bottom: SizeConfig.heightMultiplier *
                              0.25107604017216645),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(
                              color: AppColors.cancel_red,
                              width: SizeConfig.widthMultiplier *
                                  0.24305555555555552),
                          color: AppColors.remove_red),
                      child: Text(
                        _l10n.remove,
                        style: TextStyle(
                          color: AppColors.cancel_red,
                          fontSize:
                              SizeConfig.textMultiplier * 1.2553802008608321,
                        ),
                      ),
                    ),
                  ),
                ],
              ),

              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (addresses?.streetAddress != null)
                    Text(addresses?.streetAddress,
                        style: GoogleFonts.inter(
                            fontSize:
                                SizeConfig.textMultiplier * 1.757532281205165,
                            fontWeight: FontWeight.w400,
                            letterSpacing: 0.25,
                            color: AppColors.app_txt_color)),
                  if (addresses?.suburb != null)
                    Text(addresses?.suburb,
                        style: GoogleFonts.inter(
                            fontSize:
                                SizeConfig.textMultiplier * 1.757532281205165,
                            fontWeight: FontWeight.w400,
                            letterSpacing: 0.25,
                            color: AppColors.app_txt_color)),
                  if (addresses?.state != null)
                    Text(addresses?.state,
                        style: GoogleFonts.inter(
                            fontSize:
                                SizeConfig.textMultiplier * 1.757532281205165,
                            fontWeight: FontWeight.w400,
                            letterSpacing: 0.25,
                            color: AppColors.app_txt_color)),
                  if (addresses?.country != null)
                    Text(addresses?.country,
                        style: GoogleFonts.inter(
                            fontSize:
                                SizeConfig.textMultiplier * 1.757532281205165,
                            fontWeight: FontWeight.w400,
                            letterSpacing: 0.25,
                            color: AppColors.app_txt_color)),
                  if (addresses?.postcode != null)
                    Text('${addresses?.postcode}',
                        style: GoogleFonts.inter(
                            fontSize:
                                SizeConfig.textMultiplier * 1.757532281205165,
                            fontWeight: FontWeight.w400,
                            letterSpacing: 0.25,
                            color: AppColors.app_txt_color)),
                ],
              )

              // _secondaryAddress(addressList[1]),
            ]),
          );
  }

  Widget _secondaryAddress(UpdateAddressModel addresses) {
    // print(addresses.addressNum);
    return Container(
      margin: EdgeInsets.only(
          top: SizeConfig.heightMultiplier * 1.5064562410329987),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(
          children: [
            Text(_l10n.secondary,
                style: GoogleFonts.inter(
                    fontSize: SizeConfig.textMultiplier * 1.2553802008608321,
                    fontWeight: FontWeight.w400,
                    color: AppColors.text_field_container)),
            Spacer(),
            GestureDetector(
              onTap: () {
                UpdateAddressModel updateModel = UpdateAddressModel();
                updateModel.streetAddress = addresses.streetAddress;
                updateModel.streetAddressTwo = addresses.suburb;
                updateModel.phoneNumber = addresses.phoneNumber;
                updateModel.country = addresses.country;
                updateModel.state = addresses.state;
                updateModel.addressNum = 1;
                updateModel.instructions = addresses.instructions;
                updateModel.suburb = addresses.suburb;
                updateModel.postcode = addresses.postcode.toString();
                ProfileSettingRoute.updateAddressModel = updateModel;
                RouterService.appRouter
                    .navigateTo(AddNewAddressRoute.buildPath());
              },
              child: Container(
                height: SizeConfig.heightMultiplier * 2.5107604017216643,
                alignment: Alignment.center,
                margin: EdgeInsets.only(
                  right: SizeConfig.widthMultiplier * 1.9444444444444442,
                ),
                padding: EdgeInsets.only(
                    left: SizeConfig.widthMultiplier * 1.9444444444444442,
                    right: SizeConfig.widthMultiplier * 1.9444444444444442,
                    top: SizeConfig.heightMultiplier * 0.25107604017216645,
                    bottom: SizeConfig.heightMultiplier * 0.25107604017216645),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                        color: AppColors.seeAllText,
                        width:
                            SizeConfig.widthMultiplier * 0.24305555555555552),
                    color: AppColors.seeAllBack),
                child: Text(
                  _l10n.edit,
                  style: TextStyle(
                    color: AppColors.seeAllText,
                    fontSize: SizeConfig.textMultiplier * 1.2553802008608321,
                  ),
                ),
              ),
            ),
            GestureDetector(
              onTap: () {},
              child: Container(
                height: SizeConfig.heightMultiplier * 2.5107604017216643,
                alignment: Alignment.center,
                margin: EdgeInsets.only(
                  right: SizeConfig.widthMultiplier * 3.8888888888888884,
                ),
                padding: EdgeInsets.only(
                    left: SizeConfig.widthMultiplier * 1.9444444444444442,
                    right: SizeConfig.widthMultiplier * 1.9444444444444442,
                    top: SizeConfig.heightMultiplier * 0.25107604017216645,
                    bottom: SizeConfig.heightMultiplier * 0.25107604017216645),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                        color: AppColors.cancel_red,
                        width:
                            SizeConfig.widthMultiplier * 0.24305555555555552),
                    color: AppColors.remove_red),
                child: Text(
                  _l10n.remove,
                  style: TextStyle(
                    color: AppColors.cancel_red,
                    fontSize: SizeConfig.textMultiplier * 1.2553802008608321,
                  ),
                ),
              ),
            ),
          ],
        ),
        // Text('John Doe',
        //     style: GoogleFonts.inter(
        //         fontSize: SizeConfig.textMultiplier * 1.757532281205165,
        //         fontWeight: FontWeight.w700,
        //         letterSpacing: 0.1,
        //         color: AppColors.app_txt_color)),
        if (addresses != null)
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (addresses?.streetAddress != null)
                Text(addresses?.streetAddress,
                    style: GoogleFonts.inter(
                        fontSize: SizeConfig.textMultiplier * 1.757532281205165,
                        fontWeight: FontWeight.w400,
                        letterSpacing: 0.25,
                        color: AppColors.app_txt_color)),
              if (addresses?.suburb != null)
                Text(addresses?.suburb,
                    style: GoogleFonts.inter(
                        fontSize: SizeConfig.textMultiplier * 1.757532281205165,
                        fontWeight: FontWeight.w400,
                        letterSpacing: 0.25,
                        color: AppColors.app_txt_color)),
              if (addresses?.state != null)
                Text(addresses?.state,
                    style: GoogleFonts.inter(
                        fontSize: SizeConfig.textMultiplier * 1.757532281205165,
                        fontWeight: FontWeight.w400,
                        letterSpacing: 0.25,
                        color: AppColors.app_txt_color)),
              if (addresses?.country != null)
                Text(addresses?.country,
                    style: GoogleFonts.inter(
                        fontSize: SizeConfig.textMultiplier * 1.757532281205165,
                        fontWeight: FontWeight.w400,
                        letterSpacing: 0.25,
                        color: AppColors.app_txt_color)),
              if (addresses?.postcode != null)
                Text('${addresses?.postcode}',
                    style: GoogleFonts.inter(
                        fontSize: SizeConfig.textMultiplier * 1.757532281205165,
                        fontWeight: FontWeight.w400,
                        letterSpacing: 0.25,
                        color: AppColors.app_txt_color)),
            ],
          ),
        if (addressList.length > 2)
          Container(
              margin: EdgeInsets.only(
                  top: SizeConfig.heightMultiplier * 1.5064562410329987),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (addressList[2] != null)
                    Text(addressList[2].streetAddress,
                        style: GoogleFonts.inter(
                            fontSize:
                                SizeConfig.textMultiplier * 1.757532281205165,
                            fontWeight: FontWeight.w400,
                            letterSpacing: 0.25,
                            color: AppColors.app_txt_color)),
                  if (addressList[2].suburb != null)
                    Text(addressList[2].suburb,
                        style: GoogleFonts.inter(
                            fontSize:
                                SizeConfig.textMultiplier * 1.757532281205165,
                            fontWeight: FontWeight.w400,
                            letterSpacing: 0.25,
                            color: AppColors.app_txt_color)),
                  if (addressList[2].state != null)
                    Text(addressList[2].state,
                        style: GoogleFonts.inter(
                            fontSize:
                                SizeConfig.textMultiplier * 1.757532281205165,
                            fontWeight: FontWeight.w400,
                            letterSpacing: 0.25,
                            color: AppColors.app_txt_color)),
                  if (addressList[2].country != null)
                    Text(addressList[2].country,
                        style: GoogleFonts.inter(
                            fontSize:
                                SizeConfig.textMultiplier * 1.757532281205165,
                            fontWeight: FontWeight.w400,
                            letterSpacing: 0.25,
                            color: AppColors.app_txt_color)),
                  if (addressList[2].postcode != null)
                    Text('${addressList[2].postcode}',
                        style: GoogleFonts.inter(
                            fontSize:
                                SizeConfig.textMultiplier * 1.757532281205165,
                            fontWeight: FontWeight.w400,
                            letterSpacing: 0.25,
                            color: AppColors.app_txt_color)),
                ],
              )),
      ]),
    );
  }

  Widget _receivingPayment() {
    return Container(
      margin: EdgeInsets.only(
          top: SizeConfig.heightMultiplier * 1.5064562410329987),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(
          children: [
            Image.asset(
              'assets/images/card_img.png',
              width: SizeConfig.widthMultiplier * 3.8888888888888884,
              height: SizeConfig.heightMultiplier * 1.5064562410329987,
            ),
            Container(
                margin: EdgeInsets.only(
                    left: SizeConfig.widthMultiplier * 0.9722222222222221),
                child: Text(_l10n.paypal,
                    style: GoogleFonts.inter(
                        fontSize:
                            SizeConfig.textMultiplier * 1.2553802008608321,
                        fontWeight: FontWeight.w400,
                        color: AppColors.text_field_container))),
          ],
        ),
        Row(
          children: [
            Text('Example@example.com',
                style: GoogleFonts.inter(
                    fontSize: SizeConfig.textMultiplier * 1.757532281205165,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 0.1,
                    color: AppColors.app_txt_color)),
            Spacer(),
            GestureDetector(
              onTap: () {},
              child: Container(
                height: SizeConfig.heightMultiplier * 2.5107604017216643,
                alignment: Alignment.center,
                margin: EdgeInsets.only(
                  right: SizeConfig.widthMultiplier * 3.8888888888888884,
                ),
                padding: EdgeInsets.only(
                    left: SizeConfig.widthMultiplier * 1.9444444444444442,
                    right: SizeConfig.widthMultiplier * 1.9444444444444442,
                    top: SizeConfig.heightMultiplier * 0.25107604017216645,
                    bottom: SizeConfig.heightMultiplier * 0.25107604017216645),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                        color: AppColors.cancel_red,
                        width:
                            SizeConfig.widthMultiplier * 0.24305555555555552),
                    color: AppColors.remove_red),
                child: Text(
                  _l10n.remove,
                  style: TextStyle(
                    color: AppColors.cancel_red,
                    fontSize: SizeConfig.textMultiplier * 1.2553802008608321,
                  ),
                ),
              ),
            ),
          ],
        ),
        Container(
          margin: EdgeInsets.only(
              top: SizeConfig.heightMultiplier * 2.1341463414634148),
          child: Row(
            children: [
              Image.asset(
                'assets/images/card_img.png',
                width: SizeConfig.widthMultiplier * 3.8888888888888884,
                height: SizeConfig.heightMultiplier * 1.5064562410329987,
              ),
              Container(
                  margin: EdgeInsets.only(
                      left: SizeConfig.widthMultiplier * 0.9722222222222221),
                  child: Text(_l10n.stripe,
                      style: GoogleFonts.inter(
                          fontSize:
                              SizeConfig.textMultiplier * 1.2553802008608321,
                          fontWeight: FontWeight.w400,
                          color: AppColors.text_field_container))),
            ],
          ),
        ),
        Row(
          children: [
            Text('Example@example.com',
                style: GoogleFonts.inter(
                    fontSize: SizeConfig.textMultiplier * 1.757532281205165,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 0.1,
                    color: AppColors.app_txt_color)),
            Spacer(),
            GestureDetector(
              onTap: () {},
              child: Container(
                height: SizeConfig.heightMultiplier * 2.5107604017216643,
                alignment: Alignment.center,
                margin: EdgeInsets.only(
                  right: SizeConfig.widthMultiplier * 3.8888888888888884,
                ),
                padding: EdgeInsets.only(
                    left: SizeConfig.widthMultiplier * 1.9444444444444442,
                    right: SizeConfig.widthMultiplier * 1.9444444444444442,
                    top: SizeConfig.heightMultiplier * 0.25107604017216645,
                    bottom: SizeConfig.heightMultiplier * 0.25107604017216645),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                        color: AppColors.cancel_red,
                        width:
                            SizeConfig.widthMultiplier * 0.24305555555555552),
                    color: AppColors.remove_red),
                child: Text(
                  _l10n.remove,
                  style: TextStyle(
                    color: AppColors.cancel_red,
                    fontSize: SizeConfig.textMultiplier * 1.2553802008608321,
                  ),
                ),
              ),
            ),
          ],
        ),
        GestureDetector(
            onTap: () {
              ReceivingPaymentRoute.isReceive = true;
              RouterService.appRouter
                  .navigateTo(ReceivingPaymentRoute.buildPath());
            },
            child: Container(
                margin: EdgeInsets.only(
                    top: SizeConfig.heightMultiplier * 2.0086083213773316),
                height: SizeConfig.heightMultiplier * 6.276901004304161,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: AppColors.appBlue)),
                child: Row(
                  children: [
                    Container(
                      width: SizeConfig.widthMultiplier * 5.833333333333333,
                      height: SizeConfig.heightMultiplier * 3.0129124820659974,
                      margin: EdgeInsets.only(
                          top: SizeConfig.heightMultiplier * 1.2553802008608321,
                          left: SizeConfig.widthMultiplier * 3.645833333333333,
                          bottom:
                              SizeConfig.heightMultiplier * 1.2553802008608321),
                      child: Icon(
                        Icons.add,
                        color: AppColors.appBlue,
                        size: 14,
                      ),
                    ),
                    Container(
                        margin: EdgeInsets.only(
                            top: SizeConfig.heightMultiplier *
                                1.5064562410329987,
                            left:
                                SizeConfig.widthMultiplier * 2.6736111111111107,
                            bottom: SizeConfig.heightMultiplier *
                                1.5064562410329987),
                        child: Text(
                          _l10n.addReceivePayment,
                          style: GoogleFonts.inter(
                              fontSize:
                                  SizeConfig.textMultiplier * 1.757532281205165,
                              fontWeight: FontWeight.w400,
                              color: AppColors.appBlue,
                              letterSpacing: 0.25,
                              textStyle: TextStyle(fontFamily: 'Roboto')),
                        )),
                  ],
                ))),
      ]),
    );
  }

  Widget _sendingPayment() {
    return Container(
      margin: EdgeInsets.only(
          top: SizeConfig.heightMultiplier * 1.5064562410329987),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Container(
            child: Text(_l10n.primary,
                style: GoogleFonts.inter(
                    fontSize: SizeConfig.textMultiplier * 1.2553802008608321,
                    fontWeight: FontWeight.w400,
                    color: AppColors.text_field_container))),
        Row(
          children: [
            Image.asset(
              'assets/images/card_img.png',
              width: SizeConfig.widthMultiplier * 3.8888888888888884,
              height: SizeConfig.heightMultiplier * 1.5064562410329987,
            ),
            Container(
                margin: EdgeInsets.only(
                    left: SizeConfig.widthMultiplier * 0.9722222222222221),
                child: Text(_l10n.paypal,
                    style: GoogleFonts.inter(
                        fontSize:
                            SizeConfig.textMultiplier * 1.2553802008608321,
                        fontWeight: FontWeight.w400,
                        color: AppColors.text_field_container))),
          ],
        ),
        Row(
          children: [
            Text('Example@example.com',
                style: GoogleFonts.inter(
                    fontSize: SizeConfig.textMultiplier * 1.757532281205165,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 0.1,
                    color: AppColors.app_txt_color)),
            Spacer(),
            GestureDetector(
              onTap: () {},
              child: Container(
                height: SizeConfig.heightMultiplier * 2.5107604017216643,
                alignment: Alignment.center,
                margin: EdgeInsets.only(
                  right: SizeConfig.widthMultiplier * 3.8888888888888884,
                ),
                padding: EdgeInsets.only(
                    left: SizeConfig.widthMultiplier * 1.9444444444444442,
                    right: SizeConfig.widthMultiplier * 1.9444444444444442,
                    top: SizeConfig.heightMultiplier * 0.25107604017216645,
                    bottom: SizeConfig.heightMultiplier * 0.25107604017216645),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                        color: AppColors.cancel_red,
                        width:
                            SizeConfig.widthMultiplier * 0.24305555555555552),
                    color: AppColors.remove_red),
                child: Text(
                  _l10n.remove,
                  style: TextStyle(
                    color: AppColors.cancel_red,
                    fontSize: SizeConfig.textMultiplier * 1.2553802008608321,
                  ),
                ),
              ),
            ),
          ],
        ),
        Container(
            margin: EdgeInsets.only(
                top: SizeConfig.heightMultiplier * 1.5064562410329987),
            child: Text(_l10n.secondary,
                style: GoogleFonts.inter(
                    fontSize: SizeConfig.textMultiplier * 1.2553802008608321,
                    fontWeight: FontWeight.w400,
                    color: AppColors.text_field_container))),
        Container(
          // margin: EdgeInsets.only(top: SizeConfig.heightMultiplier * 2.1341463414634148),
          child: Row(
            children: [
              Image.asset(
                'assets/images/card_img.png',
                width: SizeConfig.widthMultiplier * 3.8888888888888884,
                height: SizeConfig.heightMultiplier * 1.5064562410329987,
              ),
              Container(
                  margin: EdgeInsets.only(
                      left: SizeConfig.widthMultiplier * 0.9722222222222221),
                  child: Text(_l10n.mastercard,
                      style: GoogleFonts.inter(
                          fontSize:
                              SizeConfig.textMultiplier * 1.2553802008608321,
                          fontWeight: FontWeight.w400,
                          color: AppColors.text_field_container))),
            ],
          ),
        ),
        Row(
          children: [
            Text('Example@example.com',
                style: GoogleFonts.inter(
                    fontSize: SizeConfig.textMultiplier * 1.757532281205165,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 0.1,
                    color: AppColors.app_txt_color)),
            Spacer(),
            GestureDetector(
              onTap: () {},
              child: Container(
                height: SizeConfig.heightMultiplier * 2.5107604017216643,
                alignment: Alignment.center,
                margin: EdgeInsets.only(
                  right: SizeConfig.widthMultiplier * 3.8888888888888884,
                ),
                padding: EdgeInsets.only(
                    left: SizeConfig.widthMultiplier * 1.9444444444444442,
                    right: SizeConfig.widthMultiplier * 1.9444444444444442,
                    top: SizeConfig.heightMultiplier * 0.25107604017216645,
                    bottom: SizeConfig.heightMultiplier * 0.25107604017216645),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                        color: AppColors.cancel_red,
                        width:
                            SizeConfig.widthMultiplier * 0.24305555555555552),
                    color: AppColors.remove_red),
                child: Text(
                  _l10n.remove,
                  style: TextStyle(
                    color: AppColors.cancel_red,
                    fontSize: SizeConfig.textMultiplier * 1.2553802008608321,
                  ),
                ),
              ),
            ),
          ],
        ),
        Container(
          margin: EdgeInsets.only(
              top: SizeConfig.heightMultiplier * 1.0043041606886658),
          child: Row(
            children: [
              Image.asset(
                'assets/images/card_img.png',
                width: SizeConfig.widthMultiplier * 3.8888888888888884,
                height: SizeConfig.heightMultiplier * 1.5064562410329987,
              ),
              Container(
                  margin: EdgeInsets.only(
                      left: SizeConfig.widthMultiplier * 0.9722222222222221),
                  child: Text(_l10n.mastercard,
                      style: GoogleFonts.inter(
                          fontSize:
                              SizeConfig.textMultiplier * 1.2553802008608321,
                          fontWeight: FontWeight.w400,
                          color: AppColors.text_field_container))),
            ],
          ),
        ),
        Row(
          children: [
            Text('Example@example.com',
                style: GoogleFonts.inter(
                    fontSize: SizeConfig.textMultiplier * 1.757532281205165,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 0.1,
                    color: AppColors.app_txt_color)),
            Spacer(),
            GestureDetector(
              onTap: () {},
              child: Container(
                height: SizeConfig.heightMultiplier * 2.5107604017216643,
                alignment: Alignment.center,
                margin: EdgeInsets.only(
                  right: SizeConfig.widthMultiplier * 3.8888888888888884,
                ),
                padding: EdgeInsets.only(
                    left: SizeConfig.widthMultiplier * 1.9444444444444442,
                    right: SizeConfig.widthMultiplier * 1.9444444444444442,
                    top: SizeConfig.heightMultiplier * 0.25107604017216645,
                    bottom: SizeConfig.heightMultiplier * 0.25107604017216645),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                        color: AppColors.cancel_red,
                        width:
                            SizeConfig.widthMultiplier * 0.24305555555555552),
                    color: AppColors.remove_red),
                child: Text(
                  _l10n.remove,
                  style: TextStyle(
                    color: AppColors.cancel_red,
                    fontSize: SizeConfig.textMultiplier * 1.2553802008608321,
                  ),
                ),
              ),
            ),
          ],
        ),
        GestureDetector(
          onTap: () {
            ReceivingPaymentRoute.isReceive = false;
            RouterService.appRouter.navigateTo(AddNewSendingRoute.buildPath());
          },
          child: Container(
              margin: EdgeInsets.only(
                  top: SizeConfig.heightMultiplier * 2.0086083213773316),
              height: SizeConfig.heightMultiplier * 6.276901004304161,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: AppColors.appBlue)),
              child: Row(
                children: [
                  Container(
                    width: SizeConfig.widthMultiplier * 5.833333333333333,
                    height: SizeConfig.heightMultiplier * 3.0129124820659974,
                    margin: EdgeInsets.only(
                        top: SizeConfig.heightMultiplier * 1.2553802008608321,
                        left: SizeConfig.widthMultiplier * 3.645833333333333,
                        bottom:
                            SizeConfig.heightMultiplier * 1.2553802008608321),
                    child: Icon(
                      Icons.add,
                      color: AppColors.appBlue,
                      size: 14,
                    ),
                  ),
                  Container(
                      margin: EdgeInsets.only(
                          top: SizeConfig.heightMultiplier * 1.5064562410329987,
                          left: SizeConfig.widthMultiplier * 2.6736111111111107,
                          bottom:
                              SizeConfig.heightMultiplier * 1.5064562410329987),
                      child: Text(
                        _l10n.addSendingPayment,
                        style: GoogleFonts.inter(
                            fontSize:
                                SizeConfig.textMultiplier * 1.757532281205165,
                            fontWeight: FontWeight.w400,
                            color: AppColors.appBlue,
                            letterSpacing: 0.25,
                            textStyle: TextStyle(fontFamily: 'Roboto')),
                      )),
                ],
              )),
        ),
      ]),
    );
  }

  Widget _bottomButtons() {
    return GestureDetector(
      onTap: () {
        setState(() {
          _logoutLoading = true;
        });
        _profileSettingBloc.add(LogoutEvent());
      },
      child: Container(
        color: AppColors.white,
        child: Container(
          margin: EdgeInsets.only(
              left: SizeConfig.widthMultiplier * 3.8888888888888884,
              right: SizeConfig.widthMultiplier * 3.8888888888888884,
              bottom: SizeConfig.heightMultiplier * 2.5107604017216643),
          height: SizeConfig.heightMultiplier * 6.276901004304161,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: AppColors.cancel_red)),
          child: Center(
            child: _logoutLoading
                ? Lottie.asset('assets/loader/widget_loading.json',
                    height: SizeConfig.heightMultiplier * 2.5107604017216643,
                    width: SizeConfig.widthMultiplier * 12.152777777777777)
                : Text(
                    _l10n.logout,
                    style: GoogleFonts.roboto(
                        fontSize: SizeConfig.textMultiplier * 1.757532281205165,
                        fontWeight: FontWeight.w700,
                        color: AppColors.cancel_red,
                        letterSpacing: 0.5,
                        textStyle: TextStyle(fontFamily: 'Roboto')),
                  ),
          ),
        ),
      ),
    );
  }

  void _getEmail() async {
    setState(() async {
      _emailText = await _authRepository.getEmail();
    });
  }

  Widget _notificationSwitches() {
    return Container(
      margin: EdgeInsets.only(
          top: SizeConfig.heightMultiplier * 2.5107604017216643),
      child: Column(
        children: [
          Container(
            child: Row(
              children: [
                Container(
                  child: Text(
                    _l10n.message,
                    style: GoogleFonts.inter(
                        color: AppColors.app_txt_color,
                        fontWeight: FontWeight.w700,
                        fontSize: SizeConfig.textMultiplier * 1.757532281205165,
                        letterSpacing: 0.1),
                  ),
                ),
                Spacer(),
                Container(
                  child: FlutterSwitch(
                    width: SizeConfig.widthMultiplier * 12.152777777777777,
                    height: SizeConfig.heightMultiplier * 3.0129124820659974,
                    showOnOff: false,
                    activeTextColor: Colors.white,
                    inactiveTextColor: AppColors.toolbarBlue,
                    value: _messagesSwitch,
                    onToggle: (val) {
                      setState(() {
                        _messagesSwitch = val;
                        _profileSettingBloc.settingText = "messages";
                        _profileSettingBloc.settingData =
                            _messagesSwitch.toString();
                        _profileSettingBloc
                            .add(UpdateNotificationSettingsEvent());
                      });
                    },
                  ),
                ),
              ],
            ),
          ),
          Container(
            child: Row(
              children: [
                Container(
                  child: Text(
                    _l10n.soldItems,
                    style: GoogleFonts.inter(
                        color: AppColors.app_txt_color,
                        fontWeight: FontWeight.w700,
                        fontSize: SizeConfig.textMultiplier * 1.757532281205165,
                        letterSpacing: 0.1),
                  ),
                ),
                Spacer(),
                Container(
                  margin: EdgeInsets.only(
                      top: SizeConfig.heightMultiplier * 1.8830703012912482),
                  child: FlutterSwitch(
                    width: SizeConfig.widthMultiplier * 12.152777777777777,
                    height: SizeConfig.heightMultiplier * 3.0129124820659974,
                    showOnOff: false,
                    activeTextColor: Colors.white,
                    inactiveTextColor: AppColors.toolbarBlue,
                    value: _soldItemSwitch,
                    onToggle: (val) {
                      setState(() {
                        _soldItemSwitch = val;
                        _profileSettingBloc.settingText = "soldItems";
                        _profileSettingBloc.settingData =
                            _soldItemSwitch.toString();
                        _profileSettingBloc
                            .add(UpdateNotificationSettingsEvent());
                      });
                    },
                  ),
                ),
              ],
            ),
          ),
          Container(
            child: Row(
              children: [
                Container(
                  child: Text(
                    _l10n.feedback,
                    style: GoogleFonts.inter(
                        color: AppColors.app_txt_color,
                        fontWeight: FontWeight.w700,
                        fontSize: SizeConfig.textMultiplier * 1.757532281205165,
                        letterSpacing: 0.1),
                  ),
                ),
                Spacer(),
                Container(
                  margin: EdgeInsets.only(
                      top: SizeConfig.heightMultiplier * 1.8830703012912482),
                  child: FlutterSwitch(
                    width: SizeConfig.widthMultiplier * 12.152777777777777,
                    height: SizeConfig.heightMultiplier * 3.0129124820659974,
                    showOnOff: false,
                    activeTextColor: Colors.white,
                    inactiveTextColor: AppColors.toolbarBlue,
                    value: _feedbackReceivedSwitch,
                    onToggle: (val) {
                      setState(() {
                        _feedbackReceivedSwitch = val;
                        _profileSettingBloc.settingText = "feedbacksReceived";
                        _profileSettingBloc.settingData =
                            _feedbackReceivedSwitch.toString();
                        _profileSettingBloc
                            .add(UpdateNotificationSettingsEvent());
                      });
                    },
                  ),
                ),
              ],
            ),
          ),
          Container(
            child: Row(
              children: [
                Container(
                  child: Text(
                    _l10n.orderUpdate,
                    style: GoogleFonts.inter(
                        color: AppColors.app_txt_color,
                        fontWeight: FontWeight.w700,
                        fontSize: SizeConfig.textMultiplier * 1.757532281205165,
                        letterSpacing: 0.1),
                  ),
                ),
                Spacer(),
                Container(
                  margin: EdgeInsets.only(
                      top: SizeConfig.heightMultiplier * 1.8830703012912482),
                  child: FlutterSwitch(
                    width: SizeConfig.widthMultiplier * 12.152777777777777,
                    height: SizeConfig.heightMultiplier * 3.0129124820659974,
                    showOnOff: false,
                    activeTextColor: Colors.white,
                    inactiveTextColor: AppColors.toolbarBlue,
                    value: _orderSwitch,
                    onToggle: (val) {
                      setState(() {
                        _orderSwitch = val;
                        _profileSettingBloc.settingText = "orderUpdates";
                        _profileSettingBloc.settingData =
                            _orderSwitch.toString();
                        _profileSettingBloc
                            .add(UpdateNotificationSettingsEvent());
                      });
                    },
                  ),
                ),
              ],
            ),
          ),
          Container(
            child: Row(
              children: [
                Container(
                  child: Text(
                    _l10n.investmentUpdate,
                    style: GoogleFonts.inter(
                        color: AppColors.app_txt_color,
                        fontWeight: FontWeight.w700,
                        fontSize: SizeConfig.textMultiplier * 1.757532281205165,
                        letterSpacing: 0.1),
                  ),
                ),
                Spacer(),
                Container(
                  margin: EdgeInsets.only(
                      top: SizeConfig.heightMultiplier * 1.8830703012912482),
                  child: FlutterSwitch(
                    width: SizeConfig.widthMultiplier * 12.152777777777777,
                    height: SizeConfig.heightMultiplier * 3.0129124820659974,
                    showOnOff: false,
                    activeTextColor: Colors.white,
                    inactiveTextColor: AppColors.toolbarBlue,
                    value: _investmentSwitch,
                    onToggle: (val) {
                      setState(() {
                        _investmentSwitch = val;
                        _profileSettingBloc.settingText = "investmentUpdates";
                        _profileSettingBloc.settingData =
                            _investmentSwitch.toString();
                        _profileSettingBloc
                            .add(UpdateNotificationSettingsEvent());
                      });
                    },
                  ),
                ),
              ],
            ),
          ),
          Container(
            child: Row(
              children: [
                Container(
                  child: Text(
                    _l10n.promotions,
                    style: GoogleFonts.inter(
                        color: AppColors.app_txt_color,
                        fontWeight: FontWeight.w700,
                        fontSize: SizeConfig.textMultiplier * 1.757532281205165,
                        letterSpacing: 0.1),
                  ),
                ),
                Spacer(),
                Container(
                  margin: EdgeInsets.only(
                      top: SizeConfig.heightMultiplier * 1.8830703012912482),
                  child: FlutterSwitch(
                    width: SizeConfig.widthMultiplier * 12.152777777777777,
                    height: SizeConfig.heightMultiplier * 3.0129124820659974,
                    showOnOff: false,
                    activeTextColor: Colors.white,
                    inactiveTextColor: AppColors.toolbarBlue,
                    value: _promotionSwitch,
                    onToggle: (val) {
                      setState(() {
                        _promotionSwitch = val;
                        _profileSettingBloc.settingText = "promotions";
                        _profileSettingBloc.settingData =
                            _promotionSwitch.toString();
                        _profileSettingBloc
                            .add(UpdateNotificationSettingsEvent());
                      });
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _currencyListContainer() {
    return Container(
      child: Column(
        children: [
          Padding(
              padding: EdgeInsets.only(
                  top: SizeConfig.heightMultiplier * 1.5064562410329987),
              child: Theme(
                data: ThemeData(
                  primaryColor: AppColors.text_field_container,
                  primaryColorDark: AppColors.text_field_container,
                ),
                child: TextField(
                  keyboardType: TextInputType.phone,
                  key: _actionKey,
                  controller: _cryptoCurrencyController,
                  readOnly: true,
                  showCursor: false,
                  onTap: () {
                    setState(() {
                      this._overlayEntry = this._createOverlayEntry(
                          _cryptoCurrency,
                          _actionKey,
                          _cryptoCurrencyController);
                      Overlay.of(context).insert(this._overlayEntry);
                    });
                  },
                  style: GoogleFonts.inter(
                      fontWeight: FontWeight.w400,
                      fontSize: SizeConfig.textMultiplier * 1.757532281205165,
                      letterSpacing: 0.1,
                      color: AppColors.app_txt_color),
                  decoration: InputDecoration(
                      suffixIcon: Icon(Icons.keyboard_arrow_down),
                      border: OutlineInputBorder(
                          borderSide:
                              BorderSide(color: AppColors.text_field_container),
                          borderRadius: BorderRadius.circular(10.0)),
                      contentPadding: EdgeInsets.only(
                          left:
                              SizeConfig.widthMultiplier * 3.8888888888888884),
                      hintText: 'Crypto currency',
                      suffixStyle: const TextStyle(
                          color: AppColors.text_field_container)),
                ),
              )),
          Padding(
              padding: EdgeInsets.only(
                  top: SizeConfig.heightMultiplier * 1.5064562410329987),
              child: Theme(
                data: ThemeData(
                  primaryColor: AppColors.text_field_container,
                  primaryColorDark: AppColors.text_field_container,
                ),
                child: TextField(
                  keyboardType: TextInputType.phone,
                  key: _prefferedCurrencyKey,
                  controller: _prefferedCurrencyController,
                  readOnly: true,
                  showCursor: false,
                  onTap: () {
                    setState(() {
                      this._overlayEntry = this._createOverlayEntry(
                          _prefferedCurrency,
                          _prefferedCurrencyKey,
                          _prefferedCurrencyController);
                      Overlay.of(context).insert(this._overlayEntry);
                    });
                  },
                  style: GoogleFonts.inter(
                      fontWeight: FontWeight.w400,
                      fontSize: SizeConfig.textMultiplier * 1.757532281205165,
                      letterSpacing: 0.1,
                      color: AppColors.app_txt_color),
                  decoration: InputDecoration(
                      suffixIcon: Icon(Icons.keyboard_arrow_down),
                      border: OutlineInputBorder(
                          borderSide:
                              BorderSide(color: AppColors.text_field_container),
                          borderRadius: BorderRadius.circular(10.0)),
                      contentPadding: EdgeInsets.only(
                          left:
                              SizeConfig.widthMultiplier * 3.8888888888888884),
                      hintText: 'Preffered currency',
                      suffixStyle: const TextStyle(
                          color: AppColors.text_field_container)),
                ),
              )),
          GestureDetector(
            onTap: () {
              if (_cryptoCurrencyController.text.isEmpty) {
                _showToast("Please select crypto currency");
              } else if (_prefferedCurrencyController.text.isEmpty) {
                _showToast("Please select preferred currency");
              } else {
                if (_prefferedCurrencyController.text == "Australian Dollar ") {
                  _profileSettingBloc.prefCurrency = "AUD";
                } else if (_prefferedCurrencyController.text ==
                    "Chinese Yuan") {
                  _profileSettingBloc.prefCurrency = "CYN";
                }

                if (_cryptoCurrencyController.text == "Bitcoin") {
                  _profileSettingBloc.cryptoCurrency = "BTC";
                } else if (_cryptoCurrencyController.text == "Ethereum") {
                  _profileSettingBloc.cryptoCurrency = "ETH";
                } else if (_cryptoCurrencyController.text == "USDC") {
                  _profileSettingBloc.cryptoCurrency = "USDC";
                }

                _profileSettingBloc.add(UpdateCurrencyEvent());
              }
            },
            child: Container(
              color: AppColors.white,
              child: Container(
                margin: EdgeInsets.only(
                    bottom: SizeConfig.heightMultiplier * 1.2553802008608321,
                    top: SizeConfig.heightMultiplier * 1.2553802008608321),
                height: SizeConfig.heightMultiplier * 6.276901004304161,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: AppColors.appBlue)),
                child: Center(
                  child: Text(
                    _l10n.updateCurrencies,
                    style: GoogleFonts.roboto(
                        fontSize: SizeConfig.textMultiplier * 1.757532281205165,
                        fontWeight: FontWeight.w700,
                        color: AppColors.appBlue,
                        letterSpacing: 0.5,
                        textStyle: TextStyle(fontFamily: 'Roboto')),
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
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
              height: _dropdownList.length >= 3 ? 180 : 130,
              child: Material(
                elevation: 5,
                borderRadius: BorderRadius.circular(10.0),
                child: Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                          color: AppColors.text_field_container,
                          width: SizeConfig.widthMultiplier *
                              0.48611111111111105)),
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
