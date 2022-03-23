//
//
// import 'package:cloud_firestore_mocks/cloud_firestore_mocks.dart';
// import 'package:flutter_test/flutter_test.dart';
// import 'package:market_space/apis/userApi/UserApi.dart';
// import 'package:market_space/apis/userApi/models/cardModel.dart';
//
// Future<void> main() async {
//   MockFirestoreInstance instance;
//   UserApi api;
//   setUp(() async {
//     instance = MockFirestoreInstance();
//     await instance.collection('users').doc('CooanSOL2PNfHTC20w6rAhihkUK2').update(
//         {
//           'displayName': "kim"
//         }
//     );
//     await instance.collection('users').doc('uid').collection('privateData')
//         .doc('privateData').collection("addressData").doc('0').update(
//       {
//        " addressNum" : 0,
//         "country" :"",
//         "firstName" : "kim",
//         "instructions" :"",
//         "lastName": "john",
//         "phoneNumber" : "+61403207228",
//         "postcode" :"3020",
//         "state" : "PIng",
//         "streetAddress" : "U77 South Korea street",
//         "streetAddressTwo" : "Pingyong",
//         "suburb": "Ping"
//       }
//     );
//     api = UserApi(instance, "CooanSOL2PNfHTC20w6rAhihkUK2");
//   });
//
//   test("address exist", () async {
//     final snapshot = await instance.collection('users').get();
//     expect(snapshot.docs.first.data()['displayName'],'kim');
//
//     var list =  await api.getAddress();
//     // print(list[0].firstName);
//   });
//
//   test("card initial", () async {
//     var result = await api.getCard();
//     expect(result, null);
//
//   });
//
//   test("card exist", () async {
//     await api.addCard(CardModel("xinhuan", "12/24", "1234"));
//     var result = await api.getCard();
//     // print(result.toJson());
//   });
//
//   test("card not exist", () async {
//     await api.deleteCard();
//     var result = await api.getCard();
//     expect(result, null);
//
//   });
//
//
//
// }


