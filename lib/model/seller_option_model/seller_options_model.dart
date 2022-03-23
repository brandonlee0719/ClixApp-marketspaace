class SellerOptionsModel {
  String _cancellationAvailable;
  String _claimAvailable;
  String _extensionAvailable;
  String _leaveFeedback;
  String _purchaseProtectionTime;

  String get cancellationAvailable => _cancellationAvailable;
  String get claimAvailable => _claimAvailable;
  String get extensionAvailable => _extensionAvailable;
  String get leaveFeedback => _leaveFeedback;
  String get purchaseProtectionTime => _purchaseProtectionTime;

  SellerOptionsModel(
      {String cancellationAvailable,
      String claimAvailable,
      String extensionAvailable,
      String leaveFeedback,
      String purchaseProtectionTime}) {
    _cancellationAvailable = cancellationAvailable;
    _claimAvailable = claimAvailable;
    _extensionAvailable = extensionAvailable;
    _leaveFeedback = leaveFeedback;
    _purchaseProtectionTime = purchaseProtectionTime;
  }

  SellerOptionsModel.fromJson(dynamic json) {
    _cancellationAvailable = json["cancellationAvailable"];
    _claimAvailable = json["claimAvailable"];
    _extensionAvailable = json["extensionAvailable"];
    _leaveFeedback = json["leaveFeedback"];
    _purchaseProtectionTime = json["purchaseProtectionTime"];
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map["cancellationAvailable"] = _cancellationAvailable;
    map["claimAvailable"] = _claimAvailable;
    map["extensionAvailable"] = _extensionAvailable;
    map["leaveFeedback"] = _leaveFeedback;
    map["purchaseProtectionTime"] = _purchaseProtectionTime;
    return map;
  }
}
