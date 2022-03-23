import 'dart:async';
import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:market_space/repositories/auth/auth_repository.dart';

part 'favourite_products_event.dart';

part 'favourite_products_state.dart';

class FavouriteProductsBloc
    extends Bloc<FavouriteProductsEvent, FavouriteProductsState> {
  FavouriteProductsBloc() : super(FavouriteProductsInitial());
  AuthRepository _authRepository = AuthRepository();

  @override
  Stream<FavouriteProductsState> mapEventToState(
    FavouriteProductsEvent event,
  ) async* {
    if (event is LoadFavouriteProducts) {
      yield FavouriteProductsLoaded(List<int>.from(
          jsonDecode(await _authRepository.getFavoriteProducts())));
    }
    if (event is AddRemoveFavouriteProduct) {
      yield* _mapAddRemoveProductToState(event);
    }
  }

  Stream<FavouriteProductsState> _mapAddRemoveProductToState(
      AddRemoveFavouriteProduct event) async* {
    final cast = state as FavouriteProductsLoaded;
    var favProducts = List<int>.from(cast.favProducts);
    if (favProducts.contains(event.productId)) {
      favProducts.remove(event.productId);
    } else {
      favProducts.add(event.productId);
    }
    _authRepository.saveFavoriteProducts(favProducts);
    yield FavouriteProductsLoaded(favProducts);
  }
}
