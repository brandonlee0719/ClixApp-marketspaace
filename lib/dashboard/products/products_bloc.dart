import 'dart:async';
import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:market_space/model/flash_promo_model/flash_promo_algolia.dart';
import 'package:market_space/model/interestingCategories/interesting_categories_model.dart';
import 'package:market_space/providers/algoliaCLient.dart';
import 'package:market_space/repositories/auth/auth_repository.dart';
import 'package:meta/meta.dart';

part 'products_event.dart';

part 'products_state.dart';

class ProductsBloc extends Bloc<ProductsEvent, ProductsState> {
  ProductsBloc() : super(InitialProductsState());

  List<FlashPromoAlgoliaObj> lst = [];
  int pageCount = 0;
  AuthRepository _authRepository = AuthRepository();
  AlgoliaClient client = AlgoliaClient();

  @override
  Stream<ProductsState> mapEventToState(ProductsEvent event) async* {
    if (event is SetupEvent) {
      lst = [];
      yield Blank();
    }

    if (event is LoadListEvent) {
      yield* _mapLoadListEventToState(event);
    }

    if (event is FilterChangedEvent) {
      yield* _mapFilterChangeEventToState(event);
    }

    // if (event is ProductLikeDislikeEvent) {
    //   yield* _mapLikeDisLikeToState(event);
    // }

    if (event is LoadMoreProductsEvent) {
      String interestedCategory =
          await _authRepository.getInterestingCategories();
      List<String> interestedList = [];
      if (interestedCategory != null) {
        InterestingCategoriesModel interestedCategories =
            InterestingCategoriesModel.fromJson(jsonDecode(interestedCategory));
        interestedList = interestedCategories.interstingCategories;
      }
      List<FlashPromoAlgoliaObj> newList = [];
      pageCount++;
      if (event.category == null &&
          (event.searchText == '' || event.searchText == null)) {
        newList = await client.searchBasic(interestedList, pageCount);
      } else if (event.searchText != '' && event.searchText != null) {
        newList = await client.searchKey(event.searchText, pageCount);
      } else {
        newList = await client.searchCategory(
            category: event.category,
            page: pageCount,
            subCategory: event.subCategory);
      }
      if (newList?.isNotEmpty ?? false) {
        lst.addAll(newList);
        var userCurrency = await _authRepository.getPrefferedCurrency();
        yield ProductLoaded(lst, page: pageCount + 1, currency: userCurrency);
      }
      // else {
      //   yield LoadingMoreProductsFailed();
      // }
    }

    // if (event is LoadBySearch){

    // }
  }

  Stream<ProductsState> _mapLoadListEventToState(LoadListEvent event) async* {
    yield (LoadingProducts());
    // print("LoadListEvent Category : ${event.category}");
    String interestedCategory =
        await _authRepository.getInterestingCategories();
    List<String> interestedList = [];
    if (interestedCategory != null) {
      InterestingCategoriesModel interestedCategories =
          InterestingCategoriesModel.fromJson(jsonDecode(interestedCategory));
      interestedList = interestedCategories.interstingCategories;
    }
    if (event.category == null &&
        (event.searchText == '' || event.searchText == null)) {
      lst = await client.searchBasic(interestedList, 0);
    } else if (event.searchText != '' && event.searchText != null) {
      lst = await client.searchKey(event.searchText, 0);
    } else {
      lst = await client.searchCategory(
          category: event.category, page: 0, subCategory: event.subCategory);
    }
    // print("interested");
    String currency = await _authRepository.getPrefferedCurrency();
    if (currency == null) {
      await _authRepository.savePrefferedCurrency("AUD");
      await _authRepository.saveCryptoCurrency("BTC");
    }
    var userCurrency = await _authRepository.getPrefferedCurrency();
    if (lst != null) {
      yield ProductLoaded(lst, currency: userCurrency);
    } else {
      yield ProductLoadingFailed('No Products Found');
    }
  }
  //NOT ACTUALLY EXECUTING THE DISFIRED PRINT CHECK WHAT CALLS THE BLOC SO YOU CAN WORK WITH THIS

  Stream<ProductsState> _mapFilterChangeEventToState(
      FilterChangedEvent event) async* {
    client.clickOn(
        isLocal: event.local,
        isDigital: event.digital,
        isPreloved: event.preLoved,
        isInternational: event.international);
    add(LoadListEvent(category: event.category));
  }

// Stream<ProductsState> _mapLikeDisLikeToState(
//     ProductLikeDislikeEvent event) async* {
//   // Like Dislike product
//   final cast = state as ProductLoaded;
//   final favList = <int>[];
//   final index = cast.productList
//       .indexWhere((element) => element.productNum == event.productId);
//   cast.productList[index].liked = !cast.productList[index].liked;
//   if (cast.productList[index].liked) {
//     favList.add(event.productId);
//   } else {
//     favList.remove(event.productId);
//   }
//   await _authRepository.saveFavoriteProducts(favList);
//   yield ProductLoaded(cast.productList,
//       page: cast.page, currency: cast.currency);
//
//   // if (liked_item == 0) {
//   //   List<FlashPromoAlgoliaObj> _favList = List();
//   //   _favList.clear();
//   //   _favList.addAll(lst);
//   //   for (int index = 0; index < lst.length; index++) {
//   //     if (lst[index].productNum == favProduct.productNum) {
//   //       _favList.remove(lst[index]);
//   //       // print('product remove fav ${favProduct.productNum}');
//   //     }
//   //   }
//   //   lst.clear();
//   //   lst.addAll(_favList);
//   //   favProductNewList.clear();
//   //   for (FlashPromoAlgoliaObj algoliaObj in _favList) {
//   //     favProductNewList.add(algoliaObj);
//   //   }
//   //   FavProductModel favProductModel = FavProductModel();
//   //   favProductModel.favProductList = List();
//   //   favProductModel.favProductList = favProductNewList;
//   //
//   //   await _authRepository
//   //       .saveFavoriteProducts(favProductModel.favProductList);
//   //   yield ProductLiked(false);
//   // } else {
//   //   if (!lst.contains(favProduct)) {
//   //     lst.add(favProduct);
//   //   }
//   //   favProductNewList.clear();
//   //   for (FlashPromoAlgoliaObj algoliaObj in lst) {
//   //     favProductNewList.add(algoliaObj);
//   //   }
//   //   // print('product add fav ${favProduct.productNum}');
//   //   FavProductModel favProductModel = FavProductModel();
//   //   favProductModel.favProductList = List();
//   //   favProductModel.favProductList = favProductNewList;
//   //   await _authRepository
//   //       .saveFavoriteProducts(favProductModel.favProductList);
//   //   yield ProductLiked(true);
//   // }
// }
}
