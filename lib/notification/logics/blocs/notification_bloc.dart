import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';
import 'package:market_space/apis/orderApi/orderManager.dart';
import 'package:market_space/common/colors.dart';
import 'package:market_space/main.dart';
import 'package:market_space/model/notification_model/notification.dart';
import 'package:market_space/model/notification_model/notification_model.dart';
import 'package:market_space/model/recently_product_model/recently_brought_model.dart';
import 'package:market_space/providers/localDatabaseHelper.dart';
import 'package:market_space/providers/notification_provider/notification_provider.dart';
import 'package:market_space/recently_brought_details/recently_detail_route.dart';
import 'package:market_space/recently_brought_products/widgets/ExpandableOrderWidgets.dart';
import 'package:market_space/repositories/notification_repository/NotificationRepository.dart';
import 'package:market_space/representation/listviewScreen/interfaces.dart';
import 'package:market_space/representation/widgets/cardWidgets/recentlyBoughtTextCard.dart';
import 'package:market_space/responsive_layout/size_config.dart';
import 'package:market_space/services/RouterServices.dart';
import 'package:market_space/services/locator.dart';
import 'package:meta/meta.dart';
import 'package:rxdart/rxdart.dart';

part 'notification_event.dart';
part 'notification_state.dart';

class InterestRateBuilder
    implements IWidgetDisplayer<DocumentSnapshot<Object>> {
  @override
  Widget render(DocumentSnapshot document) {
    String amount = document.get('amount');
    String type = document.get('type');
    Timestamp time = document.get('timeStamp');
    String timeString = time.toDate().toString();
    return Container(
      margin: EdgeInsets.only(
          left: SizeConfig.widthMultiplier * 3.8888888888888884,
          right: SizeConfig.widthMultiplier * 3.8888888888888884,
          top: SizeConfig.heightMultiplier * 1.0043041606886658),
      child: Card(
        elevation: 10,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(10),
            topLeft: Radius.circular(10),
            bottomRight: Radius.circular(10),
            topRight: Radius.circular(10),
          ),
        ),
        child: Row(
          children: [
            Container(
              padding: EdgeInsets.all(10),
              child: ClipRRect(
                borderRadius: BorderRadius.all(Radius.circular(10)),
                child: Image(
                    image: AssetImage(
                      'assets/images/financials/interestIcon.png',
                    ),
                    height: SizeConfig.heightMultiplier * 8),
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  margin: EdgeInsets.only(
                      left: SizeConfig.widthMultiplier * 1.2152777777777777),
                  child: RichText(
                      text: TextSpan(children: <TextSpan>[
                    TextSpan(
                        text: "Interest Earned",
                        style: GoogleFonts.lato(
                          fontSize: SizeConfig.textMultiplier * 2.2,
                          fontWeight: FontWeight.w400,
                          color: AppColors.app_txt_color,
                        )),
                    TextSpan(
                      text: " $amount $type",
                      style: GoogleFonts.lato(
                        fontSize: SizeConfig.textMultiplier * 2.2,
                        fontWeight: FontWeight.w400,
                        color: AppColors.bitcoin_orange,
                      ),
                    )
                  ])),
                ),
                SizedBox(
                  height: SizeConfig.heightMultiplier * 2,
                ),
                Container(
                  margin: EdgeInsets.only(
                      left: SizeConfig.widthMultiplier * 1.2152777777777777),
                  child: Text(
                    timeString.substring(0, 19),
                    style: GoogleFonts.lato(
                      fontSize: SizeConfig.textMultiplier * 1.2553802008608321,
                      fontWeight: FontWeight.w400,
                      color: AppColors.catTextColor,
                    ),
                  ),
                ),
              ],
            ),
            // if(!model.isRead)
            //   Padding(
            //
            //     child: SvgPicture.asset("assets/images/circle.svg",
            //       width:12,
            //
            //     ),
            //     padding: EdgeInsets.only(right: 5),
            //   ),
            // Text("heiheihei"),
          ],
        ),
      ),
    );
  }
}

class LikeItemBuilder implements InterestRateBuilder {
  @override
  Widget render(DocumentSnapshot document) {
    BasicProductModel model = BasicProductModel.fromJson(document.data());
    return RecentBroughtCard(model: model);
  }
}

class OnTheWayBuilder implements InterestRateBuilder {
  @override
  Widget render(DocumentSnapshot document) {
    BasicProductModel model = RecentlyBrought.fromJson(document.data());
    return RecentBroughtCard(model: model);
  }
}

class BuyItemBuilder implements IWidgetDisplayer<DocumentSnapshot<Object>> {
  final bool isPart;

  BuyItemBuilder(this.isPart);

  @override
  Widget render(DocumentSnapshot<Object> document) {
    RecentlyBrought model = RecentlyBrought.fromJson(document.data());
    // TODO: implement render
    return !isPart
        ? ExpandableOrderWidget(
            model: model,
          )
        : _recentlyBroughtCard(model);
  }

  Widget _recentlyBroughtCard(RecentlyBrought model) {
    // if(_productList[3]==model)
    return InkResponse(
      onTap: () {
        RecentlyDetailRoute.recentlyBoughtModel = model;
        // RecentlyDetailRoute.orderStatusModel = model;
        RouterService.appRouter.navigateTo(
            "${RecentlyDetailRoute.buildPath()}?id=${model.orderID}");
      },
      child: Container(
        width: double.infinity,
        margin: EdgeInsets.only(
            left: SizeConfig.widthMultiplier * 3.8888888888888884,
            right: SizeConfig.widthMultiplier * 3.8888888888888884,
            top: SizeConfig.heightMultiplier * 2.5107604017216643),
        // height: SizeConfig.heightMultiplier * 16.947632711621235,
        child: Card(
            margin: EdgeInsets.zero,
            elevation: 6,
            child: Row(
              children: [
                Container(
                  child: _recentlyImage(model),
                ),
                Container(
                  child: _recentlyBroughtTxt(model),
                )
              ],
            )),
      ),
    );
  }

  Widget _recentlyImage(RecentlyBrought model) {
    return Stack(
      children: [
        Container(
            height: SizeConfig.heightMultiplier * 16.947632711621235,
            width: SizeConfig.widthMultiplier * 30.138888888888886,
            child: CachedNetworkImage(
                imageUrl: model?.imgLink != null
                    ? model?.imgLink
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

  Widget _recentlyBroughtTxt(RecentlyBrought model) {
    // if (model.tags == null) {
    //   _isTags = false;
    // } else {
    //   _isTags = true;
    // }
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
                  child: Text(model?.title,
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
                        '\$${model?.fiatPrice}',
                        maxLines: 1,
                        style: GoogleFonts.inter(
                            fontSize:
                                SizeConfig.textMultiplier * 1.757532281205165,
                            fontWeight: FontWeight.w700,
                            letterSpacing: 0.1),
                      ),
                    ),
                    // Padding(
                    //   padding: EdgeInsets.only(
                    //       right:
                    //           SizeConfig.widthMultiplier * 1.9444444444444442,
                    //       left: SizeConfig.widthMultiplier * 3.645833333333333),
                    //   child: Row(children: [
                    //     Icon(
                    //       CryptoFontIcons.BTC,
                    //       size: 12,
                    //     ),
                    //     // Text(
                    //     //   model?.cryptoCheckoutPriceSeller ?? "0.00",
                    //     //   maxLines: 1,
                    //     //   style: GoogleFonts.inter(
                    //     //       fontSize: SizeConfig.textMultiplier * 1.5064562410329987,
                    //     //       fontWeight: FontWeight.w400,
                    //     //       letterSpacing: 0.4),
                    //     // ),
                    //   ]),
                    // ),
                  ],
                ),
              ],
            ),
          ),
          // if (_isTags)
          //   Container(
          //       height: SizeConfig.heightMultiplier * 6.276901004304161,
          //       width: SizeConfig.widthMultiplier * 37.43055555555555,
          //       child: GridView.count(
          //           crossAxisCount: 2,
          //           shrinkWrap: true,
          //           childAspectRatio: 0.35,
          //           scrollDirection: Axis.horizontal,
          //           children: model?.tags?.map((e) => _tags(e))?.toList())),
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
}

class NotificationBloc extends Bloc<NotificationEvent, NotificationState> {
  /// the interest screen
  // final FireBasePaginateProvider paginateProvider = FireBasePaginateProvider(
  //   FirebaseFirestore.instance.collection('users').doc('rPLMag2bJpefZdsmldQ04sKb82U2').collection('interestEarnings'), InterestEarningDecorator()
  // );
  // final IWidgetDisplayer simpleTileBuilder = InterestRateBuilder();

  /// the liked screen

  // final FireBasePaginateProvider paginateProvider = FireBasePaginateProvider(
  //     FirebaseFirestore.instance.collection('users').doc('rPLMag2bJpefZdsmldQ04sKb82U2').collection('likedItems'), InterestEarningDecorator()
  // );
  // final IWidgetDisplayer simpleTileBuilder = LikeItemBuilder();

  /// the earnings screen
  // final FireBasePaginateProvider paginateProvider = FireBasePaginateProvider(
  //   FirebaseFirestore.instance.collection('users').doc('rPLMag2bJpefZdsmldQ04sKb82U2').collection('earnings'), InterestEarningDecorator()
  // );
  // final IWidgetDisplayer simpleTileBuilder = InterestRateBuilder();

  // /// the on the way screen
  //
  // final FireBasePaginateProvider paginateProvider = FireBasePaginateProvider(
  //     FirebaseFirestore.instance.collection('orders'), OnTheWayDecorator()
  // );
  // final IWidgetDisplayer simpleTileBuilder = OnTheWayBuilder();

  final FireBasePaginateProvider paginateProvider;
  final IWidgetDisplayer simpleTileBuilder;

  List<QueryDocumentSnapshot> documentList = List<QueryDocumentSnapshot>();

  BehaviorSubject<List<QueryDocumentSnapshot>> queryController;

  NotificationBloc(NotificationState initialState,
      {this.paginateProvider, this.simpleTileBuilder})
      : super(initialState) {
    queryController = BehaviorSubject<List<QueryDocumentSnapshot>>();
    locator.get<OrderManager>().sink.listen((_) {
      // print("I know you order something successfully!");
      this.add(NotificationScreenEvent());
    });
  }

  Stream<List<DocumentSnapshot>> get listStream => queryController.stream;

  void dispose() {
    queryController.close();
  }

  @override
  Stream<NotificationState> mapEventToState(
    NotificationEvent event,
  ) async* {
    if (event is NotificationScreenEvent) {
      yield Loading();
      try {
        var list = await paginateProvider.getList();
        documentList = list;
        queryController.sink.add(documentList);

        yield Loaded();
      } catch (Exception) {
        queryController.sink.add([]);
      }
    }

    if (event is LoadMoreNotification) {
      yield Loading();
      var list = await paginateProvider.getList(pagi: true);
      if (list.isNotEmpty) {
        documentList.addAll(list);
        queryController.sink.add(documentList);
        yield Loaded();
      } else {
        yield NoMoreNotification();
      }
    }

    if (event is Done) {
      yield Loaded();
    }

    if (event is LoadNotification) {
      yield Loading();
      yield Loaded();
    }
  }
}
