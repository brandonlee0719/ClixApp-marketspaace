import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:market_space/apis/orderApi/orderApi.dart';
import 'package:market_space/repositories/auth/auth_repository.dart';
import 'package:market_space/services/locator.dart';

enum OrderNotificationType {
  makeReview,
  makeClaim,
  makeExtension,
  declineClaim,
  declineExtension,
  acceptClaim,
  acceptExtension,
  confirmShipping,
}

class NotificationApi {
  final notificationReference = FirebaseFirestore.instance
      .collection("channels")
      .doc("notificationChannel")
      .collection("unPushedNotification");
  final orderReference = FirebaseFirestore.instance
      .collection("channels")
      .doc("notificationChannel")
      .collection("orderNotifications");

  Future<void> quickAdd() async {
    String uid = "V6J8t9PrLbZ1eGHZ3B6TO45LwCM2";
    for (int i = 0; i < 5; i++) {
      await orderReference.add({
        "body": "you have recieved a order claim",
        'channel': "order",
        'orderId': "ms190",
        "pushFrom": "buyer",
        "pushTo": uid
      });
    }
  }

  Future<Stream<QuerySnapshot>> getNotificationSnap() async {
    String uid = await AuthRepository().getUserId();
    return orderReference.where("pushTo", isEqualTo: uid).snapshots();
  }

  Future<void> addOrderNotification(
      bool isBuyer, String productName, OrderNotificationType type) async {
    Map<String, dynamic> map =
        await _buildOderNotificationDic(isBuyer, productName, type);
    await _addNotification(map);
  }

  Future<Map<String, dynamic>> _buildOderNotificationDic(
      bool isBuyer, String productName, OrderNotificationType type) async {
    String bodyString;
    OrderViewModel model = await locator.get<OrderApi>().model;
    switch (type) {
      case OrderNotificationType.makeReview:
        bodyString = "you have received a review on your product $productName";
        break;
      case OrderNotificationType.makeClaim:
        bodyString = "A claim has been raised on your product: $productName";
        break;
      case OrderNotificationType.declineClaim:
        bodyString = "Your Claim about product: $productName has been declined";
        break;
      case OrderNotificationType.makeExtension:
        bodyString =
            "A extension has been raised on your product: $productName";
        break;
      case OrderNotificationType.declineExtension:
        bodyString =
            "Your extension on product: $productName has been declined";
        break;

      case OrderNotificationType.acceptClaim:
        bodyString = "Your claim on product: $productName has been accept";
        break;

      case OrderNotificationType.acceptExtension:
        bodyString = "Your extension on product: $productName has been accept";
        break;
      case OrderNotificationType.confirmShipping:
        bodyString =
            "Your product: $productName has been received by the user!";
        break;
      default:
        bodyString = "you have received a notification";
        break;
    }
    return {
      "body": bodyString,
      "channel": "order",
      "orderId": locator.get<OrderApi>().orderId,
      if (isBuyer) "pushFrom": "buyer",
      if (!isBuyer) "pushFrom": "seller",
      "pushTo": model.sellerId,
    };
  }

  Future<void> _addNotification(Map<String, dynamic> dataMap) async {
    await notificationReference.add(dataMap);
  }

  Future<void> addChatNotification(
    String uid,
  ) async {
    await notificationReference.add({
      "body": "you have recieved a message",
      "channel": "chat",
      "pushTo": uid
    });
  }
}
