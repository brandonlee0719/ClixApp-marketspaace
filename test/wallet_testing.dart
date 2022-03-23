// import 'dart:convert';
//
// import 'package:dio/dio.dart';
// import 'package:firebase_core/firebase_core.dart';
// import 'package:flutter/services.dart';
// import 'package:flutter_test/flutter_test.dart';
//
// import 'package:market_space/investment/network/wallet_provider.dart';
// import 'package:firebase_core_platform_interface/firebase_core_platform_interface.dart';
// import 'package:mockito/mockito.dart';
//
//
//
// typedef Callback(MethodCall call);
//
// setupCloudFirestoreMocks([Callback customHandlers]) {
//
//
//   MethodChannelFirebase.channel.setMockMethodCallHandler((call) async {
//     if (call.method == 'Firebase#initializeCore') {
//       return [
//         {
//           'name': defaultFirebaseAppName,
//           'options': {
//             'apiKey': '123',
//             'appId': '123',
//             'messagingSenderId': '123',
//             'projectId': '123',
//           },
//           'pluginConstants': {},
//         }
//       ];
//     }
//
//     if (call.method == 'Firebase#initializeApp') {
//       return {
//         'name': call.arguments['appName'],
//         'options': call.arguments['options'],
//         'pluginConstants': {},
//       };
//     }
//
//     if (customHandlers != null) {
//       customHandlers(call);
//     }
//
//     return null;
//   });
// }
//
// class DioAdapterMock extends Mock implements HttpClientAdapter {}
// //to-do
// Future<void> main() async {
//   final Dio tdio = Dio();
//   DioAdapterMock dioAdapterMock;
//
//   TestWidgetsFlutterBinding.ensureInitialized();
//   setupCloudFirestoreMocks();
//
//   await Firebase.initializeApp();
//
//   setUp(() {
//     dioAdapterMock = DioAdapterMock();
//     tdio.httpClientAdapter = dioAdapterMock;
//
//   });
//
//
//   test('request test', () async {
//     // TestWidgetsFlutterBinding.ensureInitialized();
//     final responsepayload = jsonEncode({"response_code": "1000"});
//     final httpResponse =
//     ResponseBody.fromString(responsepayload, 200, headers: {
//       Headers.contentTypeHeader: [Headers.jsonContentType]
//     });
//
//     when(dioAdapterMock.fetch(any, any, any))
//         .thenAnswer((_) async => httpResponse);
//
//
//     WalletProvider provider = new WalletProvider();
//
//
//     await provider.getResponse();
//     // print(provider.response.statusCode);
//     // print(provider.response.statusMessage);
//   });
//
// }