import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:market_space/apis/conversation/conversationApi.dart';
import 'package:market_space/apis/orderApi/exceptions/OrderExceptions.dart';
import 'package:market_space/apis/orderApi/notificationApi.dart';
import 'package:market_space/apis/orderApi/orderModel.dart';
import 'package:market_space/order_checkout/model/update_address_model/update_address_model.dart';
import 'package:market_space/profile/logics/orderProvider.dart';
import 'package:market_space/profile_settings/model/debit_card_model.dart';
import 'package:market_space/providers/orderProvider.dart';
import 'package:market_space/recently_brought_details/widgets/review.dart';
import 'package:market_space/representation/widgets/deliverBar.dart';
import 'package:market_space/services/locator.dart';

class OrderViewModel {
  final double productPrice;
  final double shippingPrice;
  final double wyreFee;
  String paymentMethod;
  final String sourceCurrency;
  final String imgLink;
  final String sellerId;
  final String buyerId;
  final Timestamp stamp;
  String shippingStatus;
  String title;
  String description;
  double fiatPrice;
  String shippingCompany;
  String trackingNumber;

  OrderViewModel(
      this.productPrice,
      this.shippingPrice,
      this.wyreFee,
      this.paymentMethod,
      this.sourceCurrency,
      this.imgLink,
      this.shippingStatus,
      this.title,
      this.fiatPrice,
      this.sellerId,
      this.buyerId,
      this.stamp);

  double getSum() {
    return productPrice + shippingPrice + wyreFee;
  }

  bool isExpired() {
    // print('expire data');

    int expireDate =
        this.stamp.toDate().add(Duration(days: 29)).millisecondsSinceEpoch;
    int now = DateTime.now().millisecondsSinceEpoch;
    // print(now);
    // print(expireDate);
    if (now > expireDate) {
      return true;
    }
    return false;
  }

  static OrderViewModel fromJson(Map<String, dynamic> map, bool isBuyer) {
    double total = map["sourceAmount"].toDouble();
    double productPrice = map["fiatPrice"].toDouble();
    double wyreFee = total - productPrice;
    if (wyreFee < 0.00) {
      wyreFee = 0.00;
    }
    String tagetUid;
    // print('does this execute?');
    // print('order api data: ' + map.toString());
    if (isBuyer) {
      tagetUid = map['sellerUID'];
    } else {
      tagetUid = map['sellerUID'];
    }
    return OrderViewModel(
        productPrice,
        0.0,
        wyreFee,
        map["method"],
        map['sourceCurrency'],
        map['imgLink'],
        map['shippingStatus'],
        map['title'],
        map['fiatPrice'].toDouble(),
        map['sellerUID'],
        map['buyerUID'],
        map['timeStamp']);
  }
}

class OrderApi {
  String orderId;
  bool isBuyer = true;
  DocumentReference orderRef;
  final String shippingLine = "shippingStatus";
  CancelOrderProvider provider = CancelOrderProvider();
  Stream<DocumentSnapshot> snapshot;
  ValueNotifier<DeliverBarManager> manager =
      ValueNotifier<DeliverBarManager>(null);
  ValueNotifier<String> orderStatusString = ValueNotifier<String>(null);

  // getter for order
  // getter for claim
  // there is certain need of read order and claim
  // all the time needs to be rely on the time stamp in the order

  OrderViewModel _model;

  Future<OrderViewModel> get model async {
    // print(_model.toString());
    if (_model == null) {
      _model = await getViewModel();
    }

    return _model;
  }

  Future<OrderViewModel> getViewModel() async {
    // print('executing?');
    if (_model != null) {
      // print('weird');
      return _model;
    }
    var doc = await orderRef.get();
    // print(doc);
    var data = doc.data();
    // print("i am printing");
    // print(doc.get("timeStamp").runtimeType);

    try {
      // print(data);
      _model = OrderViewModel.fromJson(data, this.isBuyer);
    } catch (e) {
      // print("error is caught");
      // print(e);
    }
    if (_model.paymentMethod == null) {
      _model.paymentMethod = "debitCard";
    }
    // print(_model.stamp);

    return _model;
  }

  OrderApi({this.orderId}) {
    orderRef =
        FirebaseFirestore.instance.collection('orders').doc(this.orderId);
  }

  void dispose() {
    // print("dispose is called");
    _model = null;
    snapshot = null;
    manager = ValueNotifier<DeliverBarManager>(null);
    orderStatusString = ValueNotifier<String>(null);
  }

  void setId(String id) {
    this._model = null;
    this.orderId = id;
    orderRef =
        FirebaseFirestore.instance.collection('orders').doc(this.orderId);

    this.snapshot = orderRef.snapshots(includeMetadataChanges: true);

    this.snapshot.listen((event) {
      if (event.data() != null) {
        orderStatusString.value = event.get("shippingStatus");
        if (event.get("shippingStatus") == "COMPLETED") {
          manager.value = DeliverBarManager(true, true, true);
        } else if (event.get("shippingStatus") == "SHIPPED") {
          manager.value = DeliverBarManager(true, true, false);
        } else {
          manager.value = DeliverBarManager(true, false, false);
        }
      }
    });
  }

  Stream<DocumentSnapshot> getSnapshot() {
    Stream<DocumentSnapshot> snapshot = FirebaseFirestore.instance
        .collection('orders')
        .doc(this.orderId)
        .snapshots(includeMetadataChanges: true);
    this.snapshot = snapshot;
    return snapshot;
  }

  Stream<DocumentSnapshot> getClaimSnapShot() {
    return this.orderRef.collection("claims").doc('claim').snapshots();
  }

  Future<bool> isExpired() async {
    var query = await orderRef.collection("claims").get();
    var timeString = query.docs[0].data()["purchaseProtectionTime"];
    return isTimeExpired(timeString);
  }

  Future<void> raiseClaim(String reason, String detailedReason, bool isBuyer,
      {bool isExtendProtection = false}) async {
    String key = isExtendProtection ? 'claim' : "cancel";
    var query = await orderRef.collection("claims").get();
    var timeString = query.docs[0].data()["purchaseProtectionTime"];
    if (isTimeExpired(timeString)) {
      throw OrderException("Time Expired");
    }
    if (isExtendProtection) {
      orderRef.update({'MediationStatus': 'IN_MEDIATION'});
      provider.orderOperation(orderId, 'mediation');
      provider.createMediation(
          this._model.sellerId, this._model.buyerId, orderId);
    } else {
      provider.orderOperation(orderId, 'cancellation');
    }

    await orderRef.collection("claims").doc("claim").update({
      '${key}DetailedReason': detailedReason,
      '${key}Reason': reason,
      '${key}Available': 'false',
      if (isBuyer) '${key}By': 'buyer',
      if (!isBuyer) '${key}By': 'seller',
      '${key}Status': "CLAIM RAISED",
    });
  }

  Future<void> raiseExtension(bool isBuyer, int day) async {
    var query = await orderRef.collection("claims").get();
    var order = await orderRef.get();
    var timeString = query.docs[0].data()["purchaseProtectionTime"];
    if (isTimeExpired(timeString)) {
      throw OrderException("Time Expired");
    }

    await orderRef.update({"shippingStatus": 'Claim Raised'.toUpperCase()});

    await orderRef.collection("claims").doc("claim").update({
      'extensionAvailable': 'false',
      if (isBuyer) 'extensionClaimBy': 'buyer',
      if (!isBuyer) 'extensionClaimBy': 'seller',
      "extensionStatus": "CLAIM RAISED",
      "requireDays": day,
    });

    await locator.get<NotificationApi>().addOrderNotification(
        this.isBuyer, this._model.title, OrderNotificationType.makeExtension);
  }

  Future<void> acceptClaim({isExtension = false, isExpired = false}) async {
    String status = isExtension ? 'claimStatus' : 'cancelStatus';

    // if (isExtension) {
    //   var query = await orderRef.collection("claims").get();
    //   // print(query.docs[0].data()["requireDays"]);
    //   // var order = await orderRef.get();
    //   var timeString = query.docs[0].data()["purchaseProtectionTime"];
    //   status = "extensionStatus";
    //   await orderRef.collection("claims").doc("claim").update({
    //     "purchaseProtectionTime":
    //         getExtendedTime(timeString, query.docs[0].data()["requireDays"]),
    //   });
    // }
    if (!isExtension) {
      if (!isExpired) {
        provider.requestRefund(orderId);
      }
      provider.orderOperation(orderId, "cancellation_accepted");
      await orderRef.collection("claims").doc("claim").update({
        'claimStatus': "COMPLETED",
        'cancelStatus': "COMPLETED",
      });
    } else {
      await orderRef.collection("claims").doc("claim").update({
        status: "IN MEDIATION",
      });
      await orderRef.update({'MediationStatus': 'IN_MEDIATION'});
    }
    // if (isExtension) {
    //   await locator.get<NotificationApi>().addOrderNotification(this.isBuyer,
    //       this._model.title, OrderNotificationType.acceptExtension);
    // } else {
    //   await locator.get<NotificationApi>().addOrderNotification(
    //       this.isBuyer, this._model.title, OrderNotificationType.acceptClaim);
    //   await orderRef.update({
    //     "shippingStatus": 'completed'.toUpperCase(),
    //   });
    // }
  }

  Future<void> declineClaim({isExtension = false}) async {
    String status = isExtension ? 'claimStatus' : 'cancelStatus';
    // if (isExtension) {
    //   status = "extensionStatus";
    // }
    await orderRef.collection("claims").doc("claim").update({
      status: "IN MEDIATION",
    });
    await orderRef.update({'MediationStatus': 'IN_MEDIATION'});
    if (!isExtension) {
      provider.createMediation(
          this._model.sellerId, this._model.buyerId, orderId);
    }

    provider.orderOperation(orderId, 'mediation');
    // String s = (){
    //   return "haha";
    // }();

    // await locator
    //     .get<ConversationApi>()
    //     .chatTo("rPLMag2bJpefZdsmldQ04sKb82U2", "God", isMediation: true);
    //
    // if (isExtension) {
    //   await locator.get<NotificationApi>().addOrderNotification(this.isBuyer,
    //       this._model.title, OrderNotificationType.declineExtension);
    // } else {
    //   await locator.get<NotificationApi>().addOrderNotification(
    //       this.isBuyer, this._model.title, OrderNotificationType.declineClaim);
    // }
  }

  static String getExtendedTime(String timeString, int days) {
    DateTime protectionTime = DateTime.parse(timeString);
    var newTime = protectionTime.add(Duration(days: days));
    return newTime.toString();
  }

  static bool isTimeExpired(String timeString) {
    DateTime protectionTime = DateTime.parse(timeString);
    DateTime now = DateTime.now();
    if (now.compareTo(protectionTime) < 0) {
      return false;
    }
    return true;
  }

  Future<void> confirmShipping() async {
    await orderRef.update({
      shippingLine: "DELIVERED",
    });
    provider.confirmShipping(orderId);

    provider.orderOperation(orderId, 'shipped');
  }

  Future<void> uploadReview(Review review) async {
    await this
        .orderRef
        .collection("buyerData")
        .doc("review")
        .set(review.toJson());
    locator.get<NotificationApi>().addOrderNotification(
        this.isBuyer, this._model.title, OrderNotificationType.makeReview);
    provider.orderOperation(orderId, 'rating');
  }

  Future<Review> getReview() async {
    var review =
        await this.orderRef.collection("buyerData").doc("review").get();
    if (review.exists) {
      return Review.fromJson(review.data());
    }

    return null;
  }

  Future<OrderModel> getOrder() async {
    var model1 = await getAddress();
    await _getProductLines('product');
    await _getProductLines('shipping');

    return null;
  }

  Future<UpdateAddressModel> getAddress() async {
    DocumentSnapshot snap =
        await orderRef.collection('buyerData').doc('buyerInfo').get();
    var doc = snap.data();

    return UpdateAddressModel(
      country: snap.get("shippingCountry"),
      firstName: snap.get("shippingFirstName"),
      lastName: snap.get("shippingLastName"),
      streetAddress: snap.get("shippingStreetAddress"),
      postcode: snap.get("shippingPostcode"),
      suburb: snap.get("shippingSuburb"),
    );
  }

  Future<List<LineModel>> _getProductLines(String lineName) async {
    String key1 = '';
    String key2 = '';
    if (lineName == "product") {
      key1 = 'name';
      key2 = 'price';
    } else {
      key1 = 'name';
      key2 = 'cost';
    }
    List<LineModel> list = List<LineModel>();
    QuerySnapshot snaps = await orderRef.collection(lineName).get();
    for (var snap in snaps.docs) {
      LineModel model = LineModel(snap[key1], snap[key2]);
      list.add(model);
    }
    return list;
  }
}
