import 'package:market_space/providers/marketSpaaceParentProvider.dart';

abstract class IProfileProvider {
  // ignore: missing_return
  Future<String> getLiked() {}
  // ignore: missing_return
  Future<String> getItemOnTheWay() {}
  // ignore: missing_return
  Future<String> getEarnings() {}

  // ignore: missing_return
  Future<String> getSalesRevenue() {}
}

class MockProfileProvider implements IProfileProvider {
  @override
  Future<String> getEarnings() async {
    await Future.delayed(Duration(seconds: 1));
    return "20.46";
  }

  @override
  Future<String> getItemOnTheWay() async {
    await Future.delayed(Duration(seconds: 1));
    return "5";
  }

  @override
  Future<String> getLiked() async {
    await Future.delayed(Duration(seconds: 1));
    return "12";
  }

  @override
  Future<String> getSalesRevenue() async {
    await Future.delayed(Duration(seconds: 1));
    return "27.5";
  }
}

class ProfileDataModel {
  final String revenueTD;
  final String investmentEarnings;
  final String itemsOTW;
  final String likedItems;

  ProfileDataModel(
      this.revenueTD, this.investmentEarnings, this.itemsOTW, this.likedItems);

  static ProfileDataModel fromJson(Map<String, dynamic> map) {
    return ProfileDataModel(
        map["revenueTD"].toString(),
        map["investmentEarnings"].toString(),
        map["itemsOTW"].toString(),
        map["likedItems"].toString());
  }
}

class ConcreteProfileProvider extends MarketSpaceParentProvider
    implements IProfileProvider {
  final endpoint = "/get_profile_statistics";
  Future<ProfileDataModel> _futureModel;
  ProfileDataModel _model;
  bool isFinished = false;

  ConcreteProfileProvider() {
    // print("this is a concrete implement");
    _futureModel = getInitialModel();
    _futureModel.whenComplete(() => {isFinished = true});
  }

  Future<ProfileDataModel> getInitialModel() async {
    try {
      final response = await post(endpoint, {
        "revenueTD": true,
        "investmentEarnings": true,
        "itemsOTW": true,
        "likedItems": true,
      });
      // print(response.statusCode);
      // print(response.data);
      if (response.statusCode == 200) {
        // print('profile success');
        // print(ProfileDataModel.fromJson(response.data));
        return ProfileDataModel.fromJson(response.data);
      }
      // print("fail!");
      // print(response.data);
      return null;
    } catch (e) {
      // print("catch model fail");
    }
    return ProfileDataModel("-1", "-1", "-1", "-1");
  }

  Future<String> getSingle(String key) async {
    final response = await post(endpoint, {
      key: true,
    });
    // print(response.statusCode);
    // print(response.data);
    if (response.statusCode == 200) {
      return response.data[key];
    }
    return "-1";
  }

  @override
  Future<String> getEarnings() async {
    String earnings;
    if (!isFinished) {
      await _futureModel.then(
          (value) => {_model = value, earnings = value.investmentEarnings});
      return earnings;
    }
    earnings = await getSingle("investmentEarnings");

    return _model.investmentEarnings;
  }

  @override
  Future<String> getItemOnTheWay() async {
    String earnings;
    if (!isFinished) {
      await _futureModel
          .then((value) => {print(value.itemsOTW), earnings = value.itemsOTW});
      return earnings;
    }
    earnings = await getSingle("itemsOTW");
    return _model.itemsOTW;
  }

  @override
  Future<String> getLiked() async {
    String earnings;
    if (!isFinished) {
      await _futureModel.then(
          (value) => {print(value.itemsOTW), earnings = value.likedItems});
      return earnings;
    }
    earnings = await getSingle("likedItems");
    return _model.likedItems;
  }

  @override
  Future<String> getSalesRevenue() async {
    String earnings;
    if (!isFinished) {
      await _futureModel
          .then((value) => {print(value.itemsOTW), earnings = value.revenueTD});
      return earnings;
    }
    earnings = await getSingle("revenueTD");
    return _model.revenueTD;
  }
}
