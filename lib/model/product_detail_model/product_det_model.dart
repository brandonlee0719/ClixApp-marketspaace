class ProductDetModel {
  String _brandDescription;
  String _chineseBrandDescription;

  String get chineseBrandDescription => _chineseBrandDescription;

  set chineseBrandDescription(String value) {
    _chineseBrandDescription = value;
  }

  String _brandImg;
  String _brandName;
  String _courierService;
  String _cryptoPrice;
  String _deliveryInformation;
  String _chineseDeliveryInformation;
  String _category;

  String get category => _category;

  set category(String value) {
    _category = value;
  }

  String get chineseDeliveryInformation => _chineseDeliveryInformation;

  set chineseDeliveryInformation(String value) {
    _chineseDeliveryInformation = value;
  }

  String _description;
  String _chineseDescription;

  String get chineseDescription => _chineseDescription;

  set chineseDescription(String value) {
    _chineseDescription = value;
  }

  double _fiatPrice;
  String _chineseProductTitle;

  String get chineseProductTitle => _chineseProductTitle;

  set chineseProductTitle(String value) {
    _chineseProductTitle = value;
  } // double _likedItem;

  List<String> _productImages;
  int _productNum;
  // List<ProductReviews> _productReviews;
  String _productTitle;
  int _qtyAvail;
  List<RelatedItems> _relatedItems;
  String _saleConditions;
  String _chineseSaleConditions;

  String get chineseSaleConditions => _chineseSaleConditions;

  set chineseSaleConditions(String value) {
    _chineseSaleConditions = value;
  }

  SellerData _sellerData;
  String _sellerHandlingTime;
  String _chineseSellerHandlingTime;

  String get chineseSellerHandlingTime => _chineseSellerHandlingTime;

  set chineseSellerHandlingTime(String value) {
    _chineseSellerHandlingTime = value;
  }

  String _shippingMethod;
  int _shippingPrice;
  List<String> _tags;
  List<String> _chineseTags;

  List<String> get chineseTags => _chineseTags;

  set chineseTags(List<String> value) {
    _chineseTags = value;
  }

  double _totalPrice;
  List<Variations> _variations;
  List<Variations> _chineseVariations;

  List<Variations> get chineseVariations => _chineseVariations;

  set chineseVariations(List<Variations> value) {
    _chineseVariations = value;
  }

  String _freeShipping;
  String _shippingTime;
  String _deliveryTime;

  String get shippingTime => _shippingTime;
  String get deliveryTime => _deliveryTime;

  set shippingTime(String value) {
    _shippingTime = value;
  }

  set deliveryTime(String val) => _deliveryTime = val;

  String get freeShipping => _freeShipping;

  String get brandDescription => _brandDescription;
  String get brandImg => _brandImg;
  String get brandName => _brandName;
  String get courierService => _courierService;
  String get cryptoPrice => _cryptoPrice;
  String get deliveryInformation => _deliveryInformation;
  String get description => _description;
  double get fiatPrice => _fiatPrice;
  // double get likedItem => _likedItem;
  List<String> get productImages => _productImages;
  int get productNum => _productNum;
  // List<ProductReviews> get productReviews => _productReviews;
  String get productTitle => _productTitle;
  int get qtyAvail => _qtyAvail;
  List<RelatedItems> get relatedItems => _relatedItems;
  String get saleConditions => _saleConditions;
  SellerData get sellerData => _sellerData;
  String get sellerHandlingTime => _sellerHandlingTime;
  String get shippingMethod => _shippingMethod;
  int get shippingPrice => _shippingPrice;
  List<String> get tags => _tags;
  double get totalPrice => _totalPrice;
  List<Variations> get variations => _variations;

  ProductDetModel(
      {String brandDescription,
      String chineseBrandDescription,
      String brandImg,
      String brandName,
      String courierService,
      String cryptoPrice,
      String deliveryInformation,
      String chineseDeliveryInformation,
      String description,
      String chineseDescription,
      double fiatPrice,
      // double likedItem,
      List<String> productImages,
      int productNum,
      List<ProductReviews> productReviews,
      String productTitle,
      int qtyAvail,
      List<RelatedItems> relatedItems,
      String saleConditions,
      String chineseSaleConditions,
      SellerData sellerData,
      String sellerHandlingTime,
      String chineseSellerHandlingTime,
      String shippingMethod,
      String shippingTime,
      String deliveryTime,
      int shippingPrice,
      List<String> tags,
      List<String> chineseTags,
      int totalPrice,
      String chineseProductTitle,
      List<Variations> variations,
      List<Variations> chineseVariations,
      String category,
      String freeShipping}) {
    _brandDescription = brandDescription;
    _chineseBrandDescription = chineseBrandDescription;
    _brandImg = brandImg;
    _brandName = brandName;
    _courierService = courierService;
    _cryptoPrice = cryptoPrice;
    _deliveryInformation = deliveryInformation;
    _chineseDeliveryInformation = chineseDeliveryInformation;
    _description = description;
    _chineseDescription = chineseDescription;
    _fiatPrice = fiatPrice;
    // _likedItem = likedItem;
    _productImages = productImages;
    _productNum = productNum;
    // _productReviews = productReviews;
    _productTitle = productTitle;
    _qtyAvail = qtyAvail;
    _relatedItems = relatedItems;
    _saleConditions = saleConditions;
    _chineseSaleConditions = chineseSaleConditions;
    _sellerData = sellerData;
    _sellerHandlingTime = sellerHandlingTime;
    _chineseSellerHandlingTime = chineseSellerHandlingTime;
    _shippingMethod = shippingMethod;
    _shippingPrice = shippingPrice;
    _tags = tags;
    _chineseTags = chineseTags;
    _totalPrice = totalPrice.toDouble();
    _variations = variations;
    _freeShipping = freeShipping;
    _chineseProductTitle = chineseProductTitle;
    _chineseVariations = chineseVariations;
    _category = category;
    _shippingTime = shippingTime;
    _deliveryTime = deliveryTime;
  }

  ProductDetModel.fromJson(dynamic json) {
    // print(json);
    try {
      _brandDescription = json["brandDescription"];
      _chineseBrandDescription = json["chineseBrandDescription"];
      _brandImg = json["brandImg"];
      _brandName = json["brandName"];
      _courierService = json["courierService"];
      _cryptoPrice = json["cryptoPrice"];
      _deliveryInformation = json["deliveryInformation"];
      _chineseDeliveryInformation = json["chineseDeliveryInformation"];
      _description = json["description"];
      _chineseDescription = json["chineseDescription"];
      _fiatPrice = json["fiatPrice"].toDouble();
      // _likedItem = json["likedItem"];
      _productImages = json["productImages"] != null
          ? json["productImages"].cast<String>()
          : [];
      _productNum = json["productNum"];
      _freeShipping = json["freeShipping"];
      _chineseProductTitle = json["chineseProductTitle"];
      _category = json["category"];
      _shippingTime = json["shippingTime"];

      _deliveryTime = json["deliveryTime"];

      // if (json["productReviews"] != null) {
      //   _productReviews = [];
      //   json["productReviews"].forEach((v) {
      //     _productReviews.add(ProductReviews.fromJson(v));
      //   });
      // }
      _productTitle = json["productTitle"];
      _qtyAvail = json["qtyAvail"];
      if (json["relatedItems"] != null) {
        _relatedItems = [];
        json["relatedItems"].forEach((v) {
          _relatedItems.add(RelatedItems.fromJson(v));
        });
      }
      _saleConditions = json["saleConditions"];
      _chineseSaleConditions = json["chineseSaleConditions"];
      _sellerData = json["sellerData"] != null
          ? SellerData.fromJson(json["sellerData"])
          : null;
      _sellerHandlingTime = json["sellerHandlingTime"];
      _chineseSellerHandlingTime = json["chineseSellerHandlingTime"];
      _shippingMethod = json["shippingMethod"];
      _shippingPrice = json["shippingPrice"];
      _tags = json["tags"] != null ? json["tags"].cast<String>() : [];
      _chineseTags =
          json["chineseTags"] != null ? json["chineseTags"].cast<String>() : [];
      _totalPrice = json["totalPrice"].toDouble();
      _category = json["category"];
      if (json["variations"] != null) {
        _variations = [];
        json["variations"].forEach((v) {
          _variations.add(Variations.fromJson(v));
        });
      }
      if (json["chineseVariations"] != null) {
        _chineseVariations = [];
        json["chineseVariations"].forEach((v) {
          _chineseVariations.add(Variations.fromJson(v));
        });
      }
    } on Exception catch (e) {
      // print(e.toString());
    }
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map["brandDescription"] = _brandDescription;
    map["chineseBrandDescription"] = _chineseBrandDescription;
    map["brandImg"] = _brandImg;
    map["brandName"] = _brandName;
    map["courierService"] = _courierService;
    map["cryptoPrice"] = _cryptoPrice;
    map["deliveryInformation"] = _deliveryInformation;
    map["description"] = _description;
    map["chineseDeliveryInformation"] = _chineseDeliveryInformation;
    map["chineseDescription"] = _chineseDescription;
    map["fiatPrice"] = _fiatPrice.toDouble();
    // map["likedItem"] = _likedItem;
    map["productImages"] = _productImages;
    map["productNum"] = _productNum;
    map["chineseProductTitle"] = _chineseProductTitle;
    map["chineseTags"] = _chineseTags;
    // if (_productReviews != null) {
    //   map["productReviews"] = _productReviews.map((v) => v.toJson()).toList();
    // }
    map["productTitle"] = _productTitle;
    map["qtyAvail"] = _qtyAvail;
    if (_relatedItems != null) {
      map["relatedItems"] = _relatedItems.map((v) => v.toJson()).toList();
    }
    map["saleConditions"] = _saleConditions;
    if (_sellerData != null) {
      map["sellerData"] = _sellerData.toJson();
    }
    map["sellerHandlingTime"] = _sellerHandlingTime;
    map["chineseSellerHandlingTime"] = _chineseSellerHandlingTime;
    map["shippingMethod"] = _shippingMethod;
    map["shippingPrice"] = _shippingPrice;
    map["shippingTime"] = _shippingTime;
    map["deliveryTime"] = _deliveryTime;
    map["tags"] = _tags;
    map["totalPrice"] = _totalPrice;
    map["freeShipping"] = _freeShipping;
    if (_variations != null) {
      map["variations"] = _variations.map((v) => v.toJson()).toList();
    }
    return map;
  }
}

class Variations {
  List<Variation> _variation;
  String _variator;

  List<Variation> get variation => _variation;
  String get variator => _variator;

  set variation(List<Variation> value) {
    _variation = value;
  }

  Variations({List<Variation> variation, String variator}) {
    _variation = variation;
    _variator = variator;
  }

  Variations.fromJson(dynamic json) {
    if (json["variation"] != null) {
      _variation = [];
      json["variation"].forEach((v) {
        _variation.add(Variation.fromJson(v));
      });
    }
    _variator = json["variator"];
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    if (_variation != null) {
      map["variation"] = _variation.map((v) => v.toJson()).toList();
    }
    map["variator"] = _variator;
    return map;
  }

  set variator(String value) {
    _variator = value;
  }
}

class Variation {
  int _quantity;
  String _variationLabel;

  set quantity(int value) {
    _quantity = value;
  }

  int get quantity => _quantity;
  String get variationLabel => _variationLabel;

  Variation({int quantity, String variationLabel}) {
    _quantity = quantity;
    _variationLabel = variationLabel;
  }

  Variation.fromJson(dynamic json) {
    _quantity = json["quantity"];
    _variationLabel = json["variationLabel"];
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map["quantity"] = _quantity;
    map["variationLabel"] = _variationLabel;
    return map;
  }

  set variationLabel(String value) {
    _variationLabel = value;
  }
}

class SellerData {
  int _numRaters;
  String _sellerBio;
  String _sellerDisplayName;
  String _sellerProfilePicURL;
  double _sellerRating;
  int _sellerVerificationStatus;
  String uid;

  int get numRaters => _numRaters;
  String get sellerBio => _sellerBio;
  String get sellerDisplayName => _sellerDisplayName;
  String get sellerProfilePicURL => _sellerProfilePicURL;
  double get sellerRating => _sellerRating;
  int get sellerVerificationStatus => _sellerVerificationStatus;

  SellerData(
      {int numRaters,
      String sellerBio,
      String sellerDisplayName,
      String sellerProfilePicURL,
      double sellerRating,
      int sellerVerificationStatus}) {
    _numRaters = numRaters;
    _sellerBio = sellerBio;
    _sellerDisplayName = sellerDisplayName;
    _sellerProfilePicURL = sellerProfilePicURL;
    _sellerRating = sellerRating;
    _sellerVerificationStatus = sellerVerificationStatus;
  }

  SellerData.fromJson(dynamic json) {
    _numRaters = json["numRaters"];
    _sellerBio = json["sellerBio"];
    _sellerDisplayName = json["sellerDisplayName"];
    _sellerProfilePicURL = json["sellerProfilePicURL"];
    _sellerRating = json["sellerRating"].toDouble();
    _sellerVerificationStatus = json["sellerVerificationStatus"];
    uid = json["sellerUID"];
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map["numRaters"] = _numRaters;
    map["sellerBio"] = _sellerBio;
    map["sellerDisplayName"] = _sellerDisplayName;
    map["sellerProfilePicURL"] = _sellerProfilePicURL;
    map["sellerRating"] = _sellerRating;
    map["sellerVerificationStatus"] = _sellerVerificationStatus;

    return map;
  }
}

class RelatedItems {
  String _category;
  // String _cryptoPrice;
  String _imgURL;
  // String _likedItem;
  double _price;
  String _productName;
  String _chineseTitle;
  int _productNum;
  String _description;
  String _fiatCurrency;

  String get fiatCurrency => _fiatCurrency;

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
  // String get likedItem => _likedItem;
  double get price => _price;
  String get productName => _productName;
  int get productNum => _productNum;
  // int get promoNum => _promoNum;
  String get description => _description;

  RelatedItems(
      {String category,
      String cryptoPrice,
      String imgURL,
      String likedItem,
      double price,
      String productName,
      String chineseTitle,
      int productNum,
      String description,
      int promoNum,
      String fiatCurrency,
      List<dynamic> tags}) {
    _category = category;
    // _cryptoPrice = cryptoPrice;
    _imgURL = imgURL;
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

  RelatedItems.fromJson(dynamic json) {
    _category = json["category"];
    // _cryptoPrice = json["cryptoPrice"];
    _imgURL = json["imgLink"];
    // _likedItem = json["likedItem"];
    _price = json["fiatPrice"].toDouble();
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
    // map["likedItem"] = _likedItem;
    map["fiatPrice"] = _price.toDouble();
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

  /*String _cryptoPrice;
  double _fiatPrice;
  String _imgLink;
  String _likedItem;
  int _productNum;
  List<String> _tags;
  String _title;

  String get cryptoPrice => _cryptoPrice;
  double get fiatPrice => _fiatPrice;
  String get imgLink => _imgLink;
  String get likedItem => _likedItem;
  int get productNum => _productNum;
  List<String> get tags => _tags;
  String get title => _title;

  RelatedItems({
      String cryptoPrice, 
      double fiatPrice,
      String imgLink, 
      String likedItem, 
      int productNum, 
      List<String> tags, 
      String title}){
    _cryptoPrice = cryptoPrice;
    _fiatPrice = fiatPrice;
    _imgLink = imgLink;
    _likedItem = likedItem;
    _productNum = productNum;
    _tags = tags;
    _title = title;
}

  RelatedItems.fromJson(dynamic json) {
    // _cryptoPrice = json["cryptoPrice"];
    _fiatPrice = json["fiatPrice"];
    _imgLink = json["imgLink"];
    _likedItem = json["likedItem"];
    _productNum = json["productNum"];
    _tags = json["tags"] != null ? json["tags"].cast<String>() : [];
    _title = json["title"];
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map["cryptoPrice"] = _cryptoPrice;
    map["fiatPrice"] = _fiatPrice;
    map["imgLink"] = _imgLink;
    map["likedItem"] = _likedItem;
    map["productNum"] = _productNum;
    map["tags"] = _tags;
    map["title"] = _title;
    return map;
  }
*/
}

class ProductReviews {
  String _buyerComment;
  String _buyerDisplayName;
  int _buyerRating;

  String get buyerComment => _buyerComment;
  String get buyerDisplayName => _buyerDisplayName;
  int get buyerRating => _buyerRating;

  ProductReviews(
      {String buyerComment, String buyerDisplayName, int buyerRating}) {
    _buyerComment = buyerComment;
    _buyerDisplayName = buyerDisplayName;
    _buyerRating = buyerRating;
  }

  ProductReviews.fromJson(dynamic json) {
    _buyerComment = json["buyerComment"];
    _buyerDisplayName = json["buyerDisplayName"];
    _buyerRating = json["buyerRating"];
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map["buyerComment"] = _buyerComment;
    map["buyerDisplayName"] = _buyerDisplayName;
    map["buyerRating"] = _buyerRating;
    return map;
  }
}
