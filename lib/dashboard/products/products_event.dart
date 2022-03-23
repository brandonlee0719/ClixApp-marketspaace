part of 'products_bloc.dart';

@immutable
abstract class ProductsEvent {}

class SetupEvent extends ProductsEvent {}

class LoadListEvent extends ProductsEvent {
  final String category;
  final String subCategory;
  final int page;
  final String searchText;

  LoadListEvent(
      {this.category = '',
      this.subCategory = '',
      this.page = 0,
      this.searchText = ''});
}

class FilterChangedEvent extends ProductsEvent {
  final bool preLoved;
  final bool digital;
  final bool local;
  final bool international;

  final String category;

  FilterChangedEvent({
    this.preLoved = false,
    this.digital = false,
    this.local = false,
    this.international = false,
    this.category = '',
  });
}

class LoadMoreProductsEvent extends ProductsEvent {
  final String category;
  final String subCategory;
  final int page;
  final String searchText;

  LoadMoreProductsEvent(
      {this.category = '',
      this.subCategory = '',
      this.page = 0,
      this.searchText = ''});
}
