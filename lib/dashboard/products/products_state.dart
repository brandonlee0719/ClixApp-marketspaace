part of 'products_bloc.dart';

@immutable
abstract class ProductsState extends Equatable {
  const ProductsState();

  @override
  List<Object> get props => [];
}

class Blank extends ProductsState {}

class InitialProductsState extends ProductsState {}

class LoadingProducts extends ProductsState {}

class EmptySearch extends ProductsState {}

class ProductLoaded extends ProductsState {
  final List<FlashPromoAlgoliaObj> productList;

  final int page;

  final String currency;

  const ProductLoaded(this.productList, {this.page = 1, this.currency});
  @override
  List<Object> get props => [productList, page, currency];
}

class ProductLoadingFailed extends ProductsState {
  final String errorMessage;

  const ProductLoadingFailed(this.errorMessage);
  @override
  List<Object> get props => [errorMessage];
}

class LoadingMoreProducts extends ProductsState {}

class LoadingMoreProductsFailed extends ProductsState {}

// class ProductLiked extends ProductsState {
//   final bool productLiked;
//   const ProductLiked(this.productLiked);
// }
class ProductFailed extends ProductsState {}
