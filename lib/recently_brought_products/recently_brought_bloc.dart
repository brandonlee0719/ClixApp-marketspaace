import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:market_space/model/category/category_model.dart';
import 'package:market_space/model/order_status_model/order_status_model.dart';
import 'package:market_space/model/product_model.dart';
import 'package:market_space/model/recently_product_model/recently_brought_model.dart';
import 'package:market_space/recently_brought_products/recently_brought_events.dart';
import 'package:market_space/recently_brought_products/recently_brought_state.dart';
import 'package:market_space/repositories/profile_repository/profile_repository.dart';

class RecentlyBroughtBloc
    extends Bloc<RecentlyBroughtEvent, RecentlyBroughtState> {
  RecentlyBroughtBloc({RecentlyBroughtState initialState})
      : super(initialState ?? Initial());

  List<ProductModel> productList = List();
  List<CategoryModel> categoryList = List();
  final ProfileRepository _profileRepository = ProfileRepository();
  String orderId;
  OrderStatusModel orderStatus;

  Stream<List<RecentlyBrought>> get recentlyBoughtStream =>
      _profileRepository.profileProvider.recentlyBought;
  Stream<OrderStatusModel> get orderStatusStream =>
      _profileRepository.profileProvider.orderStatusStream;
  List<RecentlyBrought> recentlyBoughtList;

  @override
  RecentlyBroughtState get initialState => Initial();

  @override
  Stream<RecentlyBroughtState> mapEventToState(
      RecentlyBroughtEvent event,
      ) async* {
    if (event is RecentlyBroughtScreenEvent) {
      yield Loading();
      final items = await _getRecentBrought();
      if (recentlyBoughtList == null) {
        recentlyBoughtList = items;
      } else {
        recentlyBoughtList = [
          ...recentlyBoughtList,
          for (RecentlyBrought item in items) item
        ];
      }
      if (recentlyBoughtList != null) {
        yield Loaded();
      } else {
        yield Failed();
      }

      // await Future.delayed(Duration(milliseconds: 300));
      // yield Loaded();
    }
    if (event is RecentlyOrderStatusEvent) {
      OrderStatusModel model = await _getOrderStatus();
      if (model != null) {
        yield OrderStatusSuccessful();
      } else {
        yield OrderStatusFailed();
      }
    }
  }

  Future<List<RecentlyBrought>> _getRecentBrought() async {
    return _profileRepository.getRecentBrought(orderId);
  }

  Future<OrderStatusModel> _getOrderStatus() async {
    orderStatus =
    await _profileRepository.profileProvider.getOrderStatus(orderId);
    return orderStatus;
  }
}