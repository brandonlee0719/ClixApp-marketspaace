import 'package:market_space/providers/active_product_provider/active_product_provider.dart';

class ActiveProductRepository {
  final ActiveProductProvider activeProductProvider = ActiveProductProvider();

  Future<int> getActiveProducts() {
    return activeProductProvider.getActiveProducts();
  }

  Future<int> getActiveSingleProduct(int productNum) {
    return activeProductProvider.getActiveSingleProduct(productNum);
  }
}
