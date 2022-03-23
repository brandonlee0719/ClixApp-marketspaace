class BuyerOptions {
  ClaimOptions _claimOptions;
  List<Order_overview> _orderOverview;
  double _orderTotal;
  PaymentMethod _paymentMethod;
  ShippingAddress _shippingAddress;
  List<OrderedWith> _orderedWith;

  ClaimOptions get claimOptions => _claimOptions;

  List<Order_overview> get orderOverview => _orderOverview;

  double get orderTotal => _orderTotal;

  PaymentMethod get paymentMethod => _paymentMethod;

  ShippingAddress get shippingAddress => _shippingAddress;

  List<OrderedWith> get orderedWith => _orderedWith;

  BuyerOptions(
      {ClaimOptions claimOptions,
      List<Order_overview> orderOverview,
      double orderTotal,
      List<OrderedWith> orderedWith,
      PaymentMethod paymentMethod,
      ShippingAddress shippingAddress}) {
    _claimOptions = claimOptions;
    _orderOverview = orderOverview;
    _orderTotal = orderTotal;
    _paymentMethod = paymentMethod;
    _shippingAddress = shippingAddress;
    _orderedWith = orderedWith;
  }

  BuyerOptions.fromJson(dynamic json) {
    _claimOptions = json["claimOptions"] != null
        ? ClaimOptions.fromJson(json["claimOptions"])
        : null;
    if (json["order_overview"] != null) {
      _orderOverview = [];
      json["order_overview"].forEach((v) {
        _orderOverview.add(Order_overview.fromJson(v));
      });
    }
    _orderTotal = json["order_total"];
    if (json["orderedWith"] != null) {
      _orderedWith = [];
      json["orderedWith"].forEach((v) {
        _orderedWith.add(OrderedWith.fromJson(v));
      });
    }

    _paymentMethod = json["paymentMethod"] != null
        ? PaymentMethod.fromJson(json["paymentMethod"])
        : null;
    _shippingAddress = json["shippingAddress"] != null
        ? ShippingAddress.fromJson(json["shippingAddress"])
        : null;
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    if (_claimOptions != null) {
      map["claimOptions"] = _claimOptions.toJson();
    }
    if (_orderOverview != null) {
      map["order_overview"] = _orderOverview.map((v) => v.toJson()).toList();
    }
    map["order_total"] = _orderTotal;
    if (_paymentMethod != null) {
      map["paymentMethod"] = _paymentMethod.toJson();
    }
    if (_shippingAddress != null) {
      map["shippingAddress"] = _shippingAddress.toJson();
    }
    return map;
  }
}

class ShippingAddress {
  String _country;
  String _firstName;
  String _lastName;
  String _postcode;
  String _state;
  String _streetAddress;
  String _suburb;

  String get country => _country;

  String get firstName => _firstName;

  String get lastName => _lastName;

  String get postcode => _postcode;

  String get state => _state;

  String get streetAddress => _streetAddress;

  String get suburb => _suburb;

  ShippingAddress(
      {String country,
      String firstName,
      String lastName,
      String postcode,
      String state,
      String streetAddress,
      String suburb}) {
    _country = country;
    _firstName = firstName;
    _lastName = lastName;
    _postcode = postcode;
    _state = state;
    _streetAddress = streetAddress;
    _suburb = suburb;
  }

  ShippingAddress.fromJson(dynamic json) {
    _country = json["country"];
    _firstName = json["firstName"];
    _lastName = json["lastName"];
    _postcode = json["postcode"];
    _state = json["state"];
    _streetAddress = json["streetAddress"];
    _suburb = json["suburb"];
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map["country"] = _country;
    map["firstName"] = _firstName;
    map["lastName"] = _lastName;
    map["postcode"] = _postcode;
    map["state"] = _state;
    map["streetAddress"] = _streetAddress;
    map["suburb"] = _suburb;
    return map;
  }
}

class PaymentMethod {
  String _cardFirstName;
  String _cardLastName;
  String _cardType;
  String _expiryMonth;
  String _expiryYear;
  String _lastDigits;
  String _paymentType;

  String get cardFirstName => _cardFirstName;

  String get cardLastName => _cardLastName;

  String get cardType => _cardType;

  String get expiryMonth => _expiryMonth;

  String get expiryYear => _expiryYear;

  String get lastDigits => _lastDigits;

  String get paymentType => _paymentType;

  PaymentMethod(
      {String cardFirstName,
      String cardLastName,
      String cardType,
      String expiryMonth,
      String expiryYear,
      String lastDigits,
      String paymentType}) {
    _cardFirstName = cardFirstName;
    _cardLastName = cardLastName;
    _cardType = cardType;
    _expiryMonth = expiryMonth;
    _expiryYear = expiryYear;
    _lastDigits = lastDigits;
    _paymentType = paymentType;
  }

  PaymentMethod.fromJson(dynamic json) {
    _paymentType = json['paymentType'];
    if (_paymentType == 'WALLET') {
    } else {
      _cardFirstName = json["cardFirstName"];
      _cardLastName = json["cardLastName"];
      _cardType = json["cardType"];
      _expiryMonth = json["expiryMonth"];
      _expiryYear = json["expiryYear"];
      _lastDigits = json["lastDigits"];
    }
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map["cardFirstName"] = _cardFirstName;
    map["cardLastName"] = _cardLastName;
    map["cardType"] = _cardType;
    map["expiryMonth"] = _expiryMonth;
    map["expiryYear"] = _expiryYear;
    map["lastDigits"] = _lastDigits;
    map["paymentType"] = _paymentType;
    return map;
  }
}

class Order_overview {
  String _price;
  String _shippingMethod;
  int _shippingPrice;
  String _title;

  String get price => _price;

  String get shippingMethod => _shippingMethod;

  int get shippingPrice => _shippingPrice;

  String get title => _title;

  Order_overview(
      {String price, String shippingMethod, int shippingPrice, String title}) {
    _price = price;
    _shippingMethod = shippingMethod;
    _shippingPrice = shippingPrice;
    _title = title;
  }

  Order_overview.fromJson(dynamic json) {
    _price = json["price"];
    _shippingMethod = json["shippingMethod"];
    _shippingPrice = json["shippingPrice"];
    _title = json["title"];
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map["price"] = _price;
    map["shippingMethod"] = _shippingMethod;
    map["shippingPrice"] = _shippingPrice;
    map["title"] = _title;
    return map;
  }
}

class ClaimOptions {
  String _buyerFeedbackComment;
  int _buyerFeedbackStars;
  String _buyerLeaveFeedback;
  String _cancellationAvailable;
  String _claimAvailable;
  String _extensionAvailable;
  String _purchaseProtectionTime;

  String get buyerFeedbackComment => _buyerFeedbackComment;

  int get buyerFeedbackStars => _buyerFeedbackStars;

  String get buyerLeaveFeedback => _buyerLeaveFeedback;

  String get cancellationAvailable => _cancellationAvailable;

  String get claimAvailable => _claimAvailable;

  String get extensionAvailable => _extensionAvailable;

  String get purchaseProtectionTime => _purchaseProtectionTime;

  ClaimOptions(
      {String buyerFeedbackComment,
      int buyerFeedbackStars,
      String buyerLeaveFeedback,
      String cancellationAvailable,
      String claimAvailable,
      String extensionAvailable,
      String purchaseProtectionTime}) {
    _buyerFeedbackComment = buyerFeedbackComment;
    _buyerFeedbackStars = buyerFeedbackStars;
    _buyerLeaveFeedback = buyerLeaveFeedback;
    _cancellationAvailable = cancellationAvailable;
    _claimAvailable = claimAvailable;
    _extensionAvailable = extensionAvailable;
    _purchaseProtectionTime = purchaseProtectionTime;
  }

  ClaimOptions.fromJson(dynamic json) {
    _buyerFeedbackComment = json["buyerFeedbackComment"];
    _buyerFeedbackStars = json["buyerFeedbackStars"];
    _buyerLeaveFeedback = json["buyerLeaveFeedback"];
    _cancellationAvailable = json["cancellationAvailable"];
    _claimAvailable = json["claimAvailable"];
    _extensionAvailable = json["extensionAvailable"];
    _purchaseProtectionTime = json["purchaseProtectionTime"];
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map["buyerFeedbackComment"] = _buyerFeedbackComment;
    map["buyerFeedbackStars"] = _buyerFeedbackStars;
    map["buyerLeaveFeedback"] = _buyerLeaveFeedback;
    map["cancellationAvailable"] = _cancellationAvailable;
    map["claimAvailable"] = _claimAvailable;
    map["extensionAvailable"] = _extensionAvailable;
    map["purchaseProtectionTime"] = _purchaseProtectionTime;
    return map;
  }
}

class OrderedWith {
  String _imgLink;
  String _orderID;
  String _title;

  String get imgLink => _imgLink;

  String get orderID => _orderID;

  String get title => _title;

  OrderedWith({String imgLink, String orderID, String title}) {
    _imgLink = imgLink;
    _orderID = orderID;
    _title = title;
  }

  OrderedWith.fromJson(dynamic json) {
    _imgLink = json["imgLink"];
    _orderID = json["orderID"];
    _title = json["title"];
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map["imgLink"] = _imgLink;
    map["orderID"] = _orderID;
    map["title"] = _title;
    return map;
  }
}
