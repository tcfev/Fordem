import 'package:shared_preferences/shared_preferences.dart';

class StorageUtil {
  StorageUtil._();

  static StorageUtil _storageUtil;
  static SharedPreferences _preferences;

  /// This should be called before run app in main.
  static Future<StorageUtil> getInstance() async {
    if (_storageUtil == null) {
      // keep local instance till it is fully initialized.
      final secureStorage = StorageUtil._();
      await secureStorage._init();
      _storageUtil = secureStorage;
    }
    return _storageUtil;
  }

  Future<Null> _init() async {
    _preferences = await SharedPreferences.getInstance();
    return null;
  }

  // get string
  static String getString(String key, {String defValue}) {
    if (_preferences == null) {
      return defValue;
    }
    return _preferences.getString(key) ?? defValue;
  }

  // put string
  static Future putString(String key, String value) {
    if (_preferences == null) {
      return null;
    }
    return _preferences.setString(key, value);
  }
}
