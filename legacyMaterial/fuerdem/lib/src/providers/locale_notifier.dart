import 'package:flutter/material.dart';
import 'package:fuerdem/src/util/preferences.dart';
import 'package:logging/logging.dart';

class LocaleNotifier extends ChangeNotifier {
  LocaleNotifier(this.locale);

  Locale locale;

  void changeLocale(String languageCode) {
    locale = Locale(languageCode, '');
    notifyListeners();
    Preferences.shared.setLocate(languageCode);
  }
}
