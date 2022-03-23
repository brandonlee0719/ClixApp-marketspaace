
import 'package:market_space/apis/userApi/models/addressModel.dart';

import 'package:market_space/profile_settings/model/debit_card_model.dart';


enum OrderStatus{
  awaitingPayment,
  received,
  delivering,
  delivered,
}

extension statusString on OrderStatus{
  String getStatus(){

    switch(this){
      case OrderStatus.awaitingPayment:
        return "awaitingPayment";
      case OrderStatus.received:
        return "received";
      case OrderStatus.delivering:
        return "delivering";
      case OrderStatus.delivered:
        return "delivered";
      default:
        return "delivered";
    }

  }

  static fromFire(String fireString){
    switch(fireString){
      case "awaitingPayment":
        return OrderStatus.awaitingPayment;
      case "received":
        return OrderStatus.received;
      case "delivering":
        return OrderStatus.delivering;
      case "delivered":
        return OrderStatus.delivered;
      default:
        return OrderStatus.awaitingPayment;
    }
  }
}

class LineModel{
  final String lineString;

  final double amount;

  LineModel(this.lineString, this.amount);
}

class BuyerFeedback {
  final double rating;
  final String review;

  BuyerFeedback(this.rating, this.review);
}



class OrderModel{
  List<LineModel> productLines;
  List<LineModel> shippingLines;
  LineModel taxLine;
  LineModel totalLine;
  final DebitCardModel card;
  final UserAddress address;
  OrderStatus orderStatus;
  BuyerFeedback feedBack;
  bool isCancelled;

  OrderModel(this.card, this.address, this.orderStatus,this.isCancelled);

  void addProduct(LineModel model){
    productLines.add(model);
  }

  void addShipping(LineModel model){
    shippingLines.add(model);
  }


}

