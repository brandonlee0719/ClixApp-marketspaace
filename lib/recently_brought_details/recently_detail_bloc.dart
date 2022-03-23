import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:market_space/model/category/category_model.dart';
import 'package:market_space/model/order/order_model.dart';
import 'package:market_space/model/order_status_model/order_status_model.dart';
import 'package:market_space/model/product_model.dart';
import 'package:market_space/model/promo_model.dart';
import 'package:market_space/model/recently_bought_options/buyer_options.dart';
import 'package:market_space/recently_brought_details/recently_detail_event.dart';
import 'package:market_space/recently_brought_details/recently_detail_state.dart';
import 'package:market_space/repositories/profile_repository/profile_repository.dart';

class RecentlyDetailBloc
    extends Bloc<RecentlyDetailEvent, RecentlyDetailState> {
  RecentlyDetailBloc(RecentlyDetailState initialState) : super(initialState);

  List<ProductModel> productList = List();
  List<CategoryModel> categoryList = List();
  List<PromoModel> promoList = List();
  List<OrderModel> orderList = List();
  final ProfileRepository _profileRepository = ProfileRepository();
  String orderId, reason, detailReason;
  int rating;

  Stream<OrderStatusModel> get orderStatusStream =>
      _profileRepository.profileProvider.orderStatusStream;

  Stream<List<Order_overview>> get orderOverviewStream =>
      _profileRepository.profileProvider.orderOverviewStream;

  Stream<List<Order_overview>> get shippingAddressStream =>
      _profileRepository.profileProvider.orderOverviewStream;

  Stream<ClaimOptions> get claimOptionsStream =>
      _profileRepository.profileProvider.claimOptionStream;

  // OrderStatusModel orderStatusModel;
  @override
  RecentlyDetailState get initialState => Initial();
  BuyerOptions options;

  @override
  Stream<RecentlyDetailState> mapEventToState(
    RecentlyDetailEvent event,
  ) async* {
    if (event is RecentlyDetailScreenEvent) {
      yield Loading();
      yield Loaded();
    }
    if (event is ConfirmItemReceptionEvent) {
      yield ConfirmItemReceptionInit();
      int status = await _confirmReceptionItem();
      if (status == 200) {
        yield ConfirmItemReceptionSuccessful();
      } else {
        yield ConfirmItemReceptionFailed();
      }
    }
    if (event is BuyerOptionsEvent) {
      yield BuyerOptionsInit();
      options = await _getBuyerOptions();
      if (options != null) {
        // print('buyer options successful');
        // print(options.toString());
        yield BuyerOptionsSuccessful();
      } else {
        // print('not successful');
        yield BuyerOptionsFailed();
      }
    }
    if (event is LeaveSellerFeedbackEvent) {
      yield LeaveSellerFeedbackInit();
      int status = await _leaveFeedback();
      if (status == 200) {
        yield LeaveSellerFeedbackSuccessful();
      } else {
        yield LeaveSellerFeedbackFailed();
      }
    }

    if (event is CancelBuyerOrderEvent) {
      yield CancelBuyerOrderInit();
      int status = await _buyerCancelOrder();
      if (status == 200) {
        yield CancelBuyerOrderSuccessful();
      } else {
        yield CancelBuyerOrderFailed();
      }
    }
  }

  Future<int> _confirmReceptionItem() async {
    return await _profileRepository.confirmReceptionItem(orderId);
  }

  Future<int> _leaveFeedback() async {
    return await _profileRepository.leaveSellerFeedback(
        orderId, rating, detailReason);
  }

  Future<int> _buyerCancelOrder() async {
    return await _profileRepository.buyerCancelOrder(
        orderId, reason, detailReason);
  }

  Future<BuyerOptions> _getBuyerOptions() async {
    return await _profileRepository.getBuyerOptions(orderId);
  }
}
