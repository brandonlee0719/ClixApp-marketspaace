import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:market_space/common/constants.dart';
import 'package:market_space/model/messages_model/message_history_model.dart';
import 'package:market_space/model/messages_model/messages_model.dart';
import 'package:market_space/repositories/auth/auth_repository.dart';
import 'package:rxdart/rxdart.dart';

class MessagesProvider {
  final _baseUrl =
      'https://australia-southeast1-market-spaace.cloudfunctions.net';
  Dio dio = new Dio();
  final AuthRepository _authRepository = AuthRepository();
  String _token;
  int _status;
  final BehaviorSubject<List<Chats>> _notificationSink = BehaviorSubject();

  Stream<List<Chats>> get notificationStream => _notificationSink.stream;
  FirebaseAuth firebaseAuth = FirebaseAuth.instance;

  Future<List<Chats>> getChats(String notificationDate) async {
    final createUserUrl = '$_baseUrl${Constants.get_chat_list}';
    _token = await _authRepository.getUserFirebaseToken();
    dio.options.headers['content-Type'] = 'application/json';
    dio.options.headers["Authorization"] = "Bearer $_token";
    dio.options.baseUrl = _baseUrl;
    if (notificationDate == null || notificationDate == "") {
      final Response response = await dio.post(
        createUserUrl,
        data: {},
        options: Options(
            followRedirects: false,
            validateStatus: (status) {
              _status = status;
              return status < 500;
            }),
      );
      // print(response.data.toString());
      // print(createUserUrl);
      // print(response.headers);

      if (_status == 200) {
        // print("success ${_status}");
        var data = MessagesModel.fromJson(response.data);
        _notificationSink.add(data.chats);
        return data.chats;
      } else {
        if (response.data.toString() == "User is not authorized") {
          _token = await firebaseAuth.currentUser.getIdToken(true);
          _authRepository.saveUserFirebaseToken(_token);
          // print(_token);
        }
        return null;
      }
    } else {
      final Response response = await dio.post(
        createUserUrl,
        data: {"lastMsgTime": notificationDate},
        options: Options(
            followRedirects: false,
            validateStatus: (status) {
              _status = status;
              return status < 500;
            }),
      );
      // print(response.data.toString());
      // print(createUserUrl);
      // print(response.headers);

      if (_status == 200) {
        // print("success ${_status}");
        var data = MessagesModel.fromJson(response.data);
        _notificationSink.add(data.chats);
        return data.chats;
      } else {
        if (response.data.toString() == "User is not authorized") {
          _token = await firebaseAuth.currentUser.getIdToken(true);
          _authRepository.saveUserFirebaseToken(_token);
          // print(_token);
        }
        return null;
      }
    }
  }

  Future<List<HistoryChats>> getHistoryChats(String groupId) async {
    final createUserUrl = '$_baseUrl${Constants.get_chat_history}';
    _token = await _authRepository.getUserFirebaseToken();
    dio.options.headers['content-Type'] = 'application/json';
    dio.options.headers["Authorization"] = "Bearer $_token";
    dio.options.baseUrl = _baseUrl;

    final Response response = await dio.post(
      createUserUrl,
      data: {"groupID": "Q7Q3EH18kYJLWpEidjFG"},
      options: Options(
          followRedirects: false,
          validateStatus: (status) {
            _status = status;
            return status <= 500;
          }),
    );
    // print(response.data.toString());
    // print(createUserUrl);
    // print(response.headers);

    if (_status == 200) {
      // print("success ${_status}");
      var data = MessageHistoryModel.fromJson(response.data);
      return data.chats;
    } else {
      if (response.data.toString() == "User is not authorized") {
        _token = await firebaseAuth.currentUser.getIdToken(true);
        _authRepository.saveUserFirebaseToken(_token);
        // print(_token);
      }
      return null;
    }
  }

  Future<int> markChatRead(String groupId) async {
    final createUserUrl = '$_baseUrl${Constants.mark_chat_read}';
    _token = await _authRepository.getUserFirebaseToken();
    dio.options.headers['content-Type'] = 'application/json';
    dio.options.headers["Authorization"] = "Bearer $_token";
    dio.options.baseUrl = _baseUrl;

    final Response response = await dio.post(
      createUserUrl,
      data: {"groupID": "Q7Q3EH18kYJLWpEidjFG"},
      options: Options(
          followRedirects: false,
          validateStatus: (status) {
            _status = status;
            return status < 500;
          }),
    );
    // print(response.data.toString());
    // print(createUserUrl);
    // print(response.headers);

    if (_status == 200) {
      // print("success ${_status}");
      return _status;
    } else {
      if (response.data.toString() == "User is not authorized") {
        _token = await firebaseAuth.currentUser.getIdToken(true);
        _authRepository.saveUserFirebaseToken(_token);
        // print(_token);
      }
      return _status;
    }
  }

  Future<int> sendMessage(String groupId, String message, String messageTime,
      String messageType) async {
    final createUserUrl = '$_baseUrl${Constants.send_message}';
    _token = await _authRepository.getUserFirebaseToken();
    dio.options.headers['content-Type'] = 'application/json';
    dio.options.headers["Authorization"] = "Bearer $_token";
    dio.options.baseUrl = _baseUrl;
    String uid = await _authRepository.getUserId();

    final Response response = await dio.post(
      createUserUrl,
      data: {
        "groupID": "Q7Q3EH18kYJLWpEidjFG",
        "message": message,
        "messageTime": messageTime,
        "uid": uid,
        "messageType": messageType
      },
      options: Options(
          followRedirects: false,
          validateStatus: (status) {
            _status = status;
            return status < 500;
          }),
    );
    // print(response.data.toString());
    // print(createUserUrl);
    // print(response.headers);

    if (_status == 200) {
      // print("success ${_status}");
      return _status;
    } else {
      if (response.data.toString() == "User is not authorized") {
        _token = await firebaseAuth.currentUser.getIdToken(true);
        _authRepository.saveUserFirebaseToken(_token);
        // print(_token);
      }
      return _status;
    }
  }
}
