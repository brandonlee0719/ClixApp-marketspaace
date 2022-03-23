import 'package:market_space/model/image_banner/image_banner.dart';
import 'package:market_space/model/image_banner/image_banner_model.dart';
import 'package:market_space/model/rates_model/rates_model.dart';
import 'package:market_space/providers/dashboard_provider/dashboard_provider.dart';
import 'package:market_space/providers/localProvider/localDashboardProvider.dart';

class DashboardRepository {
  final dashboardProvider = DashboardProvider();
  final LocalDashBoardProvider localProvider = LocalDashBoardProvider();

  // Future<int> getFlashPromo(int promoNum, String category, String currency,
  //     String crypto_currency) async{
  //    var flash = await dashboardProvider.getFlashPromo(promoNum, category, currency, crypto_currency);
  //   return flash;
  // }
  Future<int> addLikedItem(int productNum) async {
    return await dashboardProvider.addLikedItem(productNum);
  }

  Future<int> deleteLikedItem(int productNum) async {
    return await dashboardProvider.deleteLikedItem(productNum);
  }

  Future<RatesModel> getCryptoRate() async {
    RatesModel model = await localProvider.getRateFromLocal();
    if (model != null) {
      return model;
    }
    model = await dashboardProvider.getCryptoRate();
    if (model != null) {
      return model;
    }
  }

  // Future<List<FlashPromoAlgoliaObj>> getProducts() async{
  //   return dashboardProvider.getProducts('');
  // }

  // Future<String> getBanner() async {
  //   return dashboardProvider.getBannersList();
  // }

  Future<BannerImagesModel> getBanners() async {
    return dashboardProvider.getBannersList();
  }
}
