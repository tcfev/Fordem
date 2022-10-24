import 'package:flutter/material.dart';

class LanguageData {
  LanguageData(this.flag, this.name, this.languageCode);

  final String flag;
  final String name;
  final String languageCode;

  static List<LanguageData> languageList() => <LanguageData>[
        LanguageData('🇺🇸', 'English', 'en'),
        LanguageData('\u{1f1e9}\u{1f1ea}', 'Deutsche', 'de'),
      ];

  static LanguageData getLanguage(String languageCode) =>
      languageList()
          .firstWhere((language) => language.languageCode == languageCode) ??
      languageList().first;
}

abstract class Languages {
  static Languages of(BuildContext context) =>
      Localizations.of<Languages>(context, Languages);

  String get appName;

  String get scanner;

  String get barcodeScanner;

  String get authorization;

  String get editor;

  String get compose;

  String get babyNameVotes;

  String get addPost;

  String get title;

  String get composeBodyHint;

  String get edit;

  String get openOptions;

  String get closeOptions;

  String get width;

  String get height;

  String get addImage;

  String get addVideo;

  String get radius;

  String get caption;

  String get thickness;

  String get cancel;
}
