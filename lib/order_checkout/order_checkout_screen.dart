import 'dart:ui';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:crypto_font_icons/crypto_font_icons.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:market_space/apis/orderApi/orderManager.dart';
import 'package:market_space/apis/userApi/models/addressModel.dart';
import 'package:market_space/apis/userApi/shoppingCartManager.dart';
import 'package:market_space/authScreen/authApi.dart';
import 'package:market_space/common/colors.dart';
import 'package:market_space/common/constants.dart';
import 'package:market_space/common/loading_progress.dart';
import 'package:market_space/common/mixins/webviewMxin.dart';
import 'package:market_space/model/address_model/address_model.dart';
import 'package:market_space/model/order/order_model.dart';
import 'package:market_space/model/payment_method/payment_model.dart';
import 'package:market_space/model/product_detail_model/product_det_model.dart';
import 'package:market_space/notification/representation/reusableDialogues.dart';
import 'package:market_space/order_checkout/logic/page_bloc.dart';
import 'package:market_space/order_checkout/presentation/screens/paymentScreen.dart';
import 'package:market_space/order_checkout/presentation/screens/shippingScreen.dart';
import 'package:market_space/order_checkout/presentation/widgets/addressCard.dart';
import 'package:market_space/order_checkout/presentation/widgets/checkoutToolBar.dart';
import 'package:market_space/order_checkout/presentation/widgets/complete2FAWidget.dart';
import 'package:market_space/order_checkout/presentation/widgets/confirmCVVWidget.dart';
import 'package:market_space/order_checkout/presentation/widgets/paymentCard.dart';
import 'package:market_space/order_checkout/presentation/widgets/rowCard.dart';
import 'package:market_space/profile_settings/model/debit_card_model.dart';
import 'package:market_space/order_checkout/logic/order_checkout_bloc/order_checkout_bloc.dart';
import 'package:market_space/order_checkout/order_checkout_route.dart';
import 'package:market_space/profile_settings/add_new_address/add_new_address_route.dart';
import 'package:market_space/profile_settings/profile_setting_route.dart';
import 'package:market_space/profile_settings/seller_sending_payments/add_new_sending_payment/add_new_sending_route.dart';
import 'package:market_space/repositories/auth/auth_repository.dart';
import 'package:market_space/services/RouterServices.dart';
import 'package:market_space/responsive_layout/size_config.dart';
import 'package:market_space/services/dialogueServices/dialogueService.dart';
import 'package:market_space/services/locator.dart';
import 'model/chekout_mode.dart';
import 'model/paymentCurrency.dart';
import 'model/update_address_model/update_address_model.dart';
import 'order_checkout_l10n.dart';

class OrderCheckoutScreen extends StatefulWidget {
  final List<int> productList;
  OrderCheckoutScreen(this.productList);

  @override
  _OrderCheckoutScreenState createState() => _OrderCheckoutScreenState();
}

class _OrderCheckoutScreenState extends State<OrderCheckoutScreen>
    with WebViewMixin {
  // final OrderCheckoutBloc _orderCheckoutBloc = OrderCheckoutBloc(Initial());
  OrderCheckoutL10n _l10n = OrderCheckoutL10n(
      Locale.fromSubtags(languageCode: 'en', countryCode: 'US'));
  final _globalKey = GlobalKey<ScaffoldState>();
  bool _isLoading = false;
  List<UpdateAddressModel> _addressList = List();

  DebitCardModel _debitCard;
  int slideIndex = 0;
  int _addressValue = 0;
  int _addvalue = 1;
  int _addvalueThree = 0;
  int _paymentValue = 0;
  bool _isShipping = true,
      _isPayment = false,
      _isReview = false,
      _isCompleted = false,
      _isDigital = false;
  int _walletSelected = 0;
  int _cardSelected = 1;
  AuthRepository auth = AuthRepository();
  bool _isShippingDone = false, _isPaymentDone = false, _isReviewDone = false;
  bool _isChinese = false;

  bool _orderSummaryExpand = false;

  List<ProductDetModel> _productList = List();
  bool _isTags = false;
  double _orderTotal = 0.0;
  bool _isOrderBuyNow = false;
  PaymentCurrency _currency = PaymentCurrency.AUD;
  Widget paymentScreen = new PaymentScreen();

  final Color background = AppColors.toolbarBlue;
  final Color fill = AppColors.lightgrey;

  @override
  void dispose() {
    locator.get<ShoppingCartManager>().purchaseProduct.clear();
    super.dispose();
  }

  @override
  void initState() {
    // _orderCheckoutBloc.add(OrderCheckoutScreenEvent());

    BlocProvider.of<OrderCheckoutBloc>(context).add(ViewAddressesEvent());
    BlocProvider.of<OrderCheckoutBloc>(context).add(DebitCardDetailsEvent());

    setState(() {
      if (Constants.language == null || Constants.language == "English") {
        _l10n = OrderCheckoutL10n(
            Locale.fromSubtags(languageCode: 'en', countryCode: 'US'));
      } else {
        _isChinese = true;
        _l10n = OrderCheckoutL10n(Locale.fromSubtags(languageCode: 'zh'));
      }
    });
    super.initState();
  }

  _showSnackBar(String snackText) {
    final snackBar = SnackBar(
      content: Text(snackText),
    );
    _globalKey.currentState.showSnackBar(snackBar);
  }

  @override
  Widget build(BuildContext context) {
    // ignore: close_sinks

    final List<Color> gradient = [
      background,
      background,
      fill,
      fill,
    ];

    final double fillPercent = 39.7; // fills 56.23% for container from bottom
    final double fillStop = (100 - fillPercent) / 100;
    final List<double> stops = [0.0, fillStop, fillStop, 1.0];

    OrderCheckoutBloc _orderCheckoutBloc =
        BlocProvider.of<OrderCheckoutBloc>(context);
    Map<dynamic, String> _titleMap = new Map();
    _titleMap[PageState.initial] = _l10n.selectShipping;
    _titleMap[PageState.wallet] = _l10n.selectPayment;
    _titleMap[PageState.checkout] = "Review order";
    _titleMap[PageState.complete] = "Complete order";

    return Container(
      decoration: BoxDecoration(
          gradient: LinearGradient(
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
              colors: gradient,
              stops: stops)),
      child: Stack(
        children: [
          Scaffold(
            appBar: CheckOutToolBar(
              _l10n.checkout,
            ),
            backgroundColor: Colors.transparent,
            key: _globalKey,
            bottomNavigationBar: BlocProvider.value(
                value: BlocProvider.of<PageBloc>(context),
                child: _bottomButtons()),
            resizeToAvoidBottomInset: false,
            body: Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              color: AppColors.white,
              child: BlocProvider.value(
                value: _orderCheckoutBloc,
                child: BlocListener<OrderCheckoutBloc, OrderCheckoutState>(
                  listener: (context, state) {
                    if (state is ViewAddressSuccessfully ||
                        state is DebitCardCheckoutSuccessfully) {
                      setState(() {
                        // _addressList.clear();
                        // _addressList = _orderCheckoutBloc.addressList;
                        // if (_addressList.length >= 1) {
                        //   _selectedAddressModel = _addressList[0];
                        // } else {
                        //   _selectedAddressModel = UpdateAddressModel(
                        //       addressNum: 443,
                        //       country: "z",
                        //       phoneNumber: "1234",
                        //       postcode: "3053",
                        //       streetAddress: "jjkkkllmmmnb");
                        // }
                        if (OrderCheckoutRoute.isBuyNow) {
                          _productList.clear();
                          _productList.add(OrderCheckoutRoute.productDetModel);
                        } else {
                          _productList = _orderCheckoutBloc.productList;
                        }
                        for (ProductDetModel model in locator
                            .get<ShoppingCartManager>()
                            .purchaseProduct) {
                          // double prefCurrency, cryto;
                          // var prefSevenDecimal, cryptoDecimal;
                          // if (Constants.aud != null) {
                          //   prefCurrency = model.fiatPrice.toDouble() /
                          //       double.parse(Constants.aud);
                          //   cryto = (model.fiatPrice.toDouble() /
                          //           double.parse(Constants.aud)) *
                          //       double.parse(Constants.btc);
                          //   if (prefCurrency.toString().length > 7) {
                          //     prefSevenDecimal =
                          //         double.parse(prefCurrency.toStringAsFixed(7));
                          //     cryptoDecimal =
                          //         double.parse(cryto.toStringAsFixed(7));
                          //   } else {
                          //     prefSevenDecimal = prefCurrency;
                          //     cryptoDecimal =
                          //         double.parse(cryto.toStringAsFixed(7));
                          //   }
                          // } else {
                          //   cryto = (model.fiatPrice / 1.0) *
                          //       double.parse(Constants.btc);
                          //   cryptoDecimal =
                          //       double.parse(cryto.toStringAsFixed(7));
                          // }
                          _orderTotal = _orderTotal + model.fiatPrice;
                        }
                        _addressValue = 0;
                      });
                    }

                    if (state is CheckoutOngoing) {
                      setState(() {
                        _isLoading = true;
                      });
                    }

                    if (state is AwaitingAuthentication) {
                      showDialog(
                          barrierDismissible: true,
                          context: context,
                          builder: (context) {
                            return const Complete2FAWidget();
                          }).then((value) {
                        BlocProvider.of<OrderCheckoutBloc>(context)
                            .add(FinalizeCreditCardCheckout());
                      });
                    }

                    if (state is CheckoutSuccess) {
                      setState(() {
                        locator.get<OrderManager>().notify();
                        _isLoading = false;
                        BlocProvider.of<PageBloc>(context, listen: false)
                            .add(PageEvent.toNextPage);
                      });
                      locator<ShoppingCartManager>().clearCart();
                    }

                    if (state is CheckoutFailed) {
                      _showSnackBar("checkout fail, please check your balance");
                      setState(() {
                        _isLoading = false;
                      });
                    }
                  },
                  child: ListView(
                    shrinkWrap: true,
                    children: [
                      // Container(
                      //   margin: EdgeInsets.only(
                      //       top: SizeConfig.heightMultiplier * 2.5107604017216643,
                      //       left: SizeConfig.widthMultiplier * 2.9166666666666665,
                      //       bottom: SizeConfig.heightMultiplier * 2.0086083213773316),
                      //   child: Row(
                      //     children: [
                      //       Text(
                      //         'Time left:',
                      //         style: GoogleFonts.inter(
                      //             fontSize:
                      //                 SizeConfig.textMultiplier * 1.2553802008608321,
                      //             fontWeight: FontWeight.w400,
                      //             textStyle: TextStyle(fontFamily: 'Montserrat'),
                      //             color: AppColors.darkgrey500),
                      //       ),
                      //       Text(
                      //         '8 mins',
                      //         style: GoogleFonts.inter(
                      //             fontSize:
                      //                 SizeConfig.textMultiplier * 1.5064562410329987,
                      //             fontWeight: FontWeight.w400,
                      //             letterSpacing: 0.1,
                      //             color: AppColors.app_txt_color),
                      //       ),
                      //     ],
                      //   ),
                      // ),
                      _orderTracking(),
                      Container(
                        margin: EdgeInsets.only(
                            top: SizeConfig.heightMultiplier *
                                2.5107604017216643,
                            left:
                                SizeConfig.widthMultiplier * 3.8888888888888884,
                            bottom: SizeConfig.heightMultiplier *
                                2.0086083213773316),
                        child: Builder(builder: (BuildContext context) {
                          PageState state = context.watch<PageBloc>().state;
                          return Text(
                            _titleMap[state] ?? "Error",
                            style: GoogleFonts.inter(
                                fontSize: SizeConfig.textMultiplier *
                                    2.0086083213773316,
                                fontWeight: FontWeight.w400,
                                letterSpacing: 0.15,
                                color: AppColors.app_txt_color),
                          );
                        }),
                      ),
                      Builder(builder: (BuildContext context) {
                        PageState state = context.watch<PageBloc>().state;
                        return Column(
                          children: [
                            if (state == PageState.initial)
                              new ShippingScreen(
                                isBilling: false,
                              ),
                            if (state == PageState.wallet) paymentScreen,
                            if (state == PageState.checkout)
                              _reviewScreen(_orderCheckoutBloc),
                            if (state == PageState.complete) _completeOrder(),
                            if (state == PageState.complete && _isDigital)
                              _completeProductDigital()
                            // _shippingScreen()
                          ],
                        );
                      }),
                    ],
                  ),
                ),
              ),
            ),
          ),
          if (_isLoading)
            Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 0.8, sigmaY: 0.8),
                child: Center(
                    child: LoadingProgress(
                  color: Colors.deepOrangeAccent,
                )),
              ),
            ),
        ],
      ),
    );
  }

  Widget _bottomButtons() {
    Map<PageState, String> buttonMap = new Map();
    buttonMap[PageState.initial] = "CONFIRM SHIPPING ADDRESS";
    buttonMap[PageState.wallet] = _l10n.confirmPaymentMethod;
    buttonMap[PageState.checkout] = _l10n.confirmOrder;
    buttonMap[PageState.complete] = "GO BACK";
    OrderCheckoutBloc _orderCheckoutBloc =
        BlocProvider.of<OrderCheckoutBloc>(context);

    return Builder(builder: (context) {
      PageState state = context.watch<PageBloc>().state;
      return Container(
        height: state == PageState.checkout
            ? SizeConfig.heightMultiplier * 15
            : SizeConfig.heightMultiplier * 12,
        color: AppColors.white,
        child: Column(children: [
          GestureDetector(
            onTap: () async {
              if (state == PageState.initial) {
                setState(() {
                  _isLoading = false;
                });
                BlocProvider.of<PageBloc>(context, listen: false)
                    .add(PageEvent.toNextPage);

                // print(_addressList[_addressValue].toJson());
                // print("zheshigeinimendeliwu!");
              } else if (state == PageState.wallet) {
                final selectedWalletBalance =
                    locator<OrderManager>().currency.value ==
                            PaymentCurrency.BTC
                        ? _orderCheckoutBloc.wallet.wallet.BTCInCNY
                        : locator<OrderManager>().currency.value ==
                                PaymentCurrency.ETH
                            ? _orderCheckoutBloc.wallet.wallet.ETHInCNY
                            : locator<OrderManager>().currency.value ==
                                    PaymentCurrency.USDC
                                ? _orderCheckoutBloc.wallet.wallet.USDC
                                : locator<OrderManager>().currency.value ==
                                        PaymentCurrency.AUD
                                    ? _orderCheckoutBloc.wallet.wallet.AUD
                                    : _orderCheckoutBloc.wallet.wallet.CNY;
                if (_orderCheckoutBloc.wallet.wallet != null &&
                    selectedWalletBalance >= _orderTotal) {
                  BlocProvider.of<PageBloc>(context, listen: false)
                      .add(PageEvent.toNextPage);
                } else {
                  DialogueService.instance.showErrorDialogue(
                      context,
                      "You do not have enough funds in your wallet, you can top this up by sending crypto assets to your Market Spaace wallet or by purchasing through credit card",
                      null,
                      title: 'Insufficient funds');
                }
              } else if (state == PageState.complete) {
                Navigator.pop(context);
              } else if (state == PageState.checkout) {
                TextEditingController controller = TextEditingController();
                // print("check");
                if (_isLoading == false) {
                  bool isAuth = await LocalAuthApi.authenticate();

                  if (isAuth) {
                    if (locator<OrderManager>().paymentMethod ==
                        PaymentMethodType.card) {
                      showDialog(
                              barrierDismissible: false,
                              context: context,
                              builder: (context) => ConfirmCVVWidget())
                          .then((value) {
                        // print(value);
                        _orderCheckoutBloc.add(CreditCardCheckoutEvent());
                      });
                    } else {
                      _orderCheckoutBloc.add(CheckoutEvent1());
                    }
                  }
                }
              } else {
                if (_orderCheckoutBloc.checkModel.address == null) {
                  _showSnackBar(
                      "The address is empty, please add an address before you checkout");
                }
                BlocProvider.of<PageBloc>(context, listen: false)
                    .add(PageEvent.toNextPage);
              }
            },
            child: Container(
              height: SizeConfig.heightMultiplier * 6.025824964131995,
              margin: EdgeInsets.only(
                  left: SizeConfig.widthMultiplier * 3.8888888888888884,
                  top: SizeConfig.heightMultiplier * 2.5107604017216643,
                  bottom: SizeConfig.heightMultiplier * 2.5107604017216643,
                  right: SizeConfig.widthMultiplier * 3.8888888888888884),
              decoration: BoxDecoration(
                  // border: Border.all(color: AppColors.appBlue),
                  borderRadius: BorderRadius.circular(10),
                  gradient: LinearGradient(colors: [
                    AppColors.gradient_button_light,
                    AppColors.gradient_button_dark
                  ])),
              child: Align(
                alignment: Alignment.center,
                child: Container(
                  child: Text(
                    buttonMap[state] ?? "Error",
                    style: GoogleFonts.inter(
                        fontSize: SizeConfig.textMultiplier * 1.757532281205165,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 0.5,
                        color: AppColors.white),
                  ),
                ),
              ),
            ),
          ),
          if (state == PageState.checkout) wyrePolicyWidget(),
        ]),
      );
    });
  }

  Widget _paymentMethodCard(DebitCardModel model) {
    String startLetter;
    bool _isMasterCard = false;
    if (model != null) {
      startLetter = model?.cardNumber ?? '';
      _isMasterCard = startLetter.startsWith('5');
    }
    return Container(
      margin: EdgeInsets.only(
          left: SizeConfig.widthMultiplier * 3.8888888888888884,
          right: SizeConfig.widthMultiplier * 3.8888888888888884,
          top: SizeConfig.heightMultiplier * 0.6276901004304161),
      padding: EdgeInsets.all(5),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
              color: _cardSelected == 0
                  ? AppColors.text_field_container
                  : AppColors.appBlue)),
      child: Container(
          child: Row(
        children: [
          Container(
            child: Radio(
              groupValue: 1,
              value: _cardSelected,
              activeColor: _cardSelected == 0
                  ? AppColors.text_field_container
                  : AppColors.appBlue,
              onChanged: (value) {
                setState(() {
                  _cardSelected = 1;
                  _walletSelected = 0;
                  _currency = PaymentCurrency.AUD;
                });
              },
            ),
          ),
          Container(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  child: Text(
                    _isMasterCard
                        ? 'MasterCard ${model?.cardNumber ?? ""}'
                        : 'VISA ${model?.cardNumber ?? ""}',
                    style: GoogleFonts.inter(
                      fontSize: SizeConfig.textMultiplier * 1.757532281205165,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 0.1,
                    ),
                  ),
                ),
                Container(
                  child: Text(
                    '${model?.cardHolder ?? "Holder name"}',
                    style: GoogleFonts.inter(
                      fontSize: SizeConfig.textMultiplier * 1.757532281205165,
                      fontWeight: FontWeight.w400,
                      letterSpacing: 0.1,
                    ),
                  ),
                ),
                Container(
                  child: Text(
                    '${_l10n.expires} ${model?.cardExpiry ?? ""}',
                    style: GoogleFonts.inter(
                      fontSize: SizeConfig.textMultiplier * 1.757532281205165,
                      fontWeight: FontWeight.w400,
                      letterSpacing: 0.1,
                    ),
                  ),
                ),
              ],
            ),
          )
        ],
      )),
    );
  }

  Widget _reviewScreen(OrderCheckoutBloc orderCHeckoutBLoc) {
    return Container(
      color: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            margin: EdgeInsets.only(
                top: SizeConfig.heightMultiplier * 2.5107604017216643,
                bottom: SizeConfig.heightMultiplier * 1.5064562410329987,
                left: SizeConfig.widthMultiplier * 3.8888888888888884),
            child: Text(
              _l10n.OrderSummary,
              style: GoogleFonts.inter(
                color: AppColors.app_txt_color,
                fontSize: SizeConfig.textMultiplier * 1.757532281205165,
                fontWeight: FontWeight.w700,
                letterSpacing: 0.5,
              ),
            ),
          ),
          _orderOverview(),
          Container(
            margin: EdgeInsets.only(
                left: SizeConfig.widthMultiplier * 3.8888888888888884,
                right: SizeConfig.widthMultiplier * 3.8888888888888884,
                top: SizeConfig.heightMultiplier * 2.5107604017216643,
                bottom: SizeConfig.heightMultiplier * 1.5064562410329987),
            child: Row(
              children: [
                Padding(
                    padding: EdgeInsets.only(
                        left: SizeConfig.widthMultiplier * 3.8888888888888884,
                        top: SizeConfig.heightMultiplier * 4.142754662840746),
                    child: Text(
                      _l10n.ShippingAddress,
                      style: GoogleFonts.inter(
                        color: AppColors.app_txt_color,
                        fontSize:
                            SizeConfig.textMultiplier * 2.0086083213773316,
                        fontWeight: FontWeight.w400,
                        letterSpacing: 0.15,
                      ),
                    )),
                Spacer(),
                GestureDetector(
                  child: Container(
                    height: SizeConfig.heightMultiplier * 2.5107604017216643,
                    alignment: Alignment.center,
                    margin: EdgeInsets.only(
                        right: SizeConfig.widthMultiplier * 3.8888888888888884,
                        top: SizeConfig.heightMultiplier * 4.017216642754663),
                    padding: EdgeInsets.only(
                        left: SizeConfig.widthMultiplier * 1.9444444444444442,
                        right: SizeConfig.widthMultiplier * 1.9444444444444442,
                        top: SizeConfig.heightMultiplier * 0.25107604017216645,
                        bottom:
                            SizeConfig.heightMultiplier * 0.25107604017216645),
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
              ],
            ),
          ),
          _shippingAddress(locator<OrderManager>().getShippingAddress()),
          // if (_isLoading)
          //   BackdropFilter(
          //     filter: ImageFilter.blur(sigmaX: 0.8, sigmaY: 0.8),
          //     child: Align(
          //         alignment: Alignment.center,
          //         child: LoadingProgress(
          //           color: Colors.deepOrangeAccent,
          //         )),
          //   ),
          Container(
            margin: EdgeInsets.only(
                top: SizeConfig.heightMultiplier * 2.5107604017216643,
                left: SizeConfig.widthMultiplier * 3.8888888888888884,
                right: SizeConfig.widthMultiplier * 3.8888888888888884),
            child: Row(
              children: [
                Padding(
                    padding: EdgeInsets.only(
                      left: SizeConfig.widthMultiplier * 3.8888888888888884,
                    ),
                    child: Text(
                      _l10n.billingAddress,
                      style: GoogleFonts.inter(
                        color: AppColors.app_txt_color,
                        fontSize:
                            SizeConfig.textMultiplier * 2.0086083213773316,
                        fontWeight: FontWeight.w400,
                        letterSpacing: 0.15,
                      ),
                    )),
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
                        bottom:
                            SizeConfig.heightMultiplier * 0.25107604017216645),
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
              ],
            ),
          ),
          if (locator<OrderManager>().paymentValue.value == 0)
            Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: AppColors.appBlue)),
                margin: EdgeInsets.only(
                    top: SizeConfig.heightMultiplier * 2.0086083213773316,
                    left: SizeConfig.widthMultiplier * 3.8888888888888884,
                    right: SizeConfig.widthMultiplier * 3.8888888888888884),
                child: Row(
                  children: [
                    Radio(
                      value: 0,
                      activeColor: AppColors.appBlue,
                      groupValue: _paymentValue,
                      onChanged: (int value) {
                        setState(() {
                          _paymentValue = value;
                          // print(value);
                        });
                      },
                    ),
                    Container(
                      margin: EdgeInsets.only(
                          top: SizeConfig.heightMultiplier * 2.0086083213773316,
                          left: SizeConfig.widthMultiplier * 3.8888888888888884,
                          right:
                              SizeConfig.widthMultiplier * 3.8888888888888884,
                          bottom:
                              SizeConfig.heightMultiplier * 2.0086083213773316),
                      child: Text(
                        _l10n.sameAsShippingAddress,
                        style: GoogleFonts.inter(
                          fontSize:
                              SizeConfig.textMultiplier * 1.757532281205165,
                          fontWeight: FontWeight.w700,
                          color: AppColors.app_txt_color,
                          letterSpacing: 0.1,
                        ),
                      ),
                    ),
                  ],
                )),
          if (locator<OrderManager>().paymentValue.value > 0)
            _shippingAddress(locator<OrderManager>().getBillingAddress()),
          Container(
            margin: EdgeInsets.only(
                top: SizeConfig.heightMultiplier * 2.5107604017216643,
                left: SizeConfig.widthMultiplier * 3.8888888888888884,
                right: SizeConfig.widthMultiplier * 3.8888888888888884),
            child: Row(
              children: [
                Padding(
                    padding: EdgeInsets.only(
                        left: SizeConfig.widthMultiplier * 3.8888888888888884,
                        bottom:
                            SizeConfig.heightMultiplier * 2.0086083213773316),
                    child: Text(
                      _l10n.paymentMethod,
                      style: GoogleFonts.inter(
                        color: AppColors.app_txt_color,
                        fontSize:
                            SizeConfig.textMultiplier * 2.0086083213773316,
                        fontWeight: FontWeight.w400,
                        letterSpacing: 0.15,
                      ),
                    )),
                Spacer(),
                GestureDetector(
                  onTap: () {},
                  child: Container(
                    height: SizeConfig.heightMultiplier * 2.5107604017216643,
                    alignment: Alignment.center,
                    margin: EdgeInsets.only(
                        right: SizeConfig.widthMultiplier * 3.8888888888888884,
                        bottom:
                            SizeConfig.heightMultiplier * 2.0086083213773316),
                    padding: EdgeInsets.only(
                        left: SizeConfig.widthMultiplier * 1.9444444444444442,
                        right: SizeConfig.widthMultiplier * 1.9444444444444442,
                        top: SizeConfig.heightMultiplier * 0.25107604017216645,
                        bottom:
                            SizeConfig.heightMultiplier * 0.25107604017216645),
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
              ],
            ),
          ),
          // if (locator<OrderManager>().paymentMethod == PaymentMethodType.card)
          //   _paymentMethodCard(locator<OrderManager>().debitCardModel)
          if (locator<OrderManager>().paymentMethod == PaymentMethodType.wallet)
            PaymentCard(
              method: "Wallet",
              currencyType:
                  locator<OrderManager>().currency.value == PaymentCurrency.BTC
                      ? 'BTC'
                      : locator<OrderManager>().currency.value ==
                              PaymentCurrency.ETH
                          ? 'ETH'
                          : locator<OrderManager>().currency.value ==
                                  PaymentCurrency.USDC
                              ? 'USDC'
                              : locator<OrderManager>().currency.value ==
                                      PaymentCurrency.AUD
                                  ? 'AUD'
                                  : 'CNY',
            ),
        ],
      ),
    );
  }

  Widget _orderOverview() {
    return Container(
      // height: SizeConfig.heightMultiplier * 26.362984218077475,
      margin: EdgeInsets.only(
        left: SizeConfig.widthMultiplier * 3.8888888888888884,
        right: SizeConfig.widthMultiplier * 3.8888888888888884,
        bottom: SizeConfig.widthMultiplier * 3.8888888888888884,
      ),

      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: AppColors.catTextColor)),
      child: Column(
        children: [
          Container(
              margin: EdgeInsets.only(
                  left: SizeConfig.widthMultiplier * 3.8888888888888884,
                  right: SizeConfig.widthMultiplier * 3.8888888888888884,
                  top: SizeConfig.heightMultiplier * 2.0086083213773316),
              child: ListView(
                shrinkWrap: true,
                physics: BouncingScrollPhysics(),
                children: locator
                    .get<ShoppingCartManager>()
                    .purchaseProduct
                    .map((e) => RowWidget(
                        _isChinese ? e.chineseProductTitle : e.productTitle,
                        e.fiatPrice))
                    .toList(),
              )),
          Container(
            margin: EdgeInsets.only(
                left: SizeConfig.widthMultiplier * 3.8888888888888884,
                right: SizeConfig.widthMultiplier * 3.8888888888888884,
                top: SizeConfig.heightMultiplier * 1.5064562410329987),
            height: SizeConfig.heightMultiplier * 0.12553802008608322,
            decoration: BoxDecoration(color: AppColors.catTextColor),
          ),
          Container(
              margin: EdgeInsets.only(
                  left: SizeConfig.widthMultiplier * 3.8888888888888884,
                  right: SizeConfig.widthMultiplier * 3.8888888888888884,
                  top: SizeConfig.heightMultiplier * 1.3809182209469155),
              child: ListView(
                shrinkWrap: true,
                physics: BouncingScrollPhysics(),
                children: _productList
                    .map((e) => RowWidget(
                        e.shippingMethod == null
                            ? "Free shipping"
                            : e.shippingMethod,
                        e.shippingPrice == null ? 0.0 : e.shippingPrice))
                    .toList(),
              )),
          Container(
            margin: EdgeInsets.only(
                left: SizeConfig.widthMultiplier * 3.8888888888888884,
                right: SizeConfig.widthMultiplier * 3.8888888888888884,
                top: SizeConfig.heightMultiplier * 1.5064562410329987),
            height: SizeConfig.heightMultiplier * 0.12553802008608322,
            decoration: BoxDecoration(color: AppColors.catTextColor),
          ),
          Container(
              margin: EdgeInsets.only(
                  left: SizeConfig.widthMultiplier * 3.8888888888888884,
                  right: SizeConfig.widthMultiplier * 3.8888888888888884,
                  top: SizeConfig.heightMultiplier * 1.3809182209469155),
              child: Row(
                children: [
                  Text('Taxes and VAT :',
                      style: GoogleFonts.inter(
                          fontSize:
                              SizeConfig.textMultiplier * 1.5064562410329987,
                          color: AppColors.catTextColor,
                          fontWeight: FontWeight.w400,
                          letterSpacing: 0.4)),
                  Spacer(),
                  Text('0.0',
                      style: GoogleFonts.inter(
                          fontSize:
                              SizeConfig.textMultiplier * 1.5064562410329987,
                          color: AppColors.catTextColor,
                          fontWeight: FontWeight.w400,
                          letterSpacing: 0.4)),
                ],
              )),
          Container(
              margin: EdgeInsets.only(
                  left: SizeConfig.widthMultiplier * 3.8888888888888884,
                  right: SizeConfig.widthMultiplier * 3.8888888888888884,
                  top: SizeConfig.heightMultiplier * 1.6319942611190819,
                  bottom: SizeConfig.heightMultiplier * 1.6319942611190819),
              child: Row(
                children: [
                  Text('Total price :',
                      style: GoogleFonts.inter(
                          fontSize:
                              SizeConfig.textMultiplier * 1.757532281205165,
                          color: AppColors.app_txt_color,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 0.4)),
                  Spacer(),
                  Text(
                    "\$$_orderTotal",
                    style: GoogleFonts.inter(
                        fontSize: SizeConfig.textMultiplier * 1.757532281205165,
                        color: AppColors.app_txt_color,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 0.4),
                  ),
                ],
              )),
        ],
      ),
    );
  }

  Widget _shippingAddress(UpdateAddressModel model) {
    return Container(
        height: SizeConfig.heightMultiplier * 12.679340028694405,
        width: MediaQuery.of(context).size.width,
        margin: EdgeInsets.only(
          left: SizeConfig.widthMultiplier * 3.8888888888888884,
          right: SizeConfig.widthMultiplier * 3.8888888888888884,
        ),
        padding: EdgeInsets.only(
            left: SizeConfig.widthMultiplier * 4.861111111111111,
            top: SizeConfig.heightMultiplier * 2.0086083213773316,
            right: SizeConfig.widthMultiplier * 3.8888888888888884),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: AppColors.appBlue)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              margin: EdgeInsets.only(
                  left: SizeConfig.widthMultiplier * 3.8888888888888884,
                  right: SizeConfig.widthMultiplier * 3.8888888888888884),
              child: Text(
                '${model.firstName + model.lastName ?? ""}',
                style: GoogleFonts.inter(
                  fontSize: SizeConfig.textMultiplier * 1.757532281205165,
                  fontWeight: FontWeight.w700,
                  color: AppColors.app_txt_color,
                  letterSpacing: 0.1,
                ),
              ),
            ),
            Container(
              margin: EdgeInsets.only(
                  top: SizeConfig.heightMultiplier * 0.5021520803443329,
                  left: SizeConfig.widthMultiplier * 3.8888888888888884,
                  right: SizeConfig.widthMultiplier * 3.8888888888888884,
                  bottom: SizeConfig.heightMultiplier * 2.0086083213773316),
              child: Text(
                '${model.streetAddress ?? ""}\n${model.suburb ?? ""} ${model.state ?? ""} ${model.country ?? ""}',
                style: GoogleFonts.inter(
                  fontSize: SizeConfig.textMultiplier * 1.5064562410329987,
                  fontWeight: FontWeight.w400,
                  color: AppColors.app_txt_color,
                  letterSpacing: 0.4,
                ),
              ),
            ),
          ],
        ));
  }

  Widget _completeOrder() {
    return Container(
      margin:
          EdgeInsets.only(top: SizeConfig.heightMultiplier * 5.900286944045911),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Container(
            child: Image.asset(
              'assets/images/order_complete.png',
              width: SizeConfig.widthMultiplier * 44.722222222222214,
              height: SizeConfig.heightMultiplier * 18.32855093256815,
            ),
          ),
          Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Container(
                margin: EdgeInsets.only(
                    top: SizeConfig.heightMultiplier * 5.272596843615495,
                    left: SizeConfig.widthMultiplier * 3.8888888888888884,
                    right: SizeConfig.widthMultiplier * 3.8888888888888884),
                child: Text(
                  _l10n.orderOnWay,
                  style: GoogleFonts.inter(
                      fontSize: SizeConfig.textMultiplier * 2.259684361549498,
                      letterSpacing: 0.15,
                      fontWeight: FontWeight.w500,
                      color: AppColors.app_txt_color),
                )),
            Container(
                margin: EdgeInsets.only(
                    top: SizeConfig.heightMultiplier * 1.0043041606886658,
                    left: SizeConfig.widthMultiplier * 3.8888888888888884,
                    right: SizeConfig.widthMultiplier * 3.8888888888888884),
                child: Text(
                  _l10n.checkEmail,
                  style: GoogleFonts.inter(
                      fontSize: SizeConfig.textMultiplier * 2.0086083213773316,
                      letterSpacing: 0.15,
                      fontWeight: FontWeight.w400,
                      color: AppColors.catTextColor),
                )),
            GestureDetector(
              onTap: () {
                setState(() {
                  if (_orderSummaryExpand) {
                    _orderSummaryExpand = false;
                  } else {
                    _orderSummaryExpand = true;
                  }
                });
              },
              child: Row(
                children: [
                  Container(
                      margin: EdgeInsets.only(
                        top: SizeConfig.heightMultiplier * 5.272596843615495,
                        left: SizeConfig.widthMultiplier * 3.8888888888888884,
                      ),
                      child: Text(
                        _l10n.OrderSummary,
                        style: GoogleFonts.inter(
                            fontSize:
                                SizeConfig.textMultiplier * 2.0086083213773316,
                            letterSpacing: 0.15,
                            fontWeight: FontWeight.w400,
                            color: AppColors.app_txt_color),
                      )),
                  Container(
                      margin: EdgeInsets.only(
                        top: SizeConfig.heightMultiplier * 5.774748923959828,
                        left: SizeConfig.widthMultiplier * 3.8888888888888884,
                      ),
                      child: _orderSummaryExpand
                          ? Image.asset(
                              'assets/images/chevron_bottom.png',
                              width: SizeConfig.widthMultiplier *
                                  2.9166666666666665,
                              height: SizeConfig.heightMultiplier *
                                  0.8787661406025825,
                            )
                          : Image.asset(
                              'assets/images/chevron_right.png',
                              width: SizeConfig.widthMultiplier *
                                  2.9166666666666665,
                              height: SizeConfig.heightMultiplier *
                                  0.8787661406025825,
                            ))
                ],
              ),
            ),
            if (_orderSummaryExpand)
              ListView(
                  shrinkWrap: true,
                  physics: BouncingScrollPhysics(),
                  children: locator
                      .get<ShoppingCartManager>()
                      .purchaseProduct
                      .map((e) => _activeProductCard(e))
                      .toList()),
            if (_orderSummaryExpand)
              Container(
                margin: EdgeInsets.only(
                  top: SizeConfig.heightMultiplier * 2.0086083213773316,
                ),
                child: Container(
                  color: Colors.white,
                  child: Column(
                    // shrinkWrap: true,
                    // physics: BouncingScrollPhysics(),
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        margin: EdgeInsets.only(
                            top: SizeConfig.heightMultiplier *
                                2.5107604017216643,
                            bottom: SizeConfig.heightMultiplier *
                                1.5064562410329987,
                            left: SizeConfig.widthMultiplier *
                                3.8888888888888884),
                        child: Text(
                          _l10n.OrderSummary,
                          style: GoogleFonts.inter(
                            color: AppColors.app_txt_color,
                            fontSize:
                                SizeConfig.textMultiplier * 1.757532281205165,
                            fontWeight: FontWeight.w700,
                            letterSpacing: 0.5,
                          ),
                        ),
                      ),
                      _orderOverview(),
                      Container(
                        margin: EdgeInsets.only(
                            left:
                                SizeConfig.widthMultiplier * 3.8888888888888884,
                            right:
                                SizeConfig.widthMultiplier * 3.8888888888888884,
                            top: SizeConfig.heightMultiplier *
                                2.5107604017216643,
                            bottom: SizeConfig.heightMultiplier *
                                1.5064562410329987),
                        child: Text(
                          _l10n.ShippingAddress,
                          style: GoogleFonts.inter(
                              fontSize: SizeConfig.textMultiplier *
                                  2.0086083213773316,
                              fontWeight: FontWeight.w400,
                              letterSpacing: 0.15,
                              color: AppColors.app_txt_color),
                        ),
                      ),
                      _shippingAddress(
                          locator<OrderManager>().getShippingAddress()),
                      // _shippingAddress(_selectedAddressModel),
                      // if (_isLoading)
                      //   BackdropFilter(
                      //     filter: ImageFilter.blur(sigmaX: 0.8, sigmaY: 0.8),
                      //     child: Align(
                      //         alignment: Alignment.center,
                      //         child: LoadingProgress(
                      //           color: Colors.deepOrangeAccent,
                      //         )),
                      //   ),
                      if (!_isLoading)
                        Container(
                          margin: EdgeInsets.only(
                            top: SizeConfig.heightMultiplier *
                                2.5107604017216643,
                            left:
                                SizeConfig.widthMultiplier * 3.8888888888888884,
                          ),
                          child: Text(
                            _l10n.billingAddress,
                            style: GoogleFonts.inter(
                                fontSize: SizeConfig.textMultiplier *
                                    2.0086083213773316,
                                fontWeight: FontWeight.w400,
                                letterSpacing: 0.15,
                                color: AppColors.app_txt_color),
                          ),
                        ),
                      Container(
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(color: AppColors.appBlue)),
                          margin: EdgeInsets.only(
                              top: SizeConfig.heightMultiplier *
                                  2.0086083213773316,
                              left: SizeConfig.widthMultiplier *
                                  3.8888888888888884,
                              right: SizeConfig.widthMultiplier *
                                  3.8888888888888884),
                          child: Row(
                            children: [
                              Radio(
                                value: 0,
                                activeColor: AppColors.appBlue,
                                groupValue: _paymentValue,
                                onChanged: (int value) {
                                  setState(() {
                                    _paymentValue = value;
                                    // print(value);
                                  });
                                },
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    margin: EdgeInsets.only(
                                        top: SizeConfig.heightMultiplier *
                                            2.0086083213773316,
                                        left: SizeConfig.widthMultiplier *
                                            3.8888888888888884,
                                        right: SizeConfig.widthMultiplier *
                                            3.8888888888888884,
                                        bottom: SizeConfig.heightMultiplier *
                                            2.0086083213773316),
                                    child: Text(
                                      _l10n.sameAsShippingAddress,
                                      style: GoogleFonts.inter(
                                        fontSize: SizeConfig.textMultiplier *
                                            1.757532281205165,
                                        fontWeight: FontWeight.w700,
                                        color: AppColors.app_txt_color,
                                        letterSpacing: 0.1,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          )),
                      Container(
                        margin: EdgeInsets.only(
                            top: SizeConfig.heightMultiplier *
                                1.5064562410329987,
                            bottom: SizeConfig.heightMultiplier *
                                1.5064562410329987,
                            left: SizeConfig.widthMultiplier *
                                3.8888888888888884),
                        child: Text(
                          _l10n.paymentMethod,
                          style: GoogleFonts.inter(
                              fontSize: SizeConfig.textMultiplier *
                                  2.0086083213773316,
                              fontWeight: FontWeight.w400,
                              letterSpacing: 0.15,
                              color: AppColors.app_txt_color),
                        ),
                      ),
                      if (locator<OrderManager>().paymentMethod ==
                          PaymentMethodType.card)
                        _paymentMethodCard(
                            locator<OrderManager>().debitCardModel)
                      else if (locator<OrderManager>().paymentMethod ==
                          PaymentMethodType.wallet)
                        PaymentCard(
                          method: "Wallet",
                          currencyType: locator<OrderManager>()
                                      .currency
                                      .value ==
                                  PaymentCurrency.BTC
                              ? 'BTC'
                              : locator<OrderManager>().currency.value ==
                                      PaymentCurrency.ETH
                                  ? 'ETH'
                                  : locator<OrderManager>().currency.value ==
                                          PaymentCurrency.USDC
                                      ? 'USDC'
                                      : locator<OrderManager>()
                                                  .currency
                                                  .value ==
                                              PaymentCurrency.AUD
                                          ? 'AUD'
                                          : 'CNY',
                        ),
                    ],
                  ),
                ),
              ),
          ]),
        ],
      ),
    );
  }

  Widget _activeProductCard(ProductDetModel model) {
    return Container(
        width: MediaQuery.of(context).size.width,
        margin: EdgeInsets.only(
            left: SizeConfig.widthMultiplier * 3.8888888888888884,
            right: SizeConfig.widthMultiplier * 3.8888888888888884,
            top: SizeConfig.heightMultiplier * 2.5107604017216643),
        // height: SizeConfig.heightMultiplier * 16.947632711621235,
        child: Card(
            margin: EdgeInsets.zero,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0)),
            child: Row(
              children: [
                Container(
                  child: _recentlyImage(model),
                ),
                Container(
                  child: _cartTxt(model),
                )
              ],
            )));
  }

  Widget _recentlyImage(ProductDetModel model) {
    return Stack(
      children: [
        Container(
            height: SizeConfig.heightMultiplier * 16.947632711621235,
            width: SizeConfig.widthMultiplier * 30.138888888888886,
            child: CachedNetworkImage(
                imageUrl: model?.productImages[0] != null
                    ? model?.productImages[0]
                    : 'https://png.pngtree.com/png-clipart/20191120/original/pngtree-outline-image-icon-isolated-png-image_5045508.jpg',
                placeholder: (context, url) =>
                    Lottie.asset('assets/loader/image_loading.json'),
                errorWidget: (context, url, error) => Icon(Icons.error),
                fit: BoxFit.cover,
                imageBuilder: (context, imageProvider) => Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(10),
                              topRight: Radius.circular(10)),
                          color: AppColors.toolbarBlue,
                          image: DecorationImage(
                              image: imageProvider, fit: BoxFit.cover)),
                    ))),
      ],
    );
  }

  Widget _cartTxt(ProductDetModel model) {
    if (model.tags == null) {
      _isTags = false;
    } else {
      _isTags = true;
    }
    double prefCurrency, cryto;
    var prefSevenDecimal, cryptoDecimal;
    if (Constants.aud != null) {
      prefCurrency = model.fiatPrice / double.parse(Constants.aud);
      cryto = (model.fiatPrice / double.parse(Constants.aud)) *
          double.parse(Constants.btc);
      if (prefCurrency.toString().length > 7) {
        prefSevenDecimal = double.parse(prefCurrency.toStringAsFixed(7));
        cryptoDecimal = double.parse(cryto.toStringAsFixed(7));
      } else {
        prefSevenDecimal = prefCurrency;
        cryptoDecimal = double.parse(cryto.toStringAsFixed(7));
      }
    } else {
      cryto = (model.fiatPrice / 1.0) * double.parse(Constants.btc);
      cryptoDecimal = double.parse(cryto.toStringAsFixed(7));
    }

    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            child: Row(
              children: [
                Container(
                  margin: EdgeInsets.only(
                      left: SizeConfig.widthMultiplier * 2.9166666666666665,
                      top: SizeConfig.heightMultiplier * 1.0043041606886658),
                  child: Text(
                      _isChinese
                          ? model.chineseProductTitle
                          : model?.productTitle,
                      style: GoogleFonts.inter(
                          fontSize:
                              SizeConfig.textMultiplier * 2.259684361549498,
                          fontWeight: FontWeight.w500,
                          letterSpacing: 0.15)),
                ),
                Spacer(),
                Column(
                  children: [
                    Padding(
                      padding: EdgeInsets.only(
                          top: SizeConfig.heightMultiplier * 1.5064562410329987,
                          right:
                              SizeConfig.widthMultiplier * 1.9444444444444442,
                          left: SizeConfig.widthMultiplier * 3.645833333333333),
                      child: Text(
                        '\$${prefCurrency}',
                        maxLines: 1,
                        style: GoogleFonts.inter(
                            fontSize:
                                SizeConfig.textMultiplier * 1.757532281205165,
                            fontWeight: FontWeight.w700,
                            letterSpacing: 0.1),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(
                          right:
                              SizeConfig.widthMultiplier * 1.9444444444444442,
                          left: SizeConfig.widthMultiplier * 3.645833333333333),
                      child: Row(children: [
                        Icon(
                          CryptoFontIcons.BTC,
                          size: 12,
                        ),
                        Text(
                          '$cryptoDecimal',
                          maxLines: 1,
                          style: GoogleFonts.inter(
                              fontSize: SizeConfig.textMultiplier *
                                  1.5064562410329987,
                              fontWeight: FontWeight.w400,
                              letterSpacing: 0.4),
                        ),
                      ]),
                    ),
                  ],
                ),
              ],
            ),
          ),
          if (_isTags)
            Container(
                height: SizeConfig.heightMultiplier * 6.276901004304161,
                width: double.infinity,
                padding: EdgeInsets.all(2),
                child: GridView.count(
                    crossAxisCount: 2,
                    shrinkWrap: true,
                    childAspectRatio: 0.22,
                    scrollDirection: Axis.horizontal,
                    children: model?.tags?.map((e) => _tags(e))?.toList())),
          Padding(
            padding: EdgeInsets.only(
                left: SizeConfig.widthMultiplier * 2.9166666666666665,
                top: SizeConfig.heightMultiplier * 1.0043041606886658,
                right: SizeConfig.widthMultiplier * 1.9444444444444442,
                bottom: SizeConfig.heightMultiplier * 0.6276901004304161),
            child: Text(
              model?.description ?? "",
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: GoogleFonts.inter(
                  fontSize: SizeConfig.textMultiplier * 1.5064562410329987,
                  fontWeight: FontWeight.w400,
                  color: AppColors.catTextColor,
                  letterSpacing: 0.4),
            ),
          ),
        ],
      ),
    );
  }

  Widget _tags(String tag) {
    Color color;
    if (tag.length <= 3) {
      color = AppColors.tag_short;
    } else if (tag.length > 3 && tag.length < 6) {
      color = AppColors.tag_normal;
    } else if (tag.length >= 6 && tag.length < 8) {
      color = AppColors.tag_medium;
    } else if (tag.length >= 8) {
      color = AppColors.tag_longest;
    }
    return Container(
      margin: EdgeInsets.only(
          top: SizeConfig.heightMultiplier * 1.0043041606886658,
          left: SizeConfig.widthMultiplier * 0.9722222222222221),
      decoration:
          BoxDecoration(borderRadius: BorderRadius.circular(10), color: color),
      child: Center(
        child: Text(
          tag,
          textAlign: TextAlign.center,
          style: GoogleFonts.inter(
            fontSize: SizeConfig.textMultiplier * 1.2553802008608321,
            letterSpacing: 0.4,
          ),
        ),
      ),
    );
  }

  Widget _completeProductDigital() {
    return Container(
      margin:
          EdgeInsets.only(top: SizeConfig.heightMultiplier * 5.900286944045911),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Container(
            child: Image.asset(
              'assets/images/completed_email_icon.png',
              width: SizeConfig.widthMultiplier * 44.722222222222214,
              height: SizeConfig.heightMultiplier * 18.32855093256815,
            ),
          ),
          Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Container(
                margin: EdgeInsets.only(
                    top: SizeConfig.heightMultiplier * 5.272596843615495,
                    left: SizeConfig.widthMultiplier * 3.8888888888888884,
                    right: SizeConfig.widthMultiplier * 3.8888888888888884),
                child: Text(
                  '${_l10n.gotMail}!',
                  style: GoogleFonts.inter(
                      fontSize: SizeConfig.textMultiplier * 2.259684361549498,
                      letterSpacing: 0.15,
                      fontWeight: FontWeight.w500,
                      color: AppColors.app_txt_color),
                )),
            Container(
                margin: EdgeInsets.only(
                    top: SizeConfig.heightMultiplier * 1.0043041606886658,
                    left: SizeConfig.widthMultiplier * 3.8888888888888884,
                    right: SizeConfig.widthMultiplier * 3.8888888888888884),
                child: Text(
                  '${_l10n.checkMailOrderSummary}. ',
                  style: GoogleFonts.inter(
                      fontSize: SizeConfig.textMultiplier * 2.0086083213773316,
                      letterSpacing: 0.15,
                      fontWeight: FontWeight.w400,
                      color: AppColors.catTextColor),
                )),
            GestureDetector(
              onTap: () {
                setState(() {
                  if (_orderSummaryExpand) {
                    _orderSummaryExpand = false;
                  } else {
                    _orderSummaryExpand = true;
                  }
                });
              },
              child: Row(
                children: [
                  Container(
                      margin: EdgeInsets.only(
                        top: SizeConfig.heightMultiplier * 5.272596843615495,
                        left: SizeConfig.widthMultiplier * 3.8888888888888884,
                      ),
                      child: Text(
                        _l10n.OrderSummary,
                        style: GoogleFonts.inter(
                            fontSize:
                                SizeConfig.textMultiplier * 2.0086083213773316,
                            letterSpacing: 0.15,
                            fontWeight: FontWeight.w400,
                            color: AppColors.app_txt_color),
                      )),
                  Container(
                      margin: EdgeInsets.only(
                        top: SizeConfig.heightMultiplier * 5.774748923959828,
                        left: SizeConfig.widthMultiplier * 3.8888888888888884,
                      ),
                      child: _orderSummaryExpand
                          ? Image.asset(
                              'assets/images/chevron_bottom.png',
                              width: SizeConfig.widthMultiplier *
                                  2.9166666666666665,
                              height: SizeConfig.heightMultiplier *
                                  0.8787661406025825,
                            )
                          : Image.asset(
                              'assets/images/chevron_right.png',
                              width: SizeConfig.widthMultiplier *
                                  2.9166666666666665,
                              height: SizeConfig.heightMultiplier *
                                  0.8787661406025825,
                            ))
                ],
              ),
            ),
            if (_orderSummaryExpand)
              ListView(
                  shrinkWrap: true,
                  physics: BouncingScrollPhysics(),
                  children:
                      _productList.map((e) => _activeProductCard(e)).toList()),
            if (_orderSummaryExpand)
              Container(
                margin: EdgeInsets.only(
                  top: SizeConfig.heightMultiplier * 2.0086083213773316,
                ),
                child: Container(
                  color: Colors.white,
                  child: Column(
                    // shrinkWrap: true,
                    // physics: BouncingScrollPhysics(),
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        margin: EdgeInsets.only(
                            top: SizeConfig.heightMultiplier *
                                2.5107604017216643,
                            bottom: SizeConfig.heightMultiplier *
                                1.5064562410329987,
                            left: SizeConfig.widthMultiplier *
                                3.8888888888888884),
                        child: Text(
                          _l10n.OrderedReview,
                          style: GoogleFonts.inter(
                            color: AppColors.app_txt_color,
                            fontSize:
                                SizeConfig.textMultiplier * 1.757532281205165,
                            fontWeight: FontWeight.w700,
                            letterSpacing: 0.5,
                          ),
                        ),
                      ),
                      _orderOverview(),
                      Container(
                        margin: EdgeInsets.only(
                            left:
                                SizeConfig.widthMultiplier * 3.8888888888888884,
                            right:
                                SizeConfig.widthMultiplier * 3.8888888888888884,
                            top: SizeConfig.heightMultiplier *
                                2.5107604017216643,
                            bottom: SizeConfig.heightMultiplier *
                                1.5064562410329987),
                        child: Text(
                          _l10n.ShippingAddress,
                          style: GoogleFonts.inter(
                            color: AppColors.catTextColor,
                            fontSize:
                                SizeConfig.textMultiplier * 1.757532281205165,
                            fontWeight: FontWeight.w700,
                            letterSpacing: 0.5,
                          ),
                        ),
                      ),
                      // _shippingAddress(_selectedAddressModel),
                      // if (_isLoading)
                      //   BackdropFilter(
                      //     filter: ImageFilter.blur(sigmaX: 0.8, sigmaY: 0.8),
                      //     child: Align(
                      //         alignment: Alignment.center,
                      //         child: LoadingProgress(
                      //           color: Colors.deepOrangeAccent,
                      //         )),
                      //   ),
                      if (!_isLoading)
                        Container(
                          margin: EdgeInsets.only(
                              top: SizeConfig.heightMultiplier *
                                  2.5107604017216643,
                              left: SizeConfig.widthMultiplier *
                                  3.8888888888888884,
                              bottom: SizeConfig.heightMultiplier *
                                  2.0086083213773316),
                          child: Text(
                            _l10n.billingAddress,
                            style: GoogleFonts.inter(
                                fontSize: SizeConfig.textMultiplier *
                                    2.0086083213773316,
                                fontWeight: FontWeight.w400,
                                letterSpacing: 0.15,
                                color: AppColors.app_txt_color),
                          ),
                        ),
                      Container(
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(color: AppColors.appBlue)),
                          margin: EdgeInsets.only(
                              top: SizeConfig.heightMultiplier *
                                  2.0086083213773316,
                              left: SizeConfig.widthMultiplier *
                                  3.8888888888888884,
                              right: SizeConfig.widthMultiplier *
                                  3.8888888888888884),
                          child: Row(
                            children: [
                              Radio(
                                value: 0,
                                activeColor: AppColors.appBlue,
                                groupValue: _paymentValue,
                                onChanged: (int value) {
                                  setState(() {
                                    _paymentValue = value;
                                    // print(value);
                                  });
                                },
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    margin: EdgeInsets.only(
                                        top: SizeConfig.heightMultiplier *
                                            2.0086083213773316,
                                        left: SizeConfig.widthMultiplier *
                                            3.8888888888888884,
                                        right: SizeConfig.widthMultiplier *
                                            3.8888888888888884,
                                        bottom: SizeConfig.heightMultiplier *
                                            2.0086083213773316),
                                    child: Text(
                                      _l10n.sameAsShippingAddress,
                                      style: GoogleFonts.inter(
                                        fontSize: SizeConfig.textMultiplier *
                                            1.757532281205165,
                                        fontWeight: FontWeight.w700,
                                        color: AppColors.app_txt_color,
                                        letterSpacing: 0.1,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          )),
                      Container(
                        margin: EdgeInsets.only(
                            top: SizeConfig.heightMultiplier *
                                1.5064562410329987,
                            bottom: SizeConfig.heightMultiplier *
                                1.5064562410329987,
                            left: SizeConfig.widthMultiplier *
                                3.8888888888888884),
                        child: Text(
                          _l10n.paymentMethod,
                          style: GoogleFonts.inter(
                            color: AppColors.catTextColor,
                            fontSize:
                                SizeConfig.textMultiplier * 1.757532281205165,
                            fontWeight: FontWeight.w700,
                            letterSpacing: 0.5,
                          ),
                        ),
                      ),
                      _paymentMethodCard(_debitCard),
                    ],
                  ),
                ),
              ),
          ]),
        ],
      ),
    );
  }

  Widget _orderTracking() {
    double width = MediaQuery.of(context).size.width;
    return Builder(builder: (BuildContext context) {
      PageState state = context.watch<PageBloc>().state;
      return Container(
        width: width,
        // height: SizeConfig.heightMultiplier * 8,
        padding: EdgeInsets.only(
            left: SizeConfig.widthMultiplier * 4,
            right: SizeConfig.widthMultiplier * 4,
            top: 30),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          mainAxisSize: MainAxisSize.min,
          children: [
            Flexible(
              // width: width * 0.22,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        height:
                            SizeConfig.heightMultiplier * 1.0043041606886658,
                        width: SizeConfig.widthMultiplier * 1.9444444444444442,
                        margin: EdgeInsets.only(
                            left: SizeConfig.widthMultiplier *
                                3.8888888888888884),
                        decoration: _isShippingDone
                            ? BoxDecoration(
                                color: AppColors.appBlue,
                                shape: BoxShape.circle,
                              )
                            : BoxDecoration(
                                border: Border.all(
                                    color: _isShipping
                                        ? AppColors.appBlue
                                        : AppColors.text_field_container,
                                    width: SizeConfig.widthMultiplier *
                                        0.48611111111111105),
                                shape: BoxShape.circle,
                              ),
                      ),
                      Flexible(
                        child: Container(
                          height:
                              SizeConfig.heightMultiplier * 0.12553802008608322,
                          // width: width * 0.15,
                          margin: EdgeInsets.only(
                              left: SizeConfig.widthMultiplier *
                                  0.48611111111111105),
                          color: _isPayment || _isPaymentDone
                              ? AppColors.appBlue
                              : AppColors.text_field_container,
                        ),
                      ),
                    ],
                  ),
                  Container(
                    margin: EdgeInsets.only(
                        top: SizeConfig.heightMultiplier * 1.5064562410329987,
                        bottom:
                            SizeConfig.heightMultiplier * 1.5064562410329987),
                    child: Text(
                      _l10n.shipping,
                      style: GoogleFonts.inter(
                        fontSize:
                            SizeConfig.textMultiplier * 1.5064562410329987,
                        fontWeight:
                            _isShipping ? FontWeight.w700 : FontWeight.w400,
                        color: _isShipping
                            ? AppColors.appBlue
                            : AppColors.app_txt_color,
                        letterSpacing: 0.4,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Flexible(
                // width: width * 0.22,
                child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      height: SizeConfig.heightMultiplier * 1.0043041606886658,
                      width: SizeConfig.widthMultiplier * 1.9444444444444442,
                      margin: EdgeInsets.only(
                          left:
                              SizeConfig.widthMultiplier * 0.48611111111111105),
                      decoration: _isPaymentDone
                          ? BoxDecoration(
                              color: AppColors.appBlue,
                              shape: BoxShape.circle,
                            )
                          : BoxDecoration(
                              border: Border.all(
                                  color: (state == PageState.initial)
                                      ? AppColors.text_field_container
                                      : AppColors.appBlue,
                                  width: SizeConfig.widthMultiplier *
                                      0.48611111111111105),
                              shape: BoxShape.circle,
                            ),
                    ),
                    Flexible(
                      child: Container(
                        height:
                            SizeConfig.heightMultiplier * 0.12553802008608322,
                        // width: width * 0.18,
                        margin: EdgeInsets.only(
                            left: SizeConfig.widthMultiplier *
                                0.48611111111111105),
                        color: _isReview || _isReviewDone
                            ? AppColors.appBlue
                            : AppColors.text_field_container,
                      ),
                    ),
                  ],
                ),
                Container(
                  margin: EdgeInsets.only(
                      top: SizeConfig.heightMultiplier * 1.5064562410329987,
                      bottom: SizeConfig.heightMultiplier * 1.5064562410329987),
                  child: Text(
                    _l10n.payment,
                    style: GoogleFonts.inter(
                      fontSize: SizeConfig.textMultiplier * 1.5064562410329987,
                      fontWeight: (state == PageState.initial)
                          ? FontWeight.w400
                          : FontWeight.w700,
                      color: (state == PageState.initial)
                          ? AppColors.app_txt_color
                          : AppColors.appBlue,
                      letterSpacing: 0.4,
                    ),
                  ),
                ),
              ],
            )),
            Flexible(
                // width: width * 0.22,
                child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  child: Row(
                    children: [
                      Container(
                        height:
                            SizeConfig.heightMultiplier * 1.0043041606886658,
                        width: SizeConfig.widthMultiplier * 1.9444444444444442,
                        margin: EdgeInsets.only(
                            left: SizeConfig.widthMultiplier *
                                0.48611111111111105),
                        decoration: _isReviewDone
                            ? BoxDecoration(
                                color: AppColors.appBlue,
                                shape: BoxShape.circle,
                              )
                            : BoxDecoration(
                                border: Border.all(
                                    color: (state == PageState.checkout ||
                                            state == PageState.complete)
                                        ? AppColors.appBlue
                                        : AppColors.text_field_container,
                                    width: SizeConfig.widthMultiplier *
                                        0.48611111111111105),
                                shape: BoxShape.circle,
                              ),
                      ),
                      Flexible(
                        child: Container(
                          height:
                              SizeConfig.heightMultiplier * 0.12553802008608322,
                          // width: width * 0.18,
                          margin: EdgeInsets.only(
                              left: SizeConfig.widthMultiplier *
                                  0.48611111111111105),
                          color: false
                              ? AppColors.appBlue
                              : AppColors.text_field_container,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  // width: width * 0.2,
                  margin: EdgeInsets.only(
                      top: SizeConfig.heightMultiplier * 1.5064562410329987,
                      bottom: SizeConfig.heightMultiplier * 1.5064562410329987),
                  child: Text(
                    _l10n.reviewOrder,
                    style: GoogleFonts.inter(
                      fontSize: SizeConfig.textMultiplier * 1.5064562410329987,
                      fontWeight: (state == PageState.checkout ||
                              state == PageState.complete)
                          ? FontWeight.w700
                          : FontWeight.w400,
                      color: (state == PageState.checkout ||
                              state == PageState.complete)
                          ? AppColors.appBlue
                          : AppColors.app_txt_color,
                      letterSpacing: 0.4,
                    ),
                  ),
                ),
              ],
            )),
            Flexible(
                // width: width * 0.22,
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                  Container(
                    margin: EdgeInsets.only(
                      bottom: SizeConfig.heightMultiplier * 1.5064562410329987,
                    ),
                    height: SizeConfig.heightMultiplier * 1.0043041606886658,
                    width: SizeConfig.widthMultiplier * 1.9444444444444442,
                    decoration: BoxDecoration(
                      border: Border.all(
                          color: (state == PageState.complete)
                              ? AppColors.appBlue
                              : AppColors.text_field_container,
                          width:
                              SizeConfig.widthMultiplier * 0.48611111111111105),
                      shape: BoxShape.circle,
                    ),
                  ),
                  Container(
                    // width: width * 0.2,
                    margin: EdgeInsets.only(
                        bottom:
                            SizeConfig.heightMultiplier * 1.5064562410329987),
                    child: Text(
                      _l10n.completed,
                      style: GoogleFonts.inter(
                        fontSize:
                            SizeConfig.textMultiplier * 1.5064562410329987,
                        fontWeight: (state == PageState.complete)
                            ? FontWeight.w700
                            : FontWeight.w400,
                        color: (state == PageState.complete)
                            ? AppColors.appBlue
                            : AppColors.app_txt_color,
                        letterSpacing: 0.4,
                      ),
                    ),
                  ),
                ])),
          ],
        ),
      );
    });
  }
}
