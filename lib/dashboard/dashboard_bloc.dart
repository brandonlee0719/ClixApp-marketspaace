// import 'dart:convert';
//
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:market_space/common/constants.dart';
// import 'package:market_space/model/fav_product_model/fav_product_model.dart';
// import 'package:market_space/model/flash_promo_model/flash_promo_algolia.dart';
// import 'package:market_space/model/flash_promo_model/flash_promo_model.dart';
// import 'package:market_space/model/product_detail_model/product_det_model.dart';
// import 'package:market_space/model/rates_model/rates_model.dart';
// import 'package:market_space/providers/algoliaCLient.dart';
// import 'package:market_space/repositories/auth/auth_repository.dart';
// import 'package:market_space/repositories/dashboardRepository/dashboard_repository.dart';
//
// import 'dashboard_events.dart';
// import 'dashboard_state.dart';
//
// class DashboardScreenBloc
//     extends Bloc<DashboardScreenEvents, DashboardScreenState> {
//   DashboardScreenBloc(DashboardScreenState initialState) : super(initialState);
//   final dashboardRepo = DashboardRepository();
//
//   AlgoliaClient client = AlgoliaClient();
//
//   List<FlashPromo> promoList = List<FlashPromo>();
//
//   // Stream<List<FlashPromo>> get flashStream =>
//   //     dashboardRepo.dashboardProvider.flashStream;
//
//   // Stream<List<FlashPromoAlgoliaObj>> get flashAlgoliaStream =>
//   //     dashboardRepo.dashboardProvider.flashAlgoliaStream;
//
//   // Stream<List<FlashPromoAlgoliaObj>> get productAlgoliaStream =>
//   //     dashboardRepo.dashboardProvider.productsAlgoliaStream;
//
//   // Stream<List<Products>> get productStream =>
//   //     dashboardRepo.dashboardProvider.productStream;
//
//   static List<FlashPromoAlgoliaObj> flashList = List();
//
//   List<FlashPromoAlgoliaObj> productLoadMoreList = List<FlashPromoAlgoliaObj>();
//
//   int promoNum;
//   String category;
//   String currency;
//   String crypto_currency;
//   int liked_item;
//   int liked_deleted;
//   String addedCategoriesStatus;
//   bool showCategories;
//   AuthRepository _authRepository = AuthRepository();
//   int pageCount = 0;
//   int productPageCount = 0;
//   static RatesModel cryptoValue;
//
//   String categoryFilter;
//   bool subCatSelected = false;
//   String subCatText;
//   static List<FlashPromoAlgoliaObj> favProductList = List();
//   List<FlashPromoAlgoliaObj> favProductNewList = List();
//   List<FlashPromoAlgoliaObj> favLoadMoreProductList = List();
//   FlashPromoAlgoliaObj favProduct;
//   String newSubCategoryText;
//   List<ProductDetModel> cartList = List();
//
// //////////////////////////////
//   @override
//   DashboardScreenState get initialState => Initial();
//
//   @override
//   Stream<DashboardScreenState> mapEventToState(
//     DashboardScreenEvents event,
//   ) async* {
//     // print("DashboardBloc: Received state $state");
//
//     if (event is NavigateToLoginScreenEvent) {
//       yield Loading();
//       if (Constants.country == null) {
//         Constants.country = await _authRepository.getCountry() ?? "Australia";
//       } else {
//         Constants.country = "Australia";
//       }
//
//       showCategories =
//           await _authRepository.getCategoryAdded() == "true" ? true : false;
//       if (showCategories) {
//         cartList.clear();
//         if (cartList == null || cartList.isEmpty) {
//           var products = await _authRepository.getCartProducts();
//           if (products != null &&
//               products.isNotEmpty &&
//               products != "[]" &&
//               products != "[null]") {
//             List<dynamic> favlst = jsonDecode(products);
//             cartList.clear();
//             for (int i = 0; i < favlst.length; i++) {
//               ProductDetModel fav = ProductDetModel.fromJson(favlst[i]);
//               cartList.add(fav);
//             }
//           }
//         }
//         Constants.cartCount = cartList.length;
//         yield HideCategories();
//       } else {
//         cartList.clear();
//         if (cartList == null || cartList.isEmpty) {
//           var products = await _authRepository.getCartProducts();
//           if (products != null &&
//               products.isNotEmpty &&
//               products != "[]" &&
//               products != "[null]") {
//             List<dynamic> favlst = jsonDecode(products);
//             cartList.clear();
//             for (int i = 0; i < favlst.length; i++) {
//               ProductDetModel fav = ProductDetModel.fromJson(favlst[i]);
//               cartList.add(fav);
//             }
//           }
//         }
//         Constants.cartCount = cartList.length;
//         yield ShowCategories();
//       }
//
//       //TODO: Check why loaded
//       // List<FlashPromoAlgoliaObj> lst = await dashboardRepo.dashboardProvider
//       //     .flashWithAlgolia(pageCount, categoryFilter, subCatSelected,
//       //         subCatText, newSubCategoryText);
//       // if (lst != null || lst.isNotEmpty) {
//       //   flashLoadMoreList.clear();
//       //   flashLoadMoreList.addAll(lst);
//       //   yield Loaded();
//       // } else {
//       //   yield FlashPromoFailed();
//       // }
//     } // Navigate to login screen event
//
//     if (event is LikeDislikeEvent) {
//       if (liked_item == 0) {
//         List<FlashPromoAlgoliaObj> _favList = List();
//         _favList.clear();
//         _favList.addAll(favProductList);
//         for (int index = 0; index < favProductList.length; index++) {
//           if (favProductList[index].productNum == favProduct.productNum) {
//             _favList.remove(favProductList[index]);
//             // print('product remove fav ${favProduct.productNum}');
//           }
//         }
//         favProductList.clear();
//         favProductList.addAll(_favList);
//         favProductNewList.clear();
//         for (FlashPromoAlgoliaObj algoliaObj in _favList) {
//           favProductNewList.add(algoliaObj);
//         }
//         FavProductModel favProductModel = FavProductModel();
//         favProductModel.favProductList = List();
//         favProductModel.favProductList = favProductNewList;
//         // var obj = FavProductModel.fromJson(favProductModel);
//         await _authRepository
//             .saveFavoriteProducts(favProductModel.favProductList);
//         // int status = await _deleteLikedItem();
//         // if (status == 200) {
//         yield PromoLiked();
//         // } else {
//         //   yield PromoLikedFailed();
//         // }
//       } else {
//         if (!favProductList.contains(favProduct)) {
//           favProductList.add(favProduct);
//         }
//         favProductNewList.clear();
//         for (FlashPromoAlgoliaObj algoliaObj in favProductList) {
//           favProductNewList.add(algoliaObj);
//         }
//         // print('product add fav ${favProduct.productNum}');
//         FavProductModel favProductModel = FavProductModel();
//         favProductModel.favProductList = List();
//         favProductModel.favProductList = favProductNewList;
//         // var obj = FavProductModel.fromJson(favProductModel);
//         await _authRepository.saveFavoriteProducts(favProductModel
//             .favProductList); // int status = await _addLikedItem();
//         // if (status == 200) {
//         yield PromoLiked();
//         // } else {
//         //   yield PromoLikedFailed();
//         // }
//       }
//     }
//
//     if (event is AddInterestedCategoriesEvent) {
//       addedCategoriesStatus = await _addInterestedItems();
//       if (addedCategoriesStatus != null) {
//         yield AddCategoriesSuccessful();
//       } else {
//         yield AddCategoriesFailed();
//       }
//     }
//
//     if (event is CryptoRateEvent) {
//       cryptoValue = await dashboardRepo.dashboardProvider.getCryptoRate();
//       if (cryptoValue != null) {
//         yield CryptoRateLoadedSuccessfully();
//       } else {
//         yield CryptoRateLoadedFailed();
//       }
//     }
//   }
//
//   Future<int> _addLikedItem() async {
//     int promo = await dashboardRepo.addLikedItem(liked_item);
//     return promo;
//   }
//
//   Future<int> _deleteLikedItem() async {
//     int promo = await dashboardRepo.deleteLikedItem(liked_deleted);
//     return promo;
//   }
//
//   // Future<int> _getProducts() async{
//   //   return dashboardRepo.getProducts();
//   // }
//
//   Future<String> _addInterestedItems() async {
//     return await dashboardRepo.dashboardProvider
//         .addInterestedItems(Constants.selectedChoices);
//   }
// }
