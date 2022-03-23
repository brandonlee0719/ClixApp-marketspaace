import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:market_space/model/buyer_info_model/buyer_info_model.dart';
import 'package:market_space/model/category/category_model.dart';
import 'package:market_space/model/product_model.dart';
import 'package:market_space/model/sold_product_model/sold_product_model.dart';
import 'package:market_space/repositories/sold_product_repository/sold_product_repository.dart';
import 'package:market_space/sold_products/sold_product_event.dart';
import 'package:market_space/sold_products/sold_product_state.dart';
import 'package:rxdart/rxdart.dart';

class SoldProductBloc extends Bloc<SoldProductEvent, SoldProductState> {
  SoldProductBloc(SoldProductState initialState) : super(initialState);

  List<ProductModel> productList = List();
  List<CategoryModel> categoryList = List();
  String shippingDate;

  @override
  SoldProductState get initialState => Initial();

  final SoldProductRepository _soldProductRepository = SoldProductRepository();
  Stream<List<Orders>> get orderstream =>
      _soldProductRepository.soldProductProvider.Orderstream;
  Stream<BuyerInfoModel> get buyerInfoStream =>
      _soldProductRepository.soldProductProvider.buyerInfotream;

  String orderId;

  @override
  Stream<SoldProductState> mapEventToState(
    SoldProductEvent event,
  ) async* {
    if (event is SoldProductScreenEvent) {
      yield Loading();
      // _prepareProductData();
      // _prepareCatList();
      int status = await _getOrders();

      if (status == 200) {
        yield Loaded();
      } else {
        yield Failed();
      }
    }
    if (event is SoldProductBuyerInfoEvent) {
      BuyerInfoModel buyerInfo = await _getBuyerInfo();
      if (buyerInfo != null) {
        yield BuyerInfoLoaded();
      } else {
        yield BuyerInfoFailed();
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
  }

  Future<int> _getOrders() async {
    return await _soldProductRepository.getSoldProducts();
  }

  Future<BuyerInfoModel> _getBuyerInfo() async {
    return await _soldProductRepository.getBuyerInfo(orderId);
  }

  Future<int> _markShippedItem() async {
    shippingDate = DateTime.now().toString();
    return _soldProductRepository.markShippedItem(orderId, shippingDate);
  }
}
