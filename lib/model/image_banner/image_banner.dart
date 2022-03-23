class ImageBanner {
  List<String> _imgURLs;

  List<String> get imgURLs => _imgURLs;

  ImageBanner({List<String> imgURLs}) {
    _imgURLs = imgURLs;
  }

  ImageBanner.fromJson(dynamic json) {
    // print('json ${json.runtimeType}');
    _imgURLs = json["imgURLs"] != null ? json["imgURLs"].cast<String>() : [];
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map["imgURLs"] = _imgURLs;
    return map;
  }
}
