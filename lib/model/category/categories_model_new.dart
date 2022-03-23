import 'package:equatable/equatable.dart';

class CategoriesModel extends Equatable {
  final List<CategoriesData> categoriesList;

  const CategoriesModel({this.categoriesList});

  factory CategoriesModel.fromJson(Map<String, dynamic> json) =>
      CategoriesModel(
        categoriesList: (json['categoriesList'] as List<dynamic>)
            ?.map((e) => e == null
                ? null
                : CategoriesData.fromJson(e as Map<String, dynamic>))
            ?.toList(),
      );

  Map<String, dynamic> toJson() => {
        'categoriesList': categoriesList?.map((e) => e?.toJson())?.toList(),
      };

  @override
  List<Object> get props => [categoriesList];
}

class CategoriesData extends Equatable {
  final String categoryId;
  final String categoryName;
  final String algoliaSearchString;
  final List<SubCategories> subCategories;

  const CategoriesData({
    this.categoryId,
    this.categoryName,
    this.algoliaSearchString,
    this.subCategories,
  });

  factory CategoriesData.fromJson(Map<String, dynamic> json) => CategoriesData(
        categoryId: json['categoryId'] as String,
        categoryName: json['category_name'] as String,
        algoliaSearchString: json['category_name'] == "Main"?null:(json['category_name'] as String).replaceAll("'", '-').replaceAll(" ", '_'),//json['algolia_search_string'] as String,
        subCategories: (json['subCategories'] as List<dynamic>)
            ?.map((e) => e == null
                ? null
                : SubCategories.fromJson(e as Map<String, dynamic>))
            ?.toList(),
      );

  Map<String, dynamic> toJson() => {
        'categoryId': categoryId,
        'category_name': categoryName,
        'algolia_search_string': algoliaSearchString,
        'subCategories': subCategories?.map((e) => e?.toJson())?.toList(),
      };

  @override
  List<Object> get props => [categoryId, categoryName, subCategories];
}

class SubCategories extends Equatable {
  final String subCategoryId;
  final String subCategoryName;
  final String subCategoryImage;
  final String algoliaSearchString;

  const SubCategories({
    this.subCategoryId,
    this.subCategoryName,
    this.subCategoryImage,
    this.algoliaSearchString,
  });

  factory SubCategories.fromJson(Map<String, dynamic> json) => SubCategories(
        subCategoryId: json['categoryId'] as String,
        subCategoryName: json['category'] as String,
        subCategoryImage: json['category_image'] as String,
        algoliaSearchString: json['algolia_search_string'] as String,
      );

  Map<String, dynamic> toJson() => {
        'categoryId': subCategoryId,
        'category': subCategoryName,
        'category_image': subCategoryImage,
        'algolia_search_string': algoliaSearchString,
      };

  @override
  List<Object> get props {
    return [
      subCategoryId,
      subCategoryName,
      subCategoryImage,
      algoliaSearchString,
    ];
  }
}
