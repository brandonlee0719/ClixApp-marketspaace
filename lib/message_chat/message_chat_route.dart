import 'package:fluro/fluro.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:market_space/message_chat/logic/chat_row_cubit.dart';
import 'package:market_space/message_chat/message_chat_screen.dart';
import 'package:market_space/routes/route.dart';

class MessageChatRoute extends ARoute {
  static String _path = '/dashboard/messageChat';
  static String buildPath() => _path;
  static String conversationId, name, sellerImage, id, buyerImage;

  @override
  String get path => _path;

  @override
  final TransitionType transition = TransitionType.fadeIn;

  @override
  Widget handlerFunc(BuildContext context, Map<String, dynamic> params) {
    if (params["isCreating"] != null) {
      return BlocProvider(
          create: (BuildContext context) => ChatRowCubit(
                conversationId,
              ),
          child: MessageChatScreen(
            isCreating: params["isCreating"][0],
            uid: params["uid"][0],
            userName: params["name"][0],
          ));
    }
    return BlocProvider(
        create: (BuildContext context) => ChatRowCubit(
              conversationId,
            ),
        child: MessageChatScreen());
  }
}
