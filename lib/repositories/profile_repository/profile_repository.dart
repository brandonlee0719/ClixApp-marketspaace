import 'package:market_space/model/active_products_model/active_product_model.dart';
import 'package:market_space/model/order_status_model/order_status_model.dart';
import 'package:market_space/model/profile_model/profile_model.dart';
import 'package:market_space/model/recently_bought_options/buyer_options.dart';
import 'package:market_space/model/recently_product_model/recently_brought_model.dart';
import 'package:market_space/model/sold_product_model/sold_product_model.dart';
import 'package:market_space/providers/profile_provider/profile_provider.dart';

class ProfileRepository {
  final ProfileProvider profileProvider = ProfileProvider();

  Future<int> editBio(String bio, bool isSeller) async {
    return await profileProvider.editBio(bio, isSeller);
  }

  Future<ProfileModel> getProfileData(bool isSeller) async {
    return await profileProvider.getProfileData(isSeller);
  }

  Future<List<Orders>> getSoldProducts() async {
    return await profileProvider.getOrders();
  }

  Future<List<ActiveProducts>> getActiveProducts() async {
    return await profileProvider.getActiveProducts();
  }

  Future<int> setProfileUrl(String url, bool isSeller) async {
    return await profileProvider.setProfileUrl(url, isSeller);
  }

  Future<int> setBackgroundUrl(String url, bool isSeller) async {
    return await profileProvider.setBackgroundUrl(url, isSeller);
  }

  Future<int> getFeedback(int feedbackId, bool isSeller) async {
    return await profileProvider.getFeedback(feedbackId, isSeller);
  }

  Future<List<RecentlyBrought>> getRecentBrought(String orderId) async {
    return await profileProvider.getRecentBrought(orderId);
  }

  Future<int> confirmReceptionItem(String orderId) async {
    return await profileProvider.confirmReceptionOfItem(orderId);
  }

  Future<int> leaveSellerFeedback(
      String orderId, int rating, String detailReason) async {
    return await profileProvider.leaveSellerFeedback(
        orderId, rating, detailReason);
  }

  Future<int> buyerCancelOrder(
      String orderId, String reason, String detailReason) async {
    return await profileProvider.cancelBuyerOrder(
        orderId, reason, detailReason);
  }

  Future<BuyerOptions> getBuyerOptions(String orderId) async {
    return await profileProvider.getBuyerOptions(orderId);
  }
}
