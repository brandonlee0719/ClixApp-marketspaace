import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:market_space/common/colors.dart';
import 'package:market_space/common/constants.dart';
import 'package:market_space/common/loading_progress.dart';
import 'package:market_space/common/raised_gradient_button.dart';
import 'package:market_space/common/toolbar.dart';
import 'package:market_space/model/bank_account_model/bank_account_model.dart';
import 'package:market_space/model/bank_account_model/bank_details_request_model.dart';
import 'package:market_space/profile_settings/seller_sending_payments/add_new_sending_payment/add_new_sending_bloc.dart';
import 'package:market_space/responsive_layout/size_config.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

import 'add_sending_payment_l10n.dart';

class AddSendingPaymentScreen extends StatefulWidget {
  @override
  _AddSendingPaymentScreenState createState() =>
      _AddSendingPaymentScreenState();
}

class _AddSendingPaymentScreenState extends State<AddSendingPaymentScreen> {
  final AddNewSendingBloc _AddNewSendingBloc = AddNewSendingBloc(Initial());
  AddSendingPaymentL10n _l10n = AddSendingPaymentL10n(
      Locale.fromSubtags(languageCode: 'en', countryCode: 'US'));

  bool _isLoading = false;
  String _tabSelected = "";
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  OverlayEntry _overlayEntry;
  final _productTypeKey = GlobalKey<ScaffoldState>();
  final TextEditingController _countryController = TextEditingController();
  final TextEditingController _accountController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _addressOneController = TextEditingController();
  final TextEditingController _addressTwoController = TextEditingController();
  final TextEditingController _cityController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _bsbController = TextEditingController();
  List<String> _countryList = ["Australia", "China"];
  int slideIndex = 0;
  PageController _pageController = PageController(initialPage: 0);
  bool _editBankDetails = false;
  bool _bankLoading = false;
  bool _removeAccountLoading = false;
  String _bankModelText = "";
  BankAccountModel _bankModel;
  bool _confirmLoading = false;
  String _selectedItem;
  bool _fileUploading = false;
  String _bankStatus;
  String _accountName, _accountNumber;

  @override
  void initState() {
    // _AddNewSendingBloc.add(AddNewSendingScreenEvent());

    setState(() {
      if (Constants.language == null || Constants.language == "English") {
        _l10n = AddSendingPaymentL10n(
            Locale.fromSubtags(languageCode: 'en', countryCode: 'US'));
      } else {
        _l10n = AddSendingPaymentL10n(Locale.fromSubtags(languageCode: 'zh'));
      }
      _countryController.text = "Australia";
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: Toolbar(
        title: _l10n.addNewSellerPayment,
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
          create: (_) => _AddNewSendingBloc,
          child: BlocListener<AddNewSendingBloc, AddNewSendingState>(
              listener: (context, state) {
                if (state is Loading) {
                  setState(() {
                    _bankLoading = true;
                  });
                }
                if (state is Loaded) {
                  setState(() {
                    _bankLoading = false;
                    _bankModelText = "true";
                    // _bankModel = _AddNewSendingBloc.bankAccountModel;
                    _accountName = _AddNewSendingBloc.accountName;
                    _accountNumber = _AddNewSendingBloc.accountDetails;
                    _showBankDetailsSheet();

                    // _showMarketSpaceWallet();
                  });
                }
                if (state is Failure) {
                  setState(() {
                    _bankLoading = false;
                    _bankModelText = "false";
                    _showBankDetailsSheet();
                  });
                }
                if (state is SaveBankDetails) {
                  setState(() {
                    // _showToast("${_AddNewSendingBloc.saveBankText}");
                    // Navigator.pop(context);
                    _bankLoading = false;
                    _bankModelText = "true";
                    _confirmLoading = false;
                    _pageController.jumpToPage(1);
                    // _showBankDetailsSheet();
                  });
                }
                if (state is SaveBankDetailsFailure) {
                  setState(() {
                    _showToast("${_AddNewSendingBloc.saveBankText}");
                    _confirmLoading = false;
                  });
                }
                if (state is PickFileSuccess) {
                  setState(() {
                    _fileUploading = false;
                  });
                }
                if (state is PickFileFailure) {
                  setState(() {
                    _fileUploading = false;
                  });
                }
                if (state is BankStatusSuccess) {
                  setState(() {
                    _bankStatus = _AddNewSendingBloc.bankStatus;
                  });
                }
                if (state is BankAccountRemovedSuccess) {
                  setState(() {
                    _removeAccountLoading = false;
                    Navigator.pop(context);
                    _showBankDetailsSheet();
                  });
                }
                if (state is BankAccountRemovedFailure) {
                  setState(() {
                    _removeAccountLoading = false;
                    _showToast("Remove account failed");
                  });
                }
              },
              child: _baseScreen()),
        ),
      ),
    );
  }

  Widget _baseScreen() {
    return GestureDetector(
      onTap: () {
        setState(() {
          if (_overlayEntry != null) {
            _overlayEntry.remove();
          }
        });
      },
      child: Container(
          color: Colors.white,
          child: Stack(children: [
            ListView(
                shrinkWrap: true,
                physics: BouncingScrollPhysics(),
                children: [_paymentModes()])
          ])),
    );
  }

  Widget _paymentModes() {
    return Container(
        child: ListView(shrinkWrap: true, children: [
      Container(
        margin: EdgeInsets.only(
            left: SizeConfig.widthMultiplier * 3.8888888888888884,
            top: SizeConfig.heightMultiplier * 1.8830703012912482),
        child: Text(
          'Select the payment method allowed when buyers acquire your items',
          style: GoogleFonts.inter(
              color: AppColors.text_field_container,
              fontSize: SizeConfig.textMultiplier * 1.757532281205165,
              fontWeight: FontWeight.w400),
        ),
      ),
      GestureDetector(
          onTap: () {
            setState(() {
              _tabSelected = "Wallet";
            });
            _showMarketSpaceWallet();
          },
          child: Container(
              height: SizeConfig.heightMultiplier * 7.532281205164993,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                      color: _tabSelected == "Wallet"
                          ? AppColors.appBlue
                          : AppColors.text_field_container)),
              margin: EdgeInsets.only(
                  left: SizeConfig.widthMultiplier * 3.8888888888888884,
                  right: SizeConfig.widthMultiplier * 3.8888888888888884,
                  top: SizeConfig.heightMultiplier * 3.0129124820659974),
              child: Center(
                child: Text(
                  "My Market Spaace Wallet",
                  style: GoogleFonts.inter(
                      fontSize: SizeConfig.textMultiplier * 1.757532281205165,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 0.1,
                      color: _tabSelected == "Wallet"
                          ? AppColors.appBlue
                          : AppColors.text_field_container),
                ),
              ))),
      GestureDetector(
        onTap: () {
          setState(() {
            _tabSelected = "Bank";
            _bankLoading = true;
          });
          _AddNewSendingBloc.add(AddNewSendingScreenEvent());
          // _showBankDetailsSheet();
        },
        child: Container(
            height: SizeConfig.heightMultiplier * 7.532281205164993,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                border: Border.all(
                    color: _tabSelected == "Bank"
                        ? AppColors.appBlue
                        : AppColors.text_field_container)),
            margin: EdgeInsets.only(
                left: SizeConfig.widthMultiplier * 3.8888888888888884,
                right: SizeConfig.widthMultiplier * 3.8888888888888884,
                top: SizeConfig.heightMultiplier * 1.5064562410329987),
            child: Center(
                child: _bankLoading
                    ? Lottie.asset('assets/loader/widget_loading.json',
                        height:
                            SizeConfig.heightMultiplier * 2.5107604017216643,
                        width: SizeConfig.widthMultiplier * 12.152777777777777)
                    : Text(
                        _l10n.Bank,
                        style: GoogleFonts.inter(
                            fontSize:
                                SizeConfig.textMultiplier * 1.757532281205165,
                            fontWeight: FontWeight.w700,
                            letterSpacing: 0.1,
                            color: _tabSelected == "Bank"
                                ? AppColors.appBlue
                                : AppColors.text_field_container),
                      ))),
      ),
      /* GestureDetector(
              onTap: () {
                setState(() {
                  _tabSelected = "card";
                });
                _showCardSheet();
              },
              child: Container(
                  height: SizeConfig.heightMultiplier * 7.532281205164993,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                          color: _tabSelected == "card"
                              ? AppColors.appBlue
                              : AppColors.text_field_container)),
                  margin: EdgeInsets.only(left: SizeConfig.widthMultiplier * 3.8888888888888884, right: SizeConfig.widthMultiplier * 3.8888888888888884, top: SizeConfig.heightMultiplier * 1.5064562410329987),
                  child: Center(
                    child: Text(
                      "Debit card",
                      style: GoogleFonts.inter(
                          fontSize: SizeConfig.textMultiplier * 1.757532281205165,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 0.1,
                          color: _tabSelected == "card"
                              ? AppColors.appBlue
                              : AppColors.text_field_container),
                    ),
                  ))),*/
    ]));
  }

  void _showMarketSpaceWallet() {
    showMaterialModalBottomSheet(
      context: context,
      elevation: 5,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
              topRight: Radius.circular(30), topLeft: Radius.circular(30))),
      builder: (context) => SingleChildScrollView(
        controller: ModalScrollController.of(context),
        child: Container(
            margin: EdgeInsets.only(
                bottom: SizeConfig.heightMultiplier * 3.7661406025824964),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                    margin: EdgeInsets.only(
                        left: SizeConfig.widthMultiplier * 4.861111111111111,
                        top: SizeConfig.heightMultiplier * 1.8830703012912482),
                    child: Text(
                      _l10n.Wallet,
                      style: GoogleFonts.inter(
                        fontSize: SizeConfig.textMultiplier * 2.259684361549498,
                        fontWeight: FontWeight.w700,
                      ),
                    )),
                Container(
                    margin: EdgeInsets.only(
                        left: SizeConfig.widthMultiplier * 4.861111111111111,
                        top: SizeConfig.heightMultiplier * 1.8830703012912482),
                    child: Text(
                      _l10n.selectCryptoPayment,
                      style: GoogleFonts.inter(
                          fontSize:
                              SizeConfig.textMultiplier * 1.757532281205165,
                          fontWeight: FontWeight.w400,
                          letterSpacing: 0.25),
                    )),
                Container(
                    margin: EdgeInsets.only(
                        left: SizeConfig.widthMultiplier * 4.861111111111111,
                        top: SizeConfig.heightMultiplier * 1.2553802008608321),
                    child: Row(
                      children: [
                        Container(
                            // height: SizeConfig.heightMultiplier * 7.532281205164993,
                            child: Center(
                          child: Image.asset(
                            'assets/images/bitcoin.png',
                            height:
                                SizeConfig.heightMultiplier * 3.51506456241033,
                            width:
                                SizeConfig.widthMultiplier * 20.416666666666664,
                            fit: BoxFit.contain,
                          ),
                        )),
                        Spacer(),
                        Container(
                            margin: EdgeInsets.only(
                                right: SizeConfig.widthMultiplier *
                                    7.291666666666666),
                            width:
                                SizeConfig.widthMultiplier * 5.833333333333333,
                            height: SizeConfig.heightMultiplier *
                                3.0129124820659974,
                            child: Center(
                                child: Icon(
                              Icons.check_circle,
                              color: Colors.green,
                            ))),
                      ],
                    )),
                Container(
                    margin: EdgeInsets.only(
                        left: SizeConfig.widthMultiplier * 4.861111111111111,
                        top: SizeConfig.heightMultiplier * 1.2553802008608321),
                    child: Row(
                      children: [
                        Container(
                            // height: SizeConfig.heightMultiplier * 7.532281205164993,
                            child: Center(
                          child: Image.asset(
                            'assets/images/ethrum.png',
                            height:
                                SizeConfig.heightMultiplier * 6.276901004304161,
                            width:
                                SizeConfig.widthMultiplier * 20.416666666666664,
                            fit: BoxFit.contain,
                          ),
                        )),
                        Spacer(),
                        Container(
                            margin: EdgeInsets.only(
                                right: SizeConfig.widthMultiplier *
                                    7.291666666666666),
                            width:
                                SizeConfig.widthMultiplier * 5.833333333333333,
                            height: SizeConfig.heightMultiplier *
                                3.0129124820659974,
                            child: Center(
                                child: Icon(
                              Icons.check_circle,
                              color: Colors.green,
                            ))),
                      ],
                    )),
                Container(
                    margin: EdgeInsets.only(
                        left: SizeConfig.widthMultiplier * 4.861111111111111,
                        top: SizeConfig.heightMultiplier * 1.2553802008608321),
                    child: Row(
                      children: [
                        Container(
                          height:
                              SizeConfig.heightMultiplier * 3.0129124820659974,
                          width: SizeConfig.widthMultiplier * 5.833333333333333,
                          child: Image.asset(
                            'assets/images/usdc_img.png',
                            height: SizeConfig.heightMultiplier *
                                3.0129124820659974,
                            width:
                                SizeConfig.widthMultiplier * 5.833333333333333,
                            fit: BoxFit.contain,
                          ),
                        ),
                        Container(
                            // height: SizeConfig.heightMultiplier * 7.532281205164993,
                            child: Center(
                          child: Text(
                            'USDC',
                            style: GoogleFonts.inter(
                                color: AppColors.text_field_container,
                                fontWeight: FontWeight.w500,
                                fontSize: SizeConfig.textMultiplier *
                                    2.259684361549498,
                                letterSpacing: 0.15),
                          ),
                        )),
                        Spacer(),
                        Container(
                            margin: EdgeInsets.only(
                                right: SizeConfig.widthMultiplier *
                                    7.291666666666666),
                            width:
                                SizeConfig.widthMultiplier * 5.833333333333333,
                            height: SizeConfig.heightMultiplier *
                                3.0129124820659974,
                            child: Center(
                                child: Icon(
                              Icons.check_circle,
                              color: Colors.green,
                            ))),
                      ],
                    )),
                Container(
                    margin: EdgeInsets.only(
                        left: SizeConfig.widthMultiplier * 4.861111111111111,
                        top: SizeConfig.heightMultiplier * 1.5064562410329987),
                    child: Row(
                      children: [
                        Container(
                          height:
                              SizeConfig.heightMultiplier * 3.0129124820659974,
                          width: SizeConfig.widthMultiplier * 5.833333333333333,
                          child: Image.asset(
                            'assets/images/aus_flag.png',
                            height: SizeConfig.heightMultiplier *
                                3.0129124820659974,
                            width:
                                SizeConfig.widthMultiplier * 5.833333333333333,
                            fit: BoxFit.contain,
                          ),
                        ),
                        Container(
                            margin: EdgeInsets.only(
                                left: SizeConfig.widthMultiplier *
                                    1.2152777777777777),
                            child: Center(
                              child: Text(
                                'AUD',
                                style: GoogleFonts.inter(
                                    color: AppColors.text_field_container,
                                    fontWeight: FontWeight.w500,
                                    fontSize: SizeConfig.textMultiplier *
                                        2.259684361549498,
                                    letterSpacing: 0.15),
                              ),
                            )),
                        Spacer(),
                        Container(
                            margin: EdgeInsets.only(
                                right: SizeConfig.widthMultiplier *
                                    7.291666666666666),
                            width:
                                SizeConfig.widthMultiplier * 5.833333333333333,
                            height: SizeConfig.heightMultiplier *
                                3.0129124820659974,
                            child: Center(
                                child: Icon(
                              Icons.check_circle,
                              color: Colors.green,
                            ))),
                      ],
                    )),
                Container(
                    margin: EdgeInsets.only(
                        left: SizeConfig.widthMultiplier * 4.861111111111111,
                        top: SizeConfig.heightMultiplier * 1.5064562410329987),
                    child: Row(
                      children: [
                        Container(
                          height:
                              SizeConfig.heightMultiplier * 3.0129124820659974,
                          width: SizeConfig.widthMultiplier * 5.833333333333333,
                          child: Image.asset(
                            'assets/images/china_flag.png',
                            height: SizeConfig.heightMultiplier *
                                3.0129124820659974,
                            width:
                                SizeConfig.widthMultiplier * 5.833333333333333,
                            fit: BoxFit.contain,
                          ),
                        ),
                        Container(
                            margin: EdgeInsets.only(
                                left: SizeConfig.widthMultiplier *
                                    1.2152777777777777),
                            child: Center(
                              child: Text(
                                'CNY',
                                style: GoogleFonts.inter(
                                    color: AppColors.text_field_container,
                                    fontWeight: FontWeight.w500,
                                    fontSize: SizeConfig.textMultiplier *
                                        2.259684361549498,
                                    letterSpacing: 0.15),
                              ),
                            )),
                        Spacer(),
                        Container(
                            margin: EdgeInsets.only(
                                right: SizeConfig.widthMultiplier *
                                    7.291666666666666),
                            width:
                                SizeConfig.widthMultiplier * 5.833333333333333,
                            height: SizeConfig.heightMultiplier *
                                3.0129124820659974,
                            child: Center(
                                child: Icon(
                              Icons.check_circle,
                              color: Colors.green,
                            ))),
                      ],
                    )),
                GestureDetector(
                  behavior: HitTestBehavior.translucent,
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: Container(
                    color: AppColors.white,
                    child: Container(
                      margin: EdgeInsets.only(
                          left: SizeConfig.widthMultiplier * 3.8888888888888884,
                          right:
                              SizeConfig.widthMultiplier * 3.8888888888888884,
                          bottom:
                              SizeConfig.heightMultiplier * 2.5107604017216643),
                      height: SizeConfig.heightMultiplier * 6.276901004304161,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: AppColors.cancel_red)),
                      child: Center(
                        child: Text(
                          _l10n.close,
                          style: GoogleFonts.roboto(
                              fontSize:
                                  SizeConfig.textMultiplier * 1.757532281205165,
                              fontWeight: FontWeight.w700,
                              color: AppColors.cancel_red,
                              letterSpacing: 0.5,
                              textStyle: TextStyle(fontFamily: 'Roboto')),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            )),
      ),
    );
  }

  void _showCardSheet() {
    showMaterialModalBottomSheet(
      context: context,
      elevation: 5,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
              topRight: Radius.circular(30), topLeft: Radius.circular(30))),
      builder: (context) => SingleChildScrollView(
        controller: ModalScrollController.of(context),
        child: Container(
            margin: EdgeInsets.only(
                bottom: SizeConfig.heightMultiplier * 12.553802008608322),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                    margin: EdgeInsets.only(
                        left: SizeConfig.widthMultiplier * 4.861111111111111,
                        top: SizeConfig.heightMultiplier * 1.8830703012912482),
                    child: Text(
                      "Debit or credit card",
                      style: GoogleFonts.inter(
                        fontSize: SizeConfig.textMultiplier * 2.259684361549498,
                        fontWeight: FontWeight.w700,
                      ),
                    )),
                Container(
                    margin: EdgeInsets.only(
                        left: SizeConfig.widthMultiplier * 4.861111111111111,
                        top: SizeConfig.heightMultiplier * 1.8830703012912482),
                    child: Text(
                      "My cards",
                      style: GoogleFonts.inter(
                          fontSize:
                              SizeConfig.textMultiplier * 1.757532281205165,
                          fontWeight: FontWeight.w400,
                          letterSpacing: 0.25),
                    )),
                Container(
                  decoration: BoxDecoration(
                    border: Border.all(
                        color: AppColors.text_field_container,
                        width:
                            SizeConfig.widthMultiplier * 0.24305555555555552),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  padding: EdgeInsets.all(10),
                  margin: EdgeInsets.only(
                      left: SizeConfig.widthMultiplier * 3.8888888888888884,
                      right: SizeConfig.widthMultiplier * 3.8888888888888884,
                      top: SizeConfig.heightMultiplier * 1.2553802008608321),
                  child: Center(
                    child: Row(
                      children: [
                        // Container(
                        //   decoration: BoxDecoration(
                        //     border:
                        //     Border.all(color: AppColors.text_field_container, width: SizeConfig.widthMultiplier * 0.24305555555555552),
                        //     borderRadius: BorderRadius.circular(30),
                        //   ),
                        //   height: SizeConfig.heightMultiplier * 2.5107604017216643,
                        //   width: SizeConfig.widthMultiplier * 4.861111111111111,
                        //   child: Container(
                        //     margin: EdgeInsets.all(2),
                        //     decoration: BoxDecoration(
                        //       color: AppColors.text_field_container,
                        //       borderRadius: BorderRadius.circular(10),
                        //     ),
                        //   ),
                        // ),
                        Container(
                          height:
                              SizeConfig.heightMultiplier * 2.5107604017216643,
                          width: SizeConfig.widthMultiplier * 4.861111111111111,
                          decoration: BoxDecoration(
                            border: Border.all(
                                color: AppColors.text_field_container,
                                width: SizeConfig.widthMultiplier *
                                    0.24305555555555552),
                            borderRadius: BorderRadius.circular(30),
                          ),
                        ),

                        Container(
                          margin: EdgeInsets.only(
                              left: SizeConfig.widthMultiplier *
                                  2.4305555555555554),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                child: Text(
                                  'Visa *********0450',
                                  style: GoogleFonts.inter(
                                      color: AppColors.text_field_container,
                                      fontSize: SizeConfig.textMultiplier *
                                          1.757532281205165,
                                      fontWeight: FontWeight.w700),
                                ),
                              ),
                              Container(
                                child: Column(
                                  children: [
                                    Container(
                                      child: Text(
                                        'John Doe',
                                        style: GoogleFonts.inter(
                                            color:
                                                AppColors.text_field_container,
                                            fontSize:
                                                SizeConfig.textMultiplier *
                                                    1.757532281205165,
                                            fontWeight: FontWeight.w400),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        Spacer(),
                        GestureDetector(
                          onTap: () {
                            setState(() {});
                          },
                          child: Container(
                            height: SizeConfig.heightMultiplier *
                                2.5107604017216643,
                            alignment: Alignment.center,
                            margin: EdgeInsets.only(
                              right: SizeConfig.widthMultiplier *
                                  3.8888888888888884,
                            ),
                            padding: EdgeInsets.only(
                                left: SizeConfig.widthMultiplier *
                                    1.9444444444444442,
                                right: SizeConfig.widthMultiplier *
                                    1.9444444444444442,
                                top: SizeConfig.heightMultiplier *
                                    0.25107604017216645,
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
                              "EDIT",
                              style: TextStyle(
                                color: AppColors.seeAllText,
                                fontSize: SizeConfig.textMultiplier *
                                    1.2553802008608321,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                /*Container(
                  decoration: BoxDecoration(
                    border:
                    Border.all(color: AppColors.appBlue, width: SizeConfig.widthMultiplier * 0.24305555555555552),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  padding: EdgeInsets.all(10),
                  margin: EdgeInsets.only(left: SizeConfig.widthMultiplier * 3.8888888888888884, right: SizeConfig.widthMultiplier * 3.8888888888888884, top: SizeConfig.heightMultiplier * 1.2553802008608321),
                  child: Center(
                    child: Row(
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            border:
                                Border.all(color: AppColors.appBlue, width: SizeConfig.widthMultiplier * 0.24305555555555552),
                            borderRadius: BorderRadius.circular(30),
                          ),
                          height: SizeConfig.heightMultiplier * 2.5107604017216643,
                          width: SizeConfig.widthMultiplier * 4.861111111111111,
                          child: Container(
                            margin: EdgeInsets.all(2),
                            decoration: BoxDecoration(
                              color: AppColors.appBlue,
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                        ),
                        // Container(
                        //   height: SizeConfig.heightMultiplier * 2.5107604017216643,
                        //   width: SizeConfig.widthMultiplier * 4.861111111111111,
                        //   decoration: BoxDecoration(
                        //     border: Border.all(color: AppColors.appBlue, width: SizeConfig.widthMultiplier * 0.24305555555555552),
                        //     borderRadius: BorderRadius.circular(30),
                        //   ),
                        // ),

                        Container(
                          margin: EdgeInsets.only(left: SizeConfig.widthMultiplier * 2.4305555555555554),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                child: Text(
                                  'MasterCard *********0880',
                                  style: GoogleFonts.inter(
                                      color: AppColors.black,
                                      fontSize: SizeConfig.textMultiplier * 1.757532281205165,
                                    fontWeight: FontWeight.w700
                                  ),
                                ),
                              ),
                              Container(
                                child: Column(
                                  children: [
                                    Container(
                                      child: Text(
                                        'John Doe',
                                        style: GoogleFonts.inter(
                                            color: AppColors.text_field_container,
                                            fontSize: SizeConfig.textMultiplier * 1.757532281205165,
                                            fontWeight: FontWeight.w400
                                        ),
                                      ),
                                    ),
                            ],
                          ),
                        ),

                            ],
                          ),
                        ),
                        Spacer(),
                        GestureDetector(
                          onTap: () {
                            setState(() {

                            });
                          },
                          child: Container(
                            height: SizeConfig.heightMultiplier * 2.5107604017216643,
                            alignment: Alignment.center,
                            margin: EdgeInsets.only(
                              right: SizeConfig.widthMultiplier * 3.8888888888888884,
                            ),
                            padding: EdgeInsets.only(left: SizeConfig.widthMultiplier * 1.9444444444444442, right: SizeConfig.widthMultiplier * 1.9444444444444442, top: SizeConfig.heightMultiplier * 0.25107604017216645, bottom: SizeConfig.heightMultiplier * 0.25107604017216645),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(color: AppColors.seeAllText, width: SizeConfig.widthMultiplier * 0.24305555555555552),
                                color: AppColors.seeAllBack),
                            child: Text(
                              "EDIT",
                              style: TextStyle(
                                color: AppColors.seeAllText,
                                fontSize: SizeConfig.textMultiplier * 1.2553802008608321,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),*/

                GestureDetector(
                  onTap: () {},
                  child: Container(
                      margin: EdgeInsets.only(
                          top: SizeConfig.heightMultiplier * 2.0086083213773316,
                          right:
                              SizeConfig.widthMultiplier * 3.8888888888888884,
                          left:
                              SizeConfig.widthMultiplier * 3.8888888888888884),
                      height: SizeConfig.heightMultiplier * 6.276901004304161,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: AppColors.appBlue)),
                      child: Row(
                        children: [
                          Container(
                            width:
                                SizeConfig.widthMultiplier * 5.833333333333333,
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
                                  bottom: SizeConfig.heightMultiplier *
                                      1.5064562410329987),
                              child: Text(
                                "Add new card",
                                style: GoogleFonts.inter(
                                    fontSize: SizeConfig.textMultiplier *
                                        1.757532281205165,
                                    fontWeight: FontWeight.w400,
                                    color: AppColors.appBlue,
                                    letterSpacing: 0.25,
                                    textStyle: TextStyle(fontFamily: 'Roboto')),
                              )),
                        ],
                      )),
                ),
                GestureDetector(
                  onTap: () {},
                  child: Card(
                      elevation: 5,
                      margin: EdgeInsets.only(
                          top: SizeConfig.heightMultiplier * 2.0086083213773316,
                          right:
                              SizeConfig.widthMultiplier * 3.8888888888888884,
                          left:
                              SizeConfig.widthMultiplier * 3.8888888888888884),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Container(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(
                              color: AppColors.cancel_red,
                            )),
                        height: SizeConfig.heightMultiplier * 6.276901004304161,
                        child: Row(
                          children: [
                            Container(
                              width: SizeConfig.widthMultiplier *
                                  1.2152777777777777,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(10),
                                    bottomLeft: Radius.circular(10)),
                                color: AppColors.cancel_red,
                              ),
                            ),
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
                                Icons.error_outline,
                                color: AppColors.cancel_red,
                                size: 14,
                              ),
                            ),
                            Container(
                                margin: EdgeInsets.only(
                                    top: SizeConfig.heightMultiplier *
                                        1.5064562410329987,
                                    left: SizeConfig.widthMultiplier *
                                        2.6736111111111107,
                                    bottom: SizeConfig.heightMultiplier *
                                        1.5064562410329987),
                                child: Text(
                                  "You need to upload a file",
                                  style: GoogleFonts.inter(
                                      fontSize: SizeConfig.textMultiplier *
                                          1.757532281205165,
                                      fontWeight: FontWeight.w400,
                                      color: AppColors.cancel_red,
                                      letterSpacing: 0.25,
                                      textStyle:
                                          TextStyle(fontFamily: 'Roboto')),
                                )),
                            Spacer(),
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
                                      1.2553802008608321,
                                  right: SizeConfig.widthMultiplier *
                                      2.4305555555555554),
                              child: Icon(
                                Icons.clear,
                                color: AppColors.cancel_red,
                                size: 14,
                              ),
                            ),
                          ],
                        ),
                      )),
                ),
              ],
            )),
      ),
    );
  }

  void _showBankDetailsSheet() {
    showMaterialModalBottomSheet(
        context: context,
        elevation: 5,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            topRight: Radius.circular(30),
            topLeft: Radius.circular(30),
          ),
        ),
        builder: (context) {
          return StatefulBuilder(
              builder: (BuildContext context, StateSetter setState
                  /*You can rename this!*/) {
            return SingleChildScrollView(
              controller: ModalScrollController.of(context),
              child: Container(
                  margin: EdgeInsets.only(
                      bottom: SizeConfig.heightMultiplier * 3.7661406025824964),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                          margin: EdgeInsets.only(
                              left: SizeConfig.widthMultiplier *
                                  4.861111111111111,
                              top: SizeConfig.heightMultiplier *
                                  1.8830703012912482),
                          child: Text(
                            "Bank",
                            style: GoogleFonts.inter(
                              fontSize:
                                  SizeConfig.textMultiplier * 2.259684361549498,
                              fontWeight: FontWeight.w700,
                            ),
                          )),
                      Container(
                          margin: EdgeInsets.only(
                              left: SizeConfig.widthMultiplier *
                                  4.861111111111111,
                              top: SizeConfig.heightMultiplier *
                                  1.8830703012912482),
                          child: Text(
                            "My Account",
                            style: GoogleFonts.inter(
                                fontSize: SizeConfig.textMultiplier *
                                    1.757532281205165,
                                fontWeight: FontWeight.w400,
                                letterSpacing: 0.25),
                          )),
                      if (_accountNumber != null)
                        Container(
                          decoration: BoxDecoration(
                            border: Border.all(
                                color: AppColors.appBlue,
                                width: SizeConfig.widthMultiplier *
                                    0.24305555555555552),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          padding: EdgeInsets.all(10),
                          margin: EdgeInsets.only(
                              left: SizeConfig.widthMultiplier *
                                  3.8888888888888884,
                              right: SizeConfig.widthMultiplier *
                                  3.8888888888888884,
                              top: SizeConfig.heightMultiplier *
                                  1.2553802008608321),
                          child: Center(
                            child: Row(
                              children: [
                                Container(
                                  height: SizeConfig.heightMultiplier *
                                      2.5107604017216643,
                                  width: SizeConfig.widthMultiplier *
                                      4.861111111111111,
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                        color: AppColors.appBlue,
                                        width: SizeConfig.widthMultiplier *
                                            0.24305555555555552),
                                    borderRadius: BorderRadius.circular(30),
                                  ),
                                  child: Container(
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(30),
                                        color: AppColors.appBlue),
                                    margin: EdgeInsets.all(2),
                                  ),
                                ),
                                Container(
                                  margin: EdgeInsets.only(
                                      left: SizeConfig.widthMultiplier *
                                          2.4305555555555554),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Container(
                                        child: _bankLoading
                                            ? Lottie.asset(
                                                'assets/loader/simple_loading.json',
                                                height: SizeConfig
                                                        .heightMultiplier *
                                                    1.757532281205165,
                                                width:
                                                    SizeConfig.widthMultiplier *
                                                        36.45833333333333)
                                            : Text(
                                                "Saving Account : $_accountNumber" ??
                                                    "",
                                                style: GoogleFonts.inter(
                                                    color: AppColors
                                                        .text_field_container,
                                                    fontSize: SizeConfig
                                                            .textMultiplier *
                                                        1.757532281205165,
                                                    fontWeight:
                                                        FontWeight.w700),
                                              ),
                                      ),
                                      Container(
                                        child: _bankLoading
                                            ? Lottie.asset(
                                                'assets/loader/simple_loading.json',
                                                height: SizeConfig
                                                        .heightMultiplier *
                                                    1.757532281205165,
                                                width:
                                                    SizeConfig.widthMultiplier *
                                                        36.45833333333333)
                                            : Text(
                                                _accountName ?? "",
                                                style: GoogleFonts.inter(
                                                    color: AppColors
                                                        .text_field_container,
                                                    fontSize: SizeConfig
                                                            .textMultiplier *
                                                        1.757532281205165,
                                                    fontWeight:
                                                        FontWeight.w400),
                                              ),
                                      ),
                                      // Container(
                                      //   child: Row(
                                      //     children: [
                                      //       Container(
                                      //         height: SizeConfig.heightMultiplier * 1.2553802008608321,
                                      //         width: SizeConfig.widthMultiplier * 2.4305555555555554,
                                      //         decoration: BoxDecoration(
                                      //             borderRadius:
                                      //             BorderRadius.circular(20),
                                      //             color: AppColors.pendingColor),
                                      //       ),
                                      // Container(
                                      //   margin: EdgeInsets.only(left: SizeConfig.widthMultiplier * 1.2152777777777777),
                                      //   child: Text(
                                      //     'Confirmation pending',
                                      //     style: GoogleFonts.inter(
                                      //         color: AppColors.pendingColor,
                                      //         fontSize: SizeConfig.textMultiplier * 1.757532281205165,
                                      //         fontWeight: FontWeight.w400),
                                      //   ),
                                      // ),
                                      // ],
                                      // ),
                                      // )
                                    ],
                                  ),
                                ),
                                // Spacer(),
                                // GestureDetector(
                                //   onTap: () {
                                //     setState(() {
                                //       _editBankDetails = true;
                                //       Navigator.pop(context);
                                //       slideIndex = 0;
                                //       _showAddBankDetailsSheet();
                                //     });
                                //   },
                                //   child: Container(
                                //     height: SizeConfig.heightMultiplier * 2.5107604017216643,
                                //     alignment: Alignment.center,
                                //     margin: EdgeInsets.only(
                                //       right: SizeConfig.widthMultiplier * 3.8888888888888884,
                                //     ),
                                //     padding: EdgeInsets.only(
                                //         left: SizeConfig.widthMultiplier * 1.9444444444444442, right: SizeConfig.widthMultiplier * 1.9444444444444442, top: SizeConfig.heightMultiplier * 0.25107604017216645, bottom: SizeConfig.heightMultiplier * 0.25107604017216645),
                                //     decoration: BoxDecoration(
                                //         borderRadius: BorderRadius.circular(10),
                                //         border: Border.all(
                                //             color: AppColors.seeAllText,
                                //             width: SizeConfig.widthMultiplier * 0.24305555555555552),
                                //         color: AppColors.seeAllBack),
                                //     child: Text(
                                //       "EDIT",
                                //       style: TextStyle(
                                //         color: AppColors.seeAllText,
                                //         fontSize: SizeConfig.textMultiplier * 1.2553802008608321,
                                //       ),
                                //     ),
                                //   ),
                                // ),
                              ],
                            ),
                          ),
                        ),

                      // GestureDetector(
                      //   onTap: () {},
                      //   child: Card(
                      //       elevation: 5,
                      //       margin: EdgeInsets.only(top: SizeConfig.heightMultiplier * 2.0086083213773316, right: SizeConfig.widthMultiplier * 3.8888888888888884, left: SizeConfig.widthMultiplier * 3.8888888888888884),
                      //       shape: RoundedRectangleBorder(
                      //         borderRadius: BorderRadius.circular(10),
                      //       ),
                      //       child: Container(
                      //         decoration: BoxDecoration(
                      //             borderRadius: BorderRadius.circular(10),
                      //             border: Border.all(
                      //               color: AppColors.cancel_red,
                      //             )),
                      //         height: SizeConfig.heightMultiplier * 6.276901004304161,
                      //         child: Row(
                      //           children: [
                      //             Container(
                      //               width: SizeConfig.widthMultiplier * 1.2152777777777777,
                      //               decoration: BoxDecoration(
                      //                 borderRadius: BorderRadius.only(
                      //                     topLeft: Radius.circular(10),
                      //                     bottomLeft: Radius.circular(10)),
                      //                 color: AppColors.cancel_red,
                      //               ),
                      //             ),
                      //             Container(
                      //               width: SizeConfig.widthMultiplier * 5.833333333333333,
                      //               height: SizeConfig.heightMultiplier * 3.0129124820659974,
                      //               margin: EdgeInsets.only(
                      //                   top: SizeConfig.heightMultiplier * 1.2553802008608321, left: SizeConfig.widthMultiplier * 3.645833333333333, bottom: SizeConfig.heightMultiplier * 1.2553802008608321),
                      //               child: Icon(
                      //                 Icons.error_outline,
                      //                 color: AppColors.cancel_red,
                      //                 size: 14,
                      //               ),
                      //             ),
                      //             Container(
                      //                 margin: EdgeInsets.only(
                      //                     top: SizeConfig.heightMultiplier * 1.5064562410329987, left: SizeConfig.widthMultiplier * 2.6736111111111107, bottom: SizeConfig.heightMultiplier * 1.5064562410329987),
                      //                 child: Text(
                      //                   "You need to upload a file",
                      //                   style: GoogleFonts.inter(
                      //                       fontSize: SizeConfig.textMultiplier * 1.757532281205165,
                      //                       fontWeight: FontWeight.w400,
                      //                       color: AppColors.cancel_red,
                      //                       letterSpacing: 0.25,
                      //                       textStyle:
                      //                       TextStyle(fontFamily: 'Roboto')),
                      //                 )),
                      //             Spacer(),
                      //             Container(
                      //               width: SizeConfig.widthMultiplier * 5.833333333333333,
                      //               height: SizeConfig.heightMultiplier * 3.0129124820659974,
                      //               margin: EdgeInsets.only(
                      //                   top: SizeConfig.heightMultiplier * 1.2553802008608321, left: SizeConfig.widthMultiplier * 3.645833333333333, bottom: SizeConfig.heightMultiplier * 1.2553802008608321, right: SizeConfig.widthMultiplier * 2.4305555555555554),
                      //               child: Icon(
                      //                 Icons.clear,
                      //                 color: AppColors.cancel_red,
                      //                 size: 14,
                      //               ),
                      //             ),
                      //           ],
                      //         ),
                      //       )),
                      // ),
                      if (_accountNumber == null)
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              _editBankDetails = false;
                              Navigator.pop(context);
                              slideIndex = 0;
                              _showAddBankDetailsSheet();
                            });
                          },
                          child: Container(
                              margin: EdgeInsets.only(
                                  top: SizeConfig.heightMultiplier *
                                      2.0086083213773316,
                                  right: SizeConfig.widthMultiplier *
                                      3.8888888888888884,
                                  left: SizeConfig.widthMultiplier *
                                      3.8888888888888884),
                              height: SizeConfig.heightMultiplier *
                                  6.276901004304161,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  border: Border.all(color: AppColors.appBlue)),
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
                                          bottom: SizeConfig.heightMultiplier *
                                              1.5064562410329987),
                                      child: Text(
                                        "Add account",
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
                      if (_accountNumber != null)
                        Container(
                          child: Row(
                            children: [
                              GestureDetector(
                                behavior: HitTestBehavior.translucent,
                                onTap: () {
                                  setState(() {
                                    _removeAccountLoading = true;
                                    _AddNewSendingBloc.add(
                                        RemoveBankAccountEvent());
                                  });
                                },
                                child: Container(
                                  color: AppColors.white,
                                  width:
                                      MediaQuery.of(context).size.width * 0.4,
                                  child: Container(
                                    margin: EdgeInsets.only(
                                        left: SizeConfig.widthMultiplier *
                                            3.8888888888888884,
                                        bottom: SizeConfig.heightMultiplier *
                                            2.5107604017216643,
                                        top: SizeConfig.heightMultiplier *
                                            1.2553802008608321),
                                    height: SizeConfig.heightMultiplier *
                                        6.276901004304161,
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10),
                                        border: Border.all(
                                            color: AppColors.cancel_red)),
                                    child: Center(
                                      child: _removeAccountLoading
                                          ? Lottie.asset(
                                              'assets/loader/widget_loading.json',
                                              height:
                                                  SizeConfig.heightMultiplier *
                                                      2.5107604017216643,
                                              width:
                                                  SizeConfig.widthMultiplier *
                                                      12.152777777777777)
                                          : Text(
                                              "Remove account",
                                              style: GoogleFonts.roboto(
                                                  fontSize: SizeConfig
                                                          .textMultiplier *
                                                      1.757532281205165,
                                                  fontWeight: FontWeight.w700,
                                                  color: AppColors.cancel_red,
                                                  letterSpacing: 0.5,
                                                  textStyle: TextStyle(
                                                      fontFamily: 'Roboto')),
                                            ),
                                    ),
                                  ),
                                ),
                              ),
                              Spacer(),
                              GestureDetector(
                                behavior: HitTestBehavior.translucent,
                                onTap: () {
                                  Navigator.pop(context);
                                },
                                child: Container(
                                  color: AppColors.white,
                                  width: _accountNumber != null
                                      ? MediaQuery.of(context).size.width * 0.4
                                      : MediaQuery.of(context).size.width,
                                  child: Container(
                                    margin: EdgeInsets.only(
                                        right: SizeConfig.widthMultiplier *
                                            3.8888888888888884,
                                        bottom: SizeConfig.heightMultiplier *
                                            2.5107604017216643,
                                        top: SizeConfig.heightMultiplier *
                                            1.2553802008608321),
                                    height: SizeConfig.heightMultiplier *
                                        6.276901004304161,
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10),
                                        border: Border.all(
                                            color: AppColors.app_orange)),
                                    child: Center(
                                      child: Text(
                                        _l10n.close,
                                        style: GoogleFonts.roboto(
                                            fontSize:
                                                SizeConfig.textMultiplier *
                                                    1.757532281205165,
                                            fontWeight: FontWeight.w700,
                                            color: AppColors.app_orange,
                                            letterSpacing: 0.5,
                                            textStyle: TextStyle(
                                                fontFamily: 'Roboto')),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                    ],
                  )),
            );
          });
        });
  }

  void _showAddBankDetailsSheet() async {
    String _accountNum = "";
    _phoneController.clear();
    _bsbController.clear();
    _cityController.clear();
    _addressOneController.clear();
    _addressTwoController.clear();
    _lastNameController.clear();
    _accountController.clear();
    showMaterialModalBottomSheet(
        context: context,
        elevation: 5,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                topRight: Radius.circular(30), topLeft: Radius.circular(30))),
        builder: (context) {
          return StatefulBuilder(
              builder: (BuildContext context, StateSetter setState) {
            return SingleChildScrollView(
                controller: ModalScrollController.of(context),
                child: Stack(
                  children: [
                    Container(
                        height: MediaQuery.of(context).size.height * 0.9,
                        child: PageView(
                          controller: _pageController,
                          physics: NeverScrollableScrollPhysics(),
                          onPageChanged: (index) {
                            setState(() {});
                          },
                          children: [
                            _addBankScreenOne(),
                            // if (!_editBankDetails) _addBankScreen2(),
                            // if (!_editBankDetails) _addBankScreen3(_accountNum),
                          ],
                        )),
                    Positioned(
                        top: MediaQuery.of(context).size.height * 0.75,
                        left: SizeConfig.widthMultiplier * 0.0,
                        right: SizeConfig.widthMultiplier * 0.0,
                        child: GestureDetector(
                          behavior: HitTestBehavior.translucent,
                          onTap: () {
                            setState(() {
                              if (_pageController.page == 0 &&
                                  _countryController.text == "China") {
                                if (_bsbController.text.length == 0 &&
                                    _lastNameController.text.length == 0) {
                                  _showToast(
                                      "Please enter first and last name");
                                } else if (_accountController.text.length ==
                                    0) {
                                  _showToast("Please enter account number");
                                } else if (_addressOneController.text.length ==
                                    0) {
                                  _showToast("Please enter bank name ");
                                } else if (_addressTwoController.text.length ==
                                    0) {
                                  _showToast("Please enter branch name ");
                                } else if (_cityController.text.length == 0) {
                                  _showToast("Please enter bank city");
                                } else if (_phoneController.text.length == 0) {
                                  _showToast("Please enter bank province");
                                } else {
                                  BankDetailsRequestModel model =
                                      BankDetailsRequestModel();
                                  model.country = _countryController.text;
                                  model.name =
                                      "${_bsbController.text} ${_lastNameController.text}";
                                  model.accountNum = _accountController.text;
                                  model.name =
                                      "${_bsbController.text} ${_lastNameController.text}";
                                  model.bankName = _addressOneController.text;
                                  model.bankCity = _cityController.text;
                                  model.branchName = _addressTwoController.text;
                                  model.bankProvince = _phoneController.text;
                                  _AddNewSendingBloc.bankDetailsRequestModel =
                                      model;
                                  _confirmLoading = true;
                                  _AddNewSendingBloc.add(
                                      SaveBankDetailsEvent());
                                  // _pageController.jumpToPage(1);
                                }
                              } else if (_pageController.page == 0 &&
                                  _countryController.text == "Australia") {
                                if (_bsbController.text.length == 0) {
                                  _showToast("Please enter BSB");
                                } else if (_accountController.text.length ==
                                    0) {
                                  _showToast("Please enter account number");
                                } else if (_addressOneController.text.length ==
                                    0) {
                                  _showToast("Please enter address one ");
                                } else if (_addressTwoController.text.length ==
                                    0) {
                                  _showToast("Please enter address two");
                                } else if (_cityController.text.length == 0) {
                                  _showToast("Please enter city");
                                } else {
                                  BankDetailsRequestModel model =
                                      BankDetailsRequestModel();
                                  model.country = _countryController.text;
                                  model.bsb = _bsbController.text;
                                  model.accountNum = _accountController.text;
                                  model.bankAddressOne =
                                      _addressOneController.text;
                                  model.bankAddressTwo =
                                      _addressTwoController.text;
                                  model.bankCity = _cityController.text;
                                  _AddNewSendingBloc.bankDetailsRequestModel =
                                      model;
                                  _confirmLoading = true;
                                  _AddNewSendingBloc.add(
                                      SaveBankDetailsEvent());
                                  // slideIndex = 1;
                                  // _pageController.jumpToPage(1);
                                }
                              } else if (_pageController.page == 1) {
                                // slideIndex = 2;
                                _AddNewSendingBloc.add(BankStatusEvent());
                                // _pageController.jumpToPage(2);
                              } else if (_pageController.page == 2) {
                                Navigator.pop(context);
                              }
                            });
                          },
                          child: Container(
                            width: MediaQuery.of(context).size.width,
                            height:
                                SizeConfig.heightMultiplier * 6.025824964131995,
                            margin: EdgeInsets.only(
                                top: SizeConfig.heightMultiplier *
                                    2.5107604017216643,
                                left: SizeConfig.widthMultiplier *
                                    3.8888888888888884,
                                right: SizeConfig.widthMultiplier *
                                    3.8888888888888884),
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
                                    _l10n.confirm,
                                    style: GoogleFonts.inter(
                                        color: AppColors.white,
                                        fontWeight: FontWeight.bold,
                                        fontSize: SizeConfig.textMultiplier *
                                            1.757532281205165,
                                        letterSpacing: 0.5,
                                        textStyle:
                                            TextStyle(fontFamily: 'Roboto')),
                                  )),
                            ),
                          ),
                        )),
                    if (_editBankDetails)
                      Positioned(
                          top: MediaQuery.of(context).size.height * 0.8,
                          right: SizeConfig.widthMultiplier * 0.0,
                          left: SizeConfig.widthMultiplier * 0.0,
                          child: GestureDetector(
                              onTap: () {
                                setState(() {});
                              },
                              child: Container(
                                  height: SizeConfig.heightMultiplier *
                                      6.276901004304161,
                                  width: MediaQuery.of(context).size.width,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      border: Border.all(
                                          color: AppColors.cancel_red)),
                                  margin: EdgeInsets.only(
                                      left: SizeConfig.widthMultiplier *
                                          3.8888888888888884,
                                      right: SizeConfig.widthMultiplier *
                                          3.8888888888888884,
                                      top: SizeConfig.heightMultiplier *
                                          3.0129124820659974),
                                  child: Center(
                                    child: Text(
                                      "REMOVE ACCOUNT",
                                      style: GoogleFonts.inter(
                                          fontSize: SizeConfig.textMultiplier *
                                              1.757532281205165,
                                          fontWeight: FontWeight.w700,
                                          letterSpacing: 0.1,
                                          color: AppColors.cancel_red),
                                    ),
                                  )))),
                    // if (!_editBankDetails)
                    //   Positioned(
                    //     top: MediaQuery.of(context).size.height * 0.62,
                    //     left: MediaQuery.of(context).size.width * 0.45,
                    //     child: _bottomSheet(true),
                    //   ),
                  ],
                ));
          });
        });
  }

  Widget _addBankScreenOne() {
    return StatefulBuilder(
        builder: (BuildContext context, StateSetter setState) {
      return Container(
          margin: EdgeInsets.only(
              bottom: SizeConfig.heightMultiplier * 3.7661406025824964),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                  margin: EdgeInsets.only(
                      left: SizeConfig.widthMultiplier * 4.861111111111111,
                      top: SizeConfig.heightMultiplier * 1.8830703012912482),
                  child: Text(
                    "Add new bank account",
                    style: GoogleFonts.inter(
                      fontSize: SizeConfig.textMultiplier * 2.259684361549498,
                      fontWeight: FontWeight.w700,
                    ),
                  )),
              Container(
                margin: EdgeInsets.only(
                    top: SizeConfig.heightMultiplier * 3.0129124820659974,
                    left: SizeConfig.widthMultiplier * 3.8888888888888884,
                    right: SizeConfig.widthMultiplier * 3.8888888888888884),
                height: SizeConfig.heightMultiplier * 5.523672883787662,
                width: MediaQuery.of(context).size.width,
                child: Theme(
                  data: ThemeData(
                    primaryColor: AppColors.appBlue,
                    primaryColorDark: AppColors.appBlue,
                  ),
                  child: TextField(
                    keyboardType: TextInputType.phone,
                    key: _productTypeKey,
                    controller: _countryController,
                    readOnly: true,
                    showCursor: false,
                    onTap: () {
                      setState(() {
                        this._overlayEntry = this._createOverlayEntry(
                            _countryList, _productTypeKey, _countryController);
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
                            borderSide: BorderSide(
                                color: AppColors.appBlue,
                                width: SizeConfig.widthMultiplier *
                                    0.12152777777777776),
                            borderRadius: BorderRadius.circular(10.0)),
                        contentPadding: EdgeInsets.only(
                            left: SizeConfig.widthMultiplier *
                                3.8888888888888884),
                        hintText: 'Australia',
                        suffixStyle: const TextStyle(color: AppColors.appBlue)),
                  ),
                ),
              ),
              Container(
                margin: EdgeInsets.only(
                    top: SizeConfig.heightMultiplier * 1.2553802008608321,
                    left: SizeConfig.widthMultiplier * 3.8888888888888884,
                    right: SizeConfig.widthMultiplier * 3.8888888888888884),
                height: SizeConfig.heightMultiplier * 5.523672883787662,
                width: MediaQuery.of(context).size.width,
                child: Theme(
                  data: ThemeData(
                    primaryColor: AppColors.appBlue,
                    primaryColorDark: AppColors.appBlue,
                  ),
                  child: TextField(
                    keyboardType: TextInputType.text,
                    controller: _bsbController,
                    style: GoogleFonts.inter(
                        fontWeight: FontWeight.w400,
                        fontSize: SizeConfig.textMultiplier * 1.757532281205165,
                        letterSpacing: 0.1,
                        color: AppColors.app_txt_color),
                    decoration: InputDecoration(
                        border: OutlineInputBorder(
                            borderSide: BorderSide(
                                color: AppColors.appBlue,
                                width: SizeConfig.widthMultiplier *
                                    0.12152777777777776),
                            borderRadius: BorderRadius.circular(10.0)),
                        contentPadding: EdgeInsets.only(
                            left: SizeConfig.widthMultiplier *
                                3.8888888888888884),
                        hintText:
                            _selectedItem == "China" ? "FirstName" : 'BSB',
                        suffixStyle: const TextStyle(color: AppColors.appBlue)),
                  ),
                ),
              ),
              if (_selectedItem == "China")
                Container(
                  margin: EdgeInsets.only(
                      top: SizeConfig.heightMultiplier * 1.2553802008608321,
                      left: SizeConfig.widthMultiplier * 3.8888888888888884,
                      right: SizeConfig.widthMultiplier * 3.8888888888888884),
                  height: SizeConfig.heightMultiplier * 5.523672883787662,
                  width: MediaQuery.of(context).size.width,
                  child: Theme(
                    data: ThemeData(
                      primaryColor: AppColors.appBlue,
                      primaryColorDark: AppColors.appBlue,
                    ),
                    child: TextField(
                      keyboardType: TextInputType.text,
                      controller: _lastNameController,
                      style: GoogleFonts.inter(
                          fontWeight: FontWeight.w400,
                          fontSize:
                              SizeConfig.textMultiplier * 1.757532281205165,
                          letterSpacing: 0.1,
                          color: AppColors.app_txt_color),
                      decoration: InputDecoration(
                          border: OutlineInputBorder(
                              borderSide: BorderSide(
                                  color: AppColors.appBlue,
                                  width: SizeConfig.widthMultiplier *
                                      0.12152777777777776),
                              borderRadius: BorderRadius.circular(10.0)),
                          contentPadding: EdgeInsets.only(
                              left: SizeConfig.widthMultiplier *
                                  3.8888888888888884),
                          hintText: 'Last name',
                          suffixStyle:
                              const TextStyle(color: AppColors.appBlue)),
                    ),
                  ),
                ),
              Container(
                margin: EdgeInsets.only(
                    top: SizeConfig.heightMultiplier * 1.2553802008608321,
                    left: SizeConfig.widthMultiplier * 3.8888888888888884,
                    right: SizeConfig.widthMultiplier * 3.8888888888888884),
                height: SizeConfig.heightMultiplier * 5.523672883787662,
                width: MediaQuery.of(context).size.width,
                child: Theme(
                  data: ThemeData(
                    primaryColor: AppColors.appBlue,
                    primaryColorDark: AppColors.appBlue,
                  ),
                  child: TextField(
                    keyboardType: TextInputType.text,
                    controller: _accountController,
                    style: GoogleFonts.inter(
                        fontWeight: FontWeight.w400,
                        fontSize: SizeConfig.textMultiplier * 1.757532281205165,
                        letterSpacing: 0.1,
                        color: AppColors.app_txt_color),
                    decoration: InputDecoration(
                        border: OutlineInputBorder(
                            borderSide: BorderSide(
                                color: AppColors.appBlue,
                                width: SizeConfig.widthMultiplier *
                                    0.12152777777777776),
                            borderRadius: BorderRadius.circular(10.0)),
                        contentPadding: EdgeInsets.only(
                            left: SizeConfig.widthMultiplier *
                                3.8888888888888884),
                        hintText: 'Account number',
                        suffixStyle: const TextStyle(color: AppColors.appBlue)),
                  ),
                ),
              ),
              Container(
                margin: EdgeInsets.only(
                    top: SizeConfig.heightMultiplier * 1.2553802008608321,
                    left: SizeConfig.widthMultiplier * 3.8888888888888884,
                    right: SizeConfig.widthMultiplier * 3.8888888888888884),
                height: SizeConfig.heightMultiplier * 5.523672883787662,
                width: MediaQuery.of(context).size.width,
                child: Theme(
                  data: ThemeData(
                    primaryColor: AppColors.appBlue,
                    primaryColorDark: AppColors.appBlue,
                  ),
                  child: TextField(
                    keyboardType: TextInputType.text,
                    controller: _addressOneController,
                    style: GoogleFonts.inter(
                        fontWeight: FontWeight.w400,
                        fontSize: SizeConfig.textMultiplier * 1.757532281205165,
                        letterSpacing: 0.1,
                        color: AppColors.app_txt_color),
                    decoration: InputDecoration(
                        border: OutlineInputBorder(
                            borderSide: BorderSide(
                                color: AppColors.appBlue,
                                width: SizeConfig.widthMultiplier *
                                    0.12152777777777776),
                            borderRadius: BorderRadius.circular(10.0)),
                        contentPadding: EdgeInsets.only(
                            left: SizeConfig.widthMultiplier *
                                3.8888888888888884),
                        hintText: _countryController.text == "China"
                            ? "Bank name"
                            : 'Address one',
                        suffixStyle: const TextStyle(color: AppColors.appBlue)),
                  ),
                ),
              ),
              Container(
                margin: EdgeInsets.only(
                    top: SizeConfig.heightMultiplier * 1.2553802008608321,
                    left: SizeConfig.widthMultiplier * 3.8888888888888884,
                    right: SizeConfig.widthMultiplier * 3.8888888888888884),
                height: SizeConfig.heightMultiplier * 5.523672883787662,
                width: MediaQuery.of(context).size.width,
                child: Theme(
                  data: ThemeData(
                    primaryColor: AppColors.appBlue,
                    primaryColorDark: AppColors.appBlue,
                  ),
                  child: TextField(
                    keyboardType: TextInputType.text,
                    controller: _addressTwoController,
                    style: GoogleFonts.inter(
                        fontWeight: FontWeight.w400,
                        fontSize: SizeConfig.textMultiplier * 1.757532281205165,
                        letterSpacing: 0.1,
                        color: AppColors.app_txt_color),
                    decoration: InputDecoration(
                        border: OutlineInputBorder(
                            borderSide: BorderSide(
                                color: AppColors.appBlue,
                                width: SizeConfig.widthMultiplier *
                                    0.12152777777777776),
                            borderRadius: BorderRadius.circular(10.0)),
                        contentPadding: EdgeInsets.only(
                            left: SizeConfig.widthMultiplier *
                                3.8888888888888884),
                        hintText: _countryController.text == "China"
                            ? "Branch name"
                            : 'Address two',
                        suffixStyle: const TextStyle(color: AppColors.appBlue)),
                  ),
                ),
              ),
              Container(
                margin: EdgeInsets.only(
                    top: SizeConfig.heightMultiplier * 1.2553802008608321,
                    left: SizeConfig.widthMultiplier * 3.8888888888888884,
                    right: SizeConfig.widthMultiplier * 3.8888888888888884),
                height: SizeConfig.heightMultiplier * 5.523672883787662,
                width: MediaQuery.of(context).size.width,
                child: Theme(
                  data: ThemeData(
                    primaryColor: AppColors.appBlue,
                    primaryColorDark: AppColors.appBlue,
                  ),
                  child: TextField(
                    keyboardType: TextInputType.text,
                    controller: _cityController,
                    style: GoogleFonts.inter(
                        fontWeight: FontWeight.w400,
                        fontSize: SizeConfig.textMultiplier * 1.757532281205165,
                        letterSpacing: 0.1,
                        color: AppColors.app_txt_color),
                    decoration: InputDecoration(
                        border: OutlineInputBorder(
                            borderSide: BorderSide(
                                color: AppColors.appBlue,
                                width: SizeConfig.widthMultiplier *
                                    0.12152777777777776),
                            borderRadius: BorderRadius.circular(10.0)),
                        contentPadding: EdgeInsets.only(
                            left: SizeConfig.widthMultiplier *
                                3.8888888888888884),
                        hintText: _countryController.text == "China"
                            ? "Bank City"
                            : 'City',
                        suffixStyle: const TextStyle(color: AppColors.appBlue)),
                  ),
                ),
              ),
              if (_countryController.text == "China")
                Container(
                  margin: EdgeInsets.only(
                      top: SizeConfig.heightMultiplier * 1.2553802008608321,
                      left: SizeConfig.widthMultiplier * 3.8888888888888884,
                      right: SizeConfig.widthMultiplier * 3.8888888888888884),
                  height: SizeConfig.heightMultiplier * 5.523672883787662,
                  width: MediaQuery.of(context).size.width,
                  child: Theme(
                    data: ThemeData(
                      primaryColor: AppColors.appBlue,
                      primaryColorDark: AppColors.appBlue,
                    ),
                    child: TextField(
                      keyboardType: TextInputType.text,
                      controller: _phoneController,
                      style: GoogleFonts.inter(
                          fontWeight: FontWeight.w400,
                          fontSize:
                              SizeConfig.textMultiplier * 1.757532281205165,
                          letterSpacing: 0.1,
                          color: AppColors.app_txt_color),
                      decoration: InputDecoration(
                          border: OutlineInputBorder(
                              borderSide: BorderSide(
                                  color: AppColors.appBlue,
                                  width: SizeConfig.widthMultiplier *
                                      0.12152777777777776),
                              borderRadius: BorderRadius.circular(10.0)),
                          contentPadding: EdgeInsets.only(
                              left: SizeConfig.widthMultiplier *
                                  3.8888888888888884),
                          hintText: 'Bank province',
                          suffixStyle:
                              const TextStyle(color: AppColors.appBlue)),
                    ),
                  ),
                ),
            ],
          ));
    });
  }

  Widget _addBankScreen2() {
    return Container(
        margin: EdgeInsets.only(
            bottom: SizeConfig.heightMultiplier * 3.7661406025824964),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Container(
              margin: EdgeInsets.only(
                  left: SizeConfig.widthMultiplier * 4.861111111111111,
                  top: SizeConfig.heightMultiplier * 1.8830703012912482),
              child: Text(
                "Add new bank account",
                style: GoogleFonts.inter(
                  fontSize: SizeConfig.textMultiplier * 2.259684361549498,
                  fontWeight: FontWeight.w700,
                ),
              )),
          Container(
              margin: EdgeInsets.only(
                  left: SizeConfig.widthMultiplier * 4.861111111111111,
                  top: SizeConfig.heightMultiplier * 1.8830703012912482),
              child: Text(
                "Please upload an e-statement so we can certify it’s you.",
                style: GoogleFonts.inter(
                    fontSize: SizeConfig.textMultiplier * 1.757532281205165,
                    fontWeight: FontWeight.w400,
                    letterSpacing: 0.25),
              )),
          Container(
            margin: EdgeInsets.only(
                top: SizeConfig.heightMultiplier * 1.2553802008608321,
                left: SizeConfig.widthMultiplier * 3.8888888888888884,
                right: SizeConfig.widthMultiplier * 3.8888888888888884),
            height: SizeConfig.heightMultiplier * 5.523672883787662,
            width: MediaQuery.of(context).size.width,
            child: Theme(
              data: ThemeData(
                primaryColor: AppColors.appBlue,
                primaryColorDark: AppColors.appBlue,
              ),
              child: TextField(
                keyboardType: TextInputType.phone,
                readOnly: true,
                showCursor: false,
                style: GoogleFonts.inter(
                    fontWeight: FontWeight.w400,
                    fontSize: SizeConfig.textMultiplier * 1.757532281205165,
                    letterSpacing: 0.1,
                    color: AppColors.app_txt_color),
                decoration: InputDecoration(
                    suffixIcon: GestureDetector(
                        onTap: () {
                          _fileUploading = true;
                          _AddNewSendingBloc.add(PickFileEvent());
                        },
                        child: !_fileUploading
                            ? Image.asset(
                                'assets/images/upload_file.png',
                                height: SizeConfig.heightMultiplier *
                                    3.7661406025824964,
                                width: SizeConfig.widthMultiplier *
                                    4.861111111111111,
                              )
                            : Lottie.asset('assets/loader/widget_loading.json',
                                height: SizeConfig.heightMultiplier *
                                    3.7661406025824964,
                                width: SizeConfig.widthMultiplier *
                                    4.861111111111111)),
                    border: OutlineInputBorder(
                        borderSide: BorderSide(
                            color: AppColors.appBlue,
                            width: SizeConfig.widthMultiplier *
                                0.12152777777777776),
                        borderRadius: BorderRadius.circular(10.0)),
                    contentPadding: EdgeInsets.only(
                        left: SizeConfig.widthMultiplier * 3.8888888888888884),
                    hintText: 'Upload bank e-statement',
                    suffixStyle: const TextStyle(color: AppColors.appBlue)),
              ),
            ),
          ),
          Container(
              margin: EdgeInsets.only(
                  left: SizeConfig.widthMultiplier * 6.076388888888888,
                  top: SizeConfig.heightMultiplier * 1.8830703012912482),
              child: Text(
                "How do I get an e-statement from my bank?",
                style: GoogleFonts.inter(
                    fontSize: SizeConfig.textMultiplier * 1.757532281205165,
                    fontWeight: FontWeight.w400,
                    color: AppColors.appBlue,
                    letterSpacing: 0.25),
              )),
          // Positioned(
          //   bottom: SizeConfig.heightMultiplier * 3.7661406025824964,
          //     child: GestureDetector(
          //   behavior: HitTestBehavior.translucent,
          //   onTap: () {
          //     setState(() {
          //       _pageController.jumpToPage(2);
          //     });
          //   },
          //   child: Container(
          //     width: MediaQuery.of(context).size.width,
          //     height: SizeConfig.heightMultiplier * 6.025824964131995,
          //     margin: EdgeInsets.only(top: SizeConfig.heightMultiplier * 2.5107604017216643, left: SizeConfig.widthMultiplier * 3.8888888888888884, right: SizeConfig.widthMultiplier * 3.8888888888888884),
          //     child: RaisedGradientButton(
          //       gradient: LinearGradient(
          //         colors: <Color>[
          //           AppColors.gradient_button_light,
          //           AppColors.gradient_button_dark,
          //         ],
          //       ),
          //       child: Padding(
          //           padding: EdgeInsets.fromLTRB(5, 10, 5, 10),
          //           child: Text(
          //             'NEXT',
          //             style: GoogleFonts.inter(
          //                 color: AppColors.white,
          //                 fontWeight: FontWeight.bold,
          //                 fontSize: SizeConfig.textMultiplier * 1.757532281205165,
          //                 letterSpacing: 0.5,
          //                 textStyle: TextStyle(fontFamily: 'Roboto')),
          //           )),
          //     ),
          //   ),
          // )),
        ]));
  }

  Widget _addBankScreen3(String accountNum) {
    if (_bankStatus == "Please upload bank documents") {
      _bankStatus = "Confirmation pending";
    }
    return Container(
        margin: EdgeInsets.only(
            bottom: SizeConfig.heightMultiplier * 3.7661406025824964),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Container(
              margin: EdgeInsets.only(
                  left: SizeConfig.widthMultiplier * 4.861111111111111,
                  top: SizeConfig.heightMultiplier * 1.8830703012912482),
              child: Text(
                "Bank",
                style: GoogleFonts.inter(
                  fontSize: SizeConfig.textMultiplier * 2.259684361549498,
                  fontWeight: FontWeight.w700,
                ),
              )),
          Container(
              margin: EdgeInsets.only(
                  left: SizeConfig.widthMultiplier * 4.861111111111111,
                  top: SizeConfig.heightMultiplier * 1.8830703012912482),
              child: Text(
                "Your bank account is pending confirmation. We’ll notify you with any status update.",
                style: GoogleFonts.inter(
                    fontSize: SizeConfig.textMultiplier * 1.757532281205165,
                    fontWeight: FontWeight.w400,
                    letterSpacing: 0.25),
              )),
          Container(
              margin: EdgeInsets.only(
                  left: SizeConfig.widthMultiplier * 4.861111111111111,
                  top: SizeConfig.heightMultiplier * 1.8830703012912482),
              child: Text(
                "Account #$accountNum",
                style: GoogleFonts.inter(
                    fontSize: SizeConfig.textMultiplier * 1.757532281205165,
                    fontWeight: FontWeight.w400,
                    letterSpacing: 0.25),
              )),
          Container(
              margin: EdgeInsets.only(
                  left: SizeConfig.widthMultiplier * 4.861111111111111,
                  top: SizeConfig.heightMultiplier * 1.8830703012912482),
              child: Row(
                children: [
                  Container(
                    height: SizeConfig.heightMultiplier * 1.2553802008608321,
                    width: SizeConfig.widthMultiplier * 2.4305555555555554,
                    decoration: BoxDecoration(
                        color: AppColors.pendingColor,
                        borderRadius: BorderRadius.circular(20)),
                  ),
                  Container(
                      margin: EdgeInsets.only(
                          left:
                              SizeConfig.widthMultiplier * 2.4305555555555554),
                      child: Text(
                        _bankStatus ?? "Status Loading...",
                        style: GoogleFonts.inter(
                            fontSize:
                                SizeConfig.textMultiplier * 1.757532281205165,
                            color: AppColors.pendingColor,
                            fontWeight: FontWeight.w400,
                            letterSpacing: 0.25),
                      )),
                ],
              ))
        ]));
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
              height: SizeConfig.heightMultiplier * 13.809182209469155,
              child: Material(
                elevation: 5,
                borderRadius: BorderRadius.circular(10.0),
                child: Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                          color: AppColors.appBlue,
                          width: SizeConfig.widthMultiplier *
                              0.48611111111111105)),
                  child: ListView(
                    shrinkWrap: true,
                    padding: EdgeInsets.zero,
                    children: _dropdownList
                        .map((value) => InkWell(
                              onTap: () {
                                setState(() {
                                  controller.text = value;
                                  _selectedItem = value;
                                  _overlayEntry.remove();
                                  _overlayEntry = null;
                                  Navigator.pop(context);
                                  _showAddBankDetailsSheet();
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

  Widget _bottomSheet(bool isCurrentPage) {
    return AnimatedContainer(
      margin: EdgeInsets.only(
        bottom: SizeConfig.heightMultiplier * 25.107604017216644,
        top: SizeConfig.heightMultiplier * 2.0086083213773316,
      ),
      duration: Duration(milliseconds: 500),
      child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
        for (int i = 0; i < 3; i++)
          i == slideIndex
              ? _bottomSheetContainer(true)
              : _bottomSheetContainer(false),
      ]),
    );
  }

  Widget _bottomSheetContainer(bool isCurrentPage) {
    return Container(
      margin: EdgeInsets.only(
          left: SizeConfig.widthMultiplier * 0.9722222222222221),
      height: isCurrentPage ? 8 : 8,
      width: isCurrentPage ? 8 : 8,
      decoration: BoxDecoration(
          color: isCurrentPage ? Color(0xff034AA6) : Color(0xffD4D4D4),
          shape: BoxShape.circle),
    );
  }

  void _showToast(String msg) {
    Fluttertoast.showToast(
        msg: msg,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 1,
        backgroundColor: AppColors.appBlue,
        textColor: AppColors.white,
        fontSize: SizeConfig.textMultiplier * 2.0086083213773316);
  }
}
