import 'dart:async';
import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:market_space/model/product_detail_model/product_det_model.dart';
import 'package:market_space/repositories/auth/auth_repository.dart';

class ShoppingCartManager {
  StreamController<List<dynamic>> cartStream;
  List<ProductDetModel> productList = [];
  List<ProductDetModel> purchaseProduct = [];
  ValueNotifier<int> numberOfUnChecked = ValueNotifier<int>(0);

  Future<void> removeFromCart(ProductDetModel model) async {
    productList.remove(model);
    await AuthRepository().addCartProducts(productList);
    cartStream.add(productList);
  }

  List getCartNumbers() {
    List<int> list = [];
    for (var product in productList) {
      list.add(product.productNum);
    }
    return list;
  }

  void add(ProductDetModel model) {
    productList.add(model);

    numberOfUnChecked.value = numberOfUnChecked.value + 1;
    // print(numberOfUnChecked.value);
  }

  void addToPurchase(ProductDetModel model) {
    purchaseProduct.add(model);
  }

  void clearCart() async {
    for (var product in purchaseProduct) {
      await removeFromCart(product);
    }
  }

  void removeFromPurchase(ProductDetModel model) {
    purchaseProduct.remove(model);
  }

  void clear() {
    numberOfUnChecked.value = 0;
  }

  Future<void> getCart() async {
    cartStream = StreamController<List<dynamic>>();

    if (productList.length == 0) {
      String products = await AuthRepository().getCartProducts();
      if (products != null) {
        // print(products);
        final data = jsonDecode(products);
        for (int i = 0; i < data.length; i++) {
          if (data[i] is Map) {
            productList.add(ProductDetModel.fromJson(data[i]));
          }
        }
      }
    }

    cartStream.add(productList);
  }
}
