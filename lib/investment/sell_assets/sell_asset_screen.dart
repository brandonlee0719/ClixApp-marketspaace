import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:market_space/apis/orderApi/orderManager.dart';
import 'package:market_space/common/colors.dart';
import 'package:market_space/common/mixins/chooseBillingAddressMixin.dart';
import 'package:market_space/common/mixins/keypadMixin.dart';
import 'package:market_space/common/mixins/test_cubit.dart';
import 'package:market_space/common/mixins/webviewMxin.dart';
import 'package:market_space/common/mixins/wrongInputNotifyMixin.dart';
import 'package:market_space/common/proxy/Icacher.dart';
import 'package:market_space/common/raised_gradient_button.dart';
import 'package:market_space/common/transactionScreens/transactionScreen.dart';
import 'package:market_space/investment/sell_assets/routes/chooseCoinRoute.dart';
import 'package:market_space/investment/sell_assets/screens/orderPreview.dart';
import 'package:market_space/investment/sell_assets/screens/recieveBTCScreen.dart';
import 'package:market_space/investment/sell_assets/screens/widgets/convertCard.dart';
import 'package:market_space/investment/sell_assets/screens/widgets/sellAssetToolBar.dart';
import 'package:market_space/investment/sell_assets/sell_asset_route.dart';
import 'package:market_space/order_checkout/network/checkoutProvider.dart';
import 'package:market_space/profile_settings/model/debit_card_model.dart';
import 'package:market_space/profile_settings/receiving_payment/receiving_payment_route.dart';
import 'package:market_space/representation/buttons.dart';
import 'package:market_space/services/RouterServices.dart';
import 'package:market_space/responsive_layout/size_config.dart';
import 'package:market_space/services/dialogueServices/dialogueService.dart';
import 'package:market_space/services/locator.dart';
import 'package:market_space/services/routServiceProvider.dart';
import 'package:provider/provider.dart';
import 'package:market_space/common/mixins/test_cubit.dart';

import 'assetProvider/sellAssetProvider.dart';
import 'models/ConvertModel.dart';

enum BuyCryptoMode {
  aud,
  crypto,
}

class SellAssetScreen extends StatefulWidget {
  final bool isSell;
  final bool isReceive;
  final bool isWithdraw;
  final bool isConvert;

  const SellAssetScreen(
      {this.isSell = false,
      this.isReceive = false,
      this.isWithdraw = false,
      this.isConvert = false});

  @override
  _SellAssetScreenState createState() => _SellAssetScreenState();
}

enum SellAssetScreenType {
  sell,
  buy,
  convert,
  receive,
  withdraw,
}

class _SellAssetScreenState extends State<SellAssetScreen>
    with
        WrongInputNotifier<SellAssetScreen>,
        keyPadMixin,
        ChooseBillingMixin<SellAssetScreen>,
        WebViewMixin<SellAssetScreen> {
  int slideIndex = 0;
  String _bitcoinValue = "0";
  String _bitLimit = "3000";
  bool _preview = false;
  bool _coinView = false;
  bool isLoading = false;
  RouteServiceProvider routeProvider;
  DebitCardModel model;
  BuyCryptoMode mode = BuyCryptoMode.aud;
  SellAssetScreenType sellAssetScreenType = SellAssetScreenType.buy;
  String screenType = "Buy";
  SelleAssetProvider provider = SelleAssetProvider();
  String orderId;
  bool isSuccess = false;
  ConvertModel convertModel;

  @override
  void dispose() {
    SellAssetRoute.dipose();
    // TODO: implement dispose
    super.dispose();
  }

  @override
  void initState() {
    // print(widget.isSell);
    if (widget.isSell) {
      screenType = "Sell";
    }
    routeProvider = Provider.of<RouteServiceProvider>(context, listen: false);
    if (widget.isSell) {
      initAsSell();
    } else if (widget.isConvert) {
      initAsCOnvert();
    } else {
      initAsBuy();
    }
    if (SellAssetRoute.coinType != null) {
      provider.setCoin(SellAssetRoute.coinType);
      setState(() {
        _coinView = true;
      });
    }

    setScreenType();
    reloadCard();
    super.initState();
  }

  setScreenType() {
    if (widget.isSell) {
      this.sellAssetScreenType = SellAssetScreenType.sell;
    } else if (widget.isReceive) {
      this.sellAssetScreenType = SellAssetScreenType.receive;
    } else if (widget.isConvert) {
      this.sellAssetScreenType = SellAssetScreenType.convert;
    } else if (widget.isWithdraw) {
      this.sellAssetScreenType = SellAssetScreenType.withdraw;
    }
  }

  Widget display() {
    if (isSuccess) {
      if (!widget.isSell) {
        return TransactionWidget(
          name: "assets/images/financials/successPurchase.png",
          blueText: "payment successful",
          greyText:
              "The payment ${this.mode == BuyCryptoMode.aud ? "AUD" : provider.currencySimpleName.toUpperCase()}\$${this.getNumber()} is successful",
        );
      }
      return TransactionWidget(
        name: "assets/images/financials/successfulTransfer.png",
        blueText: "Withdraw successful",
        greyText: "The withdraw A\$${this.getNumber()} is successful",
      );
    }
    switch (this.sellAssetScreenType) {
      case SellAssetScreenType.receive:
        return ReceiveCryptoScreen();
      case SellAssetScreenType.withdraw:
        return WithdrawBTCScreen();
      case SellAssetScreenType.convert:
        return _buyBitcoinUI();
      default:
        return _coinView ? _buyBitcoinUI() : _baseScreen();
    }
  }

  initAsBuy() {
    provider.status = PreviewButtonStatus.buyInitial;
    provider[PreviewButtonStatus.buyInitial] = _getModel;
    provider[PreviewButtonStatus.awaitCvv] = _getCvv;
    provider[PreviewButtonStatus.awaitCardAuth] = _getCardAuth;
    provider[PreviewButtonStatus.finalize] = () {
      // print("success");
      setState(() {
        setState(() {
          isSuccess = true;
        });
      });
    };
  }

  initAsSell() async {
    String s =
        await RouterService.appRouter.navigateTo(UploadBankRoute.buildPath());
    // print(s);
    if (s == null) {
      Navigator.pop(context);
    }
    provider.status = PreviewButtonStatus.sellInitial;
    provider[PreviewButtonStatus.sellInitial] = _getSellModel;
    provider[PreviewButtonStatus.awaitProve] = _confirmSell;
    provider[PreviewButtonStatus.finalize] = () {
      // print("success");
      setState(() {
        setState(() {
          isSuccess = true;
        });
      });
    };
  }

  initAsCOnvert() {
    provider.status = PreviewButtonStatus.convertInitial;
    provider[PreviewButtonStatus.convertInitial] = convert;
    provider[PreviewButtonStatus.awaitConvertProve] = confirmConvert;
    provider[PreviewButtonStatus.finalize] = () {
      // print("success");
      setState(() {
        setState(() {
          isSuccess = true;
        });
      });
    };
  }

  Future<void> convert() async {
    String amount = getNumber();
    String source = provider.currencySimpleName;
    String dest = provider.destCurrencySimpleName;
    String currencyOfSale = this.mode == BuyCryptoMode.aud ? "AUD" : source;

    var model = await locator
        .get<CacheableManager>()
        .convert(source, amount, currencyOfSale, dest);
    setState(() {
      this.convertModel = model;
    });

    this.orderId = model.id;
    provider.goNext();
  }

  Future<void> confirmConvert() async {
    await DialogueService.instance.showLoadingDialogue(context, () async {
      int responseCode =
          await locator.get<CacheableManager>().confirmConvert(this.orderId);
      // print(responseCode);
      if (responseCode == 200) {
        provider.goNext();
        provider.handleScreenCall();
      }
    });
  }

  Future<void> _confirmSell() async {
    if (provider.model == null) {
      DialogueService.instance
          .showErrorDialogue(context, 'please reload the review first!', () {
        // print("nothing");
      });
    } else {
      String result = await DialogueService.instance.showSMSAuth(context);
      // print("the result is $result");
      if (result != null) {
        int responseCode;
        await DialogueService.instance.showLoadingDialogue(context, () async {
          int code = await provider.confirmSell();
          // print("code is $code");
          responseCode = code;
        });
        // print(responseCode);
        if (responseCode != 200) {
          DialogueService.instance.showErrorDialogue(context,
              'Buy confirmation is not success, click sell button to try again',
              () {
            // print("nothing");
          });
        } else {
          // print("good");
          provider.goNext();
          provider.handleScreenCall();
        }
      }
    }
  }

  Future<void> _getCvv() async {
    Map<String, dynamic> map;
    if (provider.model == null) {
      DialogueService.instance
          .showErrorDialogue(context, 'please reload the review first!', () {
        // print("nothing");
      });
    } else {
      String cvv = await DialogueService.instance.showCvvDialogue(context);
      if (cvv == null || cvv.length != 3) {
        DialogueService.instance.showErrorDialogue(
            context, 'please input a valid cvv!', provider.handleScreenCall);
      }
      await DialogueService.instance.showLoadingDialogue(context, () async {
        map = await provider.buy(cvv, this.mode);
        // print(map);
        if (map != null) {
          locator.get<OrderManager>().cardAuth = Map<String, dynamic>();
          locator.get<OrderManager>().cardAuth["type"] = map["type"];
          locator.get<OrderManager>().cardAuth["unauthCardOrderID"] =
              map["unauthCardOrderID"];
        }
      });
    }

    if (map != null) {
      provider.goNext();
      provider.handleScreenCall();
    } else {
      DialogueService.instance
          .showErrorDialogue(context, 'Wrong cvv!', provider.handleScreenCall);
    }
  }

  Future<void> _getCardAuth() async {
    int responseCode;
    await DialogueService.instance.showCardAuthDialogue(context);
    var submitMap = locator.get<OrderManager>().cardAuth;
    // print(submitMap);
    await DialogueService.instance.showLoadingDialogue(context, () async {
      responseCode = await CheckoutProvider().finalizePurchase(submitMap);
    });
    // print("code: ${responseCode}");

    if (responseCode == 200) {
      provider.goNext();
      provider.handleScreenCall();
    } else {
      DialogueService.instance.showErrorDialogue(context,
          'your card auth is not accepted, plz try again', _getCardAuth);
    }
  }

  void _getModel() {
    if (!isValid()) {
      DialogueService.instance
          .showErrorDialogue(context, "your number is invalid", null);
    } else {
      provider.getTradeModel(
        this.mode == BuyCryptoMode.aud ? "source" : "dest",
        getNumber(),
      );
      provider.goNext();
    }
  }

  void _getSellModel() {
    provider.getSellModel(
      this.mode == BuyCryptoMode.aud
          ? "AUD"
          : provider.currencySimpleName.toUpperCase(),
      getNumber(),
    );

    provider.goNext();
  }

  Widget _previewButton() {
    return Builder(builder: (context) {
      return GestureDetector(
        onTap: () {
          if (_preview == false) {
            if (isValid()) {
              setState(() {
                _preview = true;
              });
            }
          }
          // show();
          provider.handleScreenCall();
        },
        child: Container(
          width: MediaQuery.of(context).size.width,
          height: SizeConfig.heightMultiplier * 6.025824964131995,
          margin: EdgeInsets.only(
              top: SizeConfig.heightMultiplier *
                  5.021520803443329001212410638749,
              left: _preview
                  ? 0
                  : SizeConfig.widthMultiplier *
                      3.8888888888888882137345679012347,
              right: _preview
                  ? 0
                  : SizeConfig.widthMultiplier *
                      3.8888888888888882137345679012347),
          child: RaisedGradientButton(
            height: SizeConfig.heightMultiplier * 2,
            gradient: LinearGradient(
              colors: <Color>[
                AppColors.gradient_button_light,
                AppColors.gradient_button_dark,
              ],
            ),
            child: Padding(
                padding: EdgeInsets.fromLTRB(
                    SizeConfig.widthMultiplier *
                        1.2152777777777775667920524691358,
                    SizeConfig.heightMultiplier *
                        1.2553802008608322503031026596873,
                    SizeConfig.widthMultiplier *
                        1.2152777777777775667920524691358,
                    SizeConfig.heightMultiplier *
                        1.2553802008608322503031026596873),
                child: Text(
                  _preview
                      ? '${widget.isSell ? "SELL" : widget.isConvert ? "CONVERT" : "BUY"}'
                      : 'PREVIEW ${widget.isSell ? "SELL" : widget.isConvert ? "CONVERT" : "BUY"}',
                  style: GoogleFonts.inter(
                      color: AppColors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: SizeConfig.textMultiplier * 1.757532281205165,
                      letterSpacing: 0.5,
                      textStyle: TextStyle(fontFamily: 'Roboto')),
                )),
          ),
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: SellAssetToolBar(),
      backgroundColor: AppColors.appBlue,
      body: wrongInputNotifier(
        child: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          color: AppColors.white,
          child: Provider<SelleAssetProvider>.value(
            value: provider,
            child: display(),
          ),
        ),
      ),
    );
  }

  Future<void> swiftMode() async {
    if (mode == BuyCryptoMode.aud) {
      this.mode = BuyCryptoMode.crypto;
      changeDecimalPlace(8);
    } else {
      this.mode = BuyCryptoMode.aud;
      changeDecimalPlace(2);
    }
    setState(() {});
  }

  Widget _baseScreen() {
    return Builder(builder: (context) {
      return Container(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              margin: EdgeInsets.only(
                  left: SizeConfig.widthMultiplier * 3.8888888888888884,
                  top: SizeConfig.heightMultiplier * 2.0086083213773316,
                  bottom: SizeConfig.heightMultiplier * 2.0086083213773316),
              child: Text(
                widget.isSell ? 'Select asset to sell' : 'Select asset to buy',
                style: GoogleFonts.inter(
                    fontSize: SizeConfig.textMultiplier * 2.259684361549498,
                    fontWeight: FontWeight.w500,
                    letterSpacing: 0.15,
                    color: AppColors.app_txt_color),
              ),
            ),
            _bitcoinCard(
                'Bitcoin (BTC)',
                Image.asset(
                  'assets/images/logos_bitcoin.png',
                  height: SizeConfig.heightMultiplier * 3.0129124820659974,
                  width: SizeConfig.widthMultiplier * 5.833333333333333,
                ),
                AppColors.bitcoin_orange),
            _bitcoinCard(
              'Ethereum (ETH)',
              Image.asset(
                'assets/images/ethereum_logo.png',
                height: SizeConfig.heightMultiplier * 3.0129124820659974,
                width: SizeConfig.widthMultiplier * 4.861111111111111,
              ),
              AppColors.black,
            ),
            _bitcoinCard(
              'USD coin (USDC)',
              Image.asset(
                'assets/images/cryptocurrency_usdc.png',
                height: SizeConfig.heightMultiplier * 3.0129124820659974,
                width: SizeConfig.widthMultiplier * 5.833333333333333,
              ),
              AppColors.toolbarBlue,
            ),
            if (widget.isSell)
              _bitcoinCard(
                'Australia dollar (AUD)',
                Image.asset(
                  'assets/images/aus_flag.png',
                  height: SizeConfig.heightMultiplier * 3.0129124820659974,
                  width: SizeConfig.widthMultiplier * 5.833333333333333,
                ),
                AppColors.blue_900,
              ),
          ],
        ),
      );
    });
  }

  Widget _bitcoinCard(String title, Image image, Color color) {
    return Builder(builder: (context) {
      return Card(
        color: color,
        margin: EdgeInsets.only(
          left: SizeConfig.widthMultiplier * 3.8888888888888884,
          right: SizeConfig.widthMultiplier * 3.8888888888888884,
          bottom: SizeConfig.widthMultiplier * 3.8888888888888884,
        ),
        child: GestureDetector(
          onTap: () {
            context.read<SelleAssetProvider>().setCoin(title);
            setState(() {
              _coinView = true;
            });
          },
          child: Container(
            height: SizeConfig.heightMultiplier * 7.40674318507891,
            margin: EdgeInsets.only(
                left: SizeConfig.widthMultiplier * 0.9722222222222221),
            color: AppColors.white,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                    margin: EdgeInsets.only(
                        left: SizeConfig.widthMultiplier * 2.9166666666666665,
                        top: SizeConfig.heightMultiplier * 2.0086083213773316,
                        bottom: SizeConfig.heightMultiplier * 2.259684361549498,
                        right: SizeConfig.widthMultiplier * 2.9166666666666665),
                    child: image),
                Container(
                  child: Text(
                    title,
                    style: GoogleFonts.inter(
                      fontWeight: FontWeight.w400,
                      fontSize: SizeConfig.textMultiplier * 2.0086083213773316,
                    ),
                  ),
                ),
                Spacer(),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    // Container(
                    //   margin: EdgeInsets.only(
                    //       left: SizeConfig.widthMultiplier * 2.9166666666666665,
                    //       top: SizeConfig.heightMultiplier * 2.0086083213773316,
                    //       right: SizeConfig.widthMultiplier * 2.9166666666666665),
                    //   child: Text(
                    //     'A\$60,609.42',
                    //     style: GoogleFonts.inter(
                    //       fontWeight: FontWeight.w700,
                    //       fontSize: SizeConfig.textMultiplier * 1.757532281205165,
                    //     ),
                    //   ),
                    // ),
                    // Container(
                    //   margin: EdgeInsets.only(
                    //       left: SizeConfig.widthMultiplier * 2.9166666666666665,
                    //       right: SizeConfig.widthMultiplier * 2.9166666666666665),
                    //   child: Text(
                    //     '-1.23%',
                    //     style: GoogleFonts.inter(
                    //         fontWeight: FontWeight.w400,
                    //         fontSize:
                    //             SizeConfig.textMultiplier * 1.5064562410329987,
                    //         color: AppColors.red_text,
                    //         letterSpacing: 0.4),
                    //   ),
                    // ),
                  ],
                )
              ],
            ),
          ),
        ),
      );
    });
  }

  Future<void> reloadCard() async {
    this.model = await locator<OrderManager>().getCard();
    setState(() {});
  }

  Widget _buyBitcoinUI() {
    return Builder(builder: (context) {
      return Container(
        height: SizeConfig.heightMultiplier * 85,
        child: Column(
          children: [
            Container(
              margin: EdgeInsets.only(
                  left: SizeConfig.widthMultiplier * 3.8888888888888884,
                  top: SizeConfig.heightMultiplier * 2.0086083213773316,
                  bottom: SizeConfig.heightMultiplier * 1.0043041606886658),
              child: Text(
                widget.isSell
                    ? 'Sell ${context.read<SelleAssetProvider>().currencyName}'
                    : this.sellAssetScreenType == SellAssetScreenType.convert
                        ? 'Convert asset'
                        : 'Buy ${context.read<SelleAssetProvider>().currencyName}',
                style: GoogleFonts.inter(
                    fontSize: SizeConfig.textMultiplier * 2.259684361549498,
                    fontWeight: FontWeight.w500,
                    letterSpacing: 0.15,
                    color: AppColors.app_txt_color),
              ),
            ),
            Container(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ValueListenableBuilder<String>(
                      valueListenable: value,
                      builder: (context, value, widget) {
                        _bitcoinValue = value;
                        return Container(
                          width: MediaQuery.of(context).size.width * 0.7,
                          margin: EdgeInsets.only(
                            left:
                                SizeConfig.widthMultiplier * 3.8888888888888884,
                          ),
                          child: this.mode == BuyCryptoMode.aud
                              ? Text(
                                  'A\$$_bitcoinValue',
                                  textAlign: TextAlign.center,
                                  maxLines: 1,
                                  // softWrap: true,
                                  // overflow: TextOverflow.ellipsis,
                                  style: GoogleFonts.inter(
                                      fontSize: SizeConfig.textMultiplier *
                                          6.527977044476327,
                                      fontWeight: FontWeight.w500,
                                      letterSpacing: -0.5,
                                      color: AppColors.investment_back),
                                )
                              : Text(
                                  '$_bitcoinValue ${context.read<SelleAssetProvider>().currencySimpleName}',
                                  textAlign: TextAlign.center,
                                  maxLines: 1,
                                  // softWrap: true,
                                  // overflow: TextOverflow.ellipsis,
                                  style: GoogleFonts.inter(
                                      fontSize: SizeConfig.textMultiplier *
                                          4.527977044476327,
                                      fontWeight: FontWeight.w200,
                                      letterSpacing: -0.5,
                                      color: AppColors.investment_back),
                                ),
                        );
                      }),
                  if (!_preview &&
                      provider.currencySimpleName.toUpperCase() != "AUD")
                    GestureDetector(
                      onTap: swiftMode,
                      child: Container(
                        margin: EdgeInsets.only(
                          left: SizeConfig.widthMultiplier * 3.8888888888888884,
                        ),
                        child: Image.asset(
                          'assets/images/suffel_icon.png',
                          height:
                              SizeConfig.heightMultiplier * 3.0129124820659974,
                          width: SizeConfig.widthMultiplier * 5.833333333333333,
                        ),
                      ),
                    ),
                ],
              ),
            ),
            if (_preview && !widget.isConvert)
              OderPreview(
                isSell: widget.isSell,
              ),
            if (_preview && widget.isConvert && this.convertModel == null)
              Text('awaiting convert'),
            if (_preview && widget.isConvert && this.convertModel != null)
              ConvertPreview(model: this.convertModel),
            if (!_preview &&
                routeProvider.transferRoute == CryptoRouteType.sell)
              _cardDetails(),
            if (!_preview && model == null)
              ButtonBuilder().build(ButtonSection(
                  ButtonSectionType.responseButton,
                  'Add new card',
                  () => RouterService.appRouter
                          .navigateTo(ReceivingPaymentRoute.buildPath())
                          .then((value) {
                        reloadCard();
                      }))),
            if (!_preview &&
                model != null &&
                this.sellAssetScreenType == SellAssetScreenType.buy)
              _paymentMethodCard(model),
            if (!_preview)
              Expanded(
                  flex: 4,
                  child: Align(alignment: Alignment.center, child: _inputUI())),
            Expanded(
                flex: 1,
                child: Align(
                    alignment: Alignment.center,
                    child: Column(children: [
                      _previewButton(),
                      if (_preview)
                        SizedBox(
                            height: SizeConfig.heightMultiplier * 6,
                            child: Center(child: wyrePolicyWidget())),
                    ]))),
          ],
        ),
      );
    });
  }

  Widget _paymentMethodCard(DebitCardModel model) {
    return Container(
      margin: EdgeInsets.only(
          left: SizeConfig.widthMultiplier * 3.8888888888888884,
          right: SizeConfig.widthMultiplier * 3.8888888888888884,
          top: SizeConfig.heightMultiplier * 0.6276901004304161),
      padding: EdgeInsets.all(5),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: AppColors.appBlue)),
      child: Container(
        width: SizeConfig.widthMultiplier * 120,
        padding: EdgeInsets.only(left: SizeConfig.widthMultiplier * 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              child: Text(
                model.cardType == CardType.mastercard
                    ? 'MasterCard ${model.cardNumber ?? ""}'
                    : 'VISA ${model.cardNumber ?? ""}',
                style: GoogleFonts.inter(
                  fontSize: SizeConfig.textMultiplier * 1.757532281205165,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 0.1,
                ),
              ),
            ),
            Container(
              child: Text(
                '${model.cardHolder ?? "Holder name"}',
                style: GoogleFonts.inter(
                  fontSize: SizeConfig.textMultiplier * 1.757532281205165,
                  fontWeight: FontWeight.w400,
                  letterSpacing: 0.1,
                ),
              ),
            ),
            Container(
              child: Text(
                'expire date: ${model.cardExpiry ?? ""}',
                style: GoogleFonts.inter(
                  fontSize: SizeConfig.textMultiplier * 1.757532281205165,
                  fontWeight: FontWeight.w400,
                  letterSpacing: 0.1,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _cardDetails() {
    return Container(
      height: SizeConfig.heightMultiplier * 10.043041606886657,
      margin: EdgeInsets.only(
          left: SizeConfig.widthMultiplier * 3.8888888888888884,
          right: SizeConfig.widthMultiplier * 3.8888888888888884,
          top: SizeConfig.heightMultiplier * 3.0129124820659974),
      padding: EdgeInsets.all(8),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: AppColors.appBlue)),
      child: Container(
          child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  margin: EdgeInsets.only(
                      left: SizeConfig.widthMultiplier * 1.2152777777777777,
                      top: SizeConfig.heightMultiplier * 0.6276901004304161),
                  child: Text(
                    'Saving account',
                    style: GoogleFonts.inter(
                      fontSize: SizeConfig.textMultiplier * 1.757532281205165,
                      fontWeight: FontWeight.w500,
                      letterSpacing: 0.1,
                    ),
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(
                    left: SizeConfig.widthMultiplier * 1.2152777777777777,
                  ),
                  child: Text(
                    '#000000009',
                    style: GoogleFonts.inter(
                      fontSize: SizeConfig.textMultiplier * 1.757532281205165,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 0.1,
                    ),
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(
                    left: SizeConfig.widthMultiplier * 1.2152777777777777,
                  ),
                  child: Text(
                    'Holder name',
                    style: GoogleFonts.inter(
                      fontSize: SizeConfig.textMultiplier * 1.757532281205165,
                      fontWeight: FontWeight.w400,
                      letterSpacing: 0.1,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Spacer(),
          Container(
            child: Text(
              'A\$3,000.00 limit',
              style: GoogleFonts.inter(
                  fontSize: SizeConfig.textMultiplier * 1.757532281205165,
                  fontWeight: FontWeight.w400,
                  letterSpacing: 0.25,
                  color: AppColors.app_txt_color),
            ),
          ),
        ],
      )),
    );
  }

  Widget _inputUI() {
    double _width = MediaQuery.of(context).size.width;
    return Container(
      width: _width,
      margin: EdgeInsets.only(
          top: SizeConfig.heightMultiplier * 1.5064562410329987),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Container(
            height: SizeConfig.heightMultiplier * 9.038737446197992,
            child: Row(
              // crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Material(
                    color: AppColors.white,
                    child: InkWell(
                      onTap: () {
                        pressNumber('1');
                      },
                      child: Container(
                        width: _width * 0.33,
                        color: Colors.transparent,
                        child: Text(
                          '1',
                          textAlign: TextAlign.center,
                          style: GoogleFonts.inter(
                              fontSize:
                                  SizeConfig.textMultiplier * 4.017216642754663,
                              fontWeight: FontWeight.w400,
                              letterSpacing: 0.25,
                              color: AppColors.app_txt_color),
                        ),
                      ),
                    )),
                Material(
                    color: AppColors.white,
                    child: InkWell(
                        onTap: () {
                          pressNumber('2');
                        },
                        child: Container(
                          width: _width * 0.33,
                          child: Text(
                            '2',
                            textAlign: TextAlign.center,
                            style: GoogleFonts.inter(
                                fontSize: SizeConfig.textMultiplier *
                                    4.017216642754663,
                                fontWeight: FontWeight.w400,
                                letterSpacing: 0.25,
                                color: AppColors.app_txt_color),
                          ),
                        ))),
                Material(
                    color: AppColors.white,
                    child: InkWell(
                        onTap: () {
                          pressNumber('3');
                        },
                        child: Container(
                          width: _width * 0.33,
                          child: Text(
                            '3',
                            textAlign: TextAlign.center,
                            style: GoogleFonts.inter(
                                fontSize: SizeConfig.textMultiplier *
                                    4.017216642754663,
                                fontWeight: FontWeight.w400,
                                letterSpacing: 0.25,
                                color: AppColors.app_txt_color),
                          ),
                        ))),
              ],
            ),
          ),
          Container(
            height: SizeConfig.heightMultiplier * 9.038737446197992,
            child: Row(
              // crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Material(
                    color: AppColors.white,
                    child: InkWell(
                        onTap: () {
                          pressNumber('4');
                        },
                        child: Container(
                          width: _width * 0.33,
                          child: Text(
                            '4',
                            textAlign: TextAlign.center,
                            style: GoogleFonts.inter(
                                fontSize: SizeConfig.textMultiplier *
                                    4.017216642754663,
                                fontWeight: FontWeight.w400,
                                letterSpacing: 0.25,
                                color: AppColors.app_txt_color),
                          ),
                        ))),
                Material(
                    color: AppColors.white,
                    child: InkWell(
                        onTap: () {
                          pressNumber('5');
                        },
                        child: Container(
                          width: _width * 0.33,
                          child: Text(
                            '5',
                            textAlign: TextAlign.center,
                            style: GoogleFonts.inter(
                                fontSize: SizeConfig.textMultiplier *
                                    4.017216642754663,
                                fontWeight: FontWeight.w400,
                                letterSpacing: 0.25,
                                color: AppColors.app_txt_color),
                          ),
                        ))),
                Material(
                    color: AppColors.white,
                    child: InkWell(
                        onTap: () {
                          pressNumber('6');
                        },
                        child: Container(
                          width: _width * 0.33,
                          child: Text(
                            '6',
                            textAlign: TextAlign.center,
                            style: GoogleFonts.inter(
                                fontSize: SizeConfig.textMultiplier *
                                    4.017216642754663,
                                fontWeight: FontWeight.w400,
                                letterSpacing: 0.25,
                                color: AppColors.app_txt_color),
                          ),
                        ))),
              ],
            ),
          ),
          Container(
            height: SizeConfig.heightMultiplier * 9.038737446197992,
            child: Row(
              // crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Material(
                    color: AppColors.white,
                    child: InkWell(
                        onTap: () {
                          pressNumber('7');
                        },
                        child: Container(
                          width: _width * 0.33,
                          child: Text(
                            '7',
                            textAlign: TextAlign.center,
                            style: GoogleFonts.inter(
                                fontSize: SizeConfig.textMultiplier *
                                    4.017216642754663,
                                fontWeight: FontWeight.w400,
                                letterSpacing: 0.25,
                                color: AppColors.app_txt_color),
                          ),
                        ))),
                Material(
                    color: AppColors.white,
                    child: InkWell(
                        onTap: () {
                          pressNumber('8');
                        },
                        child: Container(
                          width: _width * 0.33,
                          child: Text(
                            '8',
                            textAlign: TextAlign.center,
                            style: GoogleFonts.inter(
                                fontSize: SizeConfig.textMultiplier *
                                    4.017216642754663,
                                fontWeight: FontWeight.w400,
                                letterSpacing: 0.25,
                                color: AppColors.app_txt_color),
                          ),
                        ))),
                Material(
                    color: AppColors.white,
                    child: InkWell(
                        onTap: () {
                          pressNumber('9');
                        },
                        child: Container(
                          width: _width * 0.33,
                          child: Text(
                            '9',
                            textAlign: TextAlign.center,
                            style: GoogleFonts.inter(
                                fontSize: SizeConfig.textMultiplier *
                                    4.017216642754663,
                                fontWeight: FontWeight.w400,
                                letterSpacing: 0.25,
                                color: AppColors.app_txt_color),
                          ),
                        ))),
              ],
            ),
          ),
          Container(
            height: SizeConfig.heightMultiplier * 9.038737446197992,
            child: Row(
              // crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Material(
                  color: AppColors.white,
                  child: InkWell(
                    onTap: () {
                      pressDot();
                    },
                    child: Container(
                      width: _width * 0.33,
                      child: Text(
                        '.',
                        textAlign: TextAlign.center,
                        style: GoogleFonts.inter(
                            fontSize:
                                SizeConfig.textMultiplier * 4.017216642754663,
                            fontWeight: FontWeight.w400,
                            letterSpacing: 0.25,
                            color: AppColors.app_txt_color),
                      ),
                    ),
                  ),
                ),
                Material(
                    color: AppColors.white,
                    child: InkWell(
                        onTap: () {
                          pressNumber('0');
                        },
                        child: Container(
                          width: _width * 0.33,
                          child: Text(
                            '0',
                            textAlign: TextAlign.center,
                            style: GoogleFonts.inter(
                                fontSize: SizeConfig.textMultiplier *
                                    4.017216642754663,
                                fontWeight: FontWeight.w400,
                                letterSpacing: 0.25,
                                color: AppColors.app_txt_color),
                          ),
                        ))),
                Material(
                    color: AppColors.white,
                    child: InkWell(
                        onTap: () {
                          delete();
                        },
                        child: Container(
                          width: _width * 0.33,
                          child: Text(
                            '<-',
                            textAlign: TextAlign.center,
                            style: GoogleFonts.inter(
                                fontSize: SizeConfig.textMultiplier *
                                    4.017216642754663,
                                fontWeight: FontWeight.w400,
                                letterSpacing: 0.25,
                                color: AppColors.app_txt_color),
                          ),
                        ))),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
