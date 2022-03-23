import 'dart:io';
import 'dart:ui';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:market_space/apis/conversation/chatManager.dart';
import 'package:market_space/apis/conversation/conversationApi.dart';
import 'package:market_space/common/colors.dart';
import 'package:market_space/common/constants.dart';
import 'package:market_space/message_chat/message_chat_route.dart';
import 'package:market_space/message_chat/representation/widgets/message_widgets.dart';
import 'package:market_space/model/messages_model/message_history_model.dart';
import 'package:market_space/providers/localDatabaseHelper.dart';
import 'package:market_space/responsive_layout/size_config.dart';
import 'package:market_space/services/locator.dart';
import 'package:market_space/services/routServiceProvider.dart';
import 'logic/chat_row_cubit.dart';

class MessageChatScreen extends StatefulWidget {
  final String isCreating;
  final String uid;
  final String userName;

  const MessageChatScreen({Key key, this.isCreating, this.uid, this.userName})
      : super(key: key);
  @override
  _MessageChatScreenState createState() => _MessageChatScreenState();
}

class _MessageChatScreenState extends State<MessageChatScreen> {
  final _textController = TextEditingController();
  bool _disableSendButton = false;
  bool _showEmojy = false;
  FocusNode gfgFocusNode;
  final ScrollController controller = ScrollController();
  Conversation conver;
  bool isLoading = true;

  @override
  void dispose() {
    conver.messages = List<Messages>();
    conver.dispose();
    // TODO: implement dispose
    conver.messageLengthNotifier.value = 0;
    locator.get<ChatManager>().updateConversation(conver);
    controller.dispose();
    gfgFocusNode.dispose();
    super.dispose();
  }

  @override
  void initState() {
    controller.addListener(() {
      if (controller.position.pixels == controller.position.maxScrollExtent) {
        // print("heihei");
        conver.getMessages(conver.messages.length - 1, onComplete: () {});
      }
    });
    // _messagesBloc.add(MessageChatScreenEvent());
    gfgFocusNode = FocusNode();

    if (widget.isCreating == "true") {
      _createConversation();
    } else {
      conver = locator.get<ChatManager>().findConversation(MessageChatRoute.id);
      // conver = locator.get<ChatManager>().conversations[0];
      // print("the id is...");
      // print(conver.conversationId);

      conver.getMessages(0, onComplete: () {
        // jumpLater();
      });
      conver.subscribeToConversation();
      setState(() {
        isLoading = false;
      });
    }

    super.initState();
    WidgetsBinding.instance.addPostFrameCallback(
        (_) => {controller.jumpTo(controller.position.minScrollExtent)});
  }

  Future<void> _createConversation() async {
    // print(widget.uid);
    // print(widget.userName);
    this.conver = await ConversationApi().chatTo(widget.uid, widget.userName);
    conver.subscribeToConversation();

    if (widget.uid != Constants.adminUid) {
      if (context.read<RouteServiceProvider>().queryProductName == null) {
        conver.sendMessages("Seller and buyer talk", "product");
      } else {
        conver.sendMessages(
            "A query about ${context.read<RouteServiceProvider>().queryProductName} has been made",
            "product");
      }
    } else {
      conver.sendMessages(
          "Please leave your question here, our admin will reply to you as soon as possible",
          "product");
    }
    setState(() {
      isLoading = false;
    });
  }

  Future<void> scroll() async {
    await Future.delayed(Duration(milliseconds: 100));
    controller.jumpTo(controller.position.minScrollExtent);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: AppColors.toolbarBlue,
      appBar: _toolbar(),
      body: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          color: AppColors.white,
          child: GestureDetector(
            onTap: () {
              if (_showEmojy) {
                setState(() {
                  _showEmojy = false;
                });
              }
            },
            child: BlocListener<ChatRowCubit, ChatRowState>(
              listener: (context, state) {
                if (state == ChatRowState.messageSent) {
                  setState(() {
                    // print(" i am going to the bottom");
                    scroll();
                  });
                }
              },
              child: Column(
                // shrinkWrap: true,
                children: [
                  if (!isLoading)
                    ChatScreen(
                      controller: controller,
                      conver: this.conver,
                    ),
                  Container(
                      margin: EdgeInsets.all(15),
                      decoration: BoxDecoration(
                          border:
                              Border.all(color: AppColors.text_field_container),
                          color: AppColors.white,
                          borderRadius: BorderRadius.circular(30)),
                      child: Row(
                        children: [
                          Flexible(
                              child: Container(
                            child: Container(
                              margin: EdgeInsets.only(
                                  left: SizeConfig.widthMultiplier *
                                      8.2152777777777777),
                              child: TextField(
                                focusNode: gfgFocusNode,
                                maxLines: 2,
                                // autofocus: true,
                                controller: _textController,
                                onTap: () {
                                  setState(() {
                                    _showEmojy = false;
                                  });
                                  gfgFocusNode.requestFocus();
                                  scroll();
                                },
                                decoration: InputDecoration.collapsed(
                                    hintText: "Enter message"),
                              ),
                            ),
                          )),
                          if (!isLoading)
                            Container(
                                alignment: Alignment.center,
                                width: SizeConfig.widthMultiplier *
                                    10.291666666666666,
                                height: SizeConfig.heightMultiplier *
                                    7.291666666666666,
                                child: IconButton(
                                    icon: Icon(
                                      Icons.send,
                                      size: SizeConfig.textMultiplier * 4,
                                      color: _disableSendButton
                                          ? AppColors.grey_700
                                          : AppColors.appBlue,
                                    ),
                                    onPressed: () async {
                                      if (_textController.text.length == 0) {
                                        _showToast("Please enter message");
                                        // BlocProvider.of<ChatRowCubit>(context).messageFromAnotherUser();

                                      } else if (_textController.text ==
                                          "delete all!") {
                                        // print("deleted!");
                                        BlocProvider.of<ChatRowCubit>(context)
                                            .deleteAll();
                                      } else {
                                        String message = _textController.text;
                                        setState(() {
                                          scroll();
                                          _disableSendButton = true;
                                          _textController.text = "";
                                        });
                                        if (conver != null) {
                                          conver.sendMessages(message, "text");
                                          // ConversationApi().sendMe("heihei");
                                        }
                                      }
                                    })),
                        ],
                      )),
                ],
              ),
            ),
          )),
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
                              GestureDetector(
                                  onTap: () {
                                    BlocProvider.of<ChatRowCubit>(context,
                                            listen: false)
                                        .close();
                                    BlocProvider.of<ChatRowCubit>(context,
                                            listen: false)
                                        .closeAll();
                                    Navigator.pop(context);
                                  },
                                  child: Padding(
                                    padding: EdgeInsets.only(
                                        left: SizeConfig.widthMultiplier *
                                            2.4305555555555554),
                                    child: SvgPicture.asset(
                                      'assets/images/Back_button.svg',
                                      width: SizeConfig.widthMultiplier *
                                          5.833333333333333,
                                      height: SizeConfig.heightMultiplier *
                                          3.0129124820659974,
                                    ),
                                  )),
                              Padding(
                                  padding: EdgeInsets.only(
                                      left: SizeConfig.widthMultiplier *
                                          2.4305555555555554),
                                  child: Text(
                                    conver == null
                                        ? 'loading...'
                                        : conver.getChatName(),
                                    style: TextStyle(
                                        color: AppColors.white,
                                        fontFamily: 'inter',
                                        fontStyle: FontStyle.normal,
                                        fontSize: SizeConfig.textMultiplier *
                                            2.0086083213773316,
                                        fontWeight: FontWeight.w300),
                                  )),
                              //to-do change the test to scroll rather than static
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  Spacer(),
                  Container(
                      width: SizeConfig.widthMultiplier * 21.388888888888886,
                      height: SizeConfig.heightMultiplier * 3.0129124820659974,
                      margin: EdgeInsets.only(
                          left: SizeConfig.widthMultiplier * 2.9166666666666665,
                          top: SizeConfig.heightMultiplier * 1.5064562410329987,
                          right:
                              SizeConfig.widthMultiplier * 2.9166666666666665,
                          bottom:
                              SizeConfig.heightMultiplier * 1.0043041606886658),
                      child: Row(
                        children: [
                          Spacer(),
                          GestureDetector(
                            onTap: () async {
                              String url = await _getBackgroundImage();
                              conver.sendMessages(url, "image");
                            },
                            child: Container(
                              margin: EdgeInsets.only(
                                  right: SizeConfig.widthMultiplier *
                                      3.645833333333333),
                              child: Icon(
                                Icons.attachment_outlined,
                                size: 20,
                                color: AppColors.toolbarBlue,
                              ),
                            ),
                          ),
                        ],
                      )),
                ],
              )),
        ),
        preferredSize: Size.fromHeight(
            SizeConfig.heightMultiplier * 16.571018651362985704000955107872));
  }

  Future<String> _getBackgroundImage() async {
    ImagePicker picker = ImagePicker();
    FirebaseStorage _storage = FirebaseStorage.instance;
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      var background_img = File(pickedFile.path);
      Reference reference = _storage.ref().child("backgroundImage/");

      //Upload the file to firebase
      UploadTask uploadTask = reference.putFile(background_img);
      TaskSnapshot taskSnapshot = uploadTask.snapshot;
      var back_url = await taskSnapshot.ref.getDownloadURL();
      // print("background_img $back_url");
      return back_url;
    } else {
      // print('No image selected.');
      return null;
    }
  }
}
