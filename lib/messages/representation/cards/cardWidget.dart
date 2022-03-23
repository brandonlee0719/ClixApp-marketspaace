import 'package:flutter/cupertino.dart';
import 'package:market_space/apis/conversation/chatManager.dart';
import 'package:market_space/apis/firebaseManager.dart';
import 'package:market_space/common/colors.dart';
import 'package:market_space/message_chat/message_chat_route.dart';
import 'package:market_space/model/conversationModels/userModel.dart';
import 'package:market_space/providers/localDatabaseHelper.dart';
import 'package:market_space/providers/messages_provider/conversationCardProvider.dart';
import 'package:market_space/responsive_layout/size_config.dart';
import 'package:market_space/services/RouterServices.dart';
import 'package:market_space/services/locator.dart';
import '../streamTextWidget.dart';

class MessageCardViewModel{
  final String orderNumber;
  final bool inMediation;

  MessageCardViewModel(this.orderNumber, this.inMediation);
}

class MessageCard extends StatelessWidget {
  final Conversation conversation;
  final MessageCardViewModel model;

  const MessageCard({Key key, this.conversation, this.model}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return
      Container(
        margin: EdgeInsets.only(
            left: SizeConfig.widthMultiplier * 3.8888888888888884,
            right: SizeConfig.widthMultiplier * 3.8888888888888884,
            top: SizeConfig.heightMultiplier * 1.0043041606886658),
        child: GestureDetector(
          onTap: () {
            MessageChatRoute.id = conversation.conversationId;
            RouterService.appRouter.navigateTo(MessageChatRoute.buildPath());
          },
          child: Column(
            children: [
              Row(
                children: [
                  StreamIMageWidget(imgUrl: conversation.conversationCover,),
                  Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            child: Row(
                              children: [
                                Container(
                                  margin: EdgeInsets.only(
                                      left: SizeConfig.widthMultiplier *
                                          2.4305555555555554),
                                  child: StreamTextWidget(text:conversation.conversationName
                                    ,

                                    style: SelectTextStyle.name,),
                                ),
                                // Container(
                                //   margin: EdgeInsets.only(
                                //       left: SizeConfig.widthMultiplier *
                                //           2.4305555555555554),
                                //   child: StreamTextWidget(text: Conversation.parseTime(
                                //       DateTime.fromMillisecondsSinceEpoch(int.parse(conversation.lastUpdateTime)))
                                //     , style: SelectTextStyle.date,),
                                // ),
                              ],
                            ),
                          ),
                          Row(
                            children: [
                              Expanded(
                                child: Container(
                                  margin: EdgeInsets.only(
                                      left: SizeConfig.widthMultiplier *
                                          2.4305555555555554),
                                  child: StreamTextWidget(text:conversation.lastMessage, style: SelectTextStyle.content,),
                                ),
                              ),
                            ],
                          )
                        ],
                      )),
                  ValueListenableBuilder<int>(
                      valueListenable:conversation.numOfUnread,
                      builder: (context, value, widget) {
                        return StreamTextWidget(text:value.toString(), style: SelectTextStyle.unreadMessage,);
                      }
                  ),
                  //to-do, Niva could you plz replace this text with a new label that properly shows how much unread message does the user have?
                ],
              ),
              Container(
                margin: EdgeInsets.only(
                    top: SizeConfig.heightMultiplier * 1.0043041606886658),
                color: AppColors.text_field_container,
                height: SizeConfig.heightMultiplier * 0.06276901004304161,
              ),
            ],
          ),
        ),
      );
  }

}
