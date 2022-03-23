import 'dart:async';
import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:market_space/model/product_detail_model/product_det_model.dart';
import 'package:market_space/repositories/auth/auth_repository.dart';
import 'package:meta/meta.dart';

part 'cart_event.dart';
part 'cart_state.dart';

class CartBloc extends Bloc<CartEvent, CartState> {
  CartBloc(CartState initialState) : super(initialState);
  List<ProductDetModel> productList = List();

  ProductDetModel product;

  @override
  CartState get initialState => Initial();
  AuthRepository _authRepository = AuthRepository();

  @override
  Stream<CartState> mapEventToState(
    CartEvent event,
  ) async* {
    if (event is CartScreenEvent) {
      yield Loading();

      var products = await _authRepository.getCartProducts();
      if (products != null &&
          products.isNotEmpty &&
          products != "[]" &&
          products != "[null]") {
        List<dynamic> favlst = jsonDecode(products);
        productList.clear();
        for (int i = 0; i < favlst.length; i++) {
          if (favlst[i] is Map) {
            ProductDetModel fav = ProductDetModel.fromJson(favlst[i]);
            productList.add(fav);
          }
        }
      }
      if (productList != null && productList.isNotEmpty) {
        yield Loaded();
      } else {
        yield Failed();
      }
    }

    if (event is RemoveCartEvent) {
      var products = await _authRepository.getCartProducts();
      if (products != null &&
          products.isNotEmpty &&
          products != "[]" &&
          products != "[null]") {
        List<dynamic> favlst = jsonDecode(products);
        productList.clear();
        for (int i = 0; i < favlst.length; i++) {
          ProductDetModel fav = ProductDetModel.fromJson(favlst[i]);
          if (product.productNum != fav.productNum) {
            productList.add(fav);
          }
        }
      }
      // print(productList.toString());
      await _authRepository.addCartProducts(productList);

      if (productList != null && productList.isNotEmpty) {
        yield ProductRemovedSuccessfully();
      } else {
        yield ProductRemovedFailed();
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
}
