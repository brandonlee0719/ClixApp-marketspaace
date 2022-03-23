part of 'favourite_products_bloc.dart';

abstract class FavouriteProductsState extends Equatable {
  const FavouriteProductsState();
}

class FavouriteProductsInitial extends FavouriteProductsState {
  @override
  List<Object> get props => [];
}


class FavouriteProductsLoaded extends FavouriteProductsState{
  final List<int> favProducts;

  FavouriteProductsLoaded(this.favProducts);

  @override
  List<Object> get props => [favProducts];

}
