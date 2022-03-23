import 'package:bloc/bloc.dart';
import 'package:market_space/model/product_detail_model/product_det_model.dart';
import 'package:market_space/repositories/product_detail_repository/product_detail_repository.dart';
import 'package:meta/meta.dart';

enum ChatAgoliaState { initial, fetching, fetchSuccess, fetchFail }

class ChatAgoliaCubit extends Cubit<ChatAgoliaState> {
  final int productNumber;
  ProductDetModel product;
  ChatAgoliaCubit(this.productNumber) : super(ChatAgoliaState.initial) {
    fetchProduct();
  }

  Future<void> fetchProduct() async {
    emit(ChatAgoliaState.fetching);
    ProductDetailRepository repo = ProductDetailRepository();
    product = await repo.getProduct(this.productNumber);
    if (product != null) {
      emit(ChatAgoliaState.fetchSuccess);
    } else {
      emit(ChatAgoliaState.fetchFail);
    }
  }
}
