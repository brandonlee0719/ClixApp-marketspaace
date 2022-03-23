import 'dart:convert';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:market_space/apis/userApi/shoppingCartManager.dart';
import 'package:market_space/common/constants.dart';
import 'package:market_space/model/category/category_model.dart';
import 'package:market_space/model/fav_product_model/fav_product_model.dart';
import 'package:market_space/model/flash_promo_model/flash_promo_algolia.dart';
import 'package:market_space/model/product_detail_model/product_det_model.dart';
import 'package:market_space/model/product_model.dart';
import 'package:market_space/model/promo_model.dart';
import 'package:market_space/model/shipping_price_model/shipping_price_model.dart';
import 'package:market_space/product_landing_screen/product_landing_event.dart';
import 'package:market_space/product_landing_screen/product_landing_state.dart';
import 'package:market_space/repositories/product_detail_repository/product_detail_repository.dart';
import 'package:market_space/repositories/repository.dart';
import 'package:market_space/services/locator.dart';

class ProductLandingBloc
    extends Bloc<ProductLandingEvent, ProductLandingState> {
  ProductLandingBloc(ProductLandingState initialState) : super(initialState);
  final ProductDetailRepository _productDetailRepository =
      ProductDetailRepository();

  List<ProductModel> productList = List();
  List<PromoModel> promoList = List();
  List<CategoryModel> categoryList = List();
  int productNum, pageCount = 0;
  ProductDetModel productDetailModel;
  int liked_item;
  int liked_deleted;
  int _status;
  SellerData sellerData;
  List<RelatedItems> relatedItems = List();
  int cartItemCount;

  final dashboardRepo = DashboardRepository();

  AuthRepository _authRepository = AuthRepository();
  List<FlashPromoAlgoliaObj> favProductList = List();
  ShippingPriceModel shippingPrice;
  String zipCode;
  List<ProductDetModel> cartList = List();
  ProductDetModel cartProduct;
  bool _cartAdded = false;
  bool productExistInCart = false;

  @override
  ProductLandingState get initialState => Initial();

  // Stream<List<ActiveProducts>> get activeProductStream =>
  //     _activeProductRepository.activeProductProvider.activeProductStream;

  @override
  Stream<ProductLandingState> mapEventToState(
    ProductLandingEvent event,
  ) async* {
    if (event is ProductLandingScreenEvent) {
      yield Loading();
      productDetailModel = await _getProduct();
      // print('is this obtained?');
      relatedItems = await _productDetailRepository.getRelatedItems(
          productDetailModel?.category, pageCount);
      // print('and now');
      cartList.clear();
      if (cartList == null || cartList.isEmpty) {
        var products = await _authRepository.getCartProducts();
        if (products != null &&
            products.isNotEmpty &&
            products != "[]" &&
            products != "[null]") {
          List<dynamic> favlst = jsonDecode(products);
          cartList.clear();
          for (int i = 0; i < favlst.length; i++) {
            if (favlst[i] is Map) {
              ProductDetModel fav = ProductDetModel.fromJson(favlst[i]);
              cartList.add(fav);
              if (fav.productNum == productDetailModel.productNum) {
                productExistInCart = true;
              }
            }
          }
        }
      }
      // print('here');
      if (cartList == null || cartList.isEmpty) {
        productExistInCart = false;
      }
      // print('or this');
      cartItemCount = cartList.length;
      // print('bro?');
      if (productDetailModel != null) {
        yield Loaded(); // In this state we can load the HOME PAGE
      } else {
        yield Failed();
      }
    }

    if (event is SellerDataEvent) {
      sellerData = await _productDetailRepository.getSellerData(productNum);
      if (sellerData != null) {
        yield SellerDataLoaded();
      } else {
        yield SellerDataFailed();
      }
    }

    // if (event is ProductLikeEvent) {
    //   // _status = await _addLikedItem();
    //   var products = await _authRepository.getFavoriteProducts();
    //
    //   if (products != null && products.isNotEmpty && products != "[]") {
    //     List<dynamic> favlst = jsonDecode(products);
    //     favProductList.clear();
    //     for (int i = 0; i < favlst.length; i++) {
    //       FlashPromoAlgoliaObj fav = FlashPromoAlgoliaObj.fromJson(favlst[i]);
    //       favProductList.add(fav);
    //     }
    //   }
    //
    //   FlashPromoAlgoliaObj obj = FlashPromoAlgoliaObj();
    //   obj.productNum = productDetailModel.productNum;
    //   obj.productName = productDetailModel.productTitle;
    //   obj.category = productDetailModel.category;
    //
    //   // List<FlashPromoAlgoliaObj> lst = List();
    //   // lst.add(obj);
    //   favProductList.add(obj);
    //   FavProductModel favProductModel = FavProductModel();
    //   favProductModel.favProductList = List();
    //   favProductModel.favProductList = favProductList;
    //   // var obj = FavProductModel.fromJson(favProductModel);
    //   await _authRepository
    //       .saveFavoriteProducts(favProductModel.favProductList);
    //   // if(_status==200){
    //   yield ProductLiked();
    //   // }else{
    //   //   yield ProductLikedFailed();
    //   // }
    // }
    // if (event is ProductDisLikeEvent) {
    //   // _status = await _deleteLikedItem();
    //   var products = await _authRepository.getFavoriteProducts();
    //
    //   if (products != null && products.isNotEmpty && products != "[]") {
    //     List<dynamic> favlst = jsonDecode(products);
    //     favProductList.clear();
    //     for (int i = 0; i < favlst.length; i++) {
    //       FlashPromoAlgoliaObj fav = FlashPromoAlgoliaObj.fromJson(favlst[i]);
    //       favProductList.add(fav);
    //     }
    //   }
    //
    //   FlashPromoAlgoliaObj obj = FlashPromoAlgoliaObj();
    //   obj.productNum = productDetailModel.productNum;
    //   obj.productName = productDetailModel.productTitle;
    //   obj.category = productDetailModel.category;
    //
    //   List<FlashPromoAlgoliaObj> lst = List();
    //   lst.addAll(favProductList);
    //
    //   for (int index = 0; index < favProductList.length; index++) {
    //     if (favProductList[index].productNum == obj.productNum) {
    //       lst.remove(favProductList[index]);
    //     }
    //   }
    //
    //   FavProductModel favProductModel = FavProductModel();
    //   favProductModel.favProductList = List();
    //   favProductModel.favProductList = lst;
    //   // var obj = FavProductModel.fromJson(favProductModel);
    //   await _authRepository
    //       .saveFavoriteProducts(favProductModel.favProductList);
    //   if (_status == 200) {
    //     yield ProductDisliked();
    //   } else {
    //     yield ProductDislikedFailed();
    //   }
    // }

    if (event is LoadMoreRelatedEvent) {
      relatedItems.clear();
      relatedItems = await _productDetailRepository.getRelatedItems(
          productDetailModel.category, pageCount);
      if (relatedItems != null) {
        yield RelatedItemsLoaded();
      } else {
        yield RelatedItemsFailed();
      }
    }

    if (event is CalculateShippingEvent) {
      shippingPrice = await _calculateShipping();
      if (shippingPrice != null) {
        yield ShippingCalculatedSuccessfully();
      } else {
        yield ShippingCalculationFailed();
      }
    }

    if (event is AddToCartEvent) {
      productExistInCart = true;
      cartList.add(cartProduct);
      await _authRepository.addCartProducts(cartList);
      cartItemCount = cartList.length;
      locator<ShoppingCartManager>().add(cartProduct);
      yield ItemAddedToCartSuccessfully();
    }

    if (event is RemoveFromCartEvent) {
      productExistInCart = false;
      cartList.remove(cartProduct);
      await _authRepository.deleteCartProducts(cartList);
      cartItemCount = cartList.length;
      locator<ShoppingCartManager>().removeFromCart(cartProduct);
      yield ItemRemovedFromCartSuccessfully();
    }
  }

  Future<ProductDetModel> _getProduct() async {
    return _productDetailRepository.getProduct(productNum);
  }

  Future<int> _addLikedItem() async {
    int promo = await dashboardRepo.addLikedItem(liked_item);
    return promo;
  }

  Future<int> _deleteLikedItem() async {
    int promo = await dashboardRepo.deleteLikedItem(liked_deleted);
    return promo;
  }

  Future<ShippingPriceModel> _calculateShipping() async {
    shippingPrice = await _productDetailRepository.calculateShipping(
        productNum, zipCode, Constants.country);
    return shippingPrice;
  }
}
