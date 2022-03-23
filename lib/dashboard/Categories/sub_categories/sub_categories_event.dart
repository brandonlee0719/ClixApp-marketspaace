part of 'sub_categories_bloc.dart';

@immutable
abstract class SubCategoriesEvent {}

class LoadSubcategories extends SubCategoriesEvent {
  final List<SubCategories> subCategories;

  LoadSubcategories(this.subCategories);
}

class ToggleShowMoreEvent extends SubCategoriesEvent {
  final bool showMore;

  ToggleShowMoreEvent(this.showMore);
}