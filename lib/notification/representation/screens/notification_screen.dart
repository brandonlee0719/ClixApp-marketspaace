import 'dart:ui';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:market_space/apis/orderApi/notificationApi.dart';
import 'package:market_space/common/colors.dart';
import 'package:market_space/common/toolbar.dart';
import 'package:market_space/model/notification_model/notification.dart';
import 'package:market_space/notification/logics/blocs/notification_bloc.dart';
import 'package:market_space/recently_brought_details/recently_detail_route.dart';
import 'package:market_space/responsive_layout/size_config.dart';
import 'package:market_space/services/RouterServices.dart';
import 'package:market_space/services/locator.dart';
import 'package:market_space/services/routServiceProvider.dart';
import 'package:provider/provider.dart';

class NotificationScreen extends StatefulWidget {
  @override
  _NotificationScreenState createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  NotificationBloc _bloc;

  @override
  void initState() {
    // locator.get<NotificationApi>().quickAdd();
    super.initState();
    _bloc = Provider.of<NotificationBloc>(context, listen: false);

    _bloc.add(NotificationScreenEvent());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: AppColors.toolbarBlue,
      appBar: Toolbar(
        title: 'MARKETSPAACE',
      ),
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        color: AppColors.white,
        child: BlocListener<NotificationBloc, NotificationState>(
            listener: (context, state) {
              if (state is NoMoreNotification) {
                _showReportDialog();
                setState(() {});
              }
            },
            child: Column(
              children: [
                _filter(context.watch<NotificationBloc>()),
                Expanded(
                  child: StreamBuilder<List<QueryDocumentSnapshot>>(
                      stream: _bloc.listStream,
                      builder: (context, snap) {
                        if (snap.hasData) {
                          if (snap.data.length == 0) {
                            return _InitialScreen();
                          }
                          // print(snap.data.length);
                          return ListView.builder(
                            itemCount: snap.data.length + 1,
                            shrinkWrap: true,
                            controller: ScrollController(),
                            itemBuilder: (context, index) {
                              if (index < snap.data.length) {
                                return _bloc.simpleTileBuilder
                                    .render(snap.data[index]);
                              }
                              return FlatButton(
                                  onPressed: () {
                                    _bloc.add(LoadMoreNotification());
                                  },
                                  child: Text('load more'));
                            },
                          );
                        }
                        return _InitialScreen();
                      }),
                )
              ],
            )),
      ),
    );
  }

  Widget _orderBaseScreen() {
    return FutureBuilder<Stream<QuerySnapshot>>(
        future: locator.get<NotificationApi>().getNotificationSnap(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return StreamBuilder<QuerySnapshot>(
                stream: snapshot.data,
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return Container();
                  }
                  var docs = snapshot.data.docs;
                  return Container(
                    width: SizeConfig.widthMultiplier * 80,
                    height: SizeConfig.heightMultiplier * 100,
                    color: Colors.white,
                    child: ListView.builder(
                        itemCount: docs.length + 1,
                        itemBuilder: (context, i) {
                          if (i == docs.length) {
                            return Container(
                              height: 100,
                            );
                          }
                          bool isBuyer;
                          if (docs[i]["pushFrom"] == "buyer") {
                            isBuyer = false;
                          } else {
                            isBuyer = true;
                          }
                          return _orderNotificationCard(
                              docs[i]["body"], docs[i]["orderId"], isBuyer);
                        }),
                  );
                });
          }

          return Container();
        });
  }

  Widget _InitialScreen() {
    return ListView.builder(
      shrinkWrap: true,
      itemCount: 10,
      controller: ScrollController(),
      itemBuilder: (context, index) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: SizeConfig.heightMultiplier * 10.043041606886657,
              width: MediaQuery.of(context).size.width,
              margin: EdgeInsets.only(
                left: SizeConfig.widthMultiplier * 2.4305555555555554,
                right: SizeConfig.widthMultiplier * 2.4305555555555554,
              ),
              child: Lottie.asset('assets/loader/horizontal_card_loding.json',
                  width: MediaQuery.of(context).size.width, fit: BoxFit.fill),
            ),
          ],
        );
      },
    );
  }

  Widget _notificationCard(
      Notifications model, String moneyType, double amount) {
    return Container(
      margin: EdgeInsets.only(
          left: SizeConfig.widthMultiplier * 3.8888888888888884,
          right: SizeConfig.widthMultiplier * 3.8888888888888884,
          top: SizeConfig.heightMultiplier * 1.0043041606886658),
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(10),
            topLeft: Radius.circular(10),
          ),
        ),
        child: Row(
          children: [
            Container(
              padding: EdgeInsets.all(10),
              child: ClipRRect(
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(10),
                  topLeft: Radius.circular(10),
                ),
                child: CachedNetworkImage(
                  imageUrl:
                      'https://png.pngtree.com/png-clipart/20191120/original/pngtree-outline-image-icon-isolated-png-image_5045508.jpg',
                  placeholder: (context, url) =>
                      Lottie.asset('assets/loader/image_loading.json'),
                  errorWidget: (context, url, error) => Icon(Icons.error),
                  fit: BoxFit.cover,
                  height: SizeConfig.heightMultiplier * 10.043041606886657,
                  width: SizeConfig.widthMultiplier * 19.444444444444443,
                  imageBuilder: (context, imageProvider) => Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(10),
                            topRight: Radius.circular(10)),
                        color: AppColors.toolbarBlue,
                        image: DecorationImage(
                            image: imageProvider, fit: BoxFit.cover)),
                  ),
                ),
              ),
            ),
            Expanded(
                child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  margin: EdgeInsets.only(
                      left: SizeConfig.widthMultiplier * 1.2152777777777777),
                  child: Text(
                    model.time.toString().substring(0, 19),
                    style: GoogleFonts.lato(
                      fontSize: SizeConfig.textMultiplier * 1.2553802008608321,
                      fontWeight: FontWeight.w400,
                      color: AppColors.catTextColor,
                    ),
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(
                      left: SizeConfig.widthMultiplier * 1.2152777777777777),
                  child: Text(
                    "you have earned $amount $moneyType",
                    style: GoogleFonts.lato(
                      fontSize: SizeConfig.textMultiplier * 1.757532281205165,
                      fontWeight: FontWeight.w400,
                      color: AppColors.app_txt_color,
                    ),
                  ),
                ),
              ],
            )),
            if (!model.isRead)
              Padding(
                child: SvgPicture.asset(
                  "assets/images/circle.svg",
                  width: 12,
                ),
                padding: EdgeInsets.only(right: 5),
              ),
            // Text("heiheihei"),
          ],
        ),
      ),
    );
  }

  Widget _orderNotificationCard(String text, String id, bool isBuyer) {
    return GestureDetector(
      onTap: () {
        context.read<RouteServiceProvider>().orderId = id;
        context.read<RouteServiceProvider>().isBuyer = isBuyer;
        RouterService.appRouter.navigateTo(RecentlyDetailRoute.buildPath());
      },
      child: Container(
        margin: EdgeInsets.only(
            left: SizeConfig.widthMultiplier * 3.8888888888888884,
            right: SizeConfig.widthMultiplier * 3.8888888888888884,
            top: SizeConfig.heightMultiplier * 1.0043041606886658),
        child: Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(10),
              topLeft: Radius.circular(10),
            ),
          ),
          child: Row(
            children: [
              Container(
                padding: EdgeInsets.all(10),
                child: ClipRRect(
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(10),
                    topLeft: Radius.circular(10),
                  ),
                  child: CachedNetworkImage(
                    imageUrl:
                        'https://png.pngtree.com/png-clipart/20191120/original/pngtree-outline-image-icon-isolated-png-image_5045508.jpg',
                    placeholder: (context, url) =>
                        Lottie.asset('assets/loader/image_loading.json'),
                    errorWidget: (context, url, error) => Icon(Icons.error),
                    fit: BoxFit.cover,
                    height: SizeConfig.heightMultiplier * 10.043041606886657,
                    width: SizeConfig.widthMultiplier * 19.444444444444443,
                    imageBuilder: (context, imageProvider) => Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(10),
                              topRight: Radius.circular(10)),
                          color: AppColors.toolbarBlue,
                          image: DecorationImage(
                              image: imageProvider, fit: BoxFit.cover)),
                    ),
                  ),
                ),
              ),
              Expanded(
                  child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    margin: EdgeInsets.only(
                        left: SizeConfig.widthMultiplier * 1.2152777777777777),
                    child: Text(
                      "today",
                      style: GoogleFonts.lato(
                        fontSize:
                            SizeConfig.textMultiplier * 1.2553802008608321,
                        fontWeight: FontWeight.w400,
                        color: AppColors.catTextColor,
                      ),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(
                        left: SizeConfig.widthMultiplier * 1.2152777777777777),
                    child: Text(
                      text,
                      style: GoogleFonts.lato(
                        fontSize: SizeConfig.textMultiplier * 1.757532281205165,
                        fontWeight: FontWeight.w400,
                        color: AppColors.app_txt_color,
                      ),
                    ),
                  ),
                ],
              )),
              // Text("heiheihei"),
            ],
          ),
        ),
      ),
    );
  }

  Widget _filter(NotificationBloc watch) {
    return Container(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: SizeConfig.heightMultiplier * 2.5107604017216643,
            width: SizeConfig.widthMultiplier * 21.444444444444443,
            alignment: Alignment.center,
            margin: EdgeInsets.only(
                left: SizeConfig.widthMultiplier * 4.131944444444444,
                top: SizeConfig.heightMultiplier * 2.1341463414634148),
            padding: EdgeInsets.only(
                left: SizeConfig.widthMultiplier * 0.9444444444444442,
                right: SizeConfig.widthMultiplier * 1.9444444444444442,
                top: SizeConfig.heightMultiplier * 0.25107604017216645,
                bottom: SizeConfig.heightMultiplier * 0.25107604017216645),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                border: Border.all(
                    color: AppColors.seeAllText,
                    width: SizeConfig.widthMultiplier * 0.24305555555555552),
                color: AppColors.seeAllBack),
            child: Row(
              children: [
                Image.asset('assets/images/filter.png'),
                Padding(
                  padding: EdgeInsets.only(
                      left: SizeConfig.widthMultiplier * 0.8611111111111105),
                  child: Text(
                    'FILTER BY',
                    style: TextStyle(
                        fontSize:
                            SizeConfig.textMultiplier * 1.2553802008608321,
                        color: AppColors.appBlue,
                        fontWeight: FontWeight.w400),
                  ),
                ),
              ],
            ),
          ),
          /*Container(
            height: SizeConfig.heightMultiplier * 2.5107604017216643,
            width: SizeConfig.widthMultiplier * 27.70833333333333,
            alignment: Alignment.center,
            margin: EdgeInsets.only(left: SizeConfig.widthMultiplier * 4.131944444444444, top: SizeConfig.heightMultiplier * 2.1341463414634148),
            padding: EdgeInsets.only(left: SizeConfig.widthMultiplier * 1.9444444444444442, right: SizeConfig.widthMultiplier * 1.9444444444444442, top: SizeConfig.heightMultiplier * 0.25107604017216645, bottom: SizeConfig.heightMultiplier * 0.25107604017216645),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: AppColors.seeAllText, width: SizeConfig.widthMultiplier * 0.24305555555555552),
                color: AppColors.seeAllBack),
            child: Row(
              children: [
                Icon(
                  Icons.calendar_today,
                  color: AppColors.appBlue,
                  size: 10,
                ),
                Padding(
                  padding: EdgeInsets.only(left: SizeConfig.widthMultiplier * 0.48611111111111105),
                  child: Text(
                    'LAST 3 MONTHS',
                    style: TextStyle(
                        fontSize: SizeConfig.textMultiplier * 1.2553802008608321,
                        color: AppColors.appBlue,
                        fontWeight: FontWeight.w400),
                  ),
                ),
              ],
            ),
          ),*/
        ],
      ),
    );
  }

  _showReportDialog() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          //Here we will build the content of the dialog
          return AlertDialog(
            title: Text("No more notification"),
            content: Text("no more notifications to load"),
            actions: <Widget>[
              FlatButton(
                child: Text("ok"),
                onPressed: () => Navigator.of(context).pop(),
              )
            ],
          );
        });
  }
}
