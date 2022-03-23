part of 'favourite_products_bloc.dart';

abstract class FavouriteProductsEvent{
  const FavouriteProductsEvent();
}

class AddRemoveFavouriteProduct extends FavouriteProductsEvent{
  final int productId;
  AddRemoveFavouriteProduct(this.productId);
  @override
  String toString() {
    return super.toString()+"-> $productId";
  }
}

class LoadFavouriteProducts extends FavouriteProductsEvent{}

