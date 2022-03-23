import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:market_space/apis/conversation/chatManager.dart';
import 'package:market_space/common/colors.dart';
import 'package:market_space/messages/logic/message_cubit.dart';
import 'package:market_space/common/multi_selected_chip.dart';
import 'package:market_space/messages/representation/cards/cardWidget.dart';
import 'package:market_space/providers/localDatabaseHelper.dart';
import 'package:market_space/responsive_layout/size_config.dart';
import 'package:market_space/services/locator.dart';
import '../main.dart';

class MessageScreen extends StatefulWidget {
  @override
  _MessageScreenState createState() => _MessageScreenState();
}

class _MessageScreenState extends State<MessageScreen> {
  List<String> _categoryList = ["Software", "Movies", "Clothing"];
  int count = 0;
  bool isWaiting = true;
  String uid;

  final Color background = AppColors.toolbarBlue;
  final Color fill = AppColors.lightgrey;

  MessageCubit cubit = MessageCubit();

  @override
  initState() {
    // _messagesBloc.add(MessageScreenEvent());

    super.initState();
    init();
  }

  void init() async {
    ChatManager manager = locator.get<ChatManager>();
    await manager.getUsers();
    // Future.delayed(Duration(seconds: 4));
    await manager.getConversations();

    manager.listenToChatChannel();
  }

  @override
  Widget build(BuildContext context) {
    final List<Color> gradient = [
      background,
      background,
      fill,
      fill,
    ];

    final double fillPercent = 39.7; // fills 56.23% for container from bottom
    final double fillStop = (100 - fillPercent) / 100;
    final List<double> stops = [0.0, fillStop, fillStop, 1.0];

    return Container(
      decoration: BoxDecoration(
          gradient: LinearGradient(
        begin: Alignment.centerLeft,
        end: Alignment.centerRight,
        colors: gradient,
        stops: stops,
      )),
      child: SafeArea(
        child: Scaffold(
          // resizeToAvoidBottomInset: false,
          backgroundColor: Colors.white,
          appBar: _toolbar(),
          body: Column(
            // shrinkWrap: true,
            children: [_filter(), _baseScreen()],
          ),
        ),
      ),
    );
  }

  void schedule(message) async {
    var iosPlatformChannelSpecifics = IOSNotificationDetails(
        presentAlert: true, presentBadge: true, presentSound: true);
    var details = NotificationDetails(iOS: iosPlatformChannelSpecifics);
    await flutterLocalNotificationsPlugin.show(
        0, "notification", message, details);
  }

  Widget _baseScreen() {
    return StreamBuilder<List<Conversation>>(
        stream: locator.get<ChatManager>().sink.stream,
        builder: (context, snap) {
          // print("The snapshot is on...");
          ChatManager manager = locator.get<ChatManager>();
          if (snap.data == null) {
            // print("There is no data");
            return _noChat();
          }
          // print(manager.conversations);
          if (snap.data.length == 0) {
            // print("the length of snap is null");
            return _noChat();
          }

          return Expanded(
            child: ListView.builder(
                scrollDirection: Axis.vertical,
                shrinkWrap: true,
                itemCount: snap.data.length,
                itemBuilder: (BuildContext context, int index) {
                  Conversation conver = snap.data[index];
                  return new MessageCard(conversation: conver);
                }),
          );
        });
  }

  Widget _filter() {
    return GestureDetector(
      onTap: () {
        _showReportDialog();
      },
      child: Container(
        height: SizeConfig.heightMultiplier * 6,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: SizeConfig.heightMultiplier * 2.5107604017216643,
              width: SizeConfig.widthMultiplier * 19.444444444444443,
              alignment: Alignment.center,
              margin: EdgeInsets.only(
                  left: SizeConfig.widthMultiplier * 4.131944444444444,
                  top: SizeConfig.heightMultiplier * 2.1341463414634148),
              padding: EdgeInsets.only(
                  left: SizeConfig.widthMultiplier * 1,
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
                        left: SizeConfig.widthMultiplier * 0.48611111111111105),
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
          ],
        ),
      ),
    );
  }

  _showReportDialog() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          //Here we will build the content of the dialog
          return AlertDialog(
            title: Text("filter"),
            content: MultiSelectChip(_categoryList),
            actions: <Widget>[
              FlatButton(
                child: Text("Save"),
                onPressed: () => Navigator.of(context).pop(),
              )
            ],
          );
        });
  }

  Widget _toolbar() {
    return PreferredSize(
        child: SafeArea(
          child: Container(
              width: MediaQuery.of(context).size.width,
              height: kToolbarHeight,
              // margin: EdgeInsets.only(top: SizeConfig.heightMultiplier * 4.770444763271162),
              color: AppColors.toolbarBack,
              child: Row(
                children: [
                  Container(
                    child: Container(
                      width: SizeConfig.widthMultiplier * 60.27777777777777,
                      height: kToolbarHeight,
                      decoration: BoxDecoration(
                          color: AppColors.toolbarBlue,
                          borderRadius: BorderRadius.only(
                              bottomRight: Radius.circular(20))),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Row(
                            children: [
                              // GestureDetector(
                              //     onTap: () => Navigator.pop(context),
                              //     child: Padding(
                              //       padding: EdgeInsets.only(left: SizeConfig.widthMultiplier * 2.4305555555555554),
                              //       child: Image.asset(
                              //         'assets/images/back_arrow.png',
                              //         width: SizeConfig.widthMultiplier * 5.833333333333333,
                              //         height: SizeConfig.heightMultiplier * 3.0129124820659974,
                              //       ),
                              //     )),
                              Padding(
                                  padding: EdgeInsets.only(
                                      left: SizeConfig.widthMultiplier *
                                          2.4305555555555554),
                                  child: Text(
                                    'Messages',
                                    style: TextStyle(
                                        color: AppColors.white,
                                        fontFamily: 'inter',
                                        fontStyle: FontStyle.normal,
                                        fontSize: SizeConfig.textMultiplier *
                                            2.0086083213773316,
                                        fontWeight: FontWeight.w300),
                                  )),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  Spacer(),
                  // Container(
                  //     width: SizeConfig.widthMultiplier * 25.388888888888886,
                  //     height: SizeConfig.heightMultiplier * 3.0129124820659974,
                  //     margin: EdgeInsets.only(
                  //         left: SizeConfig.widthMultiplier * 2.9166666666666665, top: SizeConfig.heightMultiplier * 1.5064562410329987, right: SizeConfig.widthMultiplier * 2.9166666666666665, bottom: SizeConfig.heightMultiplier * 1.0043041606886658),
                  //     child: Row(
                  //       children: [
                  //         Padding(
                  //           padding: EdgeInsets.only(right: SizeConfig.widthMultiplier * 1.9444444444444442),
                  //           child: SvgPicture.asset(
                  //             'assets/images/pin.svg',
                  //             height: SizeConfig.heightMultiplier * 3.0129124820659974,
                  //             width: SizeConfig.widthMultiplier * 5.833333333333333,
                  //           ),
                  //         ),
                  //         Padding(
                  //           padding: EdgeInsets.only(right: SizeConfig.widthMultiplier * 1.9444444444444442),
                  //           child: SvgPicture.asset(
                  //             'assets/images/cart.svg',
                  //             height: SizeConfig.heightMultiplier * 3.0129124820659974,
                  //             width: SizeConfig.widthMultiplier * 5.833333333333333,
                  //           ),
                  //         ),
                  //         SvgPicture.asset(
                  //           'assets/images/la_bell.svg',
                  //           height: SizeConfig.heightMultiplier * 3.0129124820659974,
                  //           width: SizeConfig.widthMultiplier * 5.833333333333333,
                  //         ),
                  //       ],
                  //     )),
                ],
              )),
        ),
        preferredSize: Size.fromHeight(
            SizeConfig.heightMultiplier * 16.571018651362985704000955107872));
  }

  Widget _noChat() {
    return Container(
        margin: EdgeInsets.only(
            left: SizeConfig.widthMultiplier * 3.8888888888888884,
            right: SizeConfig.widthMultiplier * 3.8888888888888884,
            top: MediaQuery.of(context).size.height * 0.25),
        child: Center(
            child: Container(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                'assets/images/empty_chat.png',
                fit: BoxFit.contain,
                height: SizeConfig.heightMultiplier * 18.830703012912483,
                width: SizeConfig.widthMultiplier * 24.305555555555554,
              ),
              Center(
                child: Text(
                  "Howdy user, things seem a bit quiet here.. if you want to chat to a seller, you can contact them from the product page or from your order",
                  style: GoogleFonts.inter(
                    fontSize: SizeConfig.textMultiplier * 1.757532281205165,
                    fontWeight: FontWeight.w400,
                    letterSpacing: 0.25,
                    color: AppColors.unselected_tab,
                  ),
                ),
              ),
            ],
          ),
        )));
  }
}
