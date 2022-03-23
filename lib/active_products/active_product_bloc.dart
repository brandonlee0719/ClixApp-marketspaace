import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:market_space/model/active_products_model/active_product_model.dart';
import 'package:market_space/model/product_model.dart';
import 'package:market_space/repositories/active_product_repository/active_product_repository.dart';

import 'active_product_events.dart';
import 'active_product_state.dart';

class ActiveProductsBloc
    extends Bloc<ActiveProductsEvent, ActiveProductsState> {
  ActiveProductsBloc(ActiveProductsState initialState) : super(initialState);
  final ActiveProductRepository _activeProductRepository =
      ActiveProductRepository();

  List<ProductModel> productList = List();

  @override
  ActiveProductsState get initialState => Initial();

  Stream<List<ActiveProducts>> get activeProductStream =>
      _activeProductRepository.activeProductProvider.activeProductStream;

  @override
  Stream<ActiveProductsState> mapEventToState(
    ActiveProductsEvent event,
  ) async* {
    if (event is ActiveProductsScreenEvent) {
      yield Loading();
      int status = await _getActiveProducts();
      if (status == 200) {
        yield Loaded(); // In this state we can load the HOME PAGE
      } else {
        yield Failed();
      }
    }
  }

  // void _prepareProductData() {
  //   for (int i = 0; i < 5; i++) {
  //     ProductModel productModel = ProductModel();
  //     productModel.title = "Really fine";
  //     productModel.subTitle = "Looking shoes";
  //     productModel.type = "Clothing";
  //     productModel.price = "59.99\$";
  //     productModel.discount = "0.00548";
  //     productModel.image = "assets/images/shoes.png";
  //     productModel.description =
  //     'New wave and dream pop influences, while thematically...';
  //     if (i != 1 || i != 3 || i != 5) {
  //       productModel.tags = ["Medium", "Short", "Longest Tag", "Tags"];
  //     }
  //     productList.add(productModel);
  //   }
  // }

  Future<int> _getActiveProducts() {
    return _activeProductRepository.getActiveProducts();
  }
}
