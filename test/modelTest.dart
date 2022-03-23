//
// //to-do
// import 'package:flutter_test/flutter_test.dart';
// import 'package:market_space/apis/extensions/flutterSetTest.dart';
// import 'package:market_space/apis/orderApi/orderApi.dart';
// import 'package:market_space/investment/models/wallet.dart';
//
// void main() {
//   Map<String, dynamic> chineseJsonMap = {
//     "AUD": 510.65,
//     "AUDinCNY": 2592.18835199338,
//     "BTC": 0.0185416,
//     "BTCinCNY": 6803.724099209436,
//     "CNY": 0.0,
//     "ETH": 0.0,
//     "USDC": 0.0,
//     "heldAUD": 0.0,
//     "heldBTC": 0.0,
//     "heldCNY": 0.0,
//     "heldETH": 0.0,
//     "heldUSDC": 0.0
//   };
//
//   Map<String, dynamic> ausDollarJsonMap = {
//
//     "AUD": 510.65,
//     "BTC": 0.0185416,
//     "BTCinAUD": 1340.3044993198746,
//     "CNY": 0.0,
//     "ETH": 0.0,
//     "USDC": 0.0,
//     "heldAUD": 0.0,
//     "heldBTC": 0.0,
//     "heldCNY": 0.0,
//     "heldETH": 0.0,
//     "heldUSDC": 0.0
//
//   };
//
//   test('whether the wallet model can initialize successfully case: CNY', () {
//     var wallet1 = Wallet.fromJson(chineseJsonMap);
//     var wallet2 = Wallet.fromJson(ausDollarJsonMap);
//     expect(wallet1.CNY, 0.0);
//     expect(wallet1.BTCInCNY, 6803.724099209436);
//     expect(wallet2.AUD, 510.65);
//     expect(wallet2.BTCInCNY, 1340.3044993198746);
//   });
//
//   test("dateTime test", () async {
//     // OrderApi api = OrderApi(orderId: "cmksvkds");
//     bool isExpired = OrderApi.isTimeExpired("2021-10-07 00:13:05.417420");
//     expect(isExpired, false);
//     isExpired = OrderApi.isTimeExpired("2019-10-07 00:13:05.417420");
//     expect(isExpired, true);
//     // print(OrderApi.getExtendedTime("2021-10-07 00:13:05.417420", 7));
//     await SetTest().addElements();
//   }
//
//   );
//
//
// }