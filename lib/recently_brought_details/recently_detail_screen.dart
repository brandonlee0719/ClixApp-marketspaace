import 'dart:ui';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:market_space/apis/firebaseManager.dart';
import 'package:market_space/apis/orderApi/orderApi.dart';
import 'package:market_space/common/colors.dart';
import 'package:market_space/common/loading_progress.dart';
import 'package:market_space/common/toolbar.dart';
import 'package:market_space/model/order_status_model/order_status_model.dart';
import 'package:market_space/model/recently_bought_options/buyer_options.dart';
import 'package:market_space/model/recently_product_model/recently_brought_model.dart';
import 'package:market_space/notification/representation/widgets/screen/textInputScreen.dart';
import 'package:market_space/order_checkout/model/update_address_model/update_address_model.dart';
import 'package:market_space/providers/profile_provider/profile_provider.dart';
import 'package:market_space/recently_brought_details/recenlty_bought_l10n.dart';
import 'package:market_space/recently_brought_details/recently_detail_bloc.dart';
import 'package:market_space/recently_brought_details/recently_detail_event.dart';
import 'package:market_space/recently_brought_details/recently_detail_route.dart';
import 'package:market_space/recently_brought_details/recently_detail_state.dart';
import 'package:market_space/recently_brought_details/widgets/cancelOrderWidget.dart';
import 'package:market_space/recently_brought_details/widgets/paymentWidget.dart';
import 'package:market_space/recently_brought_details/widgets/review.dart';
import 'package:market_space/recently_brought_products/widgets/product_card/product_card_image_widget.dart';
import 'package:market_space/representation/commons/AddressCard.dart';
import 'package:market_space/representation/widgets/cardWidgets/recentlyBoughtTextCard.dart';
import 'package:market_space/representation/widgets/deliverBar.dart';
import 'package:market_space/responsive_layout/size_config.dart';
import 'package:market_space/services/locator.dart';
import 'package:market_space/services/RouterServices.dart';
import 'package:market_space/core/widgets/buttons/custom_buttons.dart';

class RecentlyDetailScreen extends StatefulWidget {
  final String id;

  const RecentlyDetailScreen({Key key, this.id}) : super(key: key);
  @override
  _RecentlyDetailScreenState createState() => _RecentlyDetailScreenState();
}

class _RecentlyDetailScreenState extends State<RecentlyDetailScreen> {
  final RecentlyDetailBloc _RecentlyDetailBloc = RecentlyDetailBloc(Initial());
  RecentlyBoughtL10n _l10n = RecentlyBoughtL10n(
      Locale.fromSubtags(languageCode: 'en', countryCode: 'US'));

  bool _isLoading = false;
  bool _isOrderedLoading = false;
  OrderViewModel _model;

  bool _confirmItem = true;
  BuyerOptions _options;
  List<Order_overview> order_overview = List();
  List<OrderedWith> order_with = List();
  OrderApi api = locator.get<OrderApi>();

  String id;
  bool isBuyer;
  Stream<DocumentSnapshot> snap;
  ValueNotifier<String> status = ValueNotifier("1");
  bool isExpired = false;

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
  void dispose() {
    // TODO: implement dispose
    locator.get<OrderApi>().dispose();
    super.dispose();
  }

  @override
  void initState() {
    _RecentlyDetailBloc.add(RecentlyDetailScreenEvent());
    setUp();

    // print(DateTime.now().millisecondsSinceEpoch);
    _RecentlyDetailBloc.orderId =
        RecentlyDetailRoute.recentlyBoughtModel.orderID;
    _RecentlyDetailBloc.add(BuyerOptionsEvent());
    super.initState();
  }

  Future<void> setUp() async {
    setState(() {
      _isLoading = true;
    });
    if (widget.id != null) {
      // print('at least this?');
      ProfileProvider provider = ProfileProvider();
      String id = widget.id;
      // print(widget.id);
      RecentlyDetailRoute.orderStatusModel = await provider.getOrderStatus(id);
      // print('status');
      RecentlyDetailRoute.recentlyBoughtModel =
          (await provider.getRecentBrought(id))[0];
      // print('second step');
    }
    await fromClick();
    // bool expired =  await locator.get<OrderApi>().isExpired();
    // // print("calculating expired$expired");
    // if(expired){
    //   // print("I am expired so i will make everything completed!");
    //   await locator.get<OrderApi>().acceptClaim(isExpired: true);
    // }
    setState(() {
      _isLoading = false;
    });
    // print("This is the recent bought model");
    // print(RecentlyDetailRoute.recentlyBoughtModel.toJson());
  }

  fromClick() async {
    // print('wbt from click');
    this.id = RecentlyDetailRoute.recentlyBoughtModel.orderID;
    // print("this is id");
    // print(id);
    locator.get<OrderApi>().setId(id);
    // print('this???');
    this._model = await api.getViewModel();
    setState(() {
      isBuyer = !(_model.sellerId == FirebaseManager.instance.getUID());
    });
    // print('finished fromClick');
  }

  @override
  Widget build(BuildContext context) {
    try {
      return Container(
        decoration: BoxDecoration(
            gradient: LinearGradient(
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
                colors: gradient,
                stops: stops)),
        child: Scaffold(
          resizeToAvoidBottomInset: false,
          backgroundColor: Colors.transparent,
          appBar: Toolbar(title: _l10n.RecentlyBought, elevation: 0),
          body: Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            color: AppColors.white,
            child: BlocProvider.value(
              value: _RecentlyDetailBloc,
              child: BlocListener<RecentlyDetailBloc, RecentlyDetailState>(
                  listener: (context, state) {},
                  child: ListView(
                    shrinkWrap: true,
                    children: [
                      // _filter(),
                      _baseScreen()
                    ],
                  )),
            ),
          ),
        ),
      );
    } on Exception catch (exception) {
      // print(exception.toString());
      return Container();
    }
  }

  Widget _baseScreen() {
    return Container(
      color: Colors.white,
      child: AbsorbPointer(
        absorbing: _isLoading,
        child: Stack(
          children: [
            ListView.builder(
              shrinkWrap: true,
              itemCount: 1,
              physics: BouncingScrollPhysics(),
              padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 14),
              itemBuilder: (context, index) {
                return _isLoading
                    ? LoadingProgress()
                    : _recentlyProductCard(
                        RecentlyDetailRoute.recentlyBoughtModel);
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _recentlyProductCard(RecentlyBrought model) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Card(
          elevation: 6,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          child: Row(
            children: [
              ProductCardImageWidget(model: model, isExpanded: false),
              RecentlyBoughtText(model: model)
            ],
          ),
        ),
        const SizedBox(height: 10),
        _orderStatus(RecentlyDetailRoute.orderStatusModel, model),
      ],
    );
  }

  Widget _titleText(String text) {
    return Container(
      margin: EdgeInsets.only(top: 20, bottom: 12),
      child: Text(
        text,
        style: GoogleFonts.inter(
          color: AppColors.app_txt_color,
          fontSize: SizeConfig.textMultiplier * 1.757532281205165,
          fontWeight: FontWeight.w700,
          letterSpacing: 0.5,
        ),
      ),
    );
  }

  Widget _orderStatus(OrderStatusModel model, RecentlyBrought recentlyBrought) {
    // print('orderID: ' + recentlyBrought.orderID.toString());
    // print('payment type: ${_options}');
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 12),
        Text(
          _l10n.OrderStatus,
          style: GoogleFonts.inter(
              color: AppColors.app_txt_color,
              fontSize: SizeConfig.textMultiplier * 1.757532281205165,
              fontWeight: FontWeight.w700,
              letterSpacing: 0.1),
        ),

        DeliverBar(),

        const SizedBox(height: 14),
        Row(children: [
          Text('${_l10n.ShippingCompany} :',
              style: TextStyle(
                  color: AppColors.darkgrey500,
                  fontSize: SizeConfig.textMultiplier * 1.757532281205165)),
          Spacer(),
          Text(
              (recentlyBrought.shippingCompany?.isNotEmpty ?? false)
                  ? recentlyBrought.shippingCompany
                  : "Regular Mail",
              style: TextStyle(
                  color: AppColors.darkgrey500,
                  fontSize: SizeConfig.textMultiplier * 1.757532281205165)),
        ]),
        const SizedBox(height: 14),

        Row(children: [
          Text('${_l10n.TrackingNumber} :',
              style: TextStyle(
                  color: AppColors.darkgrey500,
                  fontSize: SizeConfig.textMultiplier * 1.757532281205165)),
          Spacer(),
          Text(
              (recentlyBrought.trackingNumber?.isNotEmpty ?? false)
                  ? recentlyBrought.trackingNumber
                  : "Not provided",
              style: TextStyle(
                  color: AppColors.darkgrey500,
                  fontSize: SizeConfig.textMultiplier * 1.757532281205165)),
        ]),
        if (!isBuyer &&
            RecentlyDetailRoute.recentlyBoughtModel.shippingStatus ==
                "AWAITING SHIPPING")
          SubmitTrackingScreen(orderNumber: this._RecentlyDetailBloc.orderId),
        if (isBuyer)
          ValueListenableBuilder<String>(
              valueListenable: locator.get<OrderApi>().orderStatusString,
              builder: (context, string, widget) {
                if (string == "COMPLETED") {
                  return const SizedBox.shrink();
                }
                return GestureDetector(
                  onTap: () {
                    locator.get<OrderApi>().confirmShipping();
                  },
                  child: Container(
                      height: SizeConfig.heightMultiplier * 6.276901004304161,
                      padding: EdgeInsets.all(10),
                      margin: EdgeInsets.only(top: 21),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: AppColors.appBlue),
                      ),
                      child: Center(
                        child: _confirmItem
                            ? Text(
                                _l10n.confirmReception,
                                style: GoogleFonts.inter(
                                  color: AppColors.appBlue,
                                  fontSize: SizeConfig.textMultiplier *
                                      1.757532281205165,
                                  fontWeight: FontWeight.w700,
                                  letterSpacing: 0.5,
                                ),
                              )
                            : Lottie.asset('assets/loader/widget_loading.json',
                                width: 100, height: 30),
                      )),
                );
              }),
        if (_isOrderedLoading)
          SizedBox(
              height: SizeConfig.heightMultiplier * 25.107604017216644,
              child: ListView(
                shrinkWrap: true,
                scrollDirection: Axis.horizontal,
                children: [
                  SizedBox(
                      height: SizeConfig.heightMultiplier * 24.60545193687231,
                      width: 124,
                      child: Lottie.asset('assets/loader/loading_card.json',
                          width: 124)),
                  SizedBox(
                      height: SizeConfig.heightMultiplier * 24.60545193687231,
                      width: 124,
                      child: Lottie.asset('assets/loader/loading_card.json',
                          width: 124)),
                  SizedBox(
                      height: SizeConfig.heightMultiplier * 24.60545193687231,
                      width: 124,
                      child: Lottie.asset('assets/loader/loading_card.json',
                          width: 124)),
                ],
              )),
        const SizedBox(height: 14),
        MSButtons(
          context: context,
          size: Size(SizeConfig.widthMultiplier * 100, 50),
          borderRadius: 10,
          textColor: AppColors.cancel_red,
          fontWeight: FontWeight.bold,
          textFontSize: 15,
          text: isBuyer ? 'CONTACT SELLER' : 'CONTACT BUYER',
          onTap: () {
            if (isBuyer) {
              RouterService.appRouter.navigateTo(
                  '/dashboard/messageChat?isCreating=true&uid=${_model.sellerId}&name=Trial');
            } else {
              RouterService.appRouter.navigateTo(
                  '/dashboard/messageChat?isCreating=true&uid=${_model.buyerId}&name=Trial');
            }
          },
        ).outline(borderColor: AppColors.cancel_red),
        _titleText("Order Overview"),
        _orderOverview(_options),
        _titleText(_l10n.ShippingAddress),
        _shippingAddress(_options?.shippingAddress),
        // _titleText(_l10n.PaymentMethod),
        // _paymentMethod(_options?.paymentMethod),
        // ReviewPart(isBuyer: isBuyer),
        // _titleText("Cancel Order"),

        // GestureDetector(
        //     onTap: () {
        //       if (isBuyer) {
        //         RouterService.appRouter.navigateTo(
        //             '/dashboard/messageChat?isCreating=true&uid=${_model.sellerId}&name=Trial');
        //       } else {
        //         RouterService.appRouter.navigateTo(
        //             '/dashboard/messageChat?isCreating=true&uid=${_model.buyerId}&name=Trial');
        //       }
        //     },
        //     child: RaisedButton(child: Text('Contact'))),
        if (recentlyBrought?.shippingStatus?.toLowerCase() ==
            'awaiting shipping')
          CancelOrderWidget(isBuyer: isBuyer),
        CancelOrderWidget(isExtension: true, isBuyer: isBuyer),
      ],
    );
  }

  List<DropdownMenuItem<String>> buildDropDownMenuItems(List listItems) {
    List<DropdownMenuItem<String>> items = List();
    for (String listItem in listItems) {
      items.add(
        DropdownMenuItem(
          child: Text(
            listItem,
            style: TextStyle(color: AppColors.catTextColor),
          ),
          value: listItem,
        ),
      );
    }
    return items;
  }

  Widget _orderOverview(BuyerOptions options) {
    return FutureBuilder<OrderViewModel>(
        future: locator.get<OrderApi>().getViewModel(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            var data = snapshot.data;
            return Container(
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: AppColors.appBlue)),
              child: Column(
                children: [
                  Container(
                      margin: EdgeInsets.only(
                          left: SizeConfig.widthMultiplier * 3.8888888888888884,
                          right: 16,
                          top: SizeConfig.heightMultiplier * 2),
                      child: Column(
                        children: [
                          _orderText(data.title,
                              '\$${data.productPrice.toStringAsFixed(2)}'),
                          _orderText(
                            '${options?.orderOverview?.first?.shippingMethod ?? 'Regular Mail'}',
                            '${options?.orderOverview?.first?.shippingPrice ?? '\$0.00'}',
                          ),
                          _orderText("Transaction fee",
                              '\$${data.wyreFee.toStringAsFixed(2)}'),
                          Container(
                              margin: EdgeInsets.only(
                                  top: SizeConfig.heightMultiplier * 2,
                                  bottom: 8),
                              child: Row(
                                children: [
                                  Text('${_l10n.OrderTotal} :',
                                      style: GoogleFonts.inter(
                                          fontSize: SizeConfig.textMultiplier *
                                              1.757532281205165,
                                          color: AppColors.app_txt_color,
                                          fontWeight: FontWeight.w700,
                                          letterSpacing: 0.4)),
                                  Spacer(),
                                  Text(
                                    '\$${data.getSum().toStringAsFixed(2)}',
                                    style: GoogleFonts.inter(
                                        fontSize: SizeConfig.textMultiplier *
                                            1.757532281205165,
                                        color: AppColors.app_txt_color,
                                        fontWeight: FontWeight.w700,
                                        letterSpacing: 0.4),
                                  ),
                                ],
                              )),
                        ],
                      )),
                ],
              ),
            );
          }
          return const SizedBox.shrink();
        });
  }

  Widget _orderText(String title, String value) {
    return Container(
      margin: EdgeInsets.only(
          top: SizeConfig.heightMultiplier * 0.5021520803443329),
      child: Row(
        children: [
          Text(title,
              style: GoogleFonts.inter(
                  fontSize: SizeConfig.textMultiplier * 1.5064562410329987,
                  color: AppColors.catTextColor,
                  fontWeight: FontWeight.w400,
                  letterSpacing: 0.4)),
          Spacer(),
          Text(value,
              style: GoogleFonts.inter(
                  fontSize: SizeConfig.textMultiplier * 1.5064562410329987,
                  color: AppColors.catTextColor,
                  fontWeight: FontWeight.w400,
                  letterSpacing: 0.4)),
        ],
      ),
    );
  }

  Widget _shippingAddress(ShippingAddress address) {
    return FutureBuilder<UpdateAddressModel>(
        future: locator.get<OrderApi>().getAddress(),
        builder: (context, model) {
          if (model.hasData) {
            return AddressCardComponent(
              model: model.data,
            );
          }
          return Container();
        });
  }

  Widget _paymentMethod(PaymentMethod method) {
    return PaymentWidget();
  }
}
