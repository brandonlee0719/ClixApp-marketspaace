import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';

class ImageSize {
  final double length;

  // final width;

  ImageSize(this.length);
}

class FlashPromoAlgolia {
  List<FlashPromoAlgoliaObj> _flashPromo;

  List<FlashPromoAlgoliaObj> get flashPromo => _flashPromo;

  FlashPromoAlgolia({List<FlashPromoAlgoliaObj> flashPromo}) {
    _flashPromo = flashPromo;
  }

  FlashPromoAlgolia.fromJson(dynamic json) {
    if (json["flashPromo"] != null) {
      _flashPromo = [];
      json["flashPromo"].forEach((v) {
        _flashPromo.add(FlashPromoAlgoliaObj.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    if (_flashPromo != null) {
      map["flashPromo"] = _flashPromo.map((v) => v.toJson()).toList();
    }
    return map;
  }
}

class FlashPromoAlgoliaObj {
  String _category;

  // String _cryptoPrice;
  String _imgURL;
  String _thumbnailURL;

  // String _likedItem;
  double _price;
  String _productName;
  String _chineseTitle;
  ImageSize size;
  Image image;
  bool liked = false;

  set category(String value) {
    _category = value;
  }

  int _productNum;
  String _description;
  String _fiatCurrency;

  String get fiatCurrency => _fiatCurrency;

  // Future<void> calculateSize() async {
  //   // print("ImageUrl : $_imgURL");
  //   image = Image(image: CachedNetworkImageProvider(_imgURL));
  //   await image.image
  //       .resolve(ImageConfiguration())
  //       .addListener(ImageStreamListener(
  //     (ImageInfo image, bool synchronousCall) {
  //       var myImage = image.image;
  //       size = ImageSize(
  //           (myImage.height.toDouble() / myImage.width.toDouble() + 0.4) * 2);
  //     },
  //   ));
  // }

  Future<ImageSize> calculateImageDimension() async {
    Completer<ImageSize> completer = Completer();
    image = new Image(
        image:
            CachedNetworkImageProvider(_thumbnailURL)); // I modified this line
    image.image.resolve(ImageConfiguration()).addListener(
      ImageStreamListener(
        (ImageInfo image, bool synchronousCall) {
          var myImage = image.image;
          ImageSize newSize = ImageSize(
              (myImage.height.toDouble() / myImage.width.toDouble() + 0.4) * 2);
          try {
            completer.complete(newSize);
          } catch (e) {
            // print(e);
          }
        },
      ),
    );
    return completer.future;
  }

  set fiatCurrency(String value) {
    _fiatCurrency = value;
  }

  List<dynamic> _tags;

  String get chineseTitle => _chineseTitle;

  set chineseTitle(String value) {
    _chineseTitle = value;
  }

  set description(String value) {
    _description = value;
  } // int _promoNum;

  String get category => _category;

  // String get cryptoPrice => _cryptoPrice;
  String get imgURL => _imgURL;

  String get thumbnailURL => _thumbnailURL;

  // String get likedItem => _likedItem;
  double get price => _price;

  String get productName => _productName;

  int get productNum => _productNum;

  // int get promoNum => _promoNum;
  String get description => _description;

  FlashPromoAlgoliaObj(
      {String category,
      String cryptoPrice,
      String imgURL,
      String thumbnailURL,
      String likedItem,
      double price,
      String productName,
      String chineseTitle,
      int productNum,
      String description,
      int promoNum,
      String fiatCurrency,
      bool liked,
      List<dynamic> tags}) {
    _category = category;
    // _cryptoPrice = cryptoPrice;
    _imgURL = imgURL;
    _thumbnailURL = thumbnailURL;
    // _likedItem = likedItem;
    _price = price;
    _productName = productName;
    _chineseTitle = chineseTitle;
    _productNum = productNum;
    _description = description;
    _fiatCurrency = fiatCurrency;
    _tags = tags;
    // _promoNum = promoNum;
  }

  FlashPromoAlgoliaObj.fromJson(dynamic json) {
    _category = json["category"];
    // _cryptoPrice = json["cryptoPrice"];
    _imgURL = json["imgLink"];
    _thumbnailURL = (json.containsKey("thumbnailLink"))
        ? json["thumbnailLink"]
        : json["imgLink"];
    // print('thumbnail url ${_thumbnailURL}');
    // _likedItem = json["likedItem"];
    if (json["fiatPrice"] == null) {
      _price = 3000.0;
    } else {
      _price = json["fiatPrice"].toDouble();
    }
    _productName = json["productTitle"];
    _chineseTitle = json["chineseProductTitle"];
    _productNum = json["productNum"];
    _description = json["description"];
    _fiatCurrency = json["fiatCurrency"];
    _tags = json["tags"];
    // _promoNum = json["promoNum"];
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map["category"] = _category;
    // map["cryptoPrice"] = _cryptoPrice;
    map["imgLink"] = _imgURL;
    map["thumbnailURL"] = _thumbnailURL;
    // map["likedItem"] = _likedItem;
    map["fiatPrice"] = _price;
    map["productTitle"] = _productName;
    map["chineseProductTitle"] = _chineseTitle;
    map["productNum"] = _productNum;
    map["description"] = _description;
    map["fiatCurrency"] = _fiatCurrency;
    if (_tags != null) {
      map["tags"] = _tags;
    }
    // map["promoNum"] = _promoNum;
    return map;
  }

  List<dynamic> get tags => _tags;

  set tags(List<dynamic> value) {
    _tags = value;
  }

  set imgURL(String value) {
    _imgURL = value;
  }

  set thumbnailURL(String value) {
    // print('here');
    _thumbnailURL = value;
  }

  set price(double value) {
    _price = value;
  }

  set productName(String value) {
    _productName = value;
  }

  set productNum(int value) {
    _productNum = value;
  }
}

class Tags {
  List<String> _tags;

  Tags({List<String> tags}) {
    _tags = tags;
  }

  Tags.fromJson(dynamic json) {
    _tags = json["tags"] != null ? json["tags"].cast<String>() : [];
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map["tags"] = _tags;
    return map;
  }
}
