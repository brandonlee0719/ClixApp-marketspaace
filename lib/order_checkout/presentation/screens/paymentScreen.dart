import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:market_space/apis/orderApi/orderManager.dart';
import 'package:market_space/apis/orderApi/walletApi.dart';
import 'package:market_space/apis/userApi/shoppingCartManager.dart';
import 'package:market_space/common/AppIcons.dart';
import 'package:market_space/common/colors.dart';
import 'package:market_space/common/commonWidgets/warningWidget.dart';
import 'package:market_space/common/loading_progress.dart';
import 'package:market_space/investment/models/wallet.dart';
import 'package:market_space/model/recently_bought_options/buyer_options.dart';
import 'package:market_space/order_checkout/logic/order_checkout_bloc/order_checkout_bloc.dart';
import 'package:market_space/order_checkout/model/paymentCurrency.dart';
import 'package:market_space/order_checkout/model/update_address_model/update_address_model.dart';
import 'package:market_space/order_checkout/presentation/widgets/currencyLine.dart';
import 'package:market_space/profile_settings/add_new_address/add_new_address_route.dart';
import 'package:market_space/profile_settings/model/debit_card_model.dart';
import 'package:market_space/profile_settings/receiving_payment/receiving_payment_route.dart';
import 'package:market_space/profile_settings/seller_sending_payments/add_new_sending_payment/add_new_sending_route.dart';
import 'package:market_space/providers/payment_providers/cardProvider.dart';
import 'package:market_space/representation/buttons.dart';
import 'package:market_space/representation/cards.dart';
import 'package:market_space/responsive_layout/size_config.dart';
import 'package:market_space/services/RouterServices.dart';
import 'package:market_space/services/locator.dart';

import '../../order_checkout_l10n.dart';

class PaymentScreen extends StatefulWidget {
  @override
  _PaymentScreenState createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  bool isLoading = false;
  OrderCheckoutL10n _l10n = OrderCheckoutL10n(
      Locale.fromSubtags(languageCode: 'en', countryCode: 'US'));

  bool isCardLoading = false;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  Future<void> reloadCard() async {
    setState(() {
      isCardLoading = true;
    });
    await locator<OrderManager>().getCard();
    setState(() {
      isCardLoading = false;
      if (locator<OrderManager>().debitCardModel == null) {
        locator<OrderManager>().paymentMethod = PaymentMethodType.wallet;
      }
    });
  }

  bool needWarning() {
    int length = locator.get<ShoppingCartManager>().purchaseProduct.length;
    return length > 1;
  }

  @override
  Widget build(BuildContext context) {
    // ignore: close_sinks
    OrderCheckoutBloc orderCheckoutBloc =
        BlocProvider.of<OrderCheckoutBloc>(context);
    return BlocProvider.value(
      value: orderCheckoutBloc,
      child: BlocListener<OrderCheckoutBloc, OrderCheckoutState>(
        listener: (context, state) {
          if (state is Loading) {
            setState(() {
              isLoading = true;
            });
          } else {
            setState(() {
              isLoading = false;
            });
          }
        },
        child: AbsorbPointer(
          absorbing: isLoading,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              if (isLoading == false &&
                  locator<OrderManager>().debitCardModel != null &&
                  !needWarning())
                // _paymentMethodCard(locator<OrderManager>().debitCardModel),
                Container(),
              if (needWarning()) WarningWidget(),
              if (isCardLoading)
                BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 0.8, sigmaY: 0.8),
                  child: Align(
                      alignment: Alignment.center,
                      child: LoadingProgress(
                        color: Colors.deepOrangeAccent,
                      )),
                ),
              _myWallet(orderCheckoutBloc),
              // ButtonBuilder().build(ButtonSection(
              //     ButtonSectionType.responseButton, "Add new payment Method",
              //     () {
              //   RouterService.appRouter
              //       .navigateTo(ReceivingPaymentRoute.buildPath())
              //       .then((value) {
              //     reloadCard();
              //   });
              // })
              // ),
              if (isLoading == true)
                BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 0.8, sigmaY: 0.8),
                  child: Align(
                      alignment: Alignment.center,
                      child: LoadingProgress(
                        color: Colors.deepOrangeAccent,
                      )),
                ),
              if (!isLoading)
                Container(
                  margin: EdgeInsets.only(
                      top: SizeConfig.heightMultiplier * 2.5107604017216643,
                      left: SizeConfig.widthMultiplier * 4,
                      bottom: SizeConfig.heightMultiplier * 2.0086083213773316),
                  alignment: Alignment.centerLeft,
                  child: Text(
                    _l10n.billingAddress,
                    style: GoogleFonts.inter(
                        fontSize:
                            SizeConfig.textMultiplier * 2.0086083213773316,
                        fontWeight: FontWeight.w400,
                        letterSpacing: 0.15,
                        color: AppColors.app_txt_color),
                  ),
                ),
              if (!isLoading)
                GestureDetector(
                  onTap: () {
                    locator<OrderManager>().paymentValue.value = 0;
                  },
                  child: ValueListenableBuilder(
                      valueListenable: locator<OrderManager>().paymentValue,
                      builder: (context, value, widget) {
                        return Container(
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(
                                    color: locator<OrderManager>()
                                                .paymentValue
                                                .value ==
                                            0
                                        ? AppColors.appBlue
                                        : AppColors.text_field_color)),
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
                                  groupValue: value,
                                  onChanged: (value) {
                                    locator<OrderManager>().paymentValue.value =
                                        0;
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
                            ));
                      }),
                ),
              for (int i = 0;
                  i < orderCheckoutBloc.billingAddresses.length;
                  i++)
                CardBuilder().build(CardSection(
                  CardSectionType.AddressCard,
                  model: orderCheckoutBloc.billingAddresses[i],
                  value: i + 1,
                  groupValue: locator<OrderManager>().paymentValue,
                )),
              ButtonBuilder().build(ButtonSection(
                  ButtonSectionType.responseButton,
                  "Add different billing address", () {
                RouterService.appRouter
                    .navigateTo(
                        "${AddNewAddressRoute.buildPath()}?isBilling=true")
                    .then((value) {
                  setState(() {
                    if (value != null) {
                      orderCheckoutBloc.billingAddresses.add(value);
                    }
                  });
                });
              })),
              if (isLoading)
                Container(
                  margin: EdgeInsets.only(
                      top: SizeConfig.heightMultiplier * 2.5107604017216643,
                      left: SizeConfig.widthMultiplier * 3.8888888888888884,
                      bottom: SizeConfig.heightMultiplier * 2.0086083213773316),
                  child: Text(
                    _l10n.AddGiftCode,
                    style: GoogleFonts.inter(
                        fontSize:
                            SizeConfig.textMultiplier * 2.0086083213773316,
                        fontWeight: FontWeight.w400,
                        letterSpacing: 0.15,
                        color: AppColors.app_txt_color),
                  ),
                ),
              if (isLoading)
                Container(
                  margin: EdgeInsets.only(
                      bottom: SizeConfig.heightMultiplier * 6.276901004304161,
                      left: SizeConfig.widthMultiplier * 3.8888888888888884,
                      right: SizeConfig.widthMultiplier * 3.8888888888888884),
                  child: TextField(
                    enabled: false,
                    decoration: InputDecoration(
                        border: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.grey.shade300),
                            borderRadius: BorderRadius.circular(10.0)),
                        hintText: _l10n.EnterCode,
                        suffixStyle: const TextStyle(color: Colors.blue)),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
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
          border: Border.all(
              color: locator<OrderManager>().paymentMethod !=
                      PaymentMethodType.card
                  ? AppColors.text_field_container
                  : AppColors.appBlue)),
      child: Container(
          child: Row(
        children: [
          Container(
            child: Radio(
              groupValue: PaymentMethodType.card,
              value: locator<OrderManager>().paymentMethod,
              activeColor: AppColors.appBlue,
              onChanged: (value) {
                setState(() {
                  locator<OrderManager>().paymentMethod =
                      PaymentMethodType.card;
                });
              },
            ),
          ),
          // Container(
          //   child: Column(
          //     crossAxisAlignment: CrossAxisAlignment.start,
          //     children: [
          //       Container(
          //         child: Text(
          //           model.cardType == CardType.mastercard
          //               ? 'MasterCard ${model.cardNumber ?? ""}'
          //               : 'VISA ${model.cardNumber ?? ""}',
          //           style: GoogleFonts.inter(
          //             fontSize: SizeConfig.textMultiplier * 1.757532281205165,
          //             fontWeight: FontWeight.w700,
          //             letterSpacing: 0.1,
          //           ),
          //         ),
          //       ),
          //       Container(
          //         child: Text(
          //           '${model.cardHolder ?? "Holder name"}',
          //           style: GoogleFonts.inter(
          //             fontSize: SizeConfig.textMultiplier * 1.757532281205165,
          //             fontWeight: FontWeight.w400,
          //             letterSpacing: 0.1,
          //           ),
          //         ),
          //       ),
          //       Container(
          //         child: Text(
          //           '${_l10n.expires} ${model.cardExpiry ?? ""}',
          //           style: GoogleFonts.inter(
          //             fontSize: SizeConfig.textMultiplier * 1.757532281205165,
          //             fontWeight: FontWeight.w400,
          //             letterSpacing: 0.1,
          //           ),
          //         ),
          //       ),
          //     ],
          //   ),
          // )
        ],
      )),
    );
  }

  Widget _myWallet(OrderCheckoutBloc bloc) {
    PaymentMethodType type = locator<OrderManager>().paymentMethod;
    return ValueListenableBuilder(
        valueListenable: locator<WalletApi>().wallet,
        builder: (context, value, widget) {
          if (locator<WalletApi>().wallet.value == null) {
            return BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 0.8, sigmaY: 0.8),
              child: Align(
                  alignment: Alignment.center,
                  child: LoadingProgress(
                    color: Colors.deepOrangeAccent,
                  )),
            );
          }
          return Container(
            margin: const EdgeInsets.only(left: 16, right: 16, top: 16),
            padding: EdgeInsets.all(5),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                border: Border.all(
                    color: type == PaymentMethodType.wallet
                        ? AppColors.appBlue
                        : AppColors.text_field_container)),
            child: Container(
                child: Row(
              children: [
                if (type != PaymentMethodType.wallet)
                  Container(
                    child: Radio(
                      groupValue: PaymentMethodType.wallet,
                      value: type,
                      activeColor: AppColors.appBlue,
                      onChanged: (value) {
                        setState(() {
                          locator<OrderManager>().paymentMethod =
                              PaymentMethodType.wallet;
                        });
                      },
                    ),
                  ),
                if (type != PaymentMethodType.wallet)
                  Container(
                    child: Container(
                      child: Text(
                        _l10n.MyWallet,
                        style: GoogleFonts.inter(
                            fontSize:
                                SizeConfig.textMultiplier * 1.757532281205165,
                            fontWeight: FontWeight.w700,
                            letterSpacing: 0.1,
                            color: locator<OrderManager>().paymentMethod ==
                                    PaymentMethodType.wallet
                                ? AppColors.text_field_color
                                : AppColors.text_field_container),
                      ),
                    ),
                  ),
                if (type == PaymentMethodType.wallet) _walletOptions(bloc),
              ],
            )),
          );
        });
  }

  Widget _walletOptions(OrderCheckoutBloc bloc) {
    PaymentMethodType type = locator<OrderManager>().paymentMethod;

    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                    child: Radio(
                      groupValue: PaymentMethodType.wallet,
                      value: type,
                      activeColor: AppColors.appBlue,
                      onChanged: (value) {
                        setState(() {
                          locator<OrderManager>().paymentMethod = value;
                        });
                      },
                    ),
                  ),
                  Container(
                    child: Container(
                      child: Text(
                        _l10n.MyWallet,
                        style: GoogleFonts.inter(
                            fontSize:
                                SizeConfig.textMultiplier * 1.757532281205165,
                            fontWeight: FontWeight.w700,
                            letterSpacing: 0.1,
                            color: AppColors.text_field_color),
                      ),
                    ),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.only(right: 16),
                child: Icon(
                  AppIcons.down_open_big,
                  size: 15,
                  color: AppColors.appBlue,
                ),
              )
            ],
          ),
          ValueListenableBuilder(
            valueListenable: locator<OrderManager>().currency,
            builder: (context, value, widget) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CurrencyLine(
                    currency: 'BTC',
                    amount: bloc.wallet.wallet.BTCInCNY.toString(),
                    currencyType: PaymentCurrency.BTC,
                    value: value,
                    onTap: () {
                      locator<OrderManager>().currency.value =
                          PaymentCurrency.BTC;
                    },
                  ),
                  CurrencyLine(
                    currency: 'ETH',
                    amount: bloc.wallet.wallet.ETHInCNY.toString(),
                    currencyType: PaymentCurrency.ETH,
                    value: value,
                    onTap: () {
                      locator<OrderManager>().currency.value =
                          PaymentCurrency.ETH;
                    },
                  ),
                  CurrencyLine(
                    currency: 'USDC',
                    amount: bloc.wallet.wallet.USDC.toString(),
                    currencyType: PaymentCurrency.USDC,
                    value: value,
                    onTap: () {
                      locator<OrderManager>().currency.value =
                          PaymentCurrency.USDC;
                    },
                  ),
                  CurrencyLine(
                    currency: 'AUD',
                    amount: bloc.wallet.wallet.AUD.toString(),
                    currencyType: PaymentCurrency.AUD,
                    value: value,
                    onTap: () {
                      locator<OrderManager>().currency.value =
                          PaymentCurrency.AUD;
                    },
                  ),
                  // CurrencyLine(
                  //   currency: 'CNY',
                  //   amount: bloc.wallet.wallet.CNY.toString(),
                  //   currencyType: PaymentCurrency.CNY,
                  //   value: value,
                  //   onTap: () {
                  //     locator<OrderManager>().currency.value =
                  //         PaymentCurrency.CNY;
                  //   },
                  //),
                ],
              );
            },
          ),
        ],
      ),
    );
  }
}
