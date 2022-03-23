import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:market_space/common/constants.dart';
import 'package:market_space/model/notification_model/notification.dart';
import 'package:market_space/model/notification_model/notification_model.dart';
import 'package:market_space/repositories/auth/auth_repository.dart';
import 'package:rxdart/rxdart.dart';

class NotificationProvider {
  final _baseUrl =
      'https://australia-southeast1-market-spaace.cloudfunctions.net';
  Dio dio = new Dio();
  final AuthRepository _authRepository = AuthRepository();
  String _token;
  int _status;
  final BehaviorSubject<List<Notifications>> _notificationSink =
      BehaviorSubject();

  Stream<List<Notifications>> get notificationStream =>
      _notificationSink.stream;
  FirebaseAuth firebaseAuth = FirebaseAuth.instance;

  Future<List<Notifications>> getNotifications(String notificationDate) async {
    final createUserUrl = '$_baseUrl${"/get_investment_notification"}';
    _token = await _authRepository.getUserFirebaseToken();
    dio.options.headers['content-Type'] = 'application/json';
    dio.options.headers["Authorization"] = "Bearer $_token";
    dio.options.baseUrl = _baseUrl;
    final Response response = await dio.post(
      createUserUrl,
      data: {
        // "notificationDateTime": notificationDate
      },
      options: Options(
          followRedirects: false,
          validateStatus: (status) {
            _status = status;
            return status < 500;
          }),
    );

    if (_status == 200) {
      var data = NotificationModel.fromJson(json.decode(response.data));

      _notificationSink.add(data.notifications);
      return data.notifications;
    }
    return null;
  }

  Future<List<Notifications>> markNotificationRead(int notification_id) async {
    final createUserUrl = '$_baseUrl${"/mark_notification_sent"}';
    _token = await _authRepository.getUserFirebaseToken();
    dio.options.headers['content-Type'] = 'application/json';
    dio.options.headers["Authorization"] = "Bearer $_token";
    dio.options.baseUrl = _baseUrl;
    final Response response = await dio.post(
      createUserUrl,
      data: {"timestamp": notification_id.toString()},
      options: Options(
          followRedirects: false,
          validateStatus: (status) {
            _status = status;
            return status < 500;
          }),
    );

    if (_status == 200) {
      return null;
    } else {
      if (response.data.toString() == "User is not authorized") {
        _token = await firebaseAuth.currentUser.getIdToken(true);
        _authRepository.saveUserFirebaseToken(_token);
      }
      return null;
    }
  }
}
