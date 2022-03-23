part of 'message_widgets.dart';

class _ChatBubble extends StatelessWidget {
  final Messages messages;
  final bool isMe;

  const _ChatBubble({Key key, this.messages, this.isMe}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Column(children: [
      if (messages?.messageType.toLowerCase() == "image")
        _ChatImageWidget(imgUrl: messages.message),
      if (messages?.messageType?.toLowerCase() == "video")
        _UserVideoWidget(
          videoUrl: messages.message,
        ),
      if (messages?.messageType?.toLowerCase() == "text")
        _UserChatTextWidget(
          messageText: messages.message,
          isMe: isMe,
        ),

      if (messages?.messageType?.toLowerCase() == "product")
        _ProductWidget(
          message: messages?.message,
        ),
      //date time
      // if (messages?.messageType != "Product")
      //   _ChatTimestamp(messageType: messages.messageType,isMe: isMe,),
    ]);
  }
}

class _ChatRow extends StatefulWidget {
  final Messages message;
  final conversation;
  bool isSending;

  _ChatRow({Key key, this.message, this.isSending = false, this.conversation})
      : super(key: key);

  @override
  __ChatRowState createState() => __ChatRowState();
}

class __ChatRowState extends State<_ChatRow> {
  @override
  Widget build(BuildContext context) {
    return Container(
        margin: EdgeInsets.symmetric(
            vertical: SizeConfig.heightMultiplier *
                1.2553802008608322503031026596873),
        child: widget.message.messageType.toLowerCase() == "product"
            ? _ChatBubble(
                messages: widget.message,
              )
            : !(FirebaseManager.instance.getUID() == widget.message.messageUID)
                ? Container(
                    margin: EdgeInsets.only(
                        left: SizeConfig.widthMultiplier * 2.4305555555555554),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _UserImage(
                            imgUrl: widget.message.messageUID.toLowerCase() ==
                                    "admin"
                                ? null
                                : locator
                                        .get<ChatManager>()
                                        .userMap[widget.message.messageUID]
                                        .imgUrl ??
                                    "https://www.google.com/imgres?imgurl=https%3A%2F%2Fih1.redbubble.net%2Fimage.1385480438.5691%2Fst%2Csmall%2C507x507-pad%2C600x600%2Cf8f8f8.jpg&imgrefurl=https%3A%2F%2Fwww.redbubble.com%2Fshop%2Fla%2Bbi%2Bxiao%2Bxin&tbnid=d66PqueJnGKC7M&vet=12ahUKEwjB14S_2rz1AhVrF7cAHf9TAfUQMygHegUIARDAAQ..i&docid=uzup5EIlKth7IM&w=600&h=600&q=labixiaoxin&ved=2ahUKEwjB14S_2rz1AhVrF7cAHf9TAfUQMygHegUIARDAAQ",
                            placeHolder:
                                widget.message.messageUID.toLowerCase() ==
                                        "admin"
                                    ? "assets/images/admin.png"
                                    : 'assets/images/profile_pic.png'),
                        _ChatBubble(
                          messages: widget.message,
                          isMe: false,
                        ),
                      ],
                    ))
                : Container(
                    margin: EdgeInsets.only(
                        right: SizeConfig.widthMultiplier * 2.4305555555555554),
                    child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          //to-do(niva) please add a send fail icon here, I am using text to represent send fail, but apparently we need
                          //a icon that can be clicked to resend the text.
                          _ChatBubble(
                            messages: widget.message,
                            isMe: true,
                          ),
                          _UserImage(
                              imgUrl: locator
                                  .get<ChatManager>()
                                  .userMap[FirebaseManager.instance.getUID()]
                                  .imgUrl,
                              placeHolder: 'assets/images/profile_pic.png'),
                        ]),
                  ));
  }
}

class ChatScreen extends StatefulWidget {
  final ScrollController controller;
  final Conversation conver;

  const ChatScreen({Key key, this.controller, this.conver}) : super(key: key);

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  bool isFirst = true;
  List<Messages> messageList = List<Messages>();
  int index = 0;

  @override
  void initState() {
    // conversation = locator.get<ChatManager>().conversations[0];
    // print("the id is...");
    // print(locator.get<ChatManager>().conversations.length);
    // conversation.getMessages(0, onComplete: (){
    //   // print("it is completed");
    //   // print(widget.controller.position.minScrollExtent);
    //   // jumpLater();
    //
    // });

    // TODO: implement initState
    super.initState();

    // controller.jumpTo(controller.position.maxScrollExtent);
  }

  @override
  Widget build(BuildContext context) {
    Conversation conversation = widget.conver;
    return Expanded(
      child: GestureDetector(
        onTap: () {
          FocusScopeNode currentFocus = FocusScope.of(context);

          if (!currentFocus.hasPrimaryFocus) {
            currentFocus.unfocus();
          }
        },
        child: ValueListenableBuilder<int>(
            valueListenable: conversation.messageLengthNotifier,
            builder: (context, value, child) {
              int length = conversation.messages.length;
              return Container(
                  alignment: Alignment.topCenter,
                  child: ListView.builder(
                      controller: widget.controller,
                      shrinkWrap: true,
                      reverse: true,
                      itemCount: conversation.messages.length,
                      itemBuilder: (BuildContext context, int index) {
                        Messages message = conversation.messages[index];

                        if (index == length - 1) {
                          DateTime messageTime =
                              DateTime.fromMillisecondsSinceEpoch(
                                  int.parse(message.messageTime));

                          return Column(
                            children: [
                              Text(Conversation.parseTime(messageTime)),
                              _ChatRow(
                                message: conversation.messages[length - 1],
                                conversation: conversation,
                              )
                            ],
                          );
                        }

                        if (index < length - 1) {
                          DateTime messageTime =
                              DateTime.fromMillisecondsSinceEpoch(
                                  int.parse(message.messageTime));

                          Messages formerMessage =
                              conversation.messages[index + 1];
                          DateTime formerTime =
                              DateTime.fromMillisecondsSinceEpoch(
                                  int.parse(formerMessage.messageTime));

                          if (messageTime.difference(formerTime).inMinutes >=
                              60) {
                            return Column(
                              children: [
                                Text(Conversation.parseTime(messageTime)),
                                _ChatRow(
                                  message: conversation.messages[index],
                                )
                              ],
                            );
                          }
                        }
                        return _ChatRow(
                          message: conversation.messages[index],
                        );

                        // return _ChatRow(message: cubit.messageList[index],);
                      }));
            }),
      ),
    );
  }
}
