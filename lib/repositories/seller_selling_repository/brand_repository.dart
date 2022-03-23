import 'package:market_space/providers/seller_selling_provider/brand_provider.dart';

class BrandRepository {
  BrandProvider _brandProvider = BrandProvider();

  Future<List<String>> getAvailableBrands() async {
    return await _brandProvider.getAvailableBrands();
  }
}
