class SubCategoryResultsModel {
  String _category;
  String _selectedSubCategory;
  String _algoliaSubCategorySearch;
  String _algoliaCategorySearch;
  List<String> _subCategories;

  String get category => _category;

  set category(String value) {
    _category = value;
  }

  String get algoliaCategorySearch => _algoliaCategorySearch;

  set algoliaCategorySearch(String value) {
    _algoliaCategorySearch = value;
  }

  String get selectedSubCategory => _selectedSubCategory;

  set selectedSubCategory(String value) {
    _selectedSubCategory = value;
  }

  String get algoliaSubCategorySearch => _algoliaSubCategorySearch;

  set algoliaSubCategorySearch(String value) {
    _algoliaSubCategorySearch = value;
  }

  List<String> get subCategories => _subCategories;

  set subCategories(List<String> value) {
    _subCategories = value;
  }
}
