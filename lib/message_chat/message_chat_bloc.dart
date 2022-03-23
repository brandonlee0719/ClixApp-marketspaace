import 'dart:async';
import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:market_space/model/messages_model/message_history_model.dart';
import 'package:market_space/repositories/auth/auth_repository.dart';
import 'package:market_space/repositories/messages_repository/MessagesRepository.dart';
import 'package:meta/meta.dart';

import 'message_chat_route.dart';

part 'message_chat_event.dart';
part 'message_chat_state.dart';

class MessageChatBloc extends Bloc<MessageChatEvent, MessageChatState> {
  MessageChatBloc(MessageChatState initialState) : super(initialState);
  MessagesRepository _messagesRepository = MessagesRepository();
  String groupId, message;
  List<HistoryChats> historyList;
  String userUID;
  AuthRepository _authRepository = AuthRepository();
  File image, background_img;
  FirebaseStorage _storage = FirebaseStorage.instance;
  final picker = ImagePicker();
  String url, profileImage, messageType;

  @override
  Stream<MessageChatState> mapEventToState(
    MessageChatEvent event,
  ) async* {
    if (event is MessageChatScreenEvent) {
      yield Loading();
      historyList = await _getHistoryChats();
      userUID = await _authRepository.getUserId();
      profileImage = await _authRepository.getProfileImage();
      if (historyList != null) {
        yield Loaded();
        await _markChatRead();
      } else {
        yield Failed();
      }
      // await Future.delayed(Duration(microseconds: 300));
    }
    if (event is MessageSendEvent) {
      int status = await _sendMessage();
      if (status == 200) {
        historyList = await _getHistoryChats();
        if (historyList != null) {
          yield MessageSendSuccessfully();
        } else {
          yield MessageSendFailed();
        }
      } else {
        yield MessageSendFailed();
      }
    }

    if (event is PickImageEvent) {
      String imagePicked = await _pickFile();
      if (imagePicked != null) {
        yield PickImageSuccessful();
      } else {
        yield PickImageFailed();
      }
    }
    if (event is CameraImageEvent) {
      bool imagePicked = await _getCamera();
      if (imagePicked) {
        yield CameraPickImageSuccessful();
      } else {
        yield CameraPickImageFailed();
      }
    }
  }

  Future<List<HistoryChats>> _getHistoryChats() async {
    return _messagesRepository.getMessages(MessageChatRoute.conversationId);
  }

  Future<int> _sendMessage() async {
    DateTime dateTime = DateTime.now();
    String format = DateFormat('dd-MM-yyyy hh:mm:ss').format(dateTime);
    return _messagesRepository.sendMessage(
        format, MessageChatRoute.conversationId, message, messageType);
  }

  Future<int> _markChatRead() async {
    return await _messagesRepository
        .markChatRead(MessageChatRoute.conversationId);
  }

  Future<bool> _getCamera() async {
    final pickedFile = await picker.getImage(source: ImageSource.camera);

    if (pickedFile != null) {
      image = File(pickedFile.path);
      // Uri uri =  image.uri;
      String uid = FirebaseAuth.instance.currentUser.uid;

      Reference reference = _storage.ref().child("profileImage/");

      //Upload the file to firebase
      UploadTask uploadTask = reference.putFile(image);
      TaskSnapshot taskSnapshot = uploadTask.snapshot;
      url = await taskSnapshot.ref.getDownloadURL();
      return true;
    } else {
      // print('No image selected.');
      return false;
    }
  }

  Future<String> _pickFile() async {
    FilePickerResult result = await FilePicker.platform.pickFiles();

    if (result != null) {
      File file = File(result.files.single.path);
      // print(result.files.single.name);
      String s = result.files.single.name;
      s.split(".");
      List<String> splitStr = s.split(".").map((unit) {
        return unit;
      }).toList();
      if (splitStr[1] == "jpg" || splitStr[1] == "png") {
        messageType = "Image";
      } else if (splitStr[1] == "mp4") {
        messageType = "Video";
      }
      Reference reference = _storage.ref().child("messageAttachments/");
      // // Upload the file to firebase
      UploadTask uploadTask = reference.putFile(file);
      TaskSnapshot taskSnapshot = uploadTask.snapshot;
      url = await taskSnapshot.ref.getDownloadURL();
    } else {
      // User canceled the picker
    }
    return url;
  }
}
