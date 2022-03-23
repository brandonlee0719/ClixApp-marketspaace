class CategoryModel {
  String _category;
  String _categoryId;
  bool _isSelected;

  bool get isSelected => _isSelected;

  set isSelected(bool value) {
    _isSelected = value;
  }

  set category(String value) {
    _category = value;
  }

  String get category => _category;
  String get categoryId => _categoryId;

  CategoryModel({String category, String categoryId}) {
    _category = category;
    _categoryId = categoryId;
    _isSelected = isSelected;
  }

  CategoryModel.fromJson(dynamic json) {
    _category = json["category"];
    _categoryId = json["categoryId"];
    _isSelected = json["isSelected"];
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map["category"] = _category;
    map["categoryId"] = _categoryId;
    map["isSelected"] = _isSelected;
    return map;
  }

  set categoryId(String value) {
    _categoryId = value;
  }
}
