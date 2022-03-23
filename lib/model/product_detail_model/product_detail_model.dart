class ProductDetailModel {
  String _brandDescription;
  String _brandImg;
  String _brandName;
  String _courierService;
  String _cryptoPrice;
  String _deliveryInformation;
  String _description;
  String _fiatPrice;
  String _likedItem;
  String _productImg;
  int _productNum;
  List<ProductReviews> _productReviews;
  String _productTitle;
  int _qtyAvail;
  List<RelatedItems> _relatedItems;
  String _saleConditions;
  SellerData _sellerData;
  String _sellerHandlingTime;
  String _shippingMethod;
  int _shippingPrice;
  List<String> _tags;
  int _totalPrice;

  String get brandDescription => _brandDescription;
  String get brandImg => _brandImg;
  String get brandName => _brandName;
  String get courierService => _courierService;
  String get cryptoPrice => _cryptoPrice;
  String get deliveryInformation => _deliveryInformation;
  String get description => _description;
  String get fiatPrice => _fiatPrice;
  String get likedItem => _likedItem;
  String get productImg => _productImg;
  int get productNum => _productNum;
  List<ProductReviews> get productReviews => _productReviews;
  String get productTitle => _productTitle;
  int get qtyAvail => _qtyAvail;
  List<RelatedItems> get relatedItems => _relatedItems;
  String get saleConditions => _saleConditions;
  SellerData get sellerData => _sellerData;
  String get sellerHandlingTime => _sellerHandlingTime;
  String get shippingMethod => _shippingMethod;
  int get shippingPrice => _shippingPrice;
  List<String> get tags => _tags;
  int get totalPrice => _totalPrice;

  ProductDetailModel(
      {String brandDescription,
      String brandImg,
      String brandName,
      String courierService,
      String cryptoPrice,
      String deliveryInformation,
      String description,
      String fiatPrice,
      String likedItem,
      String productImg,
      int productNum,
      List<ProductReviews> productReviews,
      String productTitle,
      int qtyAvail,
      List<RelatedItems> relatedItems,
      String saleConditions,
      SellerData sellerData,
      String sellerHandlingTime,
      String shippingMethod,
      int shippingPrice,
      List<String> tags,
      int totalPrice}) {
    _brandDescription = brandDescription;
    _brandImg = brandImg;
    _brandName = brandName;
    _courierService = courierService;
    _cryptoPrice = cryptoPrice;
    _deliveryInformation = deliveryInformation;
    _description = description;
    _fiatPrice = fiatPrice;
    _likedItem = likedItem;
    _productImg = productImg;
    _productNum = productNum;
    _productReviews = productReviews;
    _productTitle = productTitle;
    _qtyAvail = qtyAvail;
    _relatedItems = relatedItems;
    _saleConditions = saleConditions;
    _sellerData = sellerData;
    _sellerHandlingTime = sellerHandlingTime;
    _shippingMethod = shippingMethod;
    _shippingPrice = shippingPrice;
    _tags = tags;
    _totalPrice = totalPrice;
  }

  ProductDetailModel.fromJson(dynamic json) {
    _brandDescription = json["brandDescription"];
    _brandImg = json["brandImg"];
    _brandName = json["brandName"];
    _courierService = json["courierService"];
    _cryptoPrice = json["cryptoPrice"];
    _deliveryInformation = json["deliveryInformation"];
    _description = json["description"];
    _fiatPrice = json["fiatPrice"];
    _likedItem = json["likedItem"];
    _productImg = json["productImg"];
    _productNum = json["productNum"];
    if (json["productReviews"] != null) {
      _productReviews = [];
      json["productReviews"].forEach((v) {
        _productReviews.add(ProductReviews.fromJson(v));
      });
    }
    _productTitle = json["productTitle"];
    _qtyAvail = json["qtyAvail"];
    if (json["relatedItems"] != null) {
      _relatedItems = [];
      json["relatedItems"].forEach((v) {
        _relatedItems.add(RelatedItems.fromJson(v));
      });
    }
    _saleConditions = json["saleConditions"];
    _sellerData = json["sellerData"] != null
        ? SellerData.fromJson(json["sellerData"])
        : null;
    _sellerHandlingTime = json["sellerHandlingTime"];
    _shippingMethod = json["shippingMethod"];
    _shippingPrice = json["shippingPrice"];
    _tags = json["tags"] != null ? json["tags"].cast<String>() : [];
    _totalPrice = json["totalPrice"];
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map["brandDescription"] = _brandDescription;
    map["brandImg"] = _brandImg;
    map["brandName"] = _brandName;
    map["courierService"] = _courierService;
    map["cryptoPrice"] = _cryptoPrice;
    map["deliveryInformation"] = _deliveryInformation;
    map["description"] = _description;
    map["fiatPrice"] = _fiatPrice;
    map["likedItem"] = _likedItem;
    map["productImg"] = _productImg;
    map["productNum"] = _productNum;
    if (_productReviews != null) {
      map["productReviews"] = _productReviews.map((v) => v.toJson()).toList();
    }
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
    map["shippingMethod"] = _shippingMethod;
    map["shippingPrice"] = _shippingPrice;
    map["tags"] = _tags;
    map["totalPrice"] = _totalPrice;
    return map;
  }
}

class SellerData {
  int _numRaters;
  String _sellerBio;
  String _sellerDisplayName;
  String _sellerProfilePicURL;
  double _sellerRating;
  int _sellerVerificationStatus;

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
    _sellerRating = json["sellerRating"];
    _sellerVerificationStatus = json["sellerVerificationStatus"];
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
  String _cryptoPrice;
  String _fiatPrice;
  String _imgLink;
  String _likedItem;
  int _productNum;
  List<String> _tags;
  String _title;

  String get cryptoPrice => _cryptoPrice;
  String get fiatPrice => _fiatPrice;
  String get imgLink => _imgLink;
  String get likedItem => _likedItem;
  int get productNum => _productNum;
  List<String> get tags => _tags;
  String get title => _title;

  RelatedItems(
      {String cryptoPrice,
      String fiatPrice,
      String imgLink,
      String likedItem,
      int productNum,
      List<String> tags,
      String title}) {
    _cryptoPrice = cryptoPrice;
    _fiatPrice = fiatPrice;
    _imgLink = imgLink;
    _likedItem = likedItem;
    _productNum = productNum;
    _tags = tags;
    _title = title;
  }

  RelatedItems.fromJson(dynamic json) {
    _cryptoPrice = json["cryptoPrice"];
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
}

/*class ProductDetailModel {
  String _cryptoPrice;
  String _fiatPrice;
  String _likedItem;
  String _productImg;
  int _productNum;
  List<ProductReviews> _productReviews;
  String _productTitle;
  List<RelatedItems> _relatedItems;
  SellerData _sellerData;
  List<String> _tags;

  String get cryptoPrice => _cryptoPrice;
  String get fiatPrice => _fiatPrice;
  String get likedItem => _likedItem;
  String get productImg => _productImg;
  int get productNum => _productNum;
  List<ProductReviews> get productReviews => _productReviews;
  String get productTitle => _productTitle;
  List<RelatedItems> get relatedItems => _relatedItems;
  SellerData get sellerData => _sellerData;
  List<String> get tags => _tags;

  ProductDetailModel({
      String cryptoPrice, 
      String fiatPrice, 
      String likedItem, 
      String productImg, 
      int productNum, 
      List<ProductReviews> productReviews, 
      String productTitle, 
      List<RelatedItems> relatedItems, 
      SellerData sellerData, 
      List<String> tags}){
    _cryptoPrice = cryptoPrice;
    _fiatPrice = fiatPrice;
    _likedItem = likedItem;
    _productImg = productImg;
    _productNum = productNum;
    _productReviews = productReviews;
    _productTitle = productTitle;
    _relatedItems = relatedItems;
    _sellerData = sellerData;
    _tags = tags;
}

  ProductDetailModel.fromJson(dynamic json) {
    _cryptoPrice = json["cryptoPrice"];
    _fiatPrice = json["fiatPrice"];
    _likedItem = json["likedItem"];
    _productImg = json["productImg"];
    _productNum = json["productNum"];
    if (json["productReviews"] != null) {
      _productReviews = [];
      json["productReviews"].forEach((v) {
        _productReviews.add(ProductReviews.fromJson(v));
      });
    }
    _productTitle = json["productTitle"];
    if (json["relatedItems"] != null) {
      _relatedItems = [];
      json["relatedItems"].forEach((v) {
        _relatedItems.add(RelatedItems.fromJson(v));
      });
    }
    _sellerData = json["sellerData"] != null ? SellerData.fromJson(json["sellerData"]) : null;
    _tags = json["tags"] != null ? json["tags"].cast<String>() : [];
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map["cryptoPrice"] = _cryptoPrice;
    map["fiatPrice"] = _fiatPrice;
    map["likedItem"] = _likedItem;
    map["productImg"] = _productImg;
    map["productNum"] = _productNum;
    if (_productReviews != null) {
      map["productReviews"] = _productReviews.map((v) => v.toJson()).toList();
    }
    map["productTitle"] = _productTitle;
    if (_relatedItems != null) {
      map["relatedItems"] = _relatedItems.map((v) => v.toJson()).toList();
    }
    if (_sellerData != null) {
      map["sellerData"] = _sellerData.toJson();
    }
    map["tags"] = _tags;
    return map;
  }

}

class SellerData {
  int _numRaters;
  String _sellerBio;
  String _sellerDisplayName;
  String _sellerProfilePicURL;
  double _sellerRating;
  int _sellerVerificationStatus;

  int get numRaters => _numRaters;
  String get sellerBio => _sellerBio;
  String get sellerDisplayName => _sellerDisplayName;
  String get sellerProfilePicURL => _sellerProfilePicURL;
  double get sellerRating => _sellerRating;
  int get sellerVerificationStatus => _sellerVerificationStatus;

  SellerData({
      int numRaters, 
      String sellerBio, 
      String sellerDisplayName, 
      String sellerProfilePicURL, 
      double sellerRating, 
      int sellerVerificationStatus}){
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
    _sellerRating = json["sellerRating"];
    _sellerVerificationStatus = json["sellerVerificationStatus"];
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
  String _cryptoPrice;
  String _fiatPrice;
  String _imgLink;
  String _likedItem;
  int _productNum;
  List<String> _tags;
  String _title;

  String get cryptoPrice => _cryptoPrice;
  String get fiatPrice => _fiatPrice;
  String get imgLink => _imgLink;
  String get likedItem => _likedItem;
  int get productNum => _productNum;
  List<String> get tags => _tags;
  String get title => _title;

  RelatedItems({
      String cryptoPrice, 
      String fiatPrice, 
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
    _cryptoPrice = json["cryptoPrice"];
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

}*/

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
