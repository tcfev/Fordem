import 'package:fuerdem/src/core/storage_util.dart';

class Preferences {
  factory Preferences() => _singleton;

  Preferences._();

  static final Preferences _singleton = Preferences._();

  static Preferences get shared => _singleton;

  final String keyLocale = 'locale';

  Future<bool> setLocate(String languageCode) => StorageUtil.putString(keyLocale, languageCode);

  String getLocale({String defaultValue}) => StorageUtil.getString(keyLocale);
}
