part of 'sub_categories_bloc.dart';

@immutable
abstract class SubCategoriesState extends Equatable {
  const SubCategoriesState();

  @override
  List<Object> get props => [];
}

class InitialSubCategoriesState extends SubCategoriesState {}

/// SUB CATEGORIES
class SubCategoriesLoadingState extends SubCategoriesState {}

class SubCategoriesLoadSuccessState extends SubCategoriesState {
  final List<SubCategories> subCategoriesList;

  final bool showMore;

  const SubCategoriesLoadSuccessState(this.subCategoriesList, {this.showMore=false});

  @override
  List<Object> get props => [subCategoriesList,showMore];
}

class SubCategoriesLoadFailedState extends SubCategoriesState {
  final String errorMessage;
  const SubCategoriesLoadFailedState(this.errorMessage);
  @override
  List<Object> get props => [errorMessage];
}
