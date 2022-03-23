import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:market_space/message_chat/message_chat_route.dart';
import 'package:market_space/messages/messages_route.dart';
import 'package:market_space/providers/auth/auth_provider.dart';

enum _MessageState {
  initial,
  loading,
  success,
}

class MessageCubit extends Cubit<_MessageState> {
  // static String data = "ABCD";
  AuthProvider provider = AuthProvider();
  MessageCubit() : super(_MessageState.initial);

  Future<void> fetchMyImage() async {
    MessageChatRoute.buyerImage = "ABCD";
    String uid = await provider.getUserUID();
    DocumentSnapshot snap =
        await FirebaseFirestore.instance.collection('users').doc(uid).get();
    String data = snap["profilePictureURL"];
    MessageChatRoute.buyerImage = data;
  }
}
