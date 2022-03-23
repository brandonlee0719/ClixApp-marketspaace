import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:market_space/common/colors.dart';
import 'package:market_space/common/constants.dart';
import 'package:market_space/common/loading_progress.dart';
import 'package:market_space/common/raised_gradient_button.dart';
import 'package:market_space/common/toolbar.dart';
import 'package:market_space/common/util/globalKeys.dart';
import 'package:market_space/model/bank_account_model/bank_account_model.dart';
import 'package:market_space/model/bank_account_model/bank_details_request_model.dart';
import 'package:market_space/profile_settings/model/debit_card_model.dart';
import 'package:market_space/profile_settings/logic/check_credit_bloc.dart';
import 'package:market_space/profile_settings/receiving_payment/receiving_payment_bloc.dart';
import 'package:market_space/profile_settings/receiving_payment/receiving_payment_l10n.dart';
import 'package:market_space/profile_settings/widget/showCard.dart';
import 'package:market_space/responsive_layout/size_config.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

class ReceivingPaymentScreen extends StatefulWidget {
  final bool isReceive;

  const ReceivingPaymentScreen({Key key, this.isReceive}) : super(key: key);

  @override
  ReceivingPaymentScreenState createState() => ReceivingPaymentScreenState();
}

class ReceivingPaymentScreenState extends State<ReceivingPaymentScreen> {
  final ReceivingPaymentBloc _receivingPaymentBloc =
      ReceivingPaymentBloc(Initial1());
  ReceivingPaymentL10n _l10n = ReceivingPaymentL10n(
      Locale.fromSubtags(languageCode: 'en', countryCode: 'US'));

  bool _isLoading = false;
  String _tabSelected = "";
  OverlayEntry _overlayEntry;
  GlobalKey<ScaffoldState> _key = GlobalKey<ScaffoldState>();
  final _productTypeKey = GlobalKey<ScaffoldState>();
  final TextEditingController _countryController = TextEditingController();
  final TextEditingController _accountController = TextEditingController();
  final TextEditingController _addressOneController = TextEditingController();
  final TextEditingController _addressTwoController = TextEditingController();
  final TextEditingController _cityController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _bsbController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();

  List<String> _countryList = ["Australia", "China"];
  int slideIndex = 0;
  PageController _pageController = PageController(initialPage: 0);
  bool _editBankDetails = false;
  bool _bankLoading = false;
  String _bankModelText = "";
  BankAccountModel _bankModel;
  bool _confirmLoading = false;
  String _selectedItem;
  bool _fileUploading = false;
  String _bankStatus;
  DebitCardModel _debitCardDetails;
  bool _removeCardLoading = false;
  bool _saveCardLoading = false;

  static final Color background = AppColors.toolbarBlue;
  static final Color fill = AppColors.lightgrey;

  static final List<Color> gradient = [
    background,
    background,
    fill,
    fill,
  ];

  static final double fillPercent =
      39.7; // fills 56.23% for container from bottom
  static final double fillStop = (100 - fillPercent) / 100;
  final List<double> stops = [0.0, fillStop, fillStop, 1.0];

  @override
  void initState() {
    // _receivingPaymentBloc.add(ReceivingPaymentScreenEvent());
    // _receivingPaymentBloc.add(GetBasicCredentialsEvent());
    _countryController.text = "Australia";

    setState(() {
      if (Constants.language == null || Constants.language == "English") {
        _l10n = ReceivingPaymentL10n(
            Locale.fromSubtags(languageCode: 'en', countryCode: 'US'));
      } else {
        _l10n = ReceivingPaymentL10n(Locale.fromSubtags(languageCode: 'zh'));
      }
    });
    super.initState();
  }

  void showSnackBar(String text) {
    final snackBar =
        SnackBar(behavior: SnackBarBehavior.floating, content: Text(text));
    //
    // Scaffold.of(context).showSnackBar(snackBar);
    _key.currentState.showSnackBar(snackBar);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          gradient: LinearGradient(
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
              colors: gradient,
              stops: stops)),
      child: Scaffold(
        appBar: Toolbar(
          title: _l10n.addNewBuyerPayment,
        ),
        key: _key,
        backgroundColor: Colors.transparent,
        // key: _globalKey,
        // bottomNavigationBar: _bottomButtons(),
        resizeToAvoidBottomInset: false,
        body: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          color: AppColors.white,
          child: BlocProvider<ReceivingPaymentBloc>.value(
            value: _receivingPaymentBloc,
            child: BlocListener<ReceivingPaymentBloc, ReceivingPaymentState>(
                listener: (context, state) {
                  if (state is Loaded1) {
                    setState(() {
                      _bankLoading = false;
                      _bankModelText = "true";
                      _bankModel = _receivingPaymentBloc.bankAccountModel;
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
                      _showToast("${_receivingPaymentBloc.saveBankText}");
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
                      _bankStatus = _receivingPaymentBloc.bankStatus;
                    });
                  }

                  if (state is SaveDebitCardSuccess) {
                    setState(() {
                      _showToast("Debit card saved");
                      _saveCardLoading = false;
                      _receivingPaymentBloc.add(SaveDebitEvent());
                    });
                  }
                  if (state is GetVaultSuccess) {
                    setState(() {
                      _debitCardDetails =
                          _receivingPaymentBloc.debitCardDetails;
                      _receivingPaymentBloc.add(SaveOtherDebitDetailsEvent());
                    });
                  }
                  if (state is RemoveVaultSuccess) {
                    _showToast("Card removed");
                    setState(() {
                      _debitCardDetails = null;
                      _removeCardLoading = false;
                      _showCardSheet();
                    });
                  }
                },
                child: _baseScreen()),
          ),
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
                  _paymentModes(),
                ])
          ])),
    );
  }

  Widget _paymentModes() {
    return Container(
        child: ListView(shrinkWrap: true, children: [
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
      // GestureDetector(
      //   onTap: () {
      //     setState(() {
      //       _tabSelected = "Bank";
      //     });
      //     // _receivingPaymentBloc.add(ReceivingPaymentScreenEvent());
      //     // _showBankDetailsSheet();
      //   },
      //   child: Container(
      //       height: SizeConfig.heightMultiplier * 7.532281205164993,
      //       decoration: BoxDecoration(
      //           borderRadius: BorderRadius.circular(10),
      //           border: Border.all(
      //               color: _tabSelected == "Bank"
      //                   ? AppColors.appBlue
      //                   : AppColors.text_field_container)),
      //       margin: EdgeInsets.only(
      //           left: SizeConfig.widthMultiplier * 3.8888888888888884,
      //           right: SizeConfig.widthMultiplier * 3.8888888888888884,
      //           top: SizeConfig.heightMultiplier * 1.5064562410329987),
      //       child: Center(
      //           child: Text(
      //         _l10n.Bank,
      //         style: GoogleFonts.inter(
      //             fontSize: SizeConfig.textMultiplier * 1.757532281205165,
      //             fontWeight: FontWeight.w700,
      //             letterSpacing: 0.1,
      //             color: _tabSelected == "Bank"
      //                 ? AppColors.appBlue
      //                 : AppColors.text_field_container),
      //       ))),
      // ),
      GestureDetector(
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
              margin: EdgeInsets.only(
                  left: SizeConfig.widthMultiplier * 3.8888888888888884,
                  right: SizeConfig.widthMultiplier * 3.8888888888888884,
                  top: SizeConfig.heightMultiplier * 1.5064562410329987),
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
              ))),
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
                        top: 20),
                    child: Row(
                      children: [
                        Container(
                          height: 24,
                          width: 24,
                          child: SvgPicture.asset("assets/svgs/bitcoin.svg",
                              semanticsLabel: 'bitcoin.svg'),
                          padding: const EdgeInsets.all(3),
                          decoration: BoxDecoration(
                            color: const Color(0xffF9AA4B),
                            shape: BoxShape.circle,
                          ),
                        ),
                        Text(
                          '  Bitcoin (BTC)',
                          style: GoogleFonts.inter(
                            color: AppColors.sub_text,
                            fontWeight: FontWeight.w400,
                            fontSize: 16,
                            letterSpacing: 0.15,
                          ),
                        ),
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
                        SizedBox(
                          height: 24,
                          width: 24,
                          child: SvgPicture.asset(
                              "assets/svgs/logos_ethereum.svg",
                              semanticsLabel: 'logos_ethereum.svg'),
                        ),
                        Text(
                          '  Ethereum (ETH)',
                          style: GoogleFonts.inter(
                            color: AppColors.sub_text,
                            fontWeight: FontWeight.w400,
                            fontSize: 16,
                            letterSpacing: 0.15,
                          ),
                        ),
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
                        SizedBox(
                          height: 24,
                          width: 24,
                          child: SvgPicture.asset(
                              "assets/svgs/cryptocurrency_usdc.svg",
                              semanticsLabel: 'cryptocurrency_usdc.svg'),
                        ),
                        Text(
                          '  USDC',
                          style: GoogleFonts.inter(
                            color: AppColors.sub_text,
                            fontWeight: FontWeight.w400,
                            fontSize: 16,
                            letterSpacing: 0.15,
                          ),
                        ),
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
                        SizedBox(
                          height: 24,
                          width: 24,
                          child: SvgPicture.asset(
                              "assets/svgs/emojione-v1_flag-for-australia.svg",
                              semanticsLabel:
                                  'emojione-v1_flag-for-australia.svg'),
                        ),
                        Text(
                          '  AUD',
                          style: GoogleFonts.inter(
                            color: AppColors.sub_text,
                            fontWeight: FontWeight.w400,
                            fontSize: 16,
                            letterSpacing: 0.15,
                          ),
                        ),
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
                        SizedBox(
                          height: 24,
                          width: 24,
                          child: SvgPicture.asset(
                              "assets/svgs/emojione-v1_flag-for-china.svg",
                              semanticsLabel: 'emojione-v1_flag-for-china.svg'),
                        ),
                        Text(
                          '  CNY',
                          style: GoogleFonts.inter(
                            color: AppColors.sub_text,
                            fontWeight: FontWeight.w400,
                            fontSize: 16,
                            letterSpacing: 0.15,
                          ),
                        ),
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
                  onTap: () {},
                  child: Container(
                    width: MediaQuery.of(context).size.width,
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
                            _l10n.confirm,
                            style: GoogleFonts.inter(
                                color: AppColors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: SizeConfig.textMultiplier *
                                    1.757532281205165,
                                letterSpacing: 0.5,
                                textStyle: TextStyle(fontFamily: 'Roboto')),
                          )),
                    ),
                  ),
                ),
              ],
            )),
      ),
    );
  }

  void _showCardSheet() {
    // ignore: close_sinks
    // CheckCreditBloc _check = BlocProvider.of<CheckCreditBloc>(context, listen: false);

    showMaterialModalBottomSheet(
      context: this.context,
      elevation: 5,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
              topRight: Radius.circular(30), topLeft: Radius.circular(30))),
      builder: (context) => SingleChildScrollView(
        controller: ModalScrollController.of(context),
        child: BlocProvider<CheckCreditBloc>(
          create: (context) {
            return CheckCreditBloc()..add(CheckCreditEvent.checkCredit);
          },
          child: Container(
              margin: EdgeInsets.only(
                  bottom: SizeConfig.heightMultiplier * 12.553802008608322),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                      margin: EdgeInsets.only(
                          left: SizeConfig.widthMultiplier * 4.861111111111111,
                          top:
                              SizeConfig.heightMultiplier * 1.8830703012912482),
                      child: Text(
                        "Debit card",
                        style: GoogleFonts.inter(
                          fontSize:
                              SizeConfig.textMultiplier * 2.259684361549498,
                          fontWeight: FontWeight.w700,
                        ),
                      )),
                  Container(
                      margin: EdgeInsets.only(
                          left: SizeConfig.widthMultiplier * 4.861111111111111,
                          top:
                              SizeConfig.heightMultiplier * 1.8830703012912482),
                      child: Text(
                        "My cards",
                        style: GoogleFonts.inter(
                            fontSize:
                                SizeConfig.textMultiplier * 1.757532281205165,
                            fontWeight: FontWeight.w400,
                            letterSpacing: 0.25),
                      )),
                  Builder(builder: (context) {
                    // ignore: close_sinks
                    CheckCreditBloc _check = context.watch<CheckCreditBloc>();
                    final state = _check.state;
                    if (state == CheckCreditState.creditCardDownloadSuccess) {
                      _removeCardLoading = false;
                      return Container(
                        decoration: BoxDecoration(
                          border: Border.all(
                              color: AppColors.text_field_container,
                              width: SizeConfig.widthMultiplier *
                                  0.24305555555555552),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        padding: EdgeInsets.all(10),
                        margin: EdgeInsets.only(
                            left:
                                SizeConfig.widthMultiplier * 3.8888888888888884,
                            right:
                                SizeConfig.widthMultiplier * 3.8888888888888884,
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
                                        // 'Visa xxxxxxxxxxx${_check.lastFourDigit}',
                                        _check.model.cardNumber,
                                        style: GoogleFonts.inter(
                                            color:
                                                AppColors.text_field_container,
                                            fontSize:
                                                SizeConfig.textMultiplier *
                                                    1.757532281205165,
                                            fontWeight: FontWeight.w700),
                                      ),
                                    ),
                                    Container(
                                      child: Column(
                                        children: [
                                          Container(
                                            child: Text(
                                              _check.model.cardHolder,
                                              style: GoogleFonts.inter(
                                                  color: AppColors
                                                      .text_field_container,
                                                  fontSize: SizeConfig
                                                          .textMultiplier *
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
                            ],
                          ),
                        ),
                      );
                    }
                    if (state == CheckCreditState.noCredit) {
                      return Container(
                          child: GestureDetector(
                        onTap: () {
                          // Navigator.pop(context);
                          ShowCardHelper(context, _check).showAddCardSheet();
                        },
                        child: Container(
                            margin: EdgeInsets.only(
                                top: SizeConfig.heightMultiplier *
                                    2.0086083213773316,
                                right: SizeConfig.widthMultiplier *
                                    3.8888888888888884,
                                left: SizeConfig.widthMultiplier *
                                    3.8888888888888884),
                            height:
                                SizeConfig.heightMultiplier * 6.276901004304161,
                            width: MediaQuery.of(context).size.width,
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
                                      "Add new card",
                                      style: GoogleFonts.inter(
                                          fontSize: SizeConfig.textMultiplier *
                                              1.757532281205165,
                                          fontWeight: FontWeight.w400,
                                          color: AppColors.appBlue,
                                          letterSpacing: 0.25,
                                          textStyle:
                                              TextStyle(fontFamily: 'Roboto')),
                                    )),
                              ],
                            )),
                      ));
                    }
                    return BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 0.8, sigmaY: 0.8),
                      child: Align(
                          alignment: Alignment.center,
                          child: LoadingProgress(
                            color: Colors.deepOrangeAccent,
                          )),
                    );
                  }),
                  Builder(builder: (context) {
                    final state = context.watch<CheckCreditBloc>().state;
                    if (state == CheckCreditState.hasCredit ||
                        state == CheckCreditState.creditCardDownloadSuccess) {
                      return GestureDetector(
                          onTap: () {
                            // print("hhahaha");
                            BlocProvider.of<CheckCreditBloc>(context,
                                    listen: false)
                                .add(CheckCreditEvent.deleteCredit);
                          },
                          child: Container(
                              height: SizeConfig.heightMultiplier *
                                  4.276901004304161,
                              width: MediaQuery.of(context).size.width,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  border:
                                      Border.all(color: AppColors.cancel_red)),
                              margin: EdgeInsets.only(
                                  left: SizeConfig.widthMultiplier *
                                      3.8888888888888884,
                                  right: SizeConfig.widthMultiplier *
                                      3.8888888888888884,
                                  top: SizeConfig.heightMultiplier *
                                      3.0129124820659974),
                              child: Center(
                                child: _removeCardLoading
                                    ? Lottie.asset(
                                        'assets/loader/widget_loading.json',
                                        width: SizeConfig.widthMultiplier *
                                            12.152777777777777,
                                        height: SizeConfig.heightMultiplier *
                                            2.5107604017216643)
                                    : Text(
                                        "REMOVE ACCOUNT",
                                        style: GoogleFonts.inter(
                                            fontSize:
                                                SizeConfig.textMultiplier *
                                                    1.757532281205165,
                                            fontWeight: FontWeight.w700,
                                            letterSpacing: 0.1,
                                            color: AppColors.cancel_red),
                                      ),
                              )));
                    }
                    return Container();
                  }),
                ],
              )),
        ),
      ),
    );
  }

  void _showBankDetailsSheet() {
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
                      if (_bankModel != null)
                        Container(
                          decoration: BoxDecoration(
                            border: Border.all(
                                color: AppColors.text_field_container,
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
                                                _bankModel.accountNum ?? "",
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
                                                _bankModel.name ?? "",
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
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      if (_bankModel == null)
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
                      GestureDetector(
                        behavior: HitTestBehavior.translucent,
                        onTap: () {
                          Navigator.pop(context);
                        },
                        child: Container(
                          color: AppColors.white,
                          child: Container(
                            margin: EdgeInsets.only(
                                left: SizeConfig.widthMultiplier *
                                    3.8888888888888884,
                                right: SizeConfig.widthMultiplier *
                                    3.8888888888888884,
                                bottom: SizeConfig.heightMultiplier *
                                    2.5107604017216643,
                                top: SizeConfig.heightMultiplier *
                                    1.2553802008608321),
                            height:
                                SizeConfig.heightMultiplier * 6.276901004304161,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                border:
                                    Border.all(color: AppColors.cancel_red)),
                            child: Center(
                              child: Text(
                                "CLOSE",
                                style: GoogleFonts.roboto(
                                    fontSize: SizeConfig.textMultiplier *
                                        1.757532281205165,
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
                            if (!_editBankDetails) _addBankScreen2(),
                            if (!_editBankDetails) _addBankScreen3(_accountNum),
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
                                  _receivingPaymentBloc
                                      .bankDetailsRequestModel = model;
                                  _confirmLoading = true;
                                  _receivingPaymentBloc
                                      .add(SaveBankDetailsEvent());
                                  _pageController.jumpToPage(1);
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
                                  _receivingPaymentBloc
                                      .bankDetailsRequestModel = model;
                                  _confirmLoading = true;
                                  _receivingPaymentBloc
                                      .add(SaveBankDetailsEvent());
                                  slideIndex = 1;
                                  _pageController.jumpToPage(1);
                                }
                              } else if (_pageController.page == 1) {
                                slideIndex = 2;
                                _pageController.jumpToPage(2);
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
                                    _editBankDetails
                                        ? "CONFIRM CHANGES"
                                        : slideIndex == 2
                                            ? _l10n.confirm
                                            : 'NEXT',
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
                    if (!_editBankDetails)
                      Positioned(
                        top: MediaQuery.of(context).size.height * 0.62,
                        left: MediaQuery.of(context).size.width * 0.45,
                        child: _bottomSheet(true),
                      ),
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
                          _receivingPaymentBloc.add(PickFileEvent());
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
                        _bankStatus ?? "Confirmation pending",
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
