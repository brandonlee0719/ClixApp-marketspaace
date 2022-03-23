import 'package:market_space/common/constants.dart';

class LocalStorageParentProvider {
  final _storage = Constants.singletonSecureStorage;

  Future<void> setValue(dynamic value, String key) async {
    await _storage.write(key: key, value: value);
  }

  Future<String> getValue(String key) async {
    String result = await _storage.read(key: key);
    return result;
  }
}
