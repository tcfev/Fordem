import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:fuerdem/src/config/color_template.dart';
import 'package:fuerdem/src/config/logging_config.dart';
import 'package:fuerdem/src/core/storage_util.dart';
import 'package:fuerdem/src/localization/languages/languages.dart';
import 'package:fuerdem/src/localization/localizations_delegate.dart';
import 'package:fuerdem/src/providers/compose_notifier.dart';
import 'package:fuerdem/src/providers/locale_notifier.dart';
import 'package:fuerdem/src/util/preferences.dart';
import 'package:logging/logging.dart';
import 'package:provider/provider.dart';

import 'src/config/router/router.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // await Firebase.initializeApp();

  final logsConfig = LoggingConfig();
  Logger.root.level = Level.FINE; // Default is Level.INFO.
  Logger.root.onRecord.listen(logsConfig.handleLogs);

  await StorageUtil.getInstance();

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  Locale _getLocale() {
    final languageCode = Preferences.shared.getLocale();
    return Locale(
        languageCode != null && languageCode.isNotEmpty ? languageCode : 'en',
        '');
  }

  @override
  Widget build(BuildContext context) => MultiProvider(
        providers: [
          ChangeNotifierProvider<ComposeNotifier>(
              create: (_) => ComposeNotifier()),
          ChangeNotifierProvider<LocaleNotifier>(
              create: (_) => LocaleNotifier(_getLocale()))
        ],
        child: Consumer<LocaleNotifier>(
          builder: (context, localeNotifier, child) => MaterialApp(
            title: 'fürDem',
            localizationsDelegates: [
              AppLocalizationsDelegate(),
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            locale: localeNotifier.locale,
            supportedLocales: [
              const Locale('en', ''),
              const Locale('de', ''),
            ],
            initialRoute: PageRouter.homeRoute,
            onGenerateRoute: PageRouter.generateRoute,
          ),
        ),
      );
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final log = Logger('homepage');

  @override
  Widget build(BuildContext context) {
    log.fine('homePage built');
    return Scaffold(
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: BoxDecoration(color: ColorTemplate.darkBlue),
              child: Text(Languages.of(context).scanner),
            ),
            ListTile(
              title: Text(Languages.of(context).barcodeScanner),
              onTap: () {
                PageRouter.namedNavigateTo(context, PageRouter.barcodeRoute);
                // Navigator.pushNamed(context, '/barcode');
              },
            ),
            ListTile(
              title: Text(Languages.of(context).authorization),
              onTap: () {
                PageRouter.namedNavigateTo(
                  context,
                  PageRouter.authorizationRoute,
                  arguments: DataPass(
                    {'phone_number': '+880137622110'},
                  ),
                );
                // Navigator.pushNamed(context, '/authorization');
                // Navigator.pop(context);
              },
            ),
            ListTile(
              title: Text(Languages.of(context).compose),
              onTap: () {
                PageRouter.namedNavigateTo(context, PageRouter.composeRoute);
                // Navigator.pushNamed(context, '/editor');
                // Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
      appBar: AppBar(title: Text(Languages.of(context).babyNameVotes)),
      body: Container(
        alignment: Alignment.center,
        child: _createLanguageDropDown(),
      ),
    );
  }

  Widget _createLanguageDropDown() => Consumer<LocaleNotifier>(
        builder: (context, localeNotifier, child) => DropdownButton<String>(
          iconSize: 30,
          value: localeNotifier.locale.languageCode,
          onChanged: (languageCode) =>
              localeNotifier.changeLocale(languageCode),
          items: LanguageData.languageList()
              .map<DropdownMenuItem<String>>(
                (e) => DropdownMenuItem<String>(
                  value: e.languageCode,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        e.flag,
                        style: TextStyle(fontSize: 30),
                      ),
                      SizedBox(width: 8),
                      Text(e.name)
                    ],
                  ),
                ),
              )
              .toList(),
        ),
      );
}
