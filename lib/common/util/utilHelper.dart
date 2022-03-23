class UtilHelper {
  static UtilHelper
      _utilHelper; // Singleton DatabaseHelper   // Singleton Database
  UtilHelper._createInstance(); // Named constructor to create instance of DatabaseHelper

  factory UtilHelper() {
    if (_utilHelper == null) {
      _utilHelper = UtilHelper
          ._createInstance(); // This is executed only once, singleton object
    }
    return _utilHelper;
  }

  onError(error, stackTrace) {
    // print("heiheihei");
  }
}
