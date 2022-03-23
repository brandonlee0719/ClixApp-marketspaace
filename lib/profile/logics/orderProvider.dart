import 'package:flutter/cupertino.dart';
import 'package:market_space/model/recently_product_model/recently_brought_model.dart';
import 'package:market_space/repositories/profile_repository/profile_repository.dart';

class OrderProvider with ChangeNotifier {
  List<RecentlyBrought> recentlyBoughtList;
  String hero = "I am a hero, are you a hero as well?";
  ProfileRepository _profileRepository = ProfileRepository();

  OrderProvider() {
    // print("i am order provider, I am created");
    _getRecentBrought();
  }

  Future<void> _getRecentBrought() async {
    recentlyBoughtList = await _profileRepository.getRecentBrought(null);
    notifyListeners();
  }
}
