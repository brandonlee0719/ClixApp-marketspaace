import 'dart:io';

class SellItemReqModel {
  String _agreeMSPolicy;
  String _category;
  String _condition;
  String _description;
  String _desiredPaymentCurrency;
  String _desiredPaymentType;
  String _fiatPrice;
  List<File> _productImages;
  List<String> _productImgLinks;
  String _productTitle, _deliveryTime;
  String _productType;
  String _sellerHandlingTime;
  String _sellerUID;
  String _subCategory;
  List<String> _tags;
  String _freeShipping;
  String _packageWidth;
  String _packageHeight;
  String _packageLength;
  String _packageWeight;
  String _fileUploadLink;
  String _productKey;
  String _brandName;
  String _customBrandName;
  String _customBrandDescription;
  File _customBrandImg;
  String _customBrandImgLink;
  String _courierService;
  String _shippingMethod;
  String _estimatedShippingPrice;
  String _deliveryInformation;
  int _quantity;
  bool _isCustomBrand;
  String _language;
  String _fiatCurrency;
  String _thumbnailLink;

  // String _reqModel;
  // String _shippingPrice;
  //

  List<Variations> _variations;
  String _saleConditions;

  String get thumbnailLink => _thumbnailLink;
  List<String> get productImgLinks => _productImgLinks;
  String get language => _language;
  String get fiatCurrency => _fiatCurrency;
  String get customBrandImgLink => _customBrandImgLink;
  bool get isCustomBrand => _isCustomBrand;
  int get quantity => _quantity;
  String get shippingMethod => _shippingMethod;
  String get courierService => _courierService;
  String get agreeMSPolicy => _agreeMSPolicy;
  String get category => _category;
  String get condition => _condition;
  String get description => _description;
  String get desiredPaymentCurrency => _desiredPaymentCurrency;
  String get desiredPaymentType => _desiredPaymentType;
  String get fiatPrice => _fiatPrice;
  List<File> get productImages => _productImages;
  String get productTitle => _productTitle;
  String get productType => _productType;
  String get deliveryTime => _deliveryTime;
  String get sellerHandlingTime => _sellerHandlingTime;
  String get sellerUID => _sellerUID;
  String get subCategory => _subCategory;
  List<String> get tags => _tags;
  String get freeShipping => _freeShipping;
  String get packageWidth => _packageWidth;
  String get packageHeight => _packageHeight;
  String get packageLength => _packageLength;
  String get packageWeight => _packageWeight;
  String get fileUploadLink => _fileUploadLink;
  String get productKey => _productKey;
  String get brandName => _brandName;
  String get customBrandName => _customBrandName;
  String get customBrandDescription => _customBrandDescription;
  File get customBrandImg => _customBrandImg;
  List<Variations> get variations => _variations;
  String get saleConditions => _saleConditions;
  String get estimatedShippingPrice => _estimatedShippingPrice;
  String get deliveryInformation => _deliveryInformation;
  // String get shippingPrice => _shippingPrice;

  SellItemReqModel(
      {List<String> productImgLinks,
      String thumbnailLink,
      String customBrandImgLink,
      bool isCustomBrand,
      String agreeMSPolicy,
      String language,
      String fiatCurrency,
      // String shippingPrice,
      String shippingMethod,
      String courierService,
      String category,
      String condition,
      String description,
      String desiredPaymentCurrency,
      String desiredPaymentType,
      String fiatPrice,
      List<File> productImages,
      String productTitle,
      String deliveryTime,
      String productType,
      String sellerHandlingTime,
      String sellerUID,
      String subCategory,
      List<String> tags,
      String freeShipping,
      String packageWidth,
      String packageHeight,
      String packageLength,
      String packageWeight,
      String fileUploadLink,
      String productKey,
      String brandName,
      String customBrandName,
      String customBrandDescription,
      File customBrandImg,
      List<Variations> variations,
      String saleConditions,
      String estimatedShippingPrice,
      String deliveryInformation,
      int quantity}) {
    _thumbnailLink = thumbnailLink;
    _productImgLinks = productImgLinks;
    _fiatCurrency = fiatCurrency;
    _language = language;
    _customBrandImgLink = customBrandImgLink;
    _isCustomBrand = isCustomBrand;
    _quantity = quantity;
    _shippingMethod = shippingMethod;
    _courierService = courierService;
    _agreeMSPolicy = agreeMSPolicy;
    _category = category;
    _condition = condition;
    _description = description;
    _desiredPaymentCurrency = desiredPaymentCurrency;
    _desiredPaymentType = desiredPaymentType;
    _fiatPrice = fiatPrice;
    _deliveryTime = deliveryTime;
    _productImages = productImages;
    _productTitle = productTitle;
    _productType = productType;
    _sellerHandlingTime = sellerHandlingTime;
    _sellerUID = sellerUID;
    _subCategory = subCategory;
    _tags = tags;
    _freeShipping = freeShipping;
    _packageWidth = packageWidth;
    _packageHeight = packageHeight;
    _packageLength = packageLength;
    _packageWeight = packageWeight;
    _fileUploadLink = fileUploadLink;
    _productKey = productKey;
    _brandName = brandName;
    _customBrandName = customBrandName;
    _customBrandDescription = customBrandDescription;
    _customBrandImg = customBrandImg;
    _variations = variations;
    _saleConditions = saleConditions;
    _estimatedShippingPrice = estimatedShippingPrice;
    _deliveryInformation = deliveryInformation;
  }

  SellItemReqModel.fromJson(dynamic json) {
    // _shippingPrice = json["shippingPrice"];
    _thumbnailLink = json["thumbnailLink"];
    _productImgLinks = json["productImgLinks"];
    _fiatCurrency = json["fiatCurrency"];
    _language = json["language"];
    _customBrandImgLink = json["customBrandImgLink"];
    _isCustomBrand = json["isCustomBrand"];
    _quantity = json["quantity"];
    _shippingMethod = json["shippingMethod"];
    _courierService = json["courierService"];
    _agreeMSPolicy = json["agreeMSPolicy"];
    _category = json["category"];
    _condition = json["condition"];
    _deliveryTime = json["deliveryTime"];
    _description = json["description"];
    _desiredPaymentCurrency = json["desiredPaymentCurrency"];
    _desiredPaymentType = json["desiredPaymentType"];
    _fiatPrice = json["fiatPrice"];
    _productImages = json["productImages"] != null
        ? json["productImages"].cast<String>()
        : [];
    _productTitle = json["productTitle"];
    _productType = json["productType"];
    _sellerHandlingTime = json["sellerHandlingTime"];
    _sellerUID = json["sellerUID"];
    _subCategory = json["subCategory"];
    _tags = json["tags"] != null ? json["tags"].cast<String>() : [];
    _freeShipping = json["freeShipping"];
    _packageWidth = json["packageWidth"];
    _packageHeight = json["packageHeight"];
    _packageLength = json["packageLength"];
    _packageWeight = json["packageWeight"];
    _fileUploadLink = json["fileUploadLink"];
    _productKey = json["productKey"];
    _brandName = json["brandName"];
    _customBrandName = json["customBrandName"];
    _customBrandDescription = json["customBrandDescription"];
    _customBrandImg = json["customBrandImg"];
    if (json["variations"] != null) {
      _variations = [];
      json["variations"].forEach((v) {
        _variations.add(Variations.fromJson(v));
      });
    }
    _saleConditions = json["saleConditions"];
    _estimatedShippingPrice = json["estimatedShippingPrice"];
    _deliveryInformation = json["deliveryInformation"];
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    // map['shippingPrice'] = _shippingPrice;
    map["thumbnailLink"] = _thumbnailLink;
    map["productImgLinks"] = _productImgLinks;
    map["language"] = _language;
    map["fiatCurrency"] = _fiatCurrency;
    map["customBrandImgLink"] = _customBrandImgLink;
    map["isCustomBrand"] = _isCustomBrand;
    map["quantity"] = _quantity;
    map["shippingMethod"] = _shippingMethod;
    map["courierService"] = _courierService;
    map["deliveryTime"] = _deliveryTime;
    map["agreeMSPolicy"] = _agreeMSPolicy;
    map["category"] = _category;
    map["condition"] = _condition;
    map["description"] = _description;
    map["desiredPaymentCurrency"] = _desiredPaymentCurrency;
    map["desiredPaymentType"] = _desiredPaymentType;
    map["fiatPrice"] = _fiatPrice;
    map["productImages"] = _productImages;
    map["productTitle"] = _productTitle;
    map["productType"] = _productType;
    map["sellerHandlingTime"] = _sellerHandlingTime;
    map["sellerUID"] = _sellerUID;
    map["subCategory"] = _subCategory;
    map["tags"] = _tags;
    map["freeShipping"] = _freeShipping;
    map["packageWidth"] = _packageWidth;
    map["packageHeight"] = _packageHeight;
    map["packageLength"] = _packageLength;
    map["packageWeight"] = _packageWeight;
    map["fileUploadLink"] = _fileUploadLink;
    map["productKey"] = _productKey;
    map["brandName"] = _brandName;
    map["customBrandName"] = _customBrandName;
    map["customBrandDescription"] = _customBrandDescription;
    map["customBrandImg"] = _customBrandImg;
    if (_variations != null) {
      map["variations"] = _variations.map((v) => v.toJson()).toList();
    }
    map["estimatedShippingPrice"] = _estimatedShippingPrice;
    map["deliveryInformation"] = _deliveryInformation;
    map["saleConditions"] = _saleConditions;
    return map;
  }

  // set shippingPrice(String value) {
  //   _shippingPrice = value;
  // }
  //

  set thumbnailLink(String value) {
    _thumbnailLink = value;
  }

  set productImgLinks(List<String> value) {
    _productImgLinks = value;
  }

  set fiatCurrency(String value) {
    _fiatCurrency = value;
  }

  set language(String value) {
    _language = value;
  }

  set customBrandImgLink(String value) {
    _customBrandImgLink = value;
  }

  set isCustomBrand(bool value) {
    _isCustomBrand = value;
  }

  set quantity(int value) {
    _quantity = value;
  }

  set deliveryInformation(String value) {
    _deliveryInformation = value;
  }

  set estimatedShippingPrice(String value) {
    _estimatedShippingPrice = value;
  }

  set packageWeight(String value) {
    _packageWeight = value;
  }

  set shippingMethod(String value) {
    _shippingMethod = value;
  }

  set courierService(String value) {
    // print('this setter hit');
    _courierService = value;
    // print('good setter');
  }

  set agreeMSPolicy(String value) {
    _agreeMSPolicy = value;
  }

  set category(String value) {
    _category = value;
  }

  set condition(String value) {
    _condition = value;
  }

  set description(String value) {
    _description = value;
  }

  set desiredPaymentCurrency(String value) {
    _desiredPaymentCurrency = value;
  }

  set desiredPaymentType(String value) {
    _desiredPaymentType = value;
  }

  set fiatPrice(String value) {
    _fiatPrice = value;
  }

  set productImages(List<File> value) {
    _productImages = value;
  }

  set productTitle(String value) {
    _productTitle = value;
  }

  set deliveryTime(String value) {
    _deliveryTime = value;
  }

  set productType(String value) {
    _productType = value;
  }

  set sellerHandlingTime(String value) {
    _sellerHandlingTime = value;
  }

  set sellerUID(String value) {
    _sellerUID = value;
  }

  set subCategory(String value) {
    _subCategory = value;
  }

  set tags(List<String> value) {
    _tags = value;
  }

  set freeShipping(String value) {
    _freeShipping = value;
  }

  set packageWidth(String value) {
    _packageWidth = value;
  }

  set packageHeight(String value) {
    _packageHeight = value;
  }

  set packageLength(String value) {
    _packageLength = value;
  }

  set fileUploadLink(String value) {
    _fileUploadLink = value;
  }

  set productKey(String value) {
    _productKey = value;
  }

  set brandName(String value) {
    _brandName = value;
  }

  set customBrandName(String value) {
    _customBrandName = value;
  }

  set customBrandDescription(String value) {
    _customBrandDescription = value;
  }

  set customBrandImg(File value) {
    _customBrandImg = value;
  }

  set variations(List<Variations> value) {
    _variations = value;
  }

  set saleConditions(String value) {
    _saleConditions = value;
  }
}

class Variations {
  List<Variation> _variation;
  String _variator;

  set variation(List<Variation> value) {
    _variation = value;
  }

  List<Variation> get variation => _variation;
  String get variator => _variator;

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

  set quantity(int value) {
    _quantity = value;
  }

  String _variationLabel;

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
