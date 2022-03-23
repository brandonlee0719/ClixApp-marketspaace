part of 'categories_bloc.dart';

@immutable
abstract class CategoriesEvent {}

class CompleteDataLoadEvent extends CategoriesEvent {}

class GetAllCategories extends CategoriesEvent {
  final Map<String, String> bodyMap;
  GetAllCategories(this.bodyMap);
}

// class ToggleHomeCategories extends CategoriesEvent {}
class ToggleShowHomeCategories extends CategoriesEvent {}

class CategorySelected extends CategoriesEvent {
  final int i;

  CategorySelected(this.i);
}
