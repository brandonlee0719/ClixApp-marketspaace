import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:market_space/model/messages_model/messages_model.dart';
import 'package:market_space/repositories/messages_repository/MessagesRepository.dart';
import 'package:meta/meta.dart';

part 'messages_event.dart';
part 'messages_state.dart';

class MessagesBloc extends Bloc<MessagesEvent, MessagesState> {
  MessagesBloc(MessagesState initialState) : super(initialState);
  List<Chats> messageList = List();
  MessagesRepository _messagesRepository = MessagesRepository();
  String dateTime;

  @override
  Stream<MessagesState> mapEventToState(
    MessagesEvent event,
  ) async* {
    if (event is MessageScreenEvent) {
      yield Loading();
      messageList = await _getChats();
      if (messageList != null) {
        yield Loaded();
      } else {
        yield Failed();
      }
      // await Future.delayed(Duration(microseconds: 300));
    }
  }

  Future<List<Chats>> _getChats() async {
    return _messagesRepository.getChats(dateTime);
  }
}
