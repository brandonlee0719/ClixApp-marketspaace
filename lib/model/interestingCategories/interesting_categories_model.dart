class InterestingCategoriesModel {
  List<String> _interstingCategories;

  set interstingCategories(List<String> value) {
    _interstingCategories = value;
  }

  List<String> get interstingCategories => _interstingCategories;

  InterestingCategoriesModel({List<String> interstingCategories}) {
    _interstingCategories = _interstingCategories;
  }

  InterestingCategoriesModel.fromJson(dynamic json) {
    _interstingCategories = json["interestingCategories"] != null
        ? json["interestingCategories"].cast<String>()
        : [];
  }

//WE SENT A STRING WE NEED TO SEND AN INT FIND OUT WHAT THE CORRESPONDING VALUES ARE

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map["interestingCategories"] = _interstingCategories;
    return map;
  }
}
