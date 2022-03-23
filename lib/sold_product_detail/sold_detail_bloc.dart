import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:market_space/model/buyer_info_model/buyer_info_model.dart';
import 'package:market_space/model/category/category_model.dart';
import 'package:market_space/model/order/order_model.dart';
import 'package:market_space/model/product_model.dart';
import 'package:market_space/model/promo_model.dart';
import 'package:market_space/model/seller_option_model/seller_options_model.dart';
import 'package:market_space/repositories/sold_product_repository/sold_product_repository.dart';
import 'package:market_space/sold_product_detail/sold_detail_event.dart';
import 'package:market_space/sold_product_detail/sold_detail_route.dart';

import 'package:market_space/sold_product_detail/sold_detail_state.dart';
import 'package:market_space/sold_products/sold_product_route.dart';

class SoldDetailBloc extends Bloc<SoldDetailEvent, SoldDetailState> {
  SoldDetailBloc(SoldDetailState initialState) : super(initialState);

  final SoldProductRepository _soldProductRepository = SoldProductRepository();

  List<ProductModel> productList = List();
  List<CategoryModel> categoryList = List();
  List<PromoModel> promoList = List();
  List<OrderModel> orderList = List();

  String orderId, shippingCompany, trackingNumber, shippingDate, reason, detail;
  BuyerInfoModel buyerInfo;
  int extensionTime;
  SellerOptionsModel sellerOptionsModel;
  double rating;
  String comment;

  @override
  SoldDetailState get initialState => Initial();

  @override
  Stream<SoldDetailState> mapEventToState(
    SoldDetailEvent event,
  ) async* {
    if (event is SoldDetailScreenEvent) {
      yield Loading();
      BuyerInfoModel infoModel = await _getBuyerInfo();
      if (infoModel != null) {
        yield Loaded();
      } else {
        yield Failed();
      }

      yield Loading();
      SellerOptionsModel sellerOptionsModel = await _sellerOptions();
      if (sellerOptionsModel != null) {
        yield SellerOptionsSuccessfully();
      } else {
        yield SellerOptionsFailed();
      }
    }

    if (event is UpdateSellerTrackingEvent) {
      int status = await _updateSellerTracking();
      if (status == 200) {
        yield TrackingUpdated();
      } else {
        yield TrackingFailed();
      }
    }

    if (event is CancelOrderEvent) {
      int status = await _cancelOrder();
      if (status == 200) {
        yield CancelOrderSuccessful();
      } else {
        yield CancelOrderFailed();
      }
    }
    if (event is ExtendProtectionEvent) {
      int status = await _extendProtection();
      if (status == 200) {
        yield ProtectionExtendedSuccessful();
      } else {
        yield ProtectionExtensionFailed();
      }
    }

    if (event is MarkItemShippedEvent) {
      int status = await _markShippedItem();
      if (status == 200) {
        yield MarkItemShippedSuccessfully();
      } else {
        yield MarkItemShippedFailed();
      }
    }

    if (event is RaiseClaimEvent) {
      int status = await _raiseClaim();
      if (status == 200) {
        yield ClaimRaisedSuccessfully();
      } else {
        yield ClaimRaisingFailed();
      }
    }

    if (event is FeedbackSendingEvent) {
      int status = await _leaveFeedback();
      await Future.delayed(Duration(milliseconds: 500));
      if (status == 200) {
        yield FeedbackSuccessfullySent();
      } else {
        yield FeedbackSendingFailed();
      }
    }
  }

  Future<int> _updateSellerTracking() async {
    return _soldProductRepository.updateSellerTracking(
        orderId, shippingCompany, trackingNumber, shippingDate);
  }

  Future<BuyerInfoModel> _getBuyerInfo() async {
    buyerInfo = await _soldProductRepository
        .getBuyerInfo(SoldDetailRoute.order.orderID);
    return buyerInfo;
  }

  Future<int> _cancelOrder() async {
    return _soldProductRepository.cancelOrder(orderId, reason, detail);
  }

  Future<int> _extendProtection() async {
    return _soldProductRepository.extendProtection(
        orderId, reason, extensionTime);
  }

  Future<int> _markShippedItem() async {
    shippingDate = DateTime.now().toString();
    return _soldProductRepository.markShippedItem(orderId, shippingDate);
  }

  Future<SellerOptionsModel> _sellerOptions() async {
    sellerOptionsModel = await _soldProductRepository
        .sellerOptions(SoldDetailRoute.order.orderID);
    return sellerOptionsModel;
  }

  Future<int> _raiseClaim() async {
    return await _soldProductRepository.raiseClaim(orderId, reason, detail);
  }

  Future<int> _leaveFeedback() async {
    return await _soldProductRepository.leaveFeedback(orderId, rating, comment);
  }
}
