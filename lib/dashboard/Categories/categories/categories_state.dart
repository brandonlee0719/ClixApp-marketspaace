part of 'categories_bloc.dart';

@immutable
abstract class CategoriesState extends Equatable {
  const CategoriesState();

  @override
  // TODO: implement props
  List<Object> get props => [];
}

class CategoriesLoadedState extends CategoriesState {
  final CategoriesModel categoryList;

  final bool showHomeCategories;

  final int selectedCategoryIndex;

  const CategoriesLoadedState(this.categoryList,
      {this.showHomeCategories = false, this.selectedCategoryIndex = 0});

  @override
  List<Object> get props =>
      [categoryList, showHomeCategories, selectedCategoryIndex];
}

class InitialCategoriesState extends CategoriesState {}

class CategoriesLoadingState extends CategoriesState {}

class CategoriesLoadFailedState extends CategoriesState {
  final String errorMessage;

  const CategoriesLoadFailedState(this.errorMessage);
}

class CategoriesLoadSuccessState extends CategoriesState {
  final CategoriesModel categoryList;

  final bool showHomeCategories;

  final int selectedCategoryIndex;

  const CategoriesLoadSuccessState(this.categoryList,
      {this.showHomeCategories = false, this.selectedCategoryIndex = 0});

  @override
  List<Object> get props =>
      [categoryList, showHomeCategories, selectedCategoryIndex];
}

// class CategorySelectedState extends CategoriesState {
//   final CategoriesModel categoryList;
//
//   const CategorySelectedState(this.categoryList);
//
//   @override
//   List<Object> get props => [categoryList];
// }

// class ToggleHomeCategoriesState extends CategoriesState {
//   final CategoriesModel categoryList;
//
//   ToggleHomeCategoriesState(this.categoryList);
//
//   @override
//   List<Object> get props => [categoryList];
// }
